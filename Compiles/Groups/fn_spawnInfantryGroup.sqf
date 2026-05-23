/*
	GMSCore_fnc_spawnInfantryGroup

	Purpose: spawn a group of N infantry units as a specified position.

	Parameters
		_groupPos: postion at which to spawn the overall group; individual units will be spawned at safe spots in the region of the group position.
		_units: number of units to spawn for the group.
		_side: side on which the group is spawned.
		_baseSkill: base skill for the group 
		_alertDistance: distance within which nearby units or groups are alerted to enemy activity by the group 
		_intelligence: the increment in awareness upon each discovery of an enemy - higher values mean more skilled AI as far as finding enemy players.
		_alertDistance: how far to search for players that the group should know about.
		_bodycleanuptimer: how long to wait before deleted the corpse 
		_maxReloads: how many times the unit is allowed to reload its weapon; -1 for infinite reloads 
		_removeLaunchers: true/false, whether launchers should be removed upon AI death 
		_removeNVG: true/false, wether NVG are removed on AI death 
		_minDamageToHeal: what the damage value from 0..1 should be to trigger the heal mechanic (default 0.4)
		_smokeShell: the type of smoke shell the unit throws before healing, use "" for none (default none)
		_maxHeals: how many times a unit is allowed to head (default, 1)

	Return: the group that was spawned.

	Copyright 2020 Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[
		["_pos",[0,0,0]],  // center of the area in which to spawn units
		["_patrolAreaMarker",GMSCore_mapMarker],
		["_markerDelete",false],	
		["_units",0],  // Number of units to spawn
		["_side",GMSCore_Side],
		["_baseSkill",0.7],
		["_alertDistance",500], 	 // How far GMS will search from the group leader for enemies to alert to the kiillers location
		["_intelligence",0.5],  	// how much to bump knowsAbout after something happens
		["_bodycleanuptimer",600],  // How long to wait before deleting corpses for that group
		["_maxReloads",-1], 			// How many times the units in the group can reload. If set to -1, infinite reloads are available.
		["_removeLaunchers",true],
		["_removeNVG",true],
		["_minDamageToHeal",0.4],
		["_maxHeals",1],
		["_smokeShell",""],
		["_aiHitCode",[]],
		["_aiKilledCode",[]],
		["_chanceGarison",0]
];

if (_pos isEqualTo [0,0,0]) then {["Spwan Infantry Group: No Position Specified or position = [0,0,0]","warning"] call GMSCore_fnc_log; };
if (_units == 0) exitWith {["Spawn Infantry: Number of units not defined or set to 0, no group spawned","error"], call GMSCore_fnc_log};
private _group = [_side] call GMSCore_fnc_createGroup;

// TODO: Implement Ranks
for "_i" from 1 to _units do
{
	private _unit = [_group, _pos, _baseSkill] call GMSCore_fnc_createUnit;
};

//[format["_spawnInfantryGroup: units _group = %1", units _group]] call GMSCore_fnc_log;

[
	_group,
	_baseSkill,
	_alertDistance, 	 // How far GMS will search from the group leader for enemies to alert to the kiillers location
	_intelligence,  	// how much to bump knowsAbout after something happens
	_bodycleanuptimer,  // How long to wait before deleting corpses for that group
	_maxReloads, 			// How many times the units in the group can reload. If set to -1, infinite reloads are available.
	_removeLaunchers,
	_removeNVG,
	_minDamageToHeal,
	_maxHeals,
	_smokeShell,
	_aiHitCode,
	_aiKilledCode	
] call GMSCore_fnc_initializeGroup;

[_group, _markerDelete] call GMSCore_fnc_setMarkerDelete; 
_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];
_group setVariable["isStuck", false];	
_group setVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_INFANTRY];
_group setVariable["maxDistAgro", NO_AGRO_RANGE_INFANTRY];
_group setVariable["antiStuckDist", antiStuckMinTravelDistance_INFANTRY];
_antistucktime = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
_group setVariable["antiStuck", diag_tickTime + _antiStuckTime];

_group setVariable["minWPdist", MIN_WP_DIST_LAND];
_group setVariable["maxWPdist", MAX_WP_DIST_LAND];

_group setVariable["antiStuckPos", getPosATL (leader _group)];
_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];

//[format["_spawnInfantryGroup: _group = %1",_group]] call GMSCore_fnc_log;

[_group, "Normal"] call GMSCore_fnc_setGroupBehavior;

{_x enableDynamicSimulation true} forEach (units _group);
_group allowFleeing 0;

// TODO: Adjust combateMoe and behavior based on whether or not a vehicle has weapons 
private _wpPos = _pos getPos[500, random(360)];
[_group, 0] setWPPos (_wpPos);
[_group, 0] setWaypointType "MOVE";
[_group, 0] setWaypointTimeout [0.5, 0.6, 0.7];
[_group, 0] setWaypointCompletionRadius 30;
[_group, 0] setWaypointCombatMode (combatMode _group);
[_group, 0] setWaypointBehaviour (behaviour (leader _group));
[_group, 0] setWaypointSpeed "FULL";
[_group, 0] setWaypointStatements ["true","[this] spawn GMSCore_fnc_detectPlayerLand"];

private _wp = _group addWaypoint [_wpPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointTimeout [3,6,9];
_wp setWaypointCompletionRadius 15;
_wp setWaypointCombatMode (combatMode _group);
_wp setWaypointBehaviour (behaviour (leader _group));
_wp setWaypointSpeed "LIMITED";
_wp setWaypointStatements ["true","[this,'Completed'] spawn GMSCore_fnc_nextWaypointAreaPatrolLand"];

private _wpCycle = _group addWaypoint [_wpPos, 0];
//_wpCycle setWPpos _wpPos;
_wpCycle setWaypointType "CYCLE";
_wpCycle setWaypointCompletionRadius 12; 

_group setCurrentWaypoint _wp; 

GMSCore_monitoredGroups pushBackUnique _group;
GMSCore_monitoredPatrolsInfantry pushBack [_group];

_group

