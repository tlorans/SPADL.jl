# This file contains functions to create the actions dataframe.

"""
    function convert_to_actions(event_df)
Convert Wyscout events to SPADL actions.
Step 1: initialize a vector of WyscoutData
Step 2: create new positions (start_x, start_y and end_x, end_y)
"""
function convert_to_actions(event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}

    vector_wyscout_data = create_wyscout_data_processing(event_df)
    vector_wyscout_data = make_new_positions(vector_wyscout_data)
    vector_wyscout_data = get_tags(vector_wyscout_data)
    vector_wyscout_data = fix_events(vector_wyscout_data)
    vector_spadl = create_actions(vector_wyscout_data)

    return vector_spadl
end

"""
    function create_wyscout_data_processing(event_df)
"""
function create_wyscout_data_processing(event_df::Vector{WyscoutEvent})::Vector{WyscoutData}

    vector_wyscout_data = Vector{WyscoutData}()

    for i in eachindex(event_df)
        tmp_event_fixed = WyscoutEventFixed(game_id = event_df[i].game_id,
                                event_id = event_df[i].event_id,
                                period_id = event_df[i].period_id,
                                team_id = event_df[i].team_id,
                                type_id = event_df[i].type_id,
                                player_id = event_df[i].player_id,
                                milliseconds = event_df[i].milliseconds)

        tmp = WyscoutData(event = event_df[i], event_fixed = tmp_event_fixed)
        push!(vector_wyscout_data, tmp)
    end

    return vector_wyscout_data
end


"""
    function create_actions(event_df)
Create the SciSports action format.
"""
function create_actions(vector_wyscout_data::Vector{WyscoutData})::Vector{RegularSPADL}

    configs = ActionsConfig()

    vector_spadl = Vector{RegularSPADL}()

    for i in eachindex(vector_wyscout_data)
        spadl_element = RegularSPADL(game_id = vector_wyscout_data[i].event_fixed.game_id,
                                original_event_id = vector_wyscout_data[i].event_fixed.event_id,
                                period_id = vector_wyscout_data[i].event_fixed.period_id,
                                team_id = vector_wyscout_data[i].event_fixed.team_id,
                                start_x = vector_wyscout_data[i].event_fixed.start_x,
                                start_y = vector_wyscout_data[i].event_fixed.start_y,
                                end_x = vector_wyscout_data[i].event_fixed.end_x,
                                end_y = vector_wyscout_data[i].event_fixed.end_y,
                                time_seconds = vector_wyscout_data[i].event_fixed.milliseconds # to be checked
                                )

        # determine bodypart_id 
        spadl_element = determine_bodypart_id(spadl_element, vector_wyscout_data[i], configs)

        # determine type_id 
        spadl_element = determine_type_id(spadl_element, vector_wyscout_data[i], configs)

        # determine result_id 
        spadl_element = determine_result_id(spadl_element, vector_wyscout_data[i], configs)

        push!(vector_spadl, spadl_element)
    end

    # remove non actions 
    vector_spadl = filter(x -> x.type_name != "non_action", vector_spadl)

    return vector_spadl
end

"""
    function determine_bodypart_id()
Determine the body part for each action.
"""
function determine_bodypart_id(spadl_element::RegularSPADL, wyscout_data::WyscoutData, config::ActionsConfig)::RegularSPADL

    if wyscout_data.event_fixed.subtype_id in [81, 36, 21, 90, 91]
        spadl_element.bodypart_name = "other"
    elseif wyscout_data.event_fixed.subtype_id == 82
        spadl_element.bodypart_name = "head"
    elseif  wyscout_data.event_fixed.subtype_id == 10 && wyscout_data.tags.head_body
        spadl_element.bodypart_name = "head/other"
    else 
        spadl_element.bodypart_name = "foot"
    end
    spadl_element.bodypart_id = findall(x -> x == spadl_element.bodypart_name, config.bodyparts)[1] - 1
    return spadl_element
end

"""
    function determine_type_id()

This function transforms the Wyscout events, sub_events and tags
into the corresponding SciSports action type        
"""
function determine_type_id(spadl_element::RegularSPADL, wyscout_data::WyscoutData, config::ActionsConfig)::RegularSPADL

    if wyscout_data.tags.own_goal
        spadl_element.type_name = "bad_touch"
    elseif wyscout_data.event_fixed.type_id == 8 
        if wyscout_data.event_fixed.subtype_id == 80
            spadl_element.type_name = "cross"
        else 
            spadl_element.type_name = "pass"
        end
    elseif wyscout_data.event_fixed.subtype_id == 36
        spadl_element.type_name = "throw_in"
    elseif wyscout_data.event_fixed.subtype_id == 30
        if wyscout_data.tags.high
            spadl_element.type_name = "corner_crossed"
        else 
            spadl_element.type_name = "corner_short"
        end
    elseif  wyscout_data.event_fixed.subtype_id == 32 
        spadl_element.type_name = "freekick_crossed"
    elseif wyscout_data.event_fixed.subtype_id == 31 
        spadl_element.type_name = "freekick_short"
    elseif wyscout_data.event_fixed.subtype_id == 34
        spadl_element.type_name = "goalkick"
    elseif wyscout_data.event_fixed.type_id == 2
        spadl_element.type_name = "foul"
    elseif wyscout_data.event_fixed.type_id == 10 
        spadl_element.type_name = "shot"
    elseif wyscout_data.event_fixed.subtype_id == 35
        spadl_element.type_name = "short_penalty"
    elseif wyscout_data.event_fixed.subtype_id == 33 
        spadl_element.type_name = "shot_freekick"
    elseif wyscout_data.event_fixed.type_id == 9 
        spadl_element.type_name = "keeper_save"
    elseif wyscout_data.event_fixed.subtype_id == 71
        spadl_element.type_name = "clearance"
    elseif wyscout_data.event_fixed.subtype_id == 72 && wyscout_data.tags.not_accurate
        spadl_element.type_name = "bad_touch"
    elseif wyscout_data.event_fixed.subtype_id == 70
        spadl_element.type_name = "dribble"
    elseif wyscout_data.tags.take_on_left || wyscout_data.tags.take_on_right
        spadl_element.type_name = "take_on"
    elseif wyscout_data.tags.sliding_tackle
        spadl_element.type_name = "tackle"
    elseif wyscout_data.tags.interception && (wyscout_data.event_fixed.subtype_id in [0, 10, 11, 12, 13, 72])
        spadl_element.type_name = "interception"
    else 
        spadl_element.type_name = "non_action"
    end 
    spadl_element.type_id = findall(x -> x == spadl_element.type_name, config.actionstypes)[1] - 1

    return spadl_element
end

"""
    function determine_result_id()
Determine the result of each event.
"""
function determine_result_id(spadl_element::RegularSPADL, wyscout_data::WyscoutData, config::ActionsConfig)::RegularSPADL

    if wyscout_data.tags.offside spadl_element.result_id = 2 end
    if wyscout_data.event_fixed.type_id == 2 spadl_element.result_id = 1 end
    if wyscout_data.tags.goal spadl_element.result_id = 1 end
    if wyscout_data.tags.own_goal spadl_element.result_id = 3 end
    if wyscout_data.event_fixed.subtype_id in [100,33,35] spadl_element.result_id = 0 end
    if wyscout_data.tags.accurate spadl_element.result_id = 1 end
    if wyscout_data.tags.not_accurate spadl_element.result_id = 0 end
    if wyscout_data.tags.interception || wyscout_data.tags.clearance || wyscout_data.event_fixed.subtype_id == 71
        spadl_element.result_id = 1
    end
    if wyscout_data.event_fixed.type_id == 9 spadl_element.result_id = 1 end  
    
    # equivalent of the line 655 of the initial python code
    if isnothing(spadl_element.result_id) spadl_element.result_id = 1 end

    spadl_element.result_name = config.actionstypes[spadl_element.result_id+1]

    return spadl_element
end