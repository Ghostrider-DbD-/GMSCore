/*
	GMSCore_fnc_spawnPatrolUAV

	Purpose: spawn and initialize an aircraft or UAV to be used for AI patrols 
			This is a special case because additional stuff needs to be done to be sure 
			the aircraft is flying and has a pilot right off the bat. 
			Note that there is a small movement of 300 meters specified at spawnin. 

	Parameters: 

	Returns:
		_aircraft, the vehicle configured 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: update GMS_RC for new parameters list
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

//[format["_spawnPatrolUAV called with _className %1 | _spawnPos %2", _className, _spawnPos]] call GMSCore_fnc_log; 

if !(isClass(configFile >> "CfgVehicles" >> _className)) exitWith
{
	[format["_spawnPatrolUAV called with invalid classname %1",_className]] call GMSCore_fnc_log;
	objNull
};
if !([_className] call GMSCore_fnc_isDrone) exitWith 
{
	[format["_spawnPatrolUAV: class name %1 is not a drone",_className]] call GMSCore_fnc_log;
	objNull
};
if !(_className isKindOf "Air") exitWith 
{
	[format["_spawnPatrolUAV: class name %1 is not kindOf 'Air'",_className]] call GMSCore_fnc_log;
	objNull
};

if (_spawnPos isEqualTo []) exitWith {[format["_spawnPatrolUAV: no value passed for _spawnPos"]] call GMSCore_fnc_log};
if (_spawnPos isEqualTo [0,0,0]) exitWith {[format["_spawnPatrolUAV: _spawnPos is at [0,0,0]"]] call GMSCore_fnc_log};

_spawnPos set[2, 200];
private _aircraft = [_className, _spawnPos, 0, 200] call GMSCore_fnc_createVehicle;
private _group = GMSCore_side createVehicleCrew _aircraft;	
//[format["_spawnPatrolUAV: side leader _group = %1 | GMSCore_side = %2", side leader _group, GMSCore_side]] call GMSCore_fnc_log;
[
	_aircraft,
	_disable,
	_removeFuel,
	_releaseToPlayers,
	_deleteTimer
] call GMSCore_fnc_initializePatrolVehicle;

_group setVariable[GMS_flyinHeight, FLYIN_HEIGHT_AIR_BASE];
_group setVariable["refuelTime", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["refuelTimeInt",  getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["assigned_vehicle", _aircraft];

if (_aircraft isKindOf "Plane") then {
	_group setVariable[GMS_flyinVariation,40];
	_group setVariable[GMS_flyinHeight,100];
};
if (_aircraft isKindOf "Helicopter") then {
	_group setVariable[GMS_flyinVariation,25];
	_group setVariable[GMS_flyinHeight,50];	
};

_group setVariable["assignedToVehicle", _aircraft];
_aircraft setVariable["assignedToGroup", _group];
[_group, _aircraft] call GMSCore_fnc_setGroupVehicle;
[_group, _markerDelete] call GMSCore_fnc_setMarkerDelete; 
_group setVariable["isStuck", false];	
_group setVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_AIR];
_group setVariable["maxDistAgro", NO_AGRO_RANGE_AIR];
_group setVariable["antiStuckDist", antiStuckMinTravelDistance_Air];
_antistucktime = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
_group setVariable["antiStuck", diag_tickTime + _antiStuckTime];
private _minRange = minDistWP_Air;  //  min distance to next waypoint for planes and faster drones 
private _maxRange = maxDistWP_Air; 
if (_aircraft isKindOf "Helicopter") then {
	if ([typeOf _aircraft] call GMSCore_fnc_isDrone) then {
		_minRange = minDistWP_Drone;
		_maxRange = maxDistWP_Drone;  
	} else {
		_minRange = minDistWP_Heli;
		_maxRange = maxDistWP_Heli;  
	};
};	

_group setVariable["minWPdist", _minRange];
_group setVariable["maxWPdist", _maxRange];
	
_group setVariable["antiStuckPos", getPosATL _aircraft];
_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];

GMSCore_monitoredGroups pushBackUnique _group;

_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];

[_group, "Normal"] call GMSCore_fnc_setGroupBehavior;

//GMSCore_monitoredPatrolsAir pushBack [_group];

if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
	// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
	{_x enableSimulationGlobal true} forEach (units _group);
	_aircraft enableSimulationGlobal true;
} else {
	// These groups patrol smaller regions and can be desimulated when no player is near 
	{_x enableDynamicSimulation true} forEach (units _group);
	_aircraft enableDynamicSimulation true;
};	
_group allowFleeing 0;

// TODO: Adjust combateMoe and behavior based on whether or not a vehicle has weapons 
private _wpPos = _spawnPos getPos[500, random(360)];
[_group, 0] setWPPos (_wpPos);
[_group, 0] setWaypointType "MOVE";
[_group, 0] setWaypointTimeout [0.5, 0.6, 0.7];
[_group, 0] setWaypointCompletionRadius 200;
[_group, 0] setWaypointCombatMode (combatMode _group);
[_group, 0] setWaypointBehaviour (behaviour (leader _group));
[_group, 0] setWaypointSpeed "FULL";
[_group, 0] setWaypointStatements ["true","[this] spawn GMSCore_fnc_detectPlayerAir"];

private _wp = _group addWaypoint [_wpPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointTimeout [3,6,9];
_wp setWaypointCompletionRadius 150;
_wp setWaypointCombatMode (combatMode _group);
_wp setWaypointBehaviour (behaviour (leader _group));
_wp setWaypointSpeed "LIMITED";
_wp setWaypointStatements ["true","[this,'Completed'] spawn GMSCore_fnc_nextWaypointAreaPatrolAir"];

private _wpCycle = _group addWaypoint [_wpPos, 0];
//_wpCycle setWPpos _wpPos;
_wpCycle setWaypointType "CYCLE";
_wpCycle setWaypointCompletionRadius 150; 

_group setCurrentWaypoint _wp; 

_group setVariable["AirLastParaDrop", diag_tickTime - HELI_PARADROP_COOLDOWN];
_aircraft flyInHeight (FLYIN_HEIGHT_AIR_BASE + random(FLYIN_HEIGHT_AIR_VARIANCE));

if (!(isNull _group) && !(isNull _aircraft)) then {
	GMSCore_monitoredGroups pushBackUnique _group;
	GMSCore_monitoredPatrolsUAV pushBack [_group];
	if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
		// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
		{_x enableSimulationGlobal true} forEach (units _group);
		_aircraft enableSimulationGlobal true;
	} else {
		// These groups patrol smaller regions and can be desimulated when no player is near 
		{_x enableDynamicSimulation true} forEach (units _group);
		_aircraft enableDynamicSimulation true;
	};			
};				

[_group, _aircraft]