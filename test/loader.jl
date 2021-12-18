using SPADL

get_events_data(:wyscout)



using ZipFile 

zarchive = ZipFile.Reader("/tmp/events.zip")

using JSON3 
typeof(zarchive)
zarchive

test = JSON3.read(zarchive.files[1])

using JSONTables
using DataFrames
test_table = DataFrame(jsontable(test))
println(names(test_table))
check = DataFrame(jsontable(test_table[1,:positions]))
test_table

using HDF5 

# with file easier teams 
teams = JSON3.read(read("/tmp/teams.json"))




h5write("test.h5","events", Matrix(test_table[:,1:2]))
