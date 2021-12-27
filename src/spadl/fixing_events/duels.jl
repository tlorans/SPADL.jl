
"""
function convert_duels()
    
This function converts Wyscout duels that end with the ball out of field
(subtype_id 50) into a pass for the player winning the duel to the location
of where the ball went out of field. The remaining duels are removed as
they are not on-the-ball actions. 
"""
function convert_duels(event_df::Vector{WyscoutEvent})

    selectors = selector_duel_out_of_field(event_df)
    selectors = selector_duel_won(selectors, event_df)
    # event_df = duel_types_and_subtypes(event_df)


    # # Remove the remaining duels
    # event_df.data = filter("type_id" => !=(1), event_df.data)

    return selectors
end

"""
    function selector_duel_out_of_field
Define selector for duels that are followed by an 'out of field' event.
"""
function selector_duel_out_of_field(event_df::Vector{WyscoutEvent})::Vector{Bool}

    vector_selector_duel_out_of_field = Vector{Bool}()

    for i in eachindex(event_df)
        selector = false 
        if i < length(eachindex(event_df)) - 2
            if event_df[i].type_id == 1 &&
                event_df[i+1].type_id == 1 &&
                event_df[i+2].subtype_id == 50 && 
                event_df[i].period_id == event_df[i+2].period_id

                selector = true
            end
        end
        push!(vector_selector_duel_out_of_field, selector)
    end
    return vector_selector_duel_out_of_field
end

"""
    function selector_duel_won
"""
function selector_duel_won(vector_selector_duel_out_of_field::Vector{Bool}, event_df::Vector{WyscoutEvent})::Dict

    vector_selector_duel_won = Vector{Bool}()
    vector_selector_duel_won_air = Vector{Bool}()
    vector_selector_duel_won_not_air = Vector{Bool}()

    for i in eachindex(event_df)
        selector_duel_won = false
        selector_duel_won_air = false
        selector_duel_won_not_air = false
        selector0_duel_won = false
        selector1_duel_won = false
        selector0_duel_won_air = false 
        selector1_duel_won_air = false
        selector0_duel_won_not_air = false 
        selector1_duel_won_not_air = false   

        if i < length(eachindex(event_df)) - 2
            if vector_selector_duel_out_of_field[i] &&
                event_df[i].team_id != event_df[i+2].team_id
                selector0_duel_won = true
            end
            if vector_selector_duel_out_of_field[i] &&
                event_df[i+1].team_id != event_df[i+2].team_id
                selector1_duel_won = true
            end
            if selector0_duel_won || selector1_duel_won 
                selector_duel_won = true 
            end

            if selector0_duel_won && event_df[i].subtype_id == 10
                selector0_duel_won_air = true
            end
            if selector1_duel_won && event_df[i+1].subtype_id == 10
                selector1_duel_won_air = true
            end
            if selector0_duel_won && event_df[i].subtype_id != 10
                selector0_duel_won_not_air = true
            end
            if selector1_duel_won && event_df[i+1].subtype_id != 10
                selector1_duel_won_not_air = true
            end

            if selector0_duel_won && selector1_duel_won
                selector_duel_won = true
            end
            if selector0_duel_won_air && selector1_duel_won_air
                selector_duel_won_air = true
            end
            if selector0_duel_won_not_air && selector1_duel_won_not_air
                selector_duel_won_not_air = true
            end


        end

        push!(vector_selector_duel_won, selector_duel_won)
        push!(vector_selector_duel_won_air, selector_duel_won_air)
        push!(vector_selector_duel_won_not_air, selector_duel_won_not_air)
    end

    selectors = Dict(:selector_duel_won => vector_selector_duel_won,
                    :selector_duel_won_air => vector_selector_duel_won_air,
                    :selector_duel_won_not_air => vector_selector_duel_won_not_air)

    return selectors
end


"""
    function duel_types_and_subtypes()
"""
function duel_types_and_subtypes(selectors::Dict, spadl_df::Vector{RegularSPADL}, tags_df::Vector{WyscoutEventTags}, event_df::Vector{WyscoutEvent})::Vector{RegularSPADL}

    for i in eachindex(spadl_df)
        if selectors["selector_duel_won"][i]
            spadl_df[i].type_id = 8
            spadl_df[i].end_x = 100 - spadl_df[i+2].start_x
            spadl_df[i].end_y = 100 - spadl_df[i+2].start_y
            tags_df[i].accurate = false 
            tags_df[i].not_accurate = true
        end
        # if selectors["selector_duel_won"][i]
        #     spadl_df
    end

end
# """
#     function duel_types_and_subtypes()
# """
# function duel_types_and_subtypes(event_df::PublicWyscoutEvents)::PublicWyscoutEvents

#     data = event_df.data

#     for i in eachindex(data.event_id)

#         if data[i, :selector_duel_won]
#             data[i, :type_id] = 8
#             data[i, :accurate] = false 
#             data[i, :not_accurate] = true 
#             data[i, :end_x] = 100 - data[i+2, :start_x]
#             data[i, :end_y] = 100 - data[i+2, :start_y]
#         end

#         if data[i, :selector_duel_won_air]
#             data[i, :subtype_id] = "82"
#         end

#         if data[i, :selector_duel_won_not_air]
#             data[i, :subtype_id] = "85"
#         end
#     end

#     event_df.data = data

#     return event_df

# end
