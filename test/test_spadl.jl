using SPADL 

test = get_events_data(:wyscout)
GC.gc()
# we have to update the loader first
test = get_events(test, "events_Italy.json")

@time events_df = events(test, 2576336)

events_df[1].tags[1]["id"]


@time check = get_tags(events_df)

using DataFrames
@time check = convert_to_actions(events_df)

view_check = check.data