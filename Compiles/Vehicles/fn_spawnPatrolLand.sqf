/*
	GMSCore_fnc_spawnPatrolLand 

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
		_vehicle, the vehicle configured 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: need to add a check to the delete objects cue for vehicles that are not local to the server and assume these were entered a player.
		having a specific check that the owner is not an HC or is a player would also help here.
		TODO: Ensure all group configs are done
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[
		["_className",""], // Clasname of vehicle to be spawned
		["_spawnPos",[0,0,0]],  //  selfevident		
		["_patrolAreaMarker", GMSCore_mapMarker],
		["_markerDelete", true],
		["_disable",0],  // damage value set to this value if less than this value when all crew are dead
		["_removeFuel",0.2],  // fuel set to this value when all crew dead
		["_releaseToPlayers",true],
		["_deleteTimer",300],
		["_vehHitCode",[]],
		["_vehKilledCode",[]]
	];
//[format["\x\addons\GMSCore_fnc_spawnPatrolVehicle: _className %1 | _spawnPos %2 | _dir %3 | _height %4 | _disable %5 | _removeFuel %6 _releaseToPlayers %7 | _deleteTimer %8",_className,_spawnPos,"_dir no longer provided","_height no longer provided",_disable,_removeFuel,_releaseToPlayers,_deleteTimer]] call GMSCore_fnc_log;
private _vehicle = [_className,_spawnPos] call GMSCore_fnc_createVehicle;

[_vehicle,_disable,_removeFuel,_releaseToPlayers,_deleteTimer] call GMSCore_fnc_initializePatrolVehicle;
_vehicle setVariable[GMS_vehKilledCode,_vehKilledCode];		
private _group = [GMSCore_Side, false] call GMSCore_fnc_createGroup;
_group addVehicle _vehicle;	
[_group, _vehicle] call GMSCore_fnc_setGroupVehicle;

_group setVariable["refuelTime", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["refuelTimeInt",  getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["assignedToVehicle", _vehicle];
_vehicle setVariable["assignedToGroup", _group];
_group setVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_LAND];
_group setVariable["maxDistAgro", NO_AGRO_RANGE_LAND];
_group setVariable["isStuck", false];	
_group setVariable["antiStuckDist", antiStuckMinTravelDistance_LAND];
_antistucktime = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
_group setVariable["antiStuck", diag_tickTime + _antiStuckTime];
_group setVariable["minWPdist", MIN_WP_DIST_LAND];
_group setVariable["maxWPdist", MAX_WP_DIST_LAND];
_group setVariable["antiStuckPos", getPosATL _vehicle];
_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];

_vehicle allowCrewInImmobile false; 
_vehicle setUnloadInCombat  [false, false]; 
(units _group) allowGetIn true;
_group allowFleeing 0;

[_group, _markerDelete] call GMSCore_fnc_setMarkerDelete; 
_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];
[_group, "Safe"] call GMSCore_fnc_setGroupBehavior;

if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
	// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
	{_x enableSimulationGlobal true} forEach (units _group);
	_vehicle enableSimulationGlobal true;
} else {
	// These groups patrol smaller regions and can be desimulated when no player is near 
	{_x enableDynamicSimulation true} forEach (units _group);
	_vehicle enableDynamicSimulation true;
};		
	
GMSCore_monitoredGroups pushBackUnique _group;
GMSCore_monitoredPatrolsLand pushBack [_group];

private _wpPos = _spawnPos getPos[500, random(360)];
//[format["_spawnPatrolLand: _wpPos = %1", _wpPos]] call GMSCore_fnc_log;
[_group, 0] setWPPos (_wpPos);
[_group, 0] setWaypointType "MOVE";
[_group, 0] setWaypointTimeout [0.5, 0.6, 0.7];
[_group, 0] setWaypointCompletionRadius 200;
[_group, 0] setWaypointCombatMode (combatMode _group);
[_group, 0] setWaypointBehaviour (behaviour (leader _group));
[_group, 0] setWaypointSpeed "FULL";
[_group, 0] setWaypointStatements ["true","[this] spawn GMSCore_fnc_detectPlayerLand"];

private _wp = _group addWaypoint [_wpPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointTimeout [3,6,9];
_wp setWaypointCompletionRadius 150;
_wp setWaypointCombatMode (combatMode _group);
_wp setWaypointBehaviour (behaviour (leader _group));
_wp setWaypointSpeed "LIMITED";
_wp setWaypointStatements ["true","[this,'Completed'] spawn GMSCore_fnc_nextWaypointAreaPatrolLand"];

private _wpCycle = _group addWaypoint [_wpPos, 0];
//_wpCycle setWPpos _wpPos;
_wpCycle setWaypointType "CYCLE";
_wpCycle setWaypointCompletionRadius 150; 

_group setCurrentWaypoint _wp; 

[_group, _vehicle]