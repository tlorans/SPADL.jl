# This file contains functions to get the list of all available games in a season


"""
    PublicWyscoutGames
"""
Base.@kwdef struct PublicWyscoutGames
    data::DataFrame
end

"""
function games()
Return a dataframe with all available games in a season.
"""
function games(events_data::PublicWyscoutLoader, competition_id::Int, season_id::Int)::PublicWyscoutGames

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
    match_data = PublicWyscoutGames(data  = match_data)

    return match_data
end


"""
    function get_matchs()
"""
function get_matchs(loader::PublicWyscoutLoader,matches::String)

    zarchive = ZipFile.Reader(joinpath(loader.path,"matches.zip"))
    dictio = Dict(zarchive.files[i].name => i for i in eachindex(zarchive.files))
    file_num = dictio[matches]
    data = DataFrame(jsontable(JSON3.read(read(zarchive.files[file_num]))))


    return data
end