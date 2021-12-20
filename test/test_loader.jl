using SPADL

test = get_events_data(:wyscout)

check = competitions(test)



match_test = games(test, 524, 181248)
test.match_index
teams_test = teams(test, 2576335)


using DataFrames
findshirtnumber = lineup(test, 2576335)
findshirtnumber_step_2 = DataFrame(DataFrame(findshirtnumber["3161"])[:,:formation])
findshirtnumber_step_3 = DataFrame(findshirtnumber_step_2[1,:substitutions])

players_test = players(test, 2576335)


# view = test.match_index[1,:db_events]
# events_dic = get_events(view)
