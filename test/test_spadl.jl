using SPADL 

test = get_events_data(:wyscout)
GC.gc()
# we have to update the loader first
test = get_events(test, "events_Italy.json")

@time events_df = events(test, 2576336);

# @time check = get_tags(events_df)

@time check = convert_to_actions(events_df);

@time check = convert_duels(events_df);

@time check = selector_duel_out_of_field(events_df);
