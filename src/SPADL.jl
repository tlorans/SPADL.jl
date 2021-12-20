module SPADL

    """
        SPADL
    A Julia package for Event Stream Data (Wyscout) translation to the 
    Soccer Player Action Description Language (SPADL).
    """

    using DataFrames
    using HTTP
    using ZipFile
    using JSON3 
    using JSONTables
    using ProgressMeter
    using HDF5 

    export 
    # Types 
    WyscoutPublic,

    # Serializers
    get_events_data,
    create_match_index,
    get_matchs,
    lineup,
    get_df,
    competitions,
    games,

    # utils 
    to_hdf


    include("data/data.jl")
    include("utils.jl")
    function __init__()

        nothing
    end

end
