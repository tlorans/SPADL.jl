# This file contains functions to create the actions dataframe.


function convert_to_actions(event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}
    vector_spadl = create_actions(event_df)
    vector_spadl = make_new_positions(vector_spadl, event_df)
end

function create_actions(event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}

    vector_spadl = Vector{RegularSPADL}()

    for i in eachindex(event_df)
        spadl_element = RegularSPADL(game_id = event_df[i].game_id,
                                original_event_id = event_df[i].event_id,
                                period_id = event_df[i].period_id,
                                team_id = event_df[i].team_id,
                                type_id = event_df[i].type_id)

        push!(vector_spadl, spadl_element)
    end

    return vector_spadl
end