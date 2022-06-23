/*

	GMSCore_fnc_canSee

	Purpose: returns true if one unit in group can see one unit in an array from another Side

	Parametsrs:
		_group: the group doing the search 
		_units: units to look for

	Returns: true if one or more units was seen

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
// TODO: will this work for vehicles
params[["_group",grpNull],["_unit",objNull]];
private _seen = false;
{
	_aiUnit = _x;
	if ([_x,_unit] call GMSCore_fnc_unitCanSee) exitWith {_seen = true};
} forEach (units _group);
_seen