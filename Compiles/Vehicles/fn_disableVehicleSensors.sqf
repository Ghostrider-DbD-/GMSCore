/*
	GMSCore_fnc_disableSensors 

	Parameters: 
	_veh - vehicle on which to disable one or more sensors 
	_sensors - a list of sensors to disable 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: 	None	
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params["_veh","_sensors"];
private _vehSensors = listVehicleSensors _veh;
{
	if (_x in _vehSensors) then {_veh enableVehicleSensor [_x, false]};
} forEach _sensors;