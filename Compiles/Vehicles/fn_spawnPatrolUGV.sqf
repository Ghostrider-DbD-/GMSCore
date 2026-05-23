/*
	GMSCore_fnc_spawnUnmannedVehicle 

	Purpose: spawn and initialize a drone to be used for AI patrols 

	Parameters: 

	Returns: [
		the vehicle configured 
		the group that mans it 

	Copyright 2020 by Ghostrider-GRG-

	Notes: Be sure to select drones from the same faction as GMSCore_Side
	TODO: Ensure all group configs are done
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params[
	["_className",""],
	["_spawnPos", []],	
	["_patrolAreaMarker",GMSCore_mapMarker],
	["_markerDelete",false],
	["_disable",0],  // damage value set to this value if less than this value when all crew are dead
	["_removeFuel",0.2],  // uel set to this value when all crew dead
	["_releaseToPlayers",true],
	["_deleteTimer",300],
	["_vehHitCode",[]],
	["_vehKilledCode",[]]	
];


if !(isClass(configFile >> "CfgVehicles" >> _className)) exitWith
{
	[format["_spawnPatrolUGV called with invalid classname %1",_className]] call GMSCore_fnc_log;
	objNull
};
if !([_className] call GMSCore_fnc_isDrone) exitWith 
{
	[format["_spawnPatrolUGV: class name %1 is not a drone",_className]] call GMSCore_fnc_log;
	objNull
};
if !(_className isKindOf "LANDVEHICLE") exitWith 
{
	[format["_spawnPatrolUGV: class name %1 is not kindOf 'LANDVEHICLE'",_className]] call GMSCore_fnc_log;
	objNull
};

if (_spawnPos isEqualTo []) exitWith {[format["_spawnPatrolUGV: no value passed for _spawnPos"]] call GMSCore_fnc_log};
if (_spawnPos isEqualTo [0,0,0]) exitWith {[format["_spawnPatrolUGV: _spawnPos is at [0,0,0]"]] call GMSCore_fnc_log};

_spawnPos set[2, 200];
private _vehicle = [_className, _spawnPos, 0, 200] call GMSCore_fnc_createVehicle;
private _group = GMSCore_side createVehicleCrew _vehicle;	
//[format["_spawnPatrolUGV: side leader _group = %1 | GMSCore_side = %2", side leader _group, GMSCore_side]] call GMSCore_fnc_log;
[
	_vehicle,
	_disable,
	_removeFuel,
	_releaseToPlayers,
	_deleteTimer
] call GMSCore_fnc_initializePatrolVehicle;

_group setVariable["isStuck", false];	
_group setVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_LAND];
_group setVariable["maxDistAgro", NO_AGRO_RANGE_LAND];
_group setVariable["antiStuckDist", antiStuckMinTravelDistance_LAND];
_antistucktime = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
_group setVariable["antiStuck", diag_tickTime + _antiStuckTime];
_group setVariable["minWPdist", MIN_WP_DIST_LAND];
_group setVariable["maxWPdist", MAX_WP_DIST_LAND];
_group setVariable["antiStuckPos", getPosATL _vehicle];
_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];
_group setVariable["refuelTime", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["refuelTimeInt",  getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];

_group setVariable["assigned_vehicle", _vehicle];

_group setVariable["assignedToVehicle", _vehicle];
_vehicle setVariable["assignedToGroup", _group];
[_group, _vehicle] call GMSCore_fnc_setGroupVehicle;
[_group, _markerDelete] call GMSCore_fnc_setMarkerDelete; 

GMSCore_monitoredGroups pushBackUnique _group;

_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];

[_group, "Safe"] call GMSCore_fnc_setGroupBehavior;

//GMSCore_monitoredPatrolsAir pushBack [_group];

if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
	// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
	{_x enableSimulationGlobal true} forEach (units _group);
	_vehicle enableSimulationGlobal true;
} else {
	// These groups patrol smaller regions and can be desimulated when no player is near 
	{_x enableDynamicSimulation true} forEach (units _group);
	_vehicle enableDynamicSimulation true;
};	
_group allowFleeing 0;

// TODO: Adjust combateMoe and behavior based on whether or not a vehicle has weapons 
private _wpPos = _spawnPos getPos[500, random(360)];
//[format["_spawnPatrolUGV: _wpPos = %1", _wpPos]] call GMSCore_fnc_log;
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
_wp setWaypointCompletionRadius 75;
_wp setWaypointCombatMode (combatMode _group);
_wp setWaypointBehaviour (behaviour (leader _group));
_wp setWaypointSpeed "LIMITED";
_wp setWaypointStatements ["true","[this,'Completed'] spawn GMSCore_fnc_nextWaypointAreaPatrolLand"];

private _wpCycle = _group addWaypoint [_wpPos, 0];
_wpCycle setWaypointType "CYCLE";
_wpCycle setWaypointCompletionRadius 50; 
_group setCurrentWaypoint _wp; 

if (!(isNull _group) && !(isNull _vehicle)) then {
	//[format["_spawnPatrolUGV: _group %1 | _vehicle %2 | typeOf _vehicle %3 | crew %4 ", _group, _vehicle, typeOf _vehicle, crew _vehicle]] call GMSCore_fnc_log;
	//[format["_spawnPatrolUGV: position %1 | altitude %2 | speed %3", getPosATL _vehicle, (getPosATL _vehicle) select 2, speed _vehicle]] call GMSCore_fnc_log;
	
	GMSCore_monitoredGroups pushBackUnique _group;
	GMSCore_monitoredPatrolsUGV pushBack [_group];
	//[format["_spawnPatrolUGV: GMSCore_monitoredPatrolsUAV = %1", GMSCore_monitoredPatrolsUAV]] call GMSCore_fnc_log;
	if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
		// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
		{_x enableSimulationGlobal true} forEach (units _group);
		_vehicle enableSimulationGlobal true;
	} else {
		// These groups patrol smaller regions and can be desimulated when no player is near 
		{_x enableDynamicSimulation true} forEach (units _group);
		_vehicle enableDynamicSimulation true;
	};			
};		

[_group, _vehicle]