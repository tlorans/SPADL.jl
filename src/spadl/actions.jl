# This file contains functions to create the actions dataframe.


"""
    PublicWyscoutActions
"""
Base.@kwdef mutable struct PublicWyscoutActions
    data::DataFrame
end


"""
    function convert_to_actions()

Convert Wyscout events to SPADL actions
"""
function convert_to_actions(event_df::PublicWyscoutEvents)::PublicWyscoutActions
    tags_df = get_tagsdf(event_df)
    event_df.data = leftjoin(event_df.data, tags_df.data, on = :event_id)
    event_df = make_new_positions(event_df)
    event_df = fix_events(event_df)

    action_df = PublicWyscoutActions(data = event_df.data)
    return action_df
end
