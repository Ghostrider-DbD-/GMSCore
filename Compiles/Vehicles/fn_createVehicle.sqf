/*
	GMS_fnc_createVehicle 

	Purpose: generic function for creating vehicles including aircraft and UAV

	Parameters:
		_vehType, classname of the vehicle to be spawned 
		_pos, position at which to spawn 
		_dir, compass heading of the vehicle (optional) 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: 	Used by SpawnPatrolVehicle 
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[
	["_vehType",""],
	["_pos",[0,0,0]],
	["_dir",random(360)],
	["_height",0]
];

private "_veh";
if (_height > 0 && _vehType isKindOf "Air") then 
{
	_veh = createVehicle[_vehType, _pos, [], 0, "FLY"];
} else {
	_veh = createVehicle[_vehType, _pos, [], 0, "NONE"];
};

_veh allowDamage false;
_veh setVectorUp surfaceNormal position _veh;
_veh setDir _dir;

if (GMS_modType isEqualTo "epoch") then
{
	_veh call EPOCH_server_setVToken;
};
uiSleep 1;
_veh allowDamage true;
_veh enableRopeAttach true;
_veh setVariable["GMS_vehicle",true];

_veh