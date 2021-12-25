
"""
function convert_duels()
    
This function converts Wyscout duels that end with the ball out of field
(subtype_id 50) into a pass for the player winning the duel to the location
of where the ball went out of field. The remaining duels are removed as
they are not on-the-ball actions. 
"""
function convert_duels(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

    event_df = selector_duel_out_of_field(event_df)
    event_df = selector_duel_won(event_df)
    event_df = duel_types_and_subtypes(event_df)


    # Remove the remaining duels
    event_df.data = filter("type_id" => !=(1), event_df.data)

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
    function selector_duel_won
Define selectors for current time step
"""
function selector_duel_won(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

    data = event_df.data 
    insertcols!(data, :selector_duel_won => false,
                        :selector_duel_won_air => false,
                        :selector_duel_won_not_air => false)
                        


    selector0_duel_won = false
    selector1_duel_won = false
    selector0_duel_won_air = false 
    selector1_duel_won_air = false
    selector0_duel_won_not_air = false 
    selector1_duel_won_not_air = false 

    for i in eachindex(data.event_id)
        if i < length(eachindex(data.event_id)) - 2 
            if data[i, :selector_duel_out_of_field] &&
                data[i, :team_id] != data[i+2, :team_id]

                selector0_duel_won = true

            end


            if data[i, :selector_duel_out_of_field] &&
                data[i+1, :team_id] != data[i+2, :team_id]

                selector1_duel_won = true
            end

            if selector0_duel_won || selector1_duel_won
                data[i, :selector_duel_won] = true
            end

            if selector0_duel_won && data[i, :subtype_id] == "10"
                selector0_duel_won_air = true
            elseif selector0_duel_won && data[i, :subtype_id] != "10"
                selector0_duel_won_not_air = true
            end

            if selector1_duel_won && data[i+1, :subtype_id] == "10"
                selector1_duel_won_air = true 
            elseif selector1_duel_won && data[i+1, :subtype_id] != "10"
                selector1_duel_won_not_air = true 
            end

            if selector0_duel_won_air || selector1_duel_won_air
                data[i, :selector_duel_won_air] = true
            elseif selector0_duel_won_not_air || selector1_duel_won_not_air
                data[i, :selector_duel_won_not_air] = true
            end

        end
    end

    event_df.data = data 

    return event_df
end

"""
    function duel_types_and_subtypes()
"""
function duel_types_and_subtypes(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

    data = event_df.data

    for i in eachindex(data.event_id)

        if data[i, :selector_duel_won]
            data[i, :type_id] = 8
            data[i, :accurate] = false 
            data[i, :not_accurate] = true 
            data[i, :end_x] = 100 - data[i+2, :start_x]
            data[i, :end_y] = 100 - data[i+2, :start_y]
        end

        if data[i, :selector_duel_won_air]
            data[i, :subtype_id] = "82"
        end

        if data[i, :selector_duel_won_not_air]
            data[i, :subtype_id] = "85"
        end
    end

    event_df.data = data

    return event_df

end
