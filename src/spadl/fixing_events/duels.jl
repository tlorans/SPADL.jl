
"""
function convert_duels()
    
This function converts Wyscout duels that end with the ball out of field
(subtype_id 50) into a pass for the player winning the duel to the location
of where the ball went out of field. The remaining duels are removed as
they are not on-the-ball actions. 
"""
function convert_duels(event_df::PublicWyscoutEvents)

for i in eachindex(event_df.event_id)
    if i < length(eachindex(event_df.event_id)) - 2
        if selector_duel_out_of_field(event_df[i, :type_id],
                                        event_df[i+1, :type_id],
                                        event_df[i+2, :subtype_id],
                                        event_df[i, :period_id],
                                        event_df[i+2, :period_id])
            println("ok")
        end
    end
end

end

"""
function selector_duel_out_of_field
Define selector for duels that are followed by an 'out of field' event.
"""
function selector_duel_out_of_field(type_id::Union{Float64, Int}, type_id_t_plus_1::Union{Float64,Int}, subtype_id_t_plus_2::String,period_id::String, period_id_t_plus_2::String)

if type_id == 1 &&
    type_id_t_plus_1 == 1 &&
    # have to treat it like a string, don't achieve to drop the empty rows and translate it in number
    subtype_id_t_plus_2 == "50" &&
    period_id == period_id_t_plus_2
    result =  true

else 
    result = false
end

return result
end

"""
function selector0_duel_won
Define selectors for current time step
"""
function selector0_duel_won(type_id::Union{Float64, Int}, type_id_t_plus_1::Union{Float64,Int}, subtype_id_t_plus_2::String,period_id::String, period_id_t_plus_2::String,
                        team_id::Union{Float64, Int}, team_id_t_plus_2::Union{Float64, Int})

if selector_duel_out_of_field(type_id,
    type_id_t_plus_1,
    subtype_id_t_plus_2,
    period_id,
    period_id_t_plus_2) && team_id != team_id_t_plus_2
    result = true 
else 
    result = false
end

return result
end

"""
function selector0_duel_won_air
"""
function selector0_duel_won_air(type_id::Union{Float64, Int}, type_id_t_plus_1::Union{Float64,Int}, subtype_id_t_plus_2::String,period_id::String, period_id_t_plus_2::String,
team_id::Union{Float64, Int}, team_id_t_plus_2::Union{Float64, Int}, subtype_id::String)

if selector0_duel_won(type_id,
    type_id_t_plus_1,
    subtype_id_t_plus_2,
    period_id,
    period_id_t_plus_2,
    team_id, 
    team_id_t_plus_2) && subtype_id == "10"
    result = true 
else
    result = false 
end

return result 
end


"""
function selector0_duel_won_not_air
"""
function selector0_duel_won_not_air(type_id::Union{Float64, Int}, type_id_t_plus_1::Union{Float64,Int}, subtype_id_t_plus_2::String,period_id::String, period_id_t_plus_2::String,
team_id::Union{Float64, Int}, team_id_t_plus_2::Union{Float64, Int}, subtype_id::String)

if selector0_duel_won(type_id,
    type_id_t_plus_1,
    subtype_id_t_plus_2,
    period_id,
    period_id_t_plus_2,
    team_id, 
    team_id_t_plus_2) && subtype_id != "10"
    result = true 
else
    result = false 
end

return result 
end