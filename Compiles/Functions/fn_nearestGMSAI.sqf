/*
    GMA_fnc_nearestGMSAI 

    Purpose: Identify nearest AI of type GMS_soldierType

    Parameters: 
		_pos: where to search 
		_range: search radius 

    Return: 
		array of GMSAI units 
		[] if none found

    Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params[["_pos",[0,0,0]],["_range",300]];
if (_pos isEqualTo [0,0,0]) exitWith {["GMSCore_fnc_nearestGMSAI: no location specified or location == [0,0,0]","warning"] call GMSCore_fnc_log};
private _nearestAI = _pos nearEntities[GMSCore_unitType,_range] select {(side _x) isEqualTo GMSCore_Side};
//diag_log format["GMSCore_fnc_nearestGMSAI: _nearestAI = %1",_nearestAI];
_nearestAI


