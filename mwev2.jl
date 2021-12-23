using DataFrames, JSON3, JSONTables, ZipFile, LazyJSON


function get_events(events::String)
    zarchive = ZipFile.Reader("/tmp/events.zip")
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[events]
    str = read(zarchive.files[file_num])
    
    return str
end

events_test = "events_Italy.json"
str = get_events(events_test)
v = LazyJSON.parse(str);
v = convert(Vector{Any},v)
# @time subset_indexes_lazy(v, 2576336)
"""
    function convert_events()
"""
function convert_events(data::DataFrame)

    rename!(data, :id => :event_id,
                    :matchId => :game_id,
                    :matchPeriod => :period_id,
                    :eventSec => :milliseconds,
                    :teamId => :team_id,
                    :playerId => :player_id,
                    :eventId => :type_id,
                    :eventName => :type_name,
                    :subEventId => :subtype_id,
                    :subEventName => :subtype_name)


    data[:, :milliseconds] = data[:,:milliseconds] * 1000
    return data
end


"""
    function subset_index_lazy 

Use the vector Any v which is the JSON parsed lazily and the game_id to request data
with matchId correspoding to the game id.
"""
function subset_indexes_lazy(v::Vector{Any}, game_id::Int) 
    json_data = Vector{Any}()
    @inbounds for i in eachindex(v)
        if v[i]["matchId"] == game_id 
            push!(json_data, v[i])
        end
    end    
    # json_data = Vector(Any, 2000)
    # count = 0
    # @inbounds for i in eachindex(v)
    #     if v[i]["matchId"] == game_id 
    #         count += 1
    #         json_data[count] = v[i]
    #     end
    # end
    return json_data
end


"""
    function transform_to_df

"""
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

"""
    function events()
Return a Dataframe with all events in the game
"""
function events(events_Italy, game_id::Int)
    subset_test = subset_indexes_lazy(events_Italy, game_id)
    result = transform_to_df(subset_test)
    data = convert_events(result)
    return data
end


@time events(v, 2576337)


