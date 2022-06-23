/*
	GMSCore_fnc_initializePatrolVehicle 

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
	["_disable",0],  // damage value set to this value if less than this value when all crew are dead
	["_removeFuel",0.2],  //uel set to this value when all crew dead
	["_releaseToPlayers",true],
	["_deleteTimer",300]
];
if (isNull _veh) then {[format["GMSCore_fnc_initializePatrolVehicle: objNull passed | _releaseToPlayers = %3 | _deleteTimer = %4",_veh,typeOf _veh,_releaseToPlayers,_deleteTimer]] call GMSCore_fnc_log;};
//[format["GMSCore_fnc_initializePatrolVehicle: _veh = %1 | _disable = %2 | _removeFuel = %3 | _releaseToPlayers = %4 | _deleteTimer = %5",_veh,_disable,_removeFuel,_releaseToPlayers,_deleteTimer]] call GMSCore_fnc_log;
_veh setFuel 1;
_veh addEventHandler["HandleDamage",{_this call GMSCore_fnc_vechicleHandleDamage;}];
_veh addMPEventHandler["MPHit",{_this call GMSCore_fnc_vehicleHit;}];
_veh addMPEventHandler["MPKilled",{_this call GMSCore_fnc_vehicleKilled;}];
_veh setVariable[GMS_disableVehicle,_disable];
_veh setVariable[GMS_removeFuel,_removeFuel];
_veh setVariable[GMS_allowAccess,_releaseToPlayers];
_veh setVariable[GMS_deleteEmptyVehicle,_deleteTimer];
[_veh] call GMSCore_fnc_emptyObjectInventory;
if (toLowerANSI(GMSCore_modType) isEqualTo "epoch") then 
{
	_veh call EPOCH_server_setVToken;
};
// Restrict Player Access
_veh lock 2;
_veh enableRopeAttach false;
_veh enableCoPilot false;

