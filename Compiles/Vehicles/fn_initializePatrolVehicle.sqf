/*
	GMS_fnc_initializePatrolVehicle 

	Purpose: provides a contianer function in case other initializations have to be added. 

	Parameters: _veh, the vehicle to be initialized 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes:
	TODO: not sure what I was thinking when I added _disable. Is this turrets or a way to add damage at spawn.	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[
	["_veh",objNull],
	["_disable",0],  // this should be turrets that are disabled
	["_removeFuel",false],  // when true fuel is removed from the vehicle
	["_releaseToPlayers",true],
	["_deleteTimer",300]
];
_veh setFuel 1;
_veh addEventHandler["HandleDamage",{_this call GMS_fnc_vechicleHandleDamage;}];
_veh addMPEventHandler["MPHit",{_this call GMS_fnc_vehicleHit;}];
_veh addMPEventHandler["MPKilled",{_this call GMS_fnc_vehicleKilled;}];
//_veh addEventHandler["GetOut",{_this call GMS_fnc_getOutVehicle;}];
_veh setVariable["GMS_disable",_disable];
_veh setVariable["GMS_removeFuel",_removeFuel];
_veh setVariable["GMS_allowAccess",_releaseToPlayers];
_veh setVariable["GMS_deleteEmptyVehicle",_deleteTimer];
[_veh] call GMS_fnc_emptyObjectInventory;
[_veh] call GMS_fnc_restrictPlayerVehicleAcess;

