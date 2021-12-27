using SPADL

@time test = get_events_data(:wyscout, download = false, path = "wyscout_data")


GC.gc()



check = competitions(test)



match_test = games(test, 524, 181248)


teams_test = teams(test, 2576335)


players_test = players(test, 2576335)

# we have to update the loader first
@time test = get_events(test, "events_Italy.json");

@time events_df = events(test, 2576336);

events_df[1]

