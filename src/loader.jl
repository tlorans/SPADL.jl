# This file contains function for automatically load event data.

"""
Serializers
"""
abstract type Serializer end

"""
    WyscoutEventDataPublicSerializer
"""
Base.@kwdef struct WyscoutEventDataPublicSerializer <: Serializer
    events_url::String = "https://ndownloader.figshare.com/files/14464685"
    matches_url::String = "https://ndownloader.figshare.com/files/14464622"
    players_url::String = "https://ndownloader.figshare.com/files/15073721"
    teams_url::String = "https://ndownloader.figshare.com/files/15073697"
end

"""
    function download_repo()
"""
function download_repo(data_loader::WyscoutEventDataPublicSerializer, path::String)

    HTTP.download(data_loader.events_url, local_path = path)
    HTTP.download(data_loader.matches_url,local_path = path)
    HTTP.download(data_loader.players_url, local_path = path)
    HTTP.download(data_loader.teams_url, local_path = path)
end

"""
    function get_events_data()
"""
function get_events_data(source::Symbol; path::String = "/data")

    if source == :wyscout 
        event_data_urls = WyscoutEventDataPublicSerializer()
        download_events_data(event_data_urls, path)
    end

    return
end


"""
    function get_df()
"""
function get_df(file::Symbol)

    if file == :teams
        data = DataFrame(jsontable(JSON3.read(read("/tmp/teams.json"))))
        data = data[:, [:name, :wyId, :officialName]]
        rename!(data, [:team_name_short, :team_id, :team_name])
    end


    return data
end


"""
    function to_hdf()
"""
function to_hdf(data::DataFrame, file_path::String, name::String)
    h5open(file_path, "w") do file
        g = create_group(file, name) # create a group
        for col in names(data)
            g[col] = data[:,col]
        end
    end
end

"""
    function hdf_to_df()
"""
function hdf_to_df(file_path::String, name::String)

    data = DataFrame(h5read(file_path, name))
    return data
end