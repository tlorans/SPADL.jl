using SPADL

test = get_events_data(:wyscout)





check = competitions(test)



match_test = games(test, 524, 181248)
teams_test = teams(test, 2576335)


players_test = players(test, 2576335)

using DataFrames, JSON3, JSONTables
@time events_df = events(test, 2576335)


new_df = make_new_positions(events_df)

check = get_tagsdf(events_df)

