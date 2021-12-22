using SPADL
using ProgressMeter
@time test = get_events_data(:wyscout)

GC.gc()



check = competitions(test)



match_test = games(test, 524, 181248)
teams_test = teams(test, 2576335)


players_test = players(test, 2576335)

using DataFrames, JSON3, JSONTables
@time events_df = events(test, 2576336)

@time check = convert_to_actions(events_df)

test_2 = convert_duels(check)
