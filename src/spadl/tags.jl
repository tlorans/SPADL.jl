# This file contains functions to return DataFrame with boolean for tags


"""
    function get_tags()

"""
function get_tags(vector_wyscout_data::Vector{WyscoutData})::Vector{WyscoutData}


    for i in eachindex(vector_wyscout_data)
        tags = WyscoutEventTags()

        for j in eachindex(vector_wyscout_data[i].event.tags)
            tag = vector_wyscout_data[i].event.tags[j]["id"]
            
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

        vector_wyscout_data[i].tags = tags
    end

    return vector_wyscout_data
end
