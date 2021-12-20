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
    PublicWyscoutLoader
"""
Base.@kwdef struct PublicWyscoutLoader
    match_index::DataFrame = create_match_index()
end

"""
    function competitions()
Return a dataframe with all available competitions and seasons.
"""
function competitions(events_data::PublicWyscoutLoader)
    data = get_df("competitions.json")
    rename!(data, :wyId => :competition_id, :name => :competition_name)
    country_names = DataFrame(data[:, :area])[:,:name]
    for i in eachindex(country_names)
        if country_names[i] == ""
            country_names[i] = "International"
        end 
    end
    insertcols!(data, :country_name => country_names,
                    :competition_gender => "male")

    data = data[:,[:competition_id, :competition_name, :country_name, :competition_gender]]

    data = leftjoin(data, unique(events_data.match_index[:,[:competition_id, :season_id, :season_name]]), on = [:competition_id])

    return data
end


"""
    function get_competitions()
"""
function create_match_index()


for_index = """
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

    for_index = DataFrame(jsontable(JSON3.read((for_index))))

    list_matches = []

    for i in eachindex(for_index.db_matches)
        tmp = get_matchs(for_index[i,:db_matches])
        push!(list_matches,tmp)
    end

    matches = reduce(vcat, list_matches)

    matches = leftjoin(matches, for_index, on = [:competition_id, :season_id])
    return matches
end


"""
    function get_matchs()
"""
function get_matchs(matches::String)

    zarchive = ZipFile.Reader("/tmp/matches.zip")
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[matches]
    data = DataFrame(jsontable(JSON3.read(read(zarchive.files[file_num]))))

    rename!(data, :wyId => :match_id,
        :competitionId => :competition_id,
        :seasonId => :season_id)
    
    data = data[:, [:match_id, :competition_id, :season_id]]

    return data
end



"""
    function get_df()
"""
function get_df(file::String)

    data = DataFrame(jsontable(JSON3.read(read(string("/tmp/",file)))))

    return data
end

function lineup(match_index::DataFrame, game_id::Int)
    tmp = filter("match_id" => ==(game_id), match_index)
    data = get_matchs(tmp[1,:db_matches])
    data = filter("match_id"=> ==(game_id), data)[:,"teamsData"]
    data = DataFrame(data)
    data = Dict(i => DataFrame(data[:,i]) for i in names(data))

    return data
end