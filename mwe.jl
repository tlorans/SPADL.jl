using DataFrames, JSON3, JSONTables, ZipFile, LazyJSON
Base.convert(::Type{JSON3.Array}, x::Vector{JSON3.Object}) = x

function get_events(events::String)
    zarchive = ZipFile.Reader("/tmp/events.zip")
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[events]
    str = read(zarchive.files[file_num])
    
    return str
end


function createDict(str)

    inDict = JSON3.read(str)
    return inDict
end

function create_subset_json(json_data, game_id::Int)
    subset_json_indexes = [i for i in eachindex(json_data) if json_data[i][:matchId] == game_id]
    subset_json = json_data[subset_json_indexes]
    json_data = nothing
    Base.GC.gc()
    subset_json = DataFrame(convert(JSON3.Array,subset_json))
    return subset_json
end


function all_process(events::String, game_id::Int)
    json_data = createDict(get_events(events))
    data = create_subset_json(json_data, 2576335)
    json_data = nothing
    Base.GC.gc()
    return data 
end

# Base.GC.gc()
@time all_process("events_Italy.json", 2576335)


# str = get_events("events_Italy.json")


# @time v = LazyJSON.parse(str);

function subset_indexes_lazy(json_data, game_id::Int)
    json_data = convert(Vector{Any},v)
    json_data = [i for i in v if i["matchId"] == game_id]
    # json_data = DataFrame(json_data)
end



function transform_to_df(json_subset)
    subset_dic = convert.(Dict, json_subset)

    test_df = DataFrame(:playerId => zeros(length(subset_dic)),
        :matchId => zeros(length(subset_dic)),
        :eventName => "",
        :positions => [Vector{Dict}[] for i in eachindex(subset_dic)],
        :eventId => zeros(length(subset_dic)),
        :subEventName => "",
        :teamId => zeros(length(subset_dic)),
        :id => zeros(length(subset_dic)),
        :matchPeriod => "",
        :subEventId => "",
        :eventSec => zeros(length(subset_dic)),
        :tags => [Vector{Dict}[] for i in eachindex(subset_dic)])

    for i in eachindex(test_df.playerId)
        test_df[i, :playerId] = subset_dic[i]["playerId"]
        test_df[i, :positions] = [convert.(Dict,subset_dic[i]["positions"])]
        test_df[i, :matchId] = subset_dic[i]["matchId"]
        test_df[i, :eventName] = string(subset_dic[i]["eventName"])
        test_df[i, :eventId] = subset_dic[i]["eventId"]
        test_df[i, :subEventName] = string(subset_dic[i]["subEventName"])
        test_df[i, :teamId] = subset_dic[i]["teamId"]
        test_df[i, :id] = subset_dic[i]["id"]
        test_df[i, :matchPeriod] = string(subset_dic[i]["matchPeriod"])
        test_df[i, :subEventId] = string(subset_dic[i]["subEventId"])
        test_df[i, :eventSec] = subset_dic[i]["eventSec"]
        test_df[i, :tags] = [convert.(Dict,subset_dic[i]["tags"])]
    end

    return test_df
end

function process_lazy(events::String, game_id::Int)
    str = get_events(events)
    v = LazyJSON.parse(str)
    subset_test = subset_indexes_lazy(v, game_id)
    result = transform_to_df(subset_test)
end


# @time subset_test = subset_indexes_lazy(v, 2576335)

# @time result = transform_to_df(subset_dic)



@time test = process_lazy("events_Italy.json", 2576335)






# @time DataFrame(subset_dic)

# @time subset_df = vcat(DataFrame.(subset_dic)...)

# @time 
# check = jsontable(subset_test)
# @time testDict = createDict(str)

typeof(testDict)

Base.convert(::Type{JSON3.Array}, x::Vector{JSON3.Object}) = x


@time test_subset = create_subset_json(testDict, 2576335)

typeof(convert(JSON3.Array, test_subset))


