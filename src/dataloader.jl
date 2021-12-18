# This file contains function for automatically load event data.

"""
EventDataLoader
"""
abstract type EventDataLoader end

"""
WyscoutEventDataPublicLoader
"""
Base.@kwdef struct WyscoutEventDataPublicLoader <: EventDataLoader
    events_url::String = "https://ndownloader.figshare.com/files/14464685"
    matches_url::String = "https://ndownloader.figshare.com/files/14464622"
    players_url::String = "https://ndownloader.figshare.com/files/15073721"
    teams_url::String = "https://ndownloader.figshare.com/files/15073697"
end

"""
    function download_event_data()
"""
function download_event_data(data_loader::WyscoutEventDataPublicLoader, path::String)

    HTTP.download(data_loader.events_url, local_path = path)
    HTTP.download(data_loader.matches_url,local_path = path)
    HTTP.download(data_loader.players_url, local_path = path)
    HTTP.download(data_loader.teams_url, local_path = path)
end
"""
    function get_events_data()
"""
function get_events_data(;source::Symbol, path::String = "/data")

    if source == :wyscout 
        event_data_urls = WyscoutEventDataPublicLoader()
        download_event_data(event_data_urls, path)
    end


end