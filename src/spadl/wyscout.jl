# This file contains functions to translate dataframe events to spadl actions 
"""
    function convert_to_actions()

Convert Wyscout events to SPADL actions
"""
function convert_to_actions(event_df::DataFrame)
    tags_df = get_tagsdf(event_df)
    event_df = leftjoin(event_df, tags_df, on = :event_id)
    event_df = make_new_positions(event_df)
    event_df = fix_wyscout_events(event_df)

    return event_df
end



"""
    function fix_wyscout_events()

Perform some fixes on the Wyscout events such that the spadl action dataframe can be built. 
"""
function fix_wyscout_events(event_df::DataFrame)

    event_df = create_shot_coordinates(event_df)

end
