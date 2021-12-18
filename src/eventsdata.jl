# This file contains types of Events Data 


"""
    EventsData
"""
abstract type EventsData end

"""
    Wyscout
"""
# struct WyscoutPublic <: EventsData
#     serializer::WyscoutEventDataPublicSerializer
#     download::Boolean
# end

"""
    wyscout_public()
Download and parse the wyscout public event data.
"""
