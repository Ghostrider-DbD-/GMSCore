/*
	GMS_fnc_spawnPatrolVehicle 

	Purpose: spawn and initialize a vehicle to be used for AI patrols 

	Parameters: 
		_className: class name of the vehicle to be spawned 
		_spawnPos: position at which to spawn the vehicle 
		__dir: compass heading of the spawned vehicle (default is 0) 
		_disable: true/false when true damage for the vehicle will be set to 1.0 when all crew are out 
		_removeFuel: true/false  when true all fuel will be removed when the crew leave the vehicle 
		_releasToPlayers: true/false  when true, empty vehicles will be unlocked and configured for use by players 
		_deleteTimer: time after which empty vehicles will be deleted if not entered in the drivers position by a player 
		_height: flyin height if > 0 else ignored 

	Returns:
		_veh, the vehicle configured 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: need to add a check to the delete objects cue for vehicles that are not local to the server and assume these were entered a player.
		having a specific check that the owner is not an HC or is a player would also help here.
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params[
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
	];

//diag_log format["GMS_fnc_spawnPatrolVehicle: count _vehHitCode = %1 | count _vehKilledCode = %2",count _vehHitCode, count _vehKilledCode];

private _veh = [_className,_spawnPos,_dir,_height] call GMS_fnc_createVehicle;
[_veh,_disable,_removeFuel,_releaseToPlayers,_deleteTimer] call GMS_fnc_initializePatrolVehicle;
_veh setVariable[GMS_vehHitCode,_vehHitCode];
_veh setVariable[GMS_vehKilledCode,_vehKilledCode];
_veh