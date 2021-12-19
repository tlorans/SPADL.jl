using SPADL

get_events_data(:wyscout)


using DataFrames
using ZipFile 
using JSON3, JSONTables
zarchive = ZipFile.Reader("/tmp/events.zip")
zarchive.files[1]
using JSON3 
typeof(zarchive)
zarchive

tmp = JSON3.read(read(zarchive.files[1]))
eltype(test)
test = get_df(:teams)

to_hdf(test, "wyscout.h5", "teams")

@time data = DataFrame(h5read("wyscout.h5", "teams"))
