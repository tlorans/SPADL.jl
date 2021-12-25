
# This file contains functions to get all players that participated in a game.


"""
    PublicWyscoutPlayers
"""
Base.@kwdef mutable struct PublicWyscoutPlayers 
    data::DataFrame = get_df("players.json")
end

"""
function players()
Return a dataframe with all players that participated in a game.
"""
function players(event_data::PublicWyscoutLoader, game_id::Int)::PublicWyscoutPlayers

    players_data = PublicWyscoutPlayers()
    players_data = convert_players(players_data)

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
    players_data.data = leftjoin(teams_df, players_data.data, on = :player_id)

    return players_data
end


"""
    function convert_players
Utiliy functions to convert the dataframe with players informations.
"""
function convert_players(players_data::PublicWyscoutPlayers)::PublicWyscoutPlayers

    players_df = players_data.data[:,[:firstName, :lastName, :birthDate,
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

    players_data.data = players_df

    return players_data
end
