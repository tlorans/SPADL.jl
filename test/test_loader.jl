using SPADL

get_events_data(:wyscout)


using DataFrames
using ZipFile 
using JSON3, JSONTables
zarchive = ZipFile.Reader("/tmp/matches.zip")
zarchive.files[1]
using JSON3 


test = get_matchs(match_index[1,:db_matches])
println(names(test))

DataFrame(DataFrame(test[1,:teamsData])[1,1])







test = get_df(:competitions)

to_hdf(test, "wyscout.h5", "teams")

match_index = create_match_index()

get_df()
