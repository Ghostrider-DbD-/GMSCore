/*
	GMS_fnc_spawnUnmannedVehicle 

	Purpose: spawn and initialize a drone to be used for AI patrols 

	Parameters: 

	Returns: [
		the vehicle configured 
		the group that mans it 

	Copyright 2020 by Ghostrider-GRG-

	Notes: Be sure to select drones from the same faction as GMS_side
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[
	["_pos",[0,0,0]],
	["_dir",0],
	["_aircraft",""],
	["_disable",0],  // a value greater than 0 will increase damage of the object to that level; set to 1.0 to disable turretes, 0.7 to neutralize vehciles
	["_removeFuel",false],  // when true fuel is removed from the vehicle
	["_releaseToPlayers",true],
	["_deleteTimer",300],
	["_height",0],
	["_vehHitCode",[]],
	["_vehKilledCode",[]]
];

/*
		["_className",""], // Clasname of vehicle to be spawned
		["_spawnPos",[0,0,0]],  //  selfevident
		["_dir",0],  //  selfevident
		["_disable",0],  // this should be disabled turrets that we remove ammo from
		["_removeFuel",false],  // when true fuel is removed from the vehicle
		["_releaseToPlayers",true],
		["_deleteTimer",300],
		["_height",0],
		["_vehHitCode",[]],
		["_vehKilledCode",[]]
*/
private _unmanned = [
	_aircraft,	
	_pos,
	_dir,
	_disable,
	_removeFuel,
	_releaseToPlayers,
	_deleteTimer,
	_height,
	_vehHitCode,
	_vehKilledCode
] call GMS_fnc_spawnPatrolVehicle;
private _group = createVehicleCrew _unmanned; 
_group setVariable[GMS_vehHitCode,_vehHitCode];
_group setVariable[GMS_vehKilledCode,_vehKilledCode];
diag_log format["GMS_fnc_spawnUnmannedVehicle: _height = %1",_height];
if (_height > 0 && _unmanned isKindOf "Air") then 
{
	_unmanned flyInHeight _height;
	_unmanned engineOn true;
	_unmanned setVariable[GMS_flyinHeight,_height];
	diag_log format["GMS_fnc_spawnUnmannedVehicle: _unmand isKindOf Air | _height = %1",_height];
};
_group call GMS_fnc_addUnitEventHandlers;
_group setVariable[GMS_groupVehicle,_unmanned];
[_unmanned,_disable,_removeFuel,_releaseToPlayers,_deleteTimer] call GMS_fnc_initializePatrolVehicle;
[_group,_unmanned]