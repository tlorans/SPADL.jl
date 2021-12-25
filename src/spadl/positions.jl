# This file contains functions to create new positions.

"""
function make_new_positions

Return a new dataframe with start and end position as columns.
"""
function make_new_positions(event_df::PublicWyscoutEvents)
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
