# This file contains functions to get the events data

Base.convert(::Type{JSON3.Array}, x::Vector{JSON3.Object}) = x


"""
PublicWyscoutEvents
"""
Base.@kwdef mutable struct PublicWyscoutEvents
    data::DataFrame 
end


"""
    function events()
Return a Dataframe with all events in the game
"""
function events(events_data::PublicWyscoutLoader, game_id::Int)::PublicWyscoutEvents
    view = filter("match_id"=> ==(game_id), events_data.match_index)[1,:db_events]
    
    subset_test = subset_indexes_lazy(events_data.events, game_id)
    result = transform_to_df(subset_test)

    result = PublicWyscoutEvents(data = result)
   
    data = convert_events(result)
    return data
end


"""
    function convert_events()
"""
function convert_events(event_df::PublicWyscoutEvents)

    rename!(event_df.data, :id => :event_id,
                    :matchId => :game_id,
                    :matchPeriod => :period_id,
                    :eventSec => :milliseconds,
                    :teamId => :team_id,
                    :playerId => :player_id,
                    :eventId => :type_id,
                    :eventName => :type_name,
                    :subEventId => :subtype_id,
                    :subEventName => :subtype_name)


    event_df.data[:, :milliseconds] = event_df.data[:,:milliseconds] * 1000
    return event_df
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
    return json_data
end


"""
    function transform_to_df

A specialised function to transform the requested subpart of the JSON event to a DataFrame.
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