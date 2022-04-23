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
	_pos set[2,600];
	_veh = createVehicle[_vehType, _pos, [], 0, "FLY"];
	_veh engineOn true;
} else {
	_veh = createVehicle[_vehType, _pos, [], 0, "NONE"];
};

_veh allowDamage false;
if (typeName _dir isEqualTo "SCALAR") then 
{
	_veh setDir _dir;
};
if (typeName _dir isEqualTo "ARRAY") then 
{
	_veh setVectorUp surfaceNormal position _veh;
};
uiSleep 1;
_veh allowDamage true;
_veh enableRopeAttach true;

// This variable is not referenced elsewhere so was no longer set as of 11/28/21
///_veh setVariable[GMS_vehicle,true];

_veh