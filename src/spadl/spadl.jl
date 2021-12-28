# This file contains function to convert events dataframe to SPADL representation.

include("tags.jl")
include("actions.jl")
include("positions.jl")
include("fixing_events/shot_coordinates.jl")
include("fixing_events/duels.jl")


"""
    function convert_to_spadl()

Convert Wyscout events to SPADL actions
"""
function convert_to_spadl(event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}
    # Create the vector of spadl actions
    # spadl_df = [RegularSPADL() for i in eachindex(event_df)]
    # tags_df = get_tags(event_df)

    # spadl_df = make_new_positions(spadl_df, tags_df, event_df)

    return action_df
end


