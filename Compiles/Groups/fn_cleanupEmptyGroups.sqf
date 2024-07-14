/*
	GMSCore_fnc_cleanupEmptyGroups
	Purpose: 
		Delete any groups with zero units.

	Parameters:
		None

	Returns: 
		None 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
//[format["Running GMS_fnc_cleanupEmptyGroups at %1"], diag_tickTime] call GMSCore_fnc_log;
private _grp = allGroups;
for "_i" from 1 to (count _grp) do
{
	private _g = _grp deleteAt 0;
	if ((count units _g) isEqualTo 0) then {deleteGroup _g};
};