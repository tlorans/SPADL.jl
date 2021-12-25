


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
