# This file contains functions to fix events.

include("shot_coordinates.jl")
include("duels.jl")
include("offsides.jl")
include("interceptions.jl")


"""
    function fix_events()

Perform some fixes on the events such that the spadl action dataframe can be built. 
"""
function fix_events(event_df::PublicWyscoutEvents)

    event_df = create_shot_coordinates(event_df)
    event_df = convert_duels(event_df)

end