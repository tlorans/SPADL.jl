# 

abstract type Schema end

"""
    WyscoutTeamSchema
"""
struct mutable WyscoutTeamSchema 
    team_id::Int64 
    team_name::String 
    team_name_short::String
end