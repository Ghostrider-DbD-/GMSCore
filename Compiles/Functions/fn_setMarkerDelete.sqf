/*
    GMSCore_fnc_setMarkerDelete 

    Purpose: set the flag that specifies whether a marker deliniating the patrol area for a group should be deleted 
    Parameters:
        _group: the group in question 
        _delete: specified whether the marker is delete (true/false) when the group is all dead/destroyed 

    Returns: None 
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group", grpNull], ["_delete", true]];
_group setVariable[GMSCore_deleteMarker, _delete];
