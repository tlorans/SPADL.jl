# This file contains functions for loading events data

include("downloads.jl")
include("loader.jl")
include("competitions.jl")
include("games.jl")
include("teams.jl")
include("players.jl")
include("utils.jl")
include("events.jl")

"""
    function get_events_data()
Obtaining the events stream data. 

# Optional Arguments
- `download=true`: specifies if the data need to be downloaded or not. If set to false, a `path` need to be provided.
- `path=""`; specifies the local path where the data are located if `download=false` and the path where the data will be stored if `download=true`.
"""
function get_events_data(source::Symbol; download::Bool = true, path::String = "")
    
    if download
        path = joinpath(path, "wyscout_data")
        mkdir(path)
    elseif !download && path != ""
        path = joinpath(path)
    else 
        throw(ArgumentError("Please provide a local path"));
    end 

    # At the moment we only support Wyscout data
    if source == :wyscout 
        event_data_urls = PublicWyscoutURLs()
        if download || length(readdir(path)) == 0
            download_repo(event_data_urls, path)
        end
        loader = PublicWyscoutLoader(path = path)
        loader = create_match_index(loader)
    else 
        throw(ArgumentError("Please provide a valid source name: `:wyscout`"));
    end

    return loader
end
