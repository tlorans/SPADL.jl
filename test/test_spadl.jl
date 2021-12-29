using SPADL

@time test = get_events_data(:wyscout, download = false, path = "wyscout_data")
GC.gc()
# we have to update the loader first
test = get_events(test, "events_Italy.json");

@time events_df = events(test, 2576336);

# @time check = get_tags(events_df)

events_df

# using DataFrames
# in_df = DataFrame(events_df)



@time check = (convert_to_actions(events_df))
using DataFrames

view = []
for i in eachindex(check)
    tmp = (check[i].event_fixed)
    push!(view, tmp)
end
view = DataFrame(view)


check[:selector_duel_won]
for i in eachindex(check[:selector_duel_won])
    if check[:selector_duel_won][i]
        println(check[:selector_duel_won][i])
    end
end



@time check = selector_duel_out_of_field(events_df);
