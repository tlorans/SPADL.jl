# This file contains functions to return DataFrame with boolean for tags



# wyscout_tags::Dict = Dict(
#     (101 => "goal"),
#     (102 => "own_goal"),
#     (301 => "assist"),
#     (302 => "key_pass"),
#     (1901 => "counter_attack"),
#     (401 => "left_foot"),
#     (402 => "right_foot"),
#     (403 => "head/body"),
#     (1101 => "direct"),
#     (1102 => "indirect"),
#     (2001 => "dangerous_ball_lost"),
#     (2101 => "blocked"),
#     (801 => "high"),
#     (802 => "low"),
#     (1401 => "interception"),
#     (1501 => "clearance"),
#     (201 => "opportunity"),
#     (1301 => "feint"),
#     (1302 => "missed_ball"),
#     (501 => "free_space_right"),
#     (502 => "free_space_left"),
#     (503 => "take_on_left"),
#     (504 => "take_on_right"),
#     (1601 => "sliding_tackle"),
#     (601 => "anticipated"),
#     (602 => "anticipation"),
#     (1701 => "red_card"),
#     (1702 => "yellow_card"),
#     (1703 => "second_yellow_card"),
#     (1201 => "position_goal_low_center"),
#     (1202 => "position_goal_low_right"),
#     (1203 => "position_goal_mid_center"),
#     (1204 => "position_goal_mid_left"),
#     (1205 => "position_goal_low_left"),
#     (1206 => "position_goal_mid_right"),
#     (1207 => "position_goal_high_center"),
#     (1208 => "position_goal_high_left"),
#     (1209 => "position_goal_high_right"),
#     (1210 => "position_out_low_right"),
#     (1211 => "position_out_mid_left"),
#     (1212 => "position_out_low_left"),
#     (1213 => "position_out_mid_right"),
#     (1214 => "position_out_high_center"),
#     (1215 => "position_out_high_left"),
#     (1216 => "position_out_high_right"),
#     (1217 => "position_post_low_right"),
#     (1218 => "position_post_mid_left"),
#     (1219 => "position_post_low_left"),
#     (1220 => "position_post_mid_right"),
#     (1221 => "position_post_high_center"),
#     (1222 => "position_post_high_left"),
#     (1223 => "position_post_high_right"),
#     (901 => "through"),
#     (1001 => "fairplay"),
#     (701 => "lost"),
#     (702 => "neutral"),
#     (703 => "won"),
#     (1801 => "accurate"),
#     (1802 => "not_accurate")
# )


"""
    WyscoutEventTags
"""
Base.@kwdef mutable struct WyscoutEventTags
    goal::Bool = false
    own_goal::Bool = false
    assist::Bool = false
    key_pass::Bool = false
    counter_attack::Bool = false
    left_foot::Bool = false
    right_foot::Bool = false
    head_body::Bool = false
    direct::Bool = false
    indirect::Bool = false
    dangerous_ball_lost::Bool = false
    blocked::Bool = false
    high::Bool = false
    low::Bool = false
    interception::Bool = false
    clearance::Bool = false
    opportunity::Bool = false
    feint::Bool = false
    missed_ball::Bool = false
    free_space_right::Bool = false
    free_space_left::Bool = false
    take_on_left::Bool = false
    take_on_right::Bool = false
    sliding_tackle::Bool = false
    anticipated::Bool = false
    anticipation::Bool = false
    red_card::Bool = false
    yellow_card::Bool = false
    second_yellow_card::Bool = false
    position_goal_low_center::Bool = false
    position_goal_low_right::Bool = false
    position_goal_mid_center::Bool = false
    position_goal_mid_left::Bool = false
    position_goal_low_left::Bool = false
    position_goal_mid_right::Bool = false
    position_goal_high_center::Bool = false
    position_goal_high_left::Bool = false
    position_goal_high_right::Bool = false
    position_out_low_right::Bool = false
    position_out_mid_left::Bool = false
    position_out_low_left::Bool = false
    position_out_mid_right::Bool = false
    position_out_high_center::Bool = false
    position_out_high_left::Bool = false
    position_out_high_right::Bool = false
    position_post_low_right::Bool = false
    position_post_mid_left::Bool = false
    position_post_low_left::Bool = false
    position_post_mid_right::Bool = false
    position_post_high_left::Bool = false
    position_post_high_right::Bool = false
    through::Bool = false
    fairplay::Bool = false
    lost::Bool = false
    neutral::Bool = false
    won::Bool = false
    accurate::Bool = false
    not_accurate::Bool = false
end


function get_tags(events_data::Vector{WyscoutEvent})::Vector{WyscoutEventTags}

    vector_tags = Vector{WyscoutEventTags}()

    for i in eachindex(events_data)
        tags = WyscoutEventTags()

        for j in eachindex(events_data[i].tags)

            if events_data[i].tags[j]["id"] == 101
                tags.goal = true 
            end

            if events_data[i].tags[j]["id"] == 102
                tags.own_goal = true 
            end


        end

        push!(vector_tags, tags)
    end

    return vector_tags
end

"""
function get_tagsdf()

Represent tags as a boolean dataframe with a column for each tag.
# """
# function get_tagsdf(event_df::PublicWyscoutEvents)::PublicWyscoutTags
    

#     tagsdf = PublicWyscoutTags(data = copy(event_df.data))

#     wyscout_tags_df = DataFrame(:tags => collect(keys(tagsdf.wyscout_tags)), 
#                                 :tags_name => collect(values(tagsdf.wyscout_tags)))


#     # we initialize the boolean tags_df dataframe
#     tags_df = DataFrame(:event_id => unique(tagsdf.data[:, :event_id]))
#     col_names = collect(values(tagsdf.wyscout_tags))
#     insertcols!(tags_df, (col_names .=> false)...)

#     # make the tags out of the vector of dictionnaries 
#     result_tags = []
#     result_event_id = []
#     for i in eachindex(tagsdf.data.tags)
#         tmp_tags = 0
#         tmp_event_id = 0
#         # if size of vector of dictionnary only one, we just need to take it 
#         if length(tagsdf.data[i,:tags][1]) ==1
#             tmp_tags = convert(Int,tagsdf.data[i,:tags][1][1]["id"])
#             tmp_event_id = tagsdf.data[i,:event_id]
#         # if more than one, we need to make it a vector
#         elseif length(tagsdf.data[i,:tags][1]) > 1
#             tmp_tags = [convert(Int,tagsdf.data[i,:tags][1][j]["id"]) for j in eachindex(tagsdf.data[i,:tags][1])]
#             tmp_event_id = [tagsdf.data[i,:event_id] for j in eachindex(tagsdf.data[i,:tags][1])]
#         end
#         push!(result_tags, tmp_tags)
#         push!(result_event_id, tmp_event_id)
#     end
#     # results are a mix of unique tags and vector, we need to reduce
#     result_tags = reduce(vcat, result_tags)
#     result_event_id = reduce(vcat, result_event_id)
#     result_df = DataFrame(:event_id => result_event_id,
#                             :tags => result_tags)

#     # then we can drop the previous tags
#     tagsdf.data = tagsdf.data[:, Not(:tags)]
#     # and make a new dataframe with one tag (id) per line                        
#     tagsdf.data = leftjoin(result_df, tagsdf.data, on = :event_id)

#     # now we will join event_df with our wyscout_df 
#     tagsdf.data = leftjoin(tagsdf.data, wyscout_tags_df, on = :tags)
#     insertcols!(tags_df, :row_id => [i for i in eachindex(tags_df.event_id)])
#     # now we will populate the tags_df dataframe 
#     for i in eachindex(tagsdf.data.event_id)
#         ids = tagsdf.data[i, :event_id]
#         tmp = filter("event_id" => ==(ids), tags_df)
#         if size(tmp,1)>0
#             nbr_row = tmp[1,:row_id]
#             tags_name = tagsdf.data[i, :tags_name]
#             tags_df[nbr_row, tags_name] = true
#         end
#     end

#     tagsdf.data = tags_df

#     return tagsdf
# end
