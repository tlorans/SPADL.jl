# This file contains functions for loading events data

include("wyscout/loader.jl")

"""
    function get_events_data()
"""
function get_events_data(source::Symbol; path::String = "/data")

    if source == :wyscout 
        event_data_urls = WyscoutEventDataPublicSerializer()
        download_repo(event_data_urls, path)
        loader = PublicWyscoutLoader()
    end

    return loader
end
