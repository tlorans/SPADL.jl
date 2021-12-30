Base.@kwdef mutable struct ToBeOrdered 
    time::Int 
    type_id::Int
end


vector_to_be_ordered = Vector{ToBeOrdered}()

for i in 1:100
    push!(vector_to_be_ordered, ToBeOrdered(
        time = i,
        type_id = rand([1,2])
    ))
end

function reorder(data::Vector{ToBeOrdered})::Vector{ToBeOrdered}

    new_vector = Vector{ToBeOrdered}()

    for i in eachindex(data)
        if data[i].type_id == 2
            push!(new_vector, data[i])
            push!(new_vector, ToBeOrdered(time = data[i].time, type_id = 3))
        else 
            push!(new_vector, data[i])
        end
    end
    return new_vector
end

test = reorder(vector_to_be_ordered)

using DataFrames
check = DataFrame(test)
