# This file contains function to convert events dataframe to SPADL representation.


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


include("tags.jl")
include("actions.jl")
include("positions.jl")
# include("fixing_actions/fixing_actions.jl")
# include("fixing_events/fixing_events.jl")


"""
    function convert_to_spadl()

Convert Wyscout events to SPADL actions
"""
function convert_to_spadl(event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}
    # Create the vector of spadl actions
    # spadl_df = [RegularSPADL() for i in eachindex(event_df)]
    # tags_df = get_tags(event_df)

    # spadl_df = make_new_positions(spadl_df, tags_df, event_df)

    return action_df
end
