/*
	GMS_fnc_loadVehicleCrew 

	Purpose: provides a way to load a group containing units into a vehicle for AI vehicle patrols 

	Parameters:
		_vehicle, the vehicle into which to load the crew 
		_crew, the group containing units to load 
		_blockedTurrets, turrets which should not be manned using turret paths 
		_blockedPositions, positions which should not be manned base on fullCrew

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: Needs some more rigorous testing
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_vehicle","_group"];

{_x moveInAny _vehicle} forEach (units _group);
_group addVehicle _vehicle;
[_group,_vehicle] call GMS_fnc_setGroupVehicle;
