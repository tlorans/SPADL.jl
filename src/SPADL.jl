module SPADL

    """
        SPADL
    A Julia package for Event Stream Data (Wyscout) translation to the 
    Soccer Player Action Description Language (SPADL).
    """

    using DataFrames
    using HTTP

    export 

    get_events_data

    # include("eventdata.jl")
    include("dataloader.jl")

    function __init__()

        nothing
    end

end
