# This file contains functions to create new positions.

"""
function make_new_positions

Return a new vector of SPADL.
"""
function make_new_positions(vector_wyscout_data::Vector{WyscoutData})::Vector{WyscoutData}

    for i in eachindex(vector_wyscout_data)
        if length(vector_wyscout_data[i].event.positions) == 2
            vector_wyscout_data[i].event_fixed.start_x = clamp(vector_wyscout_data[i].event.positions[1]["x"], 0, 105)
            vector_wyscout_data[i].event_fixed.start_y = clamp(vector_wyscout_data[i].event.positions[1]["y"], 0, 68)
            vector_wyscout_data[i].event_fixed.end_x = clamp(vector_wyscout_data[i].event.positions[2]["x"], 0, 105)
            vector_wyscout_data[i].event_fixed.end_y = clamp(vector_wyscout_data[i].event.positions[2]["y"], 0, 68)
        elseif length(event_df[i].positions) == 1
            vector_wyscout_data[i].event_fixed.start_x = clamp(vector_wyscout_data[i].event.positions[1]["x"], 0, 105)
            vector_wyscout_data[i].event_fixed.start_y = clamp(vector_wyscout_data[i].event.positions[1]["y"], 0, 68)
            vector_wyscout_data[i].event_fixed.end_x = clamp(vector_wyscout_data[i].event.start_x, 0, 105)
            vector_wyscout_data[i].event_fixed.end_y = clamp(vector_wyscout_data[i].event.start_y, 0, 68)
        end
    end

    return vector_wyscout_data
end