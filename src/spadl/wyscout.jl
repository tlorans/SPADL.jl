# This file contains functions to translate dataframe events to spadl actions 
"""
    function convert_to_actions()

Convert Wyscout events to SPADL actions
"""
function convert_to_actions(event_df::DataFrame)
    tags_df = get_tagsdf(event_df)
    event_df = leftjoin(event_df, tags_df, on = :event_id)
    event_df = make_new_positions(event_df)
    event_df = fix_wyscout_events(event_df)

    return event_df
end



"""
    function get_tagsdf()

Represent Wyscout tags as a boolean dataframe with a column for each tag.
"""
function get_tagsdf(event_df::DataFrame)
    event_df = copy(event_df)
    wyscout_tags = Dict(
        (101 => "goal"),
        (102 => "own_goal"),
        (301 => "assit"),
        (302 => "key_pass"),
        (1901 => "counter_attack"),
        (401 => "left_foot"),
        (402 => "right_foot"),
        (403 => "head/body"),
        (1101 => "direct"),
        (1102 => "indirect"),
        (2001 => "dangerous_ball_lost"),
        (2101 => "blocked"),
        (801 => "high"),
        (802 => "low"),
        (1401 => "interception"),
        (1501 => "clearance"),
        (201 => "opportunity"),
        (1301 => "feint"),
        (1302 => "missed_ball"),
        (501 => "free_space_right"),
        (502 => "free_space_left"),
        (503 => "take_on_left"),
        (504 => "take_on_right"),
        (1601 => "sliding_tackle"),
        (601 => "anticipated"),
        (602 => "anticipation"),
        (1701 => "red_card"),
        (1702 => "yellow_card"),
        (1703 => "second_yellow_card"),
        (1201 => "position_goal_low_center"),
        (1202 => "position_goal_low_right"),
        (1203 => "position_goal_mid_center"),
        (1204 => "position_goal_mid_left"),
        (1205 => "position_goal_low_left"),
        (1206 => "position_goal_mid_right"),
        (1207 => "position_goal_high_center"),
        (1208 => "position_goal_high_left"),
        (1209 => "position_goal_high_right"),
        (1210 => "position_out_low_right"),
        (1211 => "position_out_mid_left"),
        (1212 => "position_out_low_left"),
        (1213 => "position_out_mid_right"),
        (1214 => "position_out_high_center"),
        (1215 => "position_out_high_left"),
        (1216 => "position_out_high_right"),
        (1217 => "position_post_low_right"),
        (1218 => "position_post_mid_left"),
        (1219 => "position_post_low_left"),
        (1220 => "position_post_mid_right"),
        (1221 => "position_post_high_center"),
        (1222 => "position_post_high_left"),
        (1223 => "position_post_high_right"),
        (901 => "through"),
        (1001 => "fairplay"),
        (701 => "lost"),
        (702 => "neutral"),
        (703 => "won"),
        (1801 => "accurate"),
        (1802 => "not_accurate")
    )


    wyscout_tags_df = DataFrame(:tags => collect(keys(wyscout_tags)), 
                                :tags_name => collect(values(wyscout_tags)))
    
    
    # we initialize the boolean tags_df dataframe
    tags_df = DataFrame(:event_id => unique(event_df[:, :event_id]))
    col_names = collect(values(wyscout_tags))
    insertcols!(tags_df, (col_names .=> false)...)

    # make the tags out of the vector of dictionnaries 
    result_tags = []
    result_event_id = []
    for i in eachindex(event_df.tags)
        tmp_tags = 0
        tmp_event_id = 0
        # if size of vector of dictionnary only one, we just need to take it 
        if length(event_df[i,:tags][1]) ==1
            tmp_tags = convert(Int,event_df[i,:tags][1][1]["id"])
            tmp_event_id = event_df[i,:event_id]
        # if more than one, we need to make it a vector
        elseif length(event_df[i,:tags][1]) > 1
            tmp_tags = [convert(Int,event_df[i,:tags][1][j]["id"]) for j in eachindex(event_df[i,:tags][1])]
            tmp_event_id = [event_df[i,:event_id] for j in eachindex(event_df[i,:tags][1])]
        end
        push!(result_tags, tmp_tags)
        push!(result_event_id, tmp_event_id)
    end
    # results are a mix of unique tags and vector, we need to reduce
    result_tags = reduce(vcat, result_tags)
    result_event_id = reduce(vcat, result_event_id)
    result_df = DataFrame(:event_id => result_event_id,
                            :tags => result_tags)

    # then we can drop the previous tags
    event_df = event_df[:, Not(:tags)]
    # and make a new dataframe with one tag (id) per line                        
    event_df = leftjoin(result_df, event_df, on = :event_id)

    # now we will join event_df with our wyscout_df 
    event_df = leftjoin(event_df, wyscout_tags_df, on = :tags)
    insertcols!(tags_df, :row_id => [i for i in eachindex(tags_df.event_id)])
    # now we will populate the tags_df dataframe 
    for i in eachindex(event_df.event_id)
        ids = event_df[i, :event_id]
        tmp = filter("event_id" => ==(ids), tags_df)
        if size(tmp,1)>0
            nbr_row = tmp[1,:row_id]
            tags_name = event_df[i, :tags_name]
            tags_df[nbr_row, tags_name] = true
        end
    end


    return tags_df
end

"""
    function make_new_positions

Return a new dataframe with start and end position as columns.
"""
function make_new_positions(event_df::DataFrame)
    event_df = copy(event_df)
    insertcols!(event_df, 
                :start_x => 0,
                :start_y => 0,
                :end_x => 0,
                :end_y => 0)


    for i in eachindex(event_df.game_id)
        if length(event_df[i,:positions][1]) == 2
            event_df[i, :start_x] = event_df[i,:positions][1][1]["x"]
            event_df[i, :start_y] = event_df[i,:positions][1][1]["y"]
            event_df[i, :end_x] = event_df[i,:positions][1][2]["x"]
            event_df[i, :end_y] = event_df[i,:positions][1][2]["y"] 
        elseif  length(event_df[i,:positions][1]) == 1
            event_df[i, :start_x] = event_df[i,:positions][1][1]["x"]
            event_df[i, :start_y] = event_df[i,:positions][1][1]["y"]
            event_df[i, :end_x] = event_df[i, :start_x]
            event_df[i, :end_y] = event_df[i, :start_y]
        else 
            event_df[i, :start_x] = missing
            event_df[i, :start_y] = missing
            event_df[i, :end_x] = missing
            event_df[i, :end_y] = missing
        end           
    end

    event_df = event_df[:, Not(:positions)]
    
    event_df[:, :start_x] = clamp.(event_df[:, :start_x], 0, 105)
    event_df[:, :end_x] = clamp.(event_df[:, :end_x], 0, 105)
    event_df[:, :start_y] = clamp.(event_df[:, :start_y], 0, 68)
    event_df[:, :end_y] = clamp.(event_df[:, :end_y], 0, 68)
    return event_df
end


"""
    function fix_wyscout_events()

Perform some fixes on the Wyscout events such that the spadl action dataframe can be built. 
"""
function fix_wyscout_events(event_df::DataFrame)

    event_df = create_shot_coordinates(event_df)

end

"""
    function create_shot_coordinates()

Create short coordinates (estimates) from Wyscout tags
"""
function create_shot_coordinates(event_df::DataFrame)
    cols_pos = ["start_x","start_y","end_x","end_y"]
    for col in cols_pos
        event_df[!, col] = convert.(Float64, event_df[:, col])
    end

    for i in eachindex(event_df.event_id)
        if event_df[i, :position_goal_low_center] || event_df[i, :position_goal_mid_center] || event_df[i, :position_goal_high_center]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 50
        
        elseif event_df[i, :position_goal_low_right] || event_df[i, :position_goal_mid_right]  || event_df[i, :position_goal_high_right]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 55   
        
        elseif event_df[i, :position_goal_mid_left] || event_df[i, :position_goal_low_left]  || event_df[i, :position_goal_high_left]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 45 
        
        elseif event_df[i, :position_out_high_center] || event_df[i, :position_post_high_center]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 50
        
        elseif event_df[i, :position_out_low_right] || event_df[i, :position_out_mid_right] || event_df[i, :position_out_high_right]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 60

        elseif event_df[i, :position_out_mid_left] || event_df[i, :position_out_low_left] || event_df[i, :position_out_high_left]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 40

        elseif event_df[i, :position_post_mid_left] || event_df[i, :position_post_low_left] || event_df[i, :position_post_high_left]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 55.38

        elseif event_df[i, :position_post_low_right] || event_df[i, :position_post_mid_right] || event_df[i, :position_post_high_right]
            event_df[i, :end_x] = 100
            event_df[i, :end_y] = 44.62
        
        elseif event_df[i, :blocked]
            event_df[i, :end_x] = event_df[i, :start_x]
            event_df[i, :end_y] = event_df[i, :start_y]
        end
    end
    return event_df
end


"""
    function convert_duels()
        
This function converts Wyscout duels that end with the ball out of field
(subtype_id 50) into a pass for the player winning the duel to the location
of where the ball went out of field. The remaining duels are removed as
they are not on-the-ball actions. 
"""
function convert_duels(event_df::DataFrame)

    for i in eachindex(event_df.event_id)
        if i < length(eachindex(event_df.event_id)) - 2
            if selector_duel_out_of_field(event_df[i, :type_id],
                                            event_df[i+1, :type_id],
                                            event_df[i+2, :subtype_id],
                                            event_df[i, :period_id],
                                            event_df[i+2, :period_id])
                println("ok")
            end
        end
    end

end

"""
    function selector_duel_out_of_field
Define selector for duels that are followed by an 'out of field' event.
"""
function selector_duel_out_of_field(type_id::Union{Float64, Int}, type_id_t_plus_1::Union{Float64,Int}, subtype_id_t_plus_2::String,period_id::String, period_id_t_plus_2::String)

    if type_id == 1 &&
        type_id_t_plus_1 == 1 &&
        # have to treat it like a string, don't achieve to drop the empty rows and translate it in number
        subtype_id_t_plus_2 == "50" &&
        period_id == period_id_t_plus_2
        result =  true

    else 
        result = false
    end

    return result
end