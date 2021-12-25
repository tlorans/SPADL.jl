# This file contains function for automatically load event data.

"""
URLs
"""
abstract type URLs end

"""
    PublicWyscoutURLs
"""
Base.@kwdef struct PublicWyscoutURLs <: URLs
    competitions_url::String = "https://ndownloader.figshare.com/files/15073685"
    events_url::String = "https://ndownloader.figshare.com/files/14464685"
    matches_url::String = "https://ndownloader.figshare.com/files/14464622"
    players_url::String = "https://ndownloader.figshare.com/files/15073721"
    teams_url::String = "https://ndownloader.figshare.com/files/15073697"
end

"""
    function download_repo()
"""
function download_repo(data_loader::PublicWyscoutURLs, path::String)

    HTTP.download(data_loader.competitions_url, local_path = path)
    HTTP.download(data_loader.events_url, local_path = path)
    HTTP.download(data_loader.matches_url,local_path = path)
    HTTP.download(data_loader.players_url, local_path = path)
    HTTP.download(data_loader.teams_url, local_path = path)
end