/*
	GMS_fnc_spawnInfantryGroup

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
#include "\GMSCore\Init\GMS_defines.hpp"
params[
		["_pos",[0,0,0]],  // center of the area in which to spawn units
		["_units",0],  // Number of units to spawn
		["_side",GMS_side],
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
if (_pos isEqualTo [0,0,0]) exitWith {["Spwan Infantry Group: No Position Specified","error"] call GMS_fnc_log};
if (_units == 0) exitWith {["Spawn Infantry: Number of units not defined or set to 0, no group spawned","error"], call GMS_fnc_log};

private _group = [_side] call GMS_fnc_createGroup;
_group setVariable[GMS_patrolAlertDistance,_alertDistance];
_group setVariable[GMS_patrolIntelligence,_intelligence];
_group setVariable[GMS_bodyCleanupTime,_bodycleanuptimer];
_group setVariable[GMS_maxReloads,_maxReloads];
_group setVariable[GMS_removeLauncher,_removeLaunchers];
_group setVariable[GMS_removeNVG,_removeLaunchers];
_group setVariable[GMS_maxHeals,_maxHeals];
_group setVariable[GMS_minDamageForHeal,_minDamageToHeal];
_group setVariable[GMS_smokeShell,_smokeShell];
_group setVariable[GMS_aiHitCode,_aiHitCode]; 
_group setVariable[GMS_aiKilledCode,_aiKilledCode];
_group setVariable[GMS_garisonChance,_chanceGarison];
_players = allPlayers select {_x distance _pos < _alertDistance};
{_group reveal[_x,_intelligence]} forEach _players;

private _ranks = +GMS_infantryGroup;
private _currRank = [];
for "_i" from 1 to _units do
{
	private["_unit"];
	if !(_ranks isEqualTo []) then 
	{
		_currRank = _ranks deleteAt 0;
	} else {
		_rank = "PRIVATE";
	};
	GMS_unitType createUnit [_pos, _group, "_unit = this", _baseSkill, _currRank select 0];
	_unit setVariable ["loadoutType", _currRank select 1];
	if (GMS_modType isEqualTo "Epoch") then {_unit setVariable ["LAST_CHECK",28800,true]};
	_unit enableAI "ALL";

};
_group call GMS_fnc_addUnitEventHandlers;

_group

