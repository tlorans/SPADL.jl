# This file contains function for automatically load event data.

Base.convert(::Type{JSON3.Array}, x::Vector{JSON3.Object}) = x

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
    events_Italy::Vector{Any} = convert(Vector{Any},LazyJSON.parse(get_events("events_Italy.json")))
end

"""
    function create_match_index()
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

        rename!(tmp, :wyId => :match_id,
        :competitionId => :competition_id,
        :seasonId => :season_id)

        tmp = tmp[:, [:match_id, :competition_id, :season_id]]
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


    return data
end

"""
    function get_events(events::String)
"""
function get_events(events::String)
    zarchive = ZipFile.Reader("/tmp/events.zip")
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[events]
    str = read(zarchive.files[file_num])
    
    return str
end

"""
    function get_df()
"""
function get_df(file::String)

    data = DataFrame(jsontable(JSON3.read(read(string("/tmp/",file)))))

    return data
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
    function games()
Return a dataframe with all available games in a season.
"""
function games(events_data::PublicWyscoutLoader, competition_id::Int, season_id::Int)
    
    data = filter("competition_id" => ==(competition_id),events_data.match_index)
    data = filter("season_id"=> ==(season_id), data)
    data = unique(data[:,[:competition_id, :season_id, :db_matches]])

    match_data = get_matchs(data[1,:db_matches])
    rename!(match_data, :seasonId => :season_id,
                        :gameweek => :game_day,
                        :competitionId => :competition_id,
                        :wyId => :game_id,
                        :dateutc => :game_date)
    
    match_data = leftjoin(match_data,data, on = [:competition_id, :season_id])
    insertcols!(match_data, :home_team_id => 0, :away_team_id => 0)
    for i in eachindex(match_data.season_id)
        teams_id = names(DataFrame(match_data[i, :teamsData]))
        match_data[i, :home_team_id] = parse(Int,teams_id[1])
        match_data[i, :away_team_id] = parse(Int,teams_id[2])
    end

    match_data = match_data[:,[:season_id, :competition_id, :game_day, :game_id, :game_date,:home_team_id, :away_team_id]]

    return match_data
end

"""
    function teams()

Return a dataframe with both teams that participated in a game.
"""
function teams(event_data::PublicWyscoutLoader, game_id::Int)

    teams_df = get_df("teams.json")
    rename!(teams_df, :name => :team_name_short,
                        :officialName => :team_name,
                        :wyId => :team_id)

    teams_df = teams_df[:,[:team_id, :team_name, :team_name_short]]
    teams_id = collect(keys(lineup(event_data, game_id)))
    teams_id = DataFrame(:team_id => parse.(Int, teams_id))

    data = leftjoin(teams_id, teams_df, on = :team_id)
    return data
end


"""
    function players()
Return a dataframe with all players that participated in a game.
"""
function players(event_data::PublicWyscoutLoader, game_id::Int)

    players_df = get_df("players.json")
    players_df = convert_players(players_df)

    lineups = lineup(event_data, game_id)

    list_df = []
    list_teams = collect(keys(lineups))
    for team in list_teams
        df_team = lineups[team]
        df_players = DataFrame(df_team[:,:formation])
        playerslist = DataFrame(df_players[1,:lineup])[:,:playerId]


        substitutes = DataFrame(df_players[1,:substitutions])
        playerslist = vcat(playerslist, vec(substitutes[:,:playerIn]))

        playerslist = DataFrame(:player_id => playerslist,
                                :is_starter => true,
                                :minutes_played => 90)

        for j in eachindex(playerslist.player_id)
            if playerslist[j, :player_id] in vec(substitutes[:,:playerOut])
                new_min_played = filter("playerOut" => ==(playerslist[j,:player_id]), substitutes)[1,:minute]
                playerslist[j, :minutes_played] = new_min_played
            elseif playerslist[j, :player_id] in vec(substitutes[:,:playerIn])
                new_min_played = filter("playerIn" => ==(playerslist[j,:player_id]), substitutes)[1,:minute]
                playerslist[j, :minutes_played] -= new_min_played
            end
        end

        insertcols!(playerslist, :game_id => game_id,
                    :team_id => parse(Int,team))

        push!(list_df, playerslist)
    end

    teams_df = reduce(vcat, list_df)
    players_df = leftjoin(teams_df, players_df, on = :player_id)

    return players_df
end

function convert_players(data::DataFrame)
    players_df = data[:,[:firstName, :lastName, :birthDate,
                                :shortName,:wyId]]
    
    rename!(
        players_df,
        :firstName => :firstname,
        :lastName => :lastname,
        :shortName => :nickname, 
        :birthDate => :birth_data,
        :wyId => :player_id
    )

    names_col = [:firstname, :lastname, :nickname]
    for col in names_col
        players_df[:,col] = unescape_string.(players_df[:,col])
    end

    insertcols!(players_df, :player_name => string.(players_df[:,:firstname]," ",players_df[:,:lastname]))

    return players_df
end

"""
    function events()
Return a Dataframe with all events in the game
"""
function events(events_data::PublicWyscoutLoader, game_id::Int)
    view = filter("match_id"=> ==(game_id), events_data.match_index)[1,:db_events]
    
    if view == "events_Italy.json"
        subset_test = subset_indexes_lazy(events_data.events_Italy, game_id)
        result = transform_to_df(subset_test)
    end

   
    data = convert_events(result)
    return data
end


"""
    function convert_events()
"""
function convert_events(data::DataFrame)

    rename!(data, :id => :event_id,
                    :matchId => :game_id,
                    :matchPeriod => :period_id,
                    :eventSec => :milliseconds,
                    :teamId => :team_id,
                    :playerId => :player_id,
                    :eventId => :type_id,
                    :eventName => :type_name,
                    :subEventId => :subtype_id,
                    :subEventName => :subtype_name)


    data[:, :milliseconds] = data[:,:milliseconds] * 1000
    return data
end

function lineup(event_data::PublicWyscoutLoader, game_id::Int)
    tmp = filter("match_id" => ==(game_id), event_data.match_index)
    data = get_matchs(tmp[1,:db_matches])
    data = filter("wyId"=> ==(game_id), data)[:,"teamsData"]
    data = DataFrame(data)
    data = Dict(i => DataFrame(data[:,i]) for i in names(data))

    return data
end

"""
    function subset_index_lazy 

Use the vector Any v which is the JSON parsed lazily and the game_id to request data
with matchId correspoding to the game id.
"""
function subset_indexes_lazy(v, game_id::Int)
    json_data = []
    @inbounds for i in eachindex(v)
        if v[i]["matchId"] == game_id 
            push!(json_data, v[i])
        end
    end 
    return json_data
end


"""
    function transform_to_df

A specialised function to transform the requested subpart of the JSON event to a DataFrame.
"""
function transform_to_df(json_subset)
    subset_dic = convert.(Dict, json_subset)

    test_df = DataFrame(:playerId => zeros(length(subset_dic)),
        :matchId => zeros(length(subset_dic)),
        :eventName => "",
        :positions => [Vector{Dict}[] for i in eachindex(subset_dic)],
        :eventId => zeros(length(subset_dic)),
        :subEventName => "",
        :teamId => zeros(length(subset_dic)),
        :id => zeros(length(subset_dic)),
        :matchPeriod => "",
        :subEventId => "",
        :eventSec => zeros(length(subset_dic)),
        :tags => [Vector{Dict}[] for i in eachindex(subset_dic)])

    for i in eachindex(test_df.playerId)
        test_df[i, :playerId] = subset_dic[i]["playerId"]
        test_df[i, :positions] = [convert.(Dict,subset_dic[i]["positions"])]
        test_df[i, :matchId] = subset_dic[i]["matchId"]
        test_df[i, :eventName] = string(subset_dic[i]["eventName"])
        test_df[i, :eventId] = subset_dic[i]["eventId"]
        test_df[i, :subEventName] = string(subset_dic[i]["subEventName"])
        test_df[i, :teamId] = subset_dic[i]["teamId"]
        test_df[i, :id] = subset_dic[i]["id"]
        test_df[i, :matchPeriod] = string(subset_dic[i]["matchPeriod"])
        test_df[i, :subEventId] = string(subset_dic[i]["subEventId"])
        test_df[i, :eventSec] = subset_dic[i]["eventSec"]
        test_df[i, :tags] = [convert.(Dict,subset_dic[i]["tags"])]
    end

    return test_df
end

# function process_lazy(events::String, game_id::Int)
#     str = get_events(events)
#     v = LazyJSON.parse(str)
#     subset_test = subset_indexes_lazy(v, game_id)
#     result = transform_to_df(subset_test)
# end