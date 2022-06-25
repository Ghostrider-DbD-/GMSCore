/*
	GMSCore_fnc_allowPlayerAccess 

	Purpose: Configure a vehicle to allow players access
	
	Parameters: _veh, the vehicle to be handled 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: variables pulled from the vehicle are set by spawnVehiclePatrol 	
	TODO: This code should be broadcast ?
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_veh"];
private _accessAllowed = _veh getVariable [GMS_allowAccess,true];
[format["GMSCore_fnc_allowPlayerAccess: _veh = %1 | _accessAllowed = %2",_veh,_accessAllowed]] call GMSCore_fnc_log;
if (_accessAllowed) then 
{
	_veh enableRopeAttach true;
	_veh enableCoPilot true;
	private _setFuelTo = _veh getVariable[GMS_removeFuel,0.2];
	private _setDamageTo = _veh getVariable[GMS_disableVehicle,0.5];
	_veh setFuel _setFuelTo;
	if ((damage _veh) < _setDamageTo) then {_veh setDamage _setDamageTo};
	_veh lock 0;
};
