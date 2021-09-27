/*
	GMS_fnc_allowPlayerAccess 

	Purpose: Configure a vehicle to allow players access
	
	Parameters: _veh, the vehicle to be handled 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: variables pulled from the vehicle are set by spawnVehiclePatrol 	
	TODO: This code should be broadcast ?
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_veh"];
private _accessAllowed = _veh getVariable ["GMS_allowAccess",true];
if (_accessAllowed) then 
{
	_veh enableRopeAttach true;
	_veh enableCoPilot true;
	if (_veh getVariable["GMS_removeFuel",true]) then 
	{
		_veh setFuel 0;
	};
	_veh lock 1;
};
