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
    using StructTypes

    export 
    # Types 
    WyscoutPublic,

    # Serializers
    get_events_data

    include("eventsdata.jl")
    include("serializers.jl")

    function __init__()

        nothing
    end

end
