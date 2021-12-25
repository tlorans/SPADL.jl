# This file contains functions to create the actions dataframe.

"""
    function convert_to_actions()

Convert Wyscout events to SPADL actions
"""
function convert_to_actions(event_df::PublicWyscoutEvents)
    tags_df = get_tagsdf(event_df)
    event_df.data = leftjoin(event_df.data, tags_df, on = :event_id)
    event_df = make_new_positions(event_df)
    event_df = fix_events(event_df)

    return event_df
end
