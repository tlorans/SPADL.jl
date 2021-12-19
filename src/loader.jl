# This file contains function for automatically load event data.

"""
Serializers
"""
abstract type Serializer end

"""
    WyscoutEventDataPublicSerializer
"""
Base.@kwdef struct WyscoutEventDataPublicSerializer <: Serializer
    competitions_url::String = "https://ndownloader.figshare.com/files/15073685"
    events_url::String = "https://ndownloader.figshare.com/files/14464685"
    matches_url::String = "https://ndownloader.figshare.com/files/14464622"
    players_url::String = "https://ndownloader.figshare.com/files/15073721"
    teams_url::String = "https://ndownloader.figshare.com/files/15073697"
end

"""
    function get_competitions()
"""
function create_match_index()


competitions = """
[
    {
        "competition_id": 524,
        "season_id": 181248,
        "season_name": "2017/2018",
        "db_matches": "matches_Italy.json",
        "db_events": "events_Italy.json"
    },
    {
        "competition_id": 364,
        "season_id": 181150,
        "season_name": "2017/2018",
        "db_matches": "matches_England.json",
        "db_events": "events_England.json"
    },
    {
        "competition_id": 795,
        "season_id": 181144,
        "season_name": "2017/2018",
        "db_matches": "matches_Spain.json",
        "db_events": "events_Spain.json"
    },
    {
        "competition_id": 412,
        "season_id": 181189,
        "season_name": "2017/2018",
        "db_matches": "matches_France.json",
        "db_events": "events_France.json"
    },
    {
        "competition_id": 426,
        "season_id": 181137,
        "season_name": "2017/2018",
        "db_matches": "matches_Germany.json",
        "db_events": "events_Germany.json"
    },
    {
        "competition_id": 102,
        "season_id": 9291,
        "season_name": "2016",
        "db_matches": "matches_European_Championship.json",
        "db_events": "events_European_Championship.json"
    },
    {
        "competition_id": 28,
        "season_id": 10078,
        "season_name": "2018",
        "db_matches": "matches_World_Cup.json",
        "db_events": "events_World_Cup.json"
    }
]"""

    competitions = DataFrame(jsontable(JSON3.read((competitions))))

    return competitions

end


"""
    function get_matchs()
"""
function get_matchs(matches::String)

    zarchive = ZipFile.Reader("/tmp/matches.zip")
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[matches]
    data = DataFrame(jsontable(JSON3.read(read(zarchive.files[file_num]))))
    return data
end

"""
    function download_repo()
"""
function download_repo(data_loader::WyscoutEventDataPublicSerializer, path::String)

    HTTP.download(data_loader.competitions_url, local_path = path)
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
        download_repo(event_data_urls, path)
    end

    return
end

"""
    function get_df()
"""
function get_df(file::String)

    data = DataFrame(jsontable(JSON3.read(read(string("/tmp/",file)))))
    # if file == :teams
    #     data = DataFrame(jsontable(JSON3.read(read("/tmp/teams.json"))))
    #     data = data[:, [:name, :wyId, :officialName]]
    #     rename!(data, [:team_name_short, :team_id, :team_name])
    
    # elseif file == :competitions 
    #     data = DataFrame(jsontable(JSON3.read(read("/tmp/competitions.json"))))
    #     data = data[:,[:wyId, :name]]

    # elseif file == :players
    #     data = DataFrame(jsontable(JSON3.read(read("/tmp/players.json"))))
 
    # end


    return data
end

