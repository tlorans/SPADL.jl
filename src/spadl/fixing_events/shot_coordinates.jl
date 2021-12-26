# This file contains functions to create shot coordinates.

"""
function create_shot_coordinates()

Create short coordinates (estimates) from Wyscout tags
# """
function create_shot_coordinates(spadl_df::Vector{RegularSPADL}, tags_df::Vector{WyscoutEventTags})::Vector{RegularSPADL}

    for i in eachindex(spadl_df)
        
        if tags_df[i].position_goal_low_center || tags_df[i].position_goal_mid_center || tags_df[i].position_goal_high_center
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 50
        elseif tags_df[i].position_goal_low_right || tags_df[i].position_goal_mid_right || tags_df[i].position_goal_high_right
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 55
        elseif tags_df[i].position_goal_mid_left || tags_df[i].position_goal_low_left || tags_df[i].position_goal_high_left
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 45
        elseif tags_df[i].position_out_high_center || tags_df[i].position_post_high_center
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 50
        elseif tags_df[i].position_out_low_right || tags_df[i].position_out_mid_right || tags_df[i].position_out_high_right
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 60
        elseif tags_df[i].position_out_mid_left || tags_df[i].position_out_low_left || tags_df[i].position_out_high_left
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 40
        elseif tags_df[i].position_post_mid_left || tags_df[i].position_post_low_left || tags_df[i].position_post_high_left
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 55.38
        elseif tags_df[i].position_post_low_right || tags_df[i].position_post_mid_right || tags_df[i].position_post_high_right
            spadl_df[i].end_x = 100
            spadl_df[i].end_y = 44.62
        else if tags_df[i].blocked 
            spadl_df[i].end_x = spadl_df[i].start_x
            spadl_df[i].end_y = spadl_df[i].start_y
        end
    end

    return spadl_df
end
