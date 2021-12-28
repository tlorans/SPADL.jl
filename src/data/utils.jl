

"""
function lineup
"""
function lineup(event_data::PublicWyscoutLoader, game_id::Int)
    tmp = filter("match_id" => ==(game_id), event_data.match_index)
    data = get_matchs(tmp[1,:db_matches])
    data = filter("wyId"=> ==(game_id), data)[:,"teamsData"]
    data = DataFrame(data)
    data = Dict(i => DataFrame(data[:,i]) for i in names(data))

    return data
end


"""
    function get_df()
"""
function get_df(path::String)

    data = DataFrame(jsontable(JSON3.read(read(path))))

    return data
end
