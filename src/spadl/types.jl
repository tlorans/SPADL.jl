
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
WyscoutEventTags
"""
Base.@kwdef mutable struct WyscoutEventTags
    goal::Bool = false
    own_goal::Bool = false
    assist::Bool = false
    key_pass::Bool = false
    counter_attack::Bool = false
    left_foot::Bool = false
    right_foot::Bool = false
    head_body::Bool = false
    direct::Bool = false
    indirect::Bool = false
    dangerous_ball_lost::Bool = false
    blocked::Bool = false
    high::Bool = false
    low::Bool = false
    interception::Bool = false
    clearance::Bool = false
    opportunity::Bool = false
    feint::Bool = false
    missed_ball::Bool = false
    free_space_right::Bool = false
    free_space_left::Bool = false
    take_on_left::Bool = false
    take_on_right::Bool = false
    sliding_tackle::Bool = false
    anticipated::Bool = false
    anticipation::Bool = false
    red_card::Bool = false
    yellow_card::Bool = false
    second_yellow_card::Bool = false
    position_goal_low_center::Bool = false
    position_goal_low_right::Bool = false
    position_goal_mid_center::Bool = false
    position_goal_mid_left::Bool = false
    position_goal_low_left::Bool = false
    position_goal_mid_right::Bool = false
    position_goal_high_center::Bool = false
    position_goal_high_left::Bool = false
    position_goal_high_right::Bool = false
    position_out_low_right::Bool = false
    position_out_mid_left::Bool = false
    position_out_low_left::Bool = false
    position_out_mid_right::Bool = false
    position_out_high_center::Bool = false
    position_out_high_left::Bool = false
    position_out_high_right::Bool = false
    position_post_low_right::Bool = false
    position_post_mid_left::Bool = false
    position_post_low_left::Bool = false
    position_post_mid_right::Bool = false
    position_post_high_center::Bool = false
    position_post_high_left::Bool = false
    position_post_high_right::Bool = false
    through::Bool = false
    fairplay::Bool = false
    lost::Bool = false
    neutral::Bool = false
    won::Bool = false
    accurate::Bool = false
    not_accurate::Bool = false
    # added offside 
    offside::Bool = false
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
    subtype_id::Union{Nothing,Int} = nothing
    milliseconds::Float64
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
    ActionsConfig
"""
Base.@kwdef mutable struct ActionsConfig
    field_length::Float64 = 105.0 # unit: meters 
    field_width::Float64 = 68.0  # unit meters
    bodyparts::Vector{String} = ["foot", "head", "other", "head/other"]
    results::Vector{String} = ["fail","success","offside","owngoal","yellow_card","red_card"]
    actionstypes::Vector{String} = [
        "pass",
        "cross",
        "throw_in",
        "freekick_crossed",
        "freekick_short",
        "corner_crossed",
        "corner_short",
        "take_on",
        "foul",
        "tackle",
        "interception",
        "shot",
        "shot_penalty",
        "shot_freekick",
        "keeper_save",
        "keeper_claim",
        "keeper_punch",
        "keeper_pick_up",
        "clearance",
        "bad_touch",
        "non_action",
        "dribble",
        "goalkick"
    ]
end
