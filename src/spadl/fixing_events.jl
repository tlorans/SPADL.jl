
"""
function fix_events()

Perform some fixes on the events such that the spadl action dataframe can be built. 
"""
function fix_events(vector_wyscout_data::Vector{WyscoutData})::Vector{WyscoutData}
    vector_wyscout_data = create_shot_coordinates(vector_wyscout_data)
    vector_wyscout_data = convert_duels(vector_wyscout_data)

end


"""
function create_shot_coordinates()

Create short coordinates (estimates) from Wyscout tags
# """
function create_shot_coordinates(vector_wyscout_data::Vector{WyscoutData})::Vector{WyscoutData}

    for i in eachindex(vector_wyscout_data)
        
        if vector_wyscout_data[i].tags.position_goal_low_center || vector_wyscout_data[i].tags.position_goal_mid_center || vector_wyscout_data[i].tags.position_goal_high_center
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 50
        elseif vector_wyscout_data[i].tags.position_goal_low_right || vector_wyscout_data[i].tags.position_goal_mid_right || vector_wyscout_data[i].tags.position_goal_high_right
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 55
        elseif vector_wyscout_data[i].tags.position_goal_mid_left || vector_wyscout_data[i].tags.position_goal_low_left || vector_wyscout_data[i].tags.position_goal_high_left
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 45
        elseif vector_wyscout_data[i].tags.position_out_high_center || vector_wyscout_data[i].tags.position_post_high_center
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 50
        elseif vector_wyscout_data[i].tags.position_out_low_right || vector_wyscout_data[i].tags.position_out_mid_right || vector_wyscout_data[i].tags.position_out_high_right
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 60
        elseif vector_wyscout_data[i].tags.position_out_mid_left || vector_wyscout_data[i].tags.position_out_low_left || vector_wyscout_data[i].tags.position_out_high_left
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 40
        elseif vector_wyscout_data[i].tags.position_post_mid_left || vector_wyscout_data[i].tags.position_post_low_left || vector_wyscout_data[i].tags.position_post_high_left
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 55.38
        elseif vector_wyscout_data[i].tags.position_post_low_right || vector_wyscout_data[i].tags.position_post_mid_right || vector_wyscout_data[i].tags.position_post_high_right
            vector_wyscout_data[i].event_fixed.end_x = 100
            vector_wyscout_data[i].event_fixed.end_y = 44.62
        elseif vector_wyscout_data[i].tags.blocked 
            vector_wyscout_data[i].event_fixed.end_x = vector_wyscout_data[i].event_fixed.start_x
            vector_wyscout_data[i].event_fixed.end_y = vector_wyscout_data[i].event_fixed.start_y
        end
    end

    return vector_wyscout_data
end


"""
function convert_duels()
    
This function converts Wyscout duels that end with the ball out of field
(subtype_id 50) into a pass for the player winning the duel to the location
of where the ball went out of field. The remaining duels are removed as
they are not on-the-ball actions. 
"""
function convert_duels(vector_wyscout_data::Vector{WyscoutData})

    size_condition = length(eachindex(vector_wyscout_data)) - 2

    for i in eachindex(vector_wyscout_data) 

        if i < size_condition
            # define salector for same period id
            selector_same_period = (vector_wyscout_data[i].event.period_id == vector_wyscout_data[i+2].event.period_id)

            # Define selector for duels that are followed by an 'out of field' event
            selector_duel_out_of_field = (vector_wyscout_data[i].event.type_id == 1 && 
                                            vector_wyscout_data[i+1].event.type_id == 1 &&
                                            vector_wyscout_data[i+2].event.subtype_id == 50 &&
                                            selector_same_period)

            # Define selector for current time step 
            selector_0_duel_won = selector_duel_out_of_field && (vector_wyscout_data[i].event.team_id != vector_wyscout_data[i+2].team_id)
            selector_0_duel_won_air = selector_0_duel_won && (vector_wyscout_data[i].event.subtype_id == 10)
            selector_0_duel_won_not_air = selector_0_duel_won && (vector_wyscout_data[i].event.subtype_id != 10)

            # Define selector for next time step 
            selector_1_duel_won = selector_duel_out_of_field && (vector_wyscout_data[i+1].event.team_id != vector_wyscout_data[i+2].team_id)
            selector_1_duel_won_air = selector_1_duel_won && (vector_wyscout_data[i+1].event.subtype_id == 10)
            selector_1_duel_won_not_air = selector_1_duel_won && (vector_wyscout_data[i+1].event.subtype_id != 10)

            # Aggregate selectors 
            selector_duel_won = selector_0_duel_won || selector_1_duel_won
            selector_duel_won_air = selector_0_duel_won_air || selector_1_duel_won_air
            selector_duel_won_not_air = selector_0_duel_won_not_air || selector_1_duel_won_not_air

            # Set types and subtypes 
            if selector_duel_won vector_wyscout_data[i].event_fixed.type_id = 8 end 
            if selector_duel_won_air vector_wyscout_data[i].event_fixed.subtype_id = 82 end 
            if selector_duel_won_not_air vector_wyscout_data[i].event_fixed.subtype_id = 85 end 

            # set end location equal to ball out of field location
            if selector_duel_won vector_wyscout_data[i].tags.accurate = false end
            if selector_duel_won vector_wyscout_data[i].tags.not_accurate = true end 
            if selector_duel_won vector_wyscout_data[i].event_fixed.end_x = 100 - vector_wyscout_data[i+2].event_fixed.start_x end 
            if selector_duel_won vector_wyscout_data[i].event_fixed.end_y = 100 - vector_wyscout_data[i+2].event_fixed.start_y end

            # Define selector for ground attacking duels with take on 
            selector_attacking_duel = (vector_wyscout_data[i].event.subtype_id == 11)
            selector_take_on = (vector_wyscout_data[i].tags.take_on_left || vector_wyscout_data[i].tags.take_on_right)
            selector_att_duel_take_on = selector_attacking_duel && selector_take_on


            # set take on type to 0
            if selector_att_duel_take_on vector_wyscout_data[i].event_fixed.type_id = 0 end 
            if vector_wyscout_data[i].tags.sliding_tackle vector_wyscout_data[i].event_fixed.type_id = 0 end

        end

        # drop the remaining duels 
        vector_wyscout_data = filter(el -> el.event_fixed.type_id != 1, vector_wyscout_data)


        return vector_wyscout_data
    end

