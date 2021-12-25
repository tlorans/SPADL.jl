# This file contains functions to get both teams that participated in a game 


"""
    PublicWyscoutTeams
"""
Base.@kwdef mutable struct PublicWyscoutTeams
    data::DataFrame = get_df("teams.json")
end

"""
function teams()

Return a dataframe with both teams that participated in a game.
"""
function teams(event_data::PublicWyscoutLoader, game_id::Int)::PublicWyscoutTeams

    teams_data = PublicWyscoutTeams()
    rename!(teams_data.data, :name => :team_name_short,
                        :officialName => :team_name,
                        :wyId => :team_id)

    teams_data.data = teams_data.data[:,[:team_id, :team_name, :team_name_short]]
    teams_id = collect(keys(lineup(event_data, game_id)))
    teams_id = DataFrame(:team_id => parse.(Int, teams_id))

    teams_data.data = leftjoin(teams_id, teams_data.data, on = :team_id)
    
    return teams_data
end