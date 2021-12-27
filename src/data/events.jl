# This file contains functions to get the events data

Base.convert(::Type{JSON3.Array}, x::Vector{JSON3.Object}) = x


"""
    WyscoutEvent
Definition of a struct containing event stream data for a particular event.
"""
Base.@kwdef mutable struct WyscoutEvent
    event_id::Int 
    game_id::Int 
    milliseconds::Float64
    period_id::String 
    player_id::Int 
    positions::Vector{Dict}
    subtype_id::Int
    subtype_name::String 
    tags::Vector{Dict}
    team_id::Int 
    type_id::Int
    type_name::String
end


"""
    function events()
Return a Dataframe with all events in the game
"""
function events(events_data::PublicWyscoutLoader, game_id::Int)::Vector{WyscoutEvent}    
    subset_test = subset_indexes_lazy(events_data.events, game_id)
   

    subset_dic = convert.(Dict, subset_test)
    vector_events = Vector{WyscoutEvent}()

    for i in eachindex(subset_dic)

        event = WyscoutEvent(
            event_id = subset_dic[i]["id"],
            game_id = subset_dic[i]["matchId"],
            milliseconds = subset_dic[i]["eventSec"],
            period_id =  string(subset_dic[i]["matchPeriod"]),
            player_id = subset_dic[i]["playerId"],
            positions = convert.(Dict,subset_dic[i]["positions"]),
            subtype_id = if typeof(subset_dic[i]["subEventId"]) == LazyJSON.String{String} 0 else subset_dic[i]["subEventId"] end,
            subtype_name = string(subset_dic[i]["subEventName"]),
            tags = convert.(Dict,subset_dic[i]["tags"]),
            team_id = convert(Int,subset_dic[i]["teamId"]),
            type_id = subset_dic[i]["eventId"],
            type_name = string(subset_dic[i]["eventName"])
        )
        push!(vector_events, event)
    end

    return vector_events
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


