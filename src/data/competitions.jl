# This file contains functions to get access to the list of all available competitions and seasons depending on the loader.


"""
    PublicWyscoutCompetitions
"""
Base.@kwdef mutable struct PublicWyscoutCompetitions 
    data::DataFrame = get_df("competitions.json")
end


"""
function competitions()
Return a dataframe with all available competitions and seasons in PublicWyscoutLoader
"""
function competitions(events_data::PublicWyscoutLoader)::PublicWyscoutCompetitions
    competitions_data = PublicWyscoutCompetitions()

    rename!(competitions_data.data, :wyId => :competition_id, :name => :competition_name)

    country_names = DataFrame(competitions_data.data[:, :area])[:,:name]
    for i in eachindex(country_names)
        if country_names[i] == ""
            country_names[i] = "International"
        end 
    end
    insertcols!(competitions_data.data, :country_name => country_names,
                    :competition_gender => "male")

    competitions_data.data = competitions_data.data[:,[:competition_id, :competition_name, :country_name, :competition_gender]]

    competitions_data.data = leftjoin(competitions_data.data, unique(events_data.match_index[:,[:competition_id, :season_id, :season_name]]), on = [:competition_id])

    return competitions_data
end
