
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

