/*
	GMS_fnc_depsanwInfantryGroup

	Prupose: delete a group and all its units

	Parameters: _group, the group to be HandleDamage

	Return: none

	Copyright 2020 Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
if (isNull _group) exitWith {};
//diag_log format["_deleteInfantryGroup: _group = %1",_group];
{deleteVehicle _x} count (units _group);
deleteGroup _group;