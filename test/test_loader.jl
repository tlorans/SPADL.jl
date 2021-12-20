using SPADL

test = get_events_data(:wyscout)

check = test.match_index
check = competitions(test)
println(check[:,:name])
# using DataFrames
# using ZipFile 
# using JSON3, JSONTables
zarchive = ZipFile.Reader("/tmp/matches.zip")
# zarchive.files[1]
# using JSON3 



# test = get_matchs(match_index[1,:db_matches])
# println(names(test))

# DataFrame(DataFrame(test[1,:teamsData])[1,1])





# eachindex(match_index.db_matches)

# test = get_df(:competitions)
# match_index

# match_index = create_match_index()

# test = lineup(match_index, 2576335)
# DataFrame(test["3162"][:,:formation])


# get_df()

# to_hdf(test, "wyscout.h5", "teams")
