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
Take as input the initial Vector of WyscoutEvent and initialize a Vector of RegularSPADL before processing.
"""
function create_actions(vector_wyscout_data::Vector{WyscoutData})::Vector{RegularSPADL}

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

        push!(vector_spadl, spadl_element)
    end

    return vector_spadl
end

