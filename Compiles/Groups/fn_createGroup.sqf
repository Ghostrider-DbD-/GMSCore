/*

    GMS_fnc_createGroup 
    Purpose: create a group on the side set in params 
    Parameters: 
        "_side", side to tie group to, (default is GMS_side);
        
    Return: group created.

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_side",GMS_side],["_monitor",false]];

private _group = createGroup [_side,true];
//if (_monitor) then {GMSCore_monitoredGroups pushBackUnique _group};
_group enableDynamicSimulation false;

_group