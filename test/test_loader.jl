using SPADL

test = get_events_data(:wyscout)





check = competitions(test)



match_test = games(test, 524, 181248)
teams_test = teams(test, 2576335)


players_test = players(test, 2576335)

using DataFrames, JSON3, JSONTables
@time events_df = events(test, 2576335)


new_df = make_new_positions(events_df)

@time check = get_tagsdf(events_df)

@time check = convert_to_actions(events_df)

duel_out_of_field(check)

verif = check[:,[:subtype_id]]


verif[verif.subtype_id .== "",:subtype_id] 

filter!(!isempty, verif)