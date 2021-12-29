# This file contains functions to create the actions dataframe.

"""
    SPADL
"""
Base.@kwdef mutable struct RegularSPADL 
    action_id::Union{Nothing,Int} = nothing
    bodypart_id::Union{Nothing,Int} = nothing
    bodypart_name::Union{Nothing,String} = nothing
    end_x::Union{Nothing,Float64} = nothing
    end_y::Union{Nothing,Float64} = nothing
    game_id::Union{Nothing,Int} = nothing
    original_event_id::Union{Nothing,Int} = nothing
    period_id::Union{Nothing,String} = nothing
    result_id::Union{Nothing,Int} = nothing
    result_name::Union{Nothing,String} = nothing
    start_x::Union{Nothing,Float64} = nothing
    start_y::Union{Nothing,Float64} = nothing
    team_id::Union{Nothing,Int} = nothing 
    time_seconds::Union{Nothing,Float64} = nothing
    type_id::Union{Nothing,Int} = nothing
    type_name::Union{Nothing,String} = nothing
end

"""
    WyscoutEventFixed
"""
Base.@kwdef mutable struct WyscoutEventFixed
    event_id::Int 
    game_id::Int 
    player_id::Int 
    period_id::String 
    start_x::Union{Nothing,Float64} = nothing
    start_y::Union{Nothing,Float64} = nothing
    end_x::Union{Nothing,Float64} = nothing
    end_y::Union{Nothing,Float64} = nothing
    team_id::Union{Nothing,Int} = nothing 
    type_id::Union{Nothing,Int} = nothing
    subtype_id::Union{Nothing,String} = nothing
end

"""
    WyscoutData
"""
Base.@kwdef mutable struct WyscoutData
    event::WyscoutEvent
    tags::Union{Nothing,WyscoutEventTags} = nothing
    event_fixed::Union{Nothing,WyscoutEventFixed} = nothing
end

"""
    function convert_to_actions(event_df)
Convert Wyscout events to SPADL actions.
Step 1: initialize a vector of WyscoutData
Step 2: create new positions (start_x, start_y and end_x, end_y)
"""
function convert_to_actions(event_df::Vector{WyscoutEvent})

    vector_wyscout_data = create_wyscout_data_processing(event_df)
    vector_wyscout_data = make_new_positions(vector_wyscout_data)

    # vector_spadl = fix_wyscout_events(vector_spadl, tags_df, event_df)
end

"""
    function create_wyscout_data_processing(event_df)
"""
function create_wyscout_data_processing(event_df::Vector{WyscoutEvent})::Vector{WyscoutData}

    vector_wyscout_data = Vector{WyscoutData}()

    for i in eachindex(event_df)
        tmp_event_fixed = WyscoutEventFixed(game_id = event_df[i].game_id,
                                event_id = event_df[i].event_id,
                                period_id = event_df[i].period_id,
                                team_id = event_df[i].team_id,
                                type_id = event_df[i].type_id,
                                player_id = event_df[i].player_id)

        tmp = WyscoutData(event = event_df[i], event_fixed = tmp_event_fixed)
        push!(vector_wyscout_data, tmp)
    end

    return vector_wyscout_data
end


# """
#     function create_actions(event_df)
# Take as input the initial Vector of WyscoutEvent and initialize a Vector of RegularSPADL before processing.
# """
# function create_actions(event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}

#     vector_spadl = Vector{RegularSPADL}()

#     for i in eachindex(event_df)
#         spadl_element = RegularSPADL(game_id = event_df[i].game_id,
#                                 original_event_id = event_df[i].event_id,
#                                 period_id = event_df[i].period_id,
#                                 team_id = event_df[i].team_id,
#                                 type_id = event_df[i].type_id)

#         push!(vector_spadl, spadl_element)
#     end

#     return vector_spadl
# end


"""
    function fix_events()

Perform some fixes on the events such that the spadl action dataframe can be built. 
"""
# function fix_events(spadl_df::Vector{RegularSPADL}, tags_df::Vector{WyscoutEventTags}, event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}

#     spadl_df = create_shot_coordinates(spadl_df, tags_df)
#     event_df = convert_duels(event_df)

# end