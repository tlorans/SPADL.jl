
"""
function convert_duels()
    
This function converts Wyscout duels that end with the ball out of field
(subtype_id 50) into a pass for the player winning the duel to the location
of where the ball went out of field. The remaining duels are removed as
they are not on-the-ball actions. 
"""
function convert_duels(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

    event_df = selector_duel_out_of_fiel(event_df)
    event_df = selector0_duel_won(event_df)

    return event_df
end

"""
function selector_duel_out_of_field
Define selector for duels that are followed by an 'out of field' event.
"""
function selector_duel_out_of_field(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

    data = event_df.data
    insertcols!(data, :selector_duel_out_of_field => false)

    for i in eachindex(data.event_id)
        if i < length(eachindex(data.event_id)) - 2 
            if data[i, :type_id] == 1 &&
                data[i+1, :type_id] == 1 &&
                data[i+2, :subtype_id] == "50" &&
                data[i, :period_id] == data[i+2, :period_id]
            
            data[i, :selector_duel_out_of_field] = true
            end 
        end
    end

    event_df.data = data

    return event_df
end


"""
    function selector0_duel_won
Define selectors for current time step
"""
function selector0_duel_won(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

    data = event_df.data 
    insertcols!(data, :selector0_duel_won => false)

    for i in eachindex(data.event_id)
        if i < length(eachindex(data.event_id)) - 2 
            if data[i, :selector_duel_out_of_field] &&
                data[i, :team_id] != data[i+2, :team_id]
            
                data[i, :selector0_duel_won] = true
            end
        end
    end

    event_df.data = data 

    return event_df
end
