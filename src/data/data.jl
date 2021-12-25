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
"""
function get_events_data(source::Symbol; path::String = "/data")

    if source == :wyscout 
        event_data_urls = PublicWyscoutURLs()
        download_repo(event_data_urls, path)
        loader = PublicWyscoutLoader()
        loader = create_match_index(loader)
    end

    return loader
end
