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
function get_events_data(source::Symbol; download::Bool = true, path::String = "wyscout_data")

    mkdir(path)
    if source == :wyscout 
        event_data_urls = PublicWyscoutURLs()
        if download download_repo(event_data_urls, path) end
        loader = PublicWyscoutLoader()
        loader = create_match_index(loader)
    end

    # return loader
end
