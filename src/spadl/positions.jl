# This file contains functions to create new positions.

"""
function make_new_positions

Return a new dataframe with start and end position as columns.
"""
function make_new_positions(event_df::PublicWyscoutEvents)::PublicWyscoutEvents
    data = copy(event_df.data)

    insertcols!(data, 
                :start_x => 0,
                :start_y => 0,
                :end_x => 0,
                :end_y => 0)


    for i in eachindex(data.game_id)
        if length(data[i,:positions][1]) == 2
            data[i, :start_x] = data[i,:positions][1][1]["x"]
            data[i, :start_y] = data[i,:positions][1][1]["y"]
            data[i, :end_x] = data[i,:positions][1][2]["x"]
            data[i, :end_y] = data[i,:positions][1][2]["y"] 
        elseif  length(data[i,:positions][1]) == 1
            data[i, :start_x] = data[i,:positions][1][1]["x"]
            data[i, :start_y] = data[i,:positions][1][1]["y"]
            data[i, :end_x] = data[i, :start_x]
            data[i, :end_y] = data[i, :start_y]
        else 
            data[i, :start_x] = missing
            data[i, :start_y] = missing
            data[i, :end_x] = missing
            data[i, :end_y] = missing
        end           
    end

    data = data[:, Not(:positions)]

    data[:, :start_x] = clamp.(data[:, :start_x], 0, 105)
    data[:, :end_x] = clamp.(data[:, :end_x], 0, 105)
    data[:, :start_y] = clamp.(data[:, :start_y], 0, 68)
    data[:, :end_y] = clamp.(data[:, :end_y], 0, 68)

    event_df.data = data
    
    return event_df
end
