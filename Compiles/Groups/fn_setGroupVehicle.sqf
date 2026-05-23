/*
    GMSCore_fnc_setGroupVehicle 

    Purpose: set variable indicating to GMSCore what vehicle a group is assigned to 
    Parameters:
        _group - the group in question 
        _vehicle - the vehicle 

    Returns: None 
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull],["_vehicle",objNull]];
if !(isNull _group) then {_group setVariable[GMSCore_groupVehicle,_vehicle]};
