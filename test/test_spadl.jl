using SPADL

@time test = get_events_data(:wyscout, download = false, path = "wyscout_data")
GC.gc()
# we have to update the loader first
test = get_events(test, "events_Italy.json");

@time events_df = events(test, 2576336);



@time check = convert_to_actions(events_df)


configs = ActionsConfig()
findall(x -> x == "head", configs.bodyparts)



using DataFrames

#### We need to add miliseconds in WyscoutEventFixed
view = []
for i in eachindex(check)
    tmp = (check[i].event_fixed)
    push!(view, tmp)
end
view = DataFrame(view)

# for i in 1:size(view,1)
#     if i > 1 && view[i, :period_id] == view[i-1, :period_id]
#         if view[i, :milliseconds] < view[i-1, :milliseconds]
#             println("we have a problem", i)
#         end
#     end
# end


