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
    using LazyJSON

    export 
    # Types 
    WyscoutEvent,
    ActionsConfig,

    # Serializers
    get_events_data,
    create_match_index,
    get_matchs,
    get_df,
    competitions,
    games,
    teams,
    players,
    get_events,
    lineup,
    events,

    # SPADL 
    get_tags,
    # make_new_positions,
    convert_to_actions,
    convert_duels,
    # fix_events,
    selector_duel_out_of_field,

    # utils 
    to_hdf


    include("data/data.jl")
    # include("utils.jl")
    include("spadl/spadl.jl")

    function __init__()

        nothing
    end

end
