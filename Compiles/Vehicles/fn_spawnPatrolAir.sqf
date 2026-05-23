/*
	GMSCore_fnc_spawnPatrolAircraft

	Purpose: spawn and initialize an aircraft or UAV to be used for AI patrols 
			This is a special case because additional stuff needs to be done to be sure 
			the aircraft is flying and has a pilot right off the bat. 
			Note that there is a small movement of 300 meters specified at spawnin. 

	Parameters: 

	Returns:
		_aircraft, the vehicle configured 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: update GMS_RC fornew parameters list
			TODO: Ensure all group configs are done
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
/*

*/

params[
	["_className",""],
	["_spawnPos", []],
	["_patrolAreaMarker",GMSCore_mapMarker],
	["_markerDelete",false],
	["_disable",0],  // damage value set to this value if less than this value when all crew are dead
	["_removeFuel",0.2],  // uel set to this value when all crew dead
	["_releaseToPlayers",true],
	["_deleteTimer",300],
	["_aircraftHit", []],
	["_aircraftKilled", []]
];

//[format["_spawnPatrolAir called with _className %1 | _spawnPos %2 | _patrolAreaMarker %3", _className, _spawnPos, _patrolAreaMarker]] call GMSCore_fnc_log; 

if !(isClass(configFile >> "CfgVehicles" >> _className)) exitWith
{
	[format["_spawnPatrolAircraft called with invalid classname %1",_className],"error"] call GMSCore_fnc_log;
	[grpNull, objNull];
};
if !(_className isKindOf "Air") exitWith 
{
	[format["_spawnPatrolAircraft: class name %1 is not kindOf 'Air'",_className],"error"] call GMSCore_fnc_log;
	[grpNull, objNull];
};
if (_spawnPos isEqualTo []) exitWith {[format["_spawnPatrolAircraft: no value passed for _spawnPos"]] call GMSCore_fnc_log};
if (_spawnPos isEqualTo [0,0,0]) exitWith {[format["_spawnPatrolAircraft: _spawnPos is at [0,0,0]"]] call GMSCore_fnc_log};

_spawnPos set[2, 200];
private _vehicle = [_className, _spawnPos, 0, 200] call GMSCore_fnc_createVehicle;
[_vehicle,_disable,_removeFuel,_releaseToPlayers,_deleteTimer] call GMSCore_fnc_initializePatrolVehicle;
private _group = [GMSCore_Side, false] call GMSCore_fnc_createGroup;
private _pilot = [_group] call GMSCore_fnc_createUnit; 
_pilot moveInDriver _vehicle;	
_pilot assignAsDriver _vehicle; 
_group selectLeader _pilot;

_group setVariable["refuelTime", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["refuelTimeInt",  getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
_group setVariable["assignedToVehicle", _vehicle];
_vehicle setVariable["assignedToGroup", _group];
_group setVariable["isStuck", false];	
_group setVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_AIR];
_group setVariable["maxDistAgro", NO_AGRO_RANGE_AIR];
//TODO: Apply throughout new scripts [_group, _aircraft] call GMSCore_fnc_setGroupVehicle;
// TODO: Apply throughout new scripts [_group, _markerDelete] call GMSCore_fnc_setMarkerDelete; 
_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];
_group setVariable[GMSCore_deleteMarker, _markerDelete];
private _minRange = minDistWP_Air;  //  min distance to next waypoint for planes and faster drones 
private _maxRange = maxDistWP_Air; 

if (_vehicle isKindOf "Helicopter") then {
	if ([_className] call GMSCore_fnc_isDrone) then {
		_minRange = minDistWP_Drone;
		_maxRange = maxDistWP_Drone;  
	} else {
		_minRange = minDistWP_Heli;
		_maxRange = maxDistWP_Heli;  
	};
};	
_group setVariable["minWPdist", _minRange];
_group setVariable["maxWPdist", _maxRange];

private _antiStuckTime = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
_group setVariable["antiStuckPos", _spawnPos];
_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];
if (GMSCore_debug > 0) then {[_group] call GMSCore_fnc_updateGroupDebugMarker};	
if (_vehicle isKindOf "Plane") then {
	_group setVariable[GMS_flyinVariation,25];
	_group setVariable[GMS_flyinHeight,100];
};
if (_vehicle isKindOf "Helicopter") then {
	_group setVariable[GMS_flyinVariation,15];
	_group setVariable[GMS_flyinHeight,50];	
};

#define maxgunnersAircraft 3
#define maxCargoAir 0 
// params[["_group",grpNull], ["_vehicle", objNull],["_maxGunner",0],["_maxCargo", 0]];
[_group, _vehicle, maxgunnersAircraft, maxCargoAir] call GMSCore_fnc_addVehicleCrew; 

_group addVehicle _vehicle;	
_vehicle allowCrewInImmobile false; 
_vehicle setUnloadInCombat  [false, false]; 
(units _group) allowGetIn true;
	
_vehicle enableCoPilot true;

_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];

_group allowFleeing 0;
[_group, "Normal"] call GMSCore_fnc_setGroupBehavior;

if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
	// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
	{_x enableSimulationGlobal true} forEach (units _group);
	_vehicle enableSimulationGlobal true;
} else {
	// These groups patrol smaller regions and can be desimulated when no player is near 
	{_x enableDynamicSimulation true} forEach (units _group);
	_vehicle enableDynamicSimulation true;
};	
GMSCore_monitoredPatrolsAir pushBackUnique _group;
GMSCore_monitoredGroups pushBackUnique _group;
// TODO: Adjust combateMoe and behavior based on whether or not a vehicle has weapons 
private _wpPos = _spawnPos getPos[500, random(360)];
//format["_spawnPatrolAircraft: _wpPos = %1", _wpPos]] call GMSCore_fnc_log;
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
_vehicle flyInHeight (FLYIN_HEIGHT_AIR_BASE + random(FLYIN_HEIGHT_AIR_VARIANCE));

[_group, _vehicle]