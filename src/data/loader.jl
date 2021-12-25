# This file contains functions to load data for the loader (ie. the match index and the events parsed JSON to be able to search for a particular game)

"""
    PublicWyscoutLoader
"""
Base.@kwdef mutable struct PublicWyscoutLoader
    match_index::Union{DataFrame,Nothing} = nothing
    events::Union{Vector{Any}, Nothing} = nothing
end



"""
    function create_match_index()
"""
function create_match_index(loader::PublicWyscoutLoader)::PublicWyscoutLoader


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

        rename!(tmp, :wyId => :match_id,
        :competitionId => :competition_id,
        :seasonId => :season_id)

        tmp = tmp[:, [:match_id, :competition_id, :season_id]]
        push!(list_matches,tmp)
    end

    matches = reduce(vcat, list_matches)

    matches = leftjoin(matches, for_index, on = [:competition_id, :season_id])
    loader.match_index = matches

    return loader
end



"""
    function get_events()
"""
function get_events(loader::PublicWyscoutLoader, str::String)::PublicWyscoutLoader
    zarchive = ZipFile.Reader("/tmp/events.zip")
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[str]
    str = read(zarchive.files[file_num])
    str = LazyJSON.parse(str)
    str = convert(Vector{Any},str)

    loader.events = str

    return loader
end



