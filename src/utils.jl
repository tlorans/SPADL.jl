
"""
function to_hdf()
"""
function to_hdf(data::DataFrame, file_path::String, name::String)
    h5open(file_path, "w") do file
        g = create_group(file, name) # create a group
        for col in names(data)
            g[col] = data[:,col]
        end
    end
end

"""
function hdf_to_df()
"""
function hdf_to_df(file_path::String, name::String)

    data = DataFrame(h5read(file_path, name))
return data
end