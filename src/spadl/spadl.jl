# This file contains function to convert events dataframe to SPADL representation.


"""
    SPADL
"""
Base.@kwdef mutable struct RegularSPADL 
    action_id::Union{Nothing,Int}
    bodypart_id::Union{Nothing,Int}
    bodypart_name::Union{Nothing,String}
    end_x::Union{Nothing,Float64}
    end_y::Union{Nothing,Float64}
    game_id::Union{Nothing,Int}
    original_event_id::Union{Nothing,Int}
    period_id::Union{Nothing,String} 
    result_id::Union{Nothing,Int}
    result_name::Union{Nothing,String}
    start_x::Union{Nothing,Float64}
    start_y::Union{Nothing,Float64}
    team_id::Union{Nothing,Int} 
    time_seconds::Union{Nothing,Float64}
    type_id::Union{Nothing,Int}
    type_name::Union{Nothing,String}
end


include("tags.jl")
# include("positions.jl")
# include("fixing_actions/fixing_actions.jl")
# include("fixing_events/fixing_events.jl")
# include("actions.jl")

