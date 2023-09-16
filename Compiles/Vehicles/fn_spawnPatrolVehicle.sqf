/*
	GMSCore_fnc_spawnPatrolVehicle 

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

#include "\GMSCore\Init\GMSCore_defines.hpp"
params[
		["_className",""], // Clasname of vehicle to be spawned
		["_spawnPos",[0,0,0]],  //  selfevident
		["_dir",0],  //  selfevident
		["_height",0],		
		["_disable",0],  // damage value set to this value if less than this value when all crew are dead
		["_removeFuel",0.2],  // fuel set to this value when all crew dead
		["_releaseToPlayers",true],
		["_deleteTimer",300],
		["_vehHitCode",[]],
		["_vehKilledCode",[]]
	];
//[format["GMSCore_fnc_spawnPatrolVehicle: _className %1 | _spawnPos %2 | _dir %3 | _height %4 | _disable %5 | _removeFuel %6 _releaseToPlayers %7 | _deleteTimer %8",_className,_spawnPos,_dir,_height,_disable,_removeFuel,_releaseToPlayers,_deleteTimer]] call GMSCore_fnc_log;
private _veh = [_className,_spawnPos,_dir,_height] call GMSCore_fnc_createVehicle;
if !(isNull _veh) then 
{
	[_veh,_disable,_removeFuel,_releaseToPlayers,_deleteTimer] call GMSCore_fnc_initializePatrolVehicle;
	_veh enableDynamicSimulation false;
	_veh enableSimulationGlobal true;
	_veh setVariable[GMS_vehHitCode,_vehHitCode];
	_veh setVariable[GMS_vehKilledCode,_vehKilledCode];
};
_veh