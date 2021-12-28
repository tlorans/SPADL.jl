# This file contains functions to create new positions.

"""
function make_new_positions

Return a new vector of SPADL.
"""
function make_new_positions(vector_wyscout_data::Vector{WyscoutData})::Vector{WyscoutData}

    for i in eachindex(vector_wyscout_data.event)
        if length(event_df[i].positions) == 2
            spadl_df[i].start_x = clamp(event_df[i].positions[1]["x"], 0, 105)
            spadl_df[i].start_y = clamp(event_df[i].positions[1]["y"], 0, 68)
            spadl_df[i].end_x = clamp(event_df[i].positions[2]["x"], 0, 105)
            spadl_df[i].end_y = clamp(event_df[i].positions[2]["y"], 0, 68)
        elseif length(event_df[i].positions) == 1
            spadl_df[i].start_x = clamp(event_df[i].positions[1]["x"], 0, 105)
            spadl_df[i].start_y = clamp(event_df[i].positions[1]["y"], 0, 68)
            spadl_df[i].end_x = clamp(spadl_df[i].start_x, 0, 105)
            spadl_df[i].end_y = clamp(spadl_df[i].start_y, 0, 68)
        end
    end

    return spadl_df
end