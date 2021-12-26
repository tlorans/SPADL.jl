# This file contains functions to return DataFrame with boolean for tags

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

"""
    function get_tags()

"""
function get_tags(events_data::Vector{WyscoutEvent})::Vector{WyscoutEventTags}

    vector_tags = Vector{WyscoutEventTags}()

    for i in eachindex(events_data)
        tags = WyscoutEventTags()

        for j in eachindex(events_data[i].tags)
            tag = events_data[i].tags[j]["id"]
            
            if tag == 101 tags.goal = true end
            if tag == 102 tags.own_goal = true end
            if tag == 301 tags.assist = true end
            if tag == 302 tags.key_pass = true end
            if tag == 1901 tags.counter_attack = true end
            if tag == 401 tags.left_foot = true end
            if tag == 402 tags.right_foot = true end
            if tag == 403 tags.head_body = true end
            if tag == 1101 tags.direct = true end
            if tag == 1102 tags.indirect = true end
            if tag == 2001 tags.dangerous_ball_lost = true end
            if tag == 2101 tags.blocked = true end
            if tag == 801 tags.high = true end
            if tag == 802 tags.low = true end
            if tag == 1401 tags.interception = true end
            if tag == 1501 tags.clearance = true end
            if tag == 201 tags.opportunity = true end
            if tag == 1301 tags.feint = true end
            if tag == 1302 tags.missed_ball = true end
            if tag == 501 tags.free_space_right = true end
            if tag == 502 tags.free_space_left = true end
            if tag == 503 tags.take_on_left = true end
            if tag == 504 tags.take_on_right = true end
            if tag == 1601 tags.sliding_tackle = true end
            if tag == 601 tags.anticipated = true end
            if tag == 602 tags.anticipation = true end
            if tag == 1701 tags.red_card = true end
            if tag == 1702 tags.yellow_card = true end
            if tag == 1703 tags.second_yellow_card = true end
            if tag == 1201 tags.position_goal_low_center = true end
            if tag == 1202 tags.position_goal_low_right = true end
            if tag == 1203 tags.position_goal_mid_center = true end
            if tag == 1204 tags.position_goal_mid_left = true end
            if tag == 1205 tags.position_goal_low_left = true end
            if tag == 1206 tags.position_goal_mid_right = true end
            if tag == 1207 tags.position_goal_high_center = true end
            if tag == 1208 tags.position_goal_high_left = true end
            if tag == 1209 tags.position_goal_high_right = true end
            if tag == 1210 tags.position_out_low_right = true end
            if tag == 1211 tags.position_out_mid_left = true end
            if tag == 1212 tags.position_out_low_left = true end
            if tag == 1213 tags.position_out_mid_rights = true end
            if tag == 1214 tags.position_out_high_center = true end
            if tag == 1215 tags.position_out_high_left = true end
            if tag == 1216 tags.position_out_high_right = true end
            if tag == 1217 tags.position_post_low_right = true end
            if tag == 1218 tags.position_post_mid_left = true end
            if tag == 1219 tags.position_post_low_left = true end
            if tag == 1220 tags.position_post_mid_right = true end
            if tag == 1221 tags.position_post_high_center = true end
            if tag == 1222 tags.position_post_high_left = true end
            if tag == 1223 tags.position_post_high_right = true end
            if tag == 901 tags.through = true end
            if tag == 1001 tags.fairplay = true end
            if tag == 701 tags.lost = true end
            if tag == 702 tags.neutral = true end
            if tag == 703 tags.won = true end
            if tag == 1801 tags.accurate = true end
            if tag == 1802 tags.not_accurate = true end

        end

        push!(vector_tags, tags)
    end

    return vector_tags
end
