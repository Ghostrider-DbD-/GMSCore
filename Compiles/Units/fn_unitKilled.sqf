/*
	GMS_fnc_unitKilled 

	Purpose: called when the MPKilled eventhander fires for the unit   

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPKilled 

	Returns: none 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
if !(local (_this select 0)) exitWith {};
params["_unit","_killer","_instigator"];
//[format["GMS_fnc_unitKilled: _unit = %1 | _killer = %2 | _instigator %3",_unit,_killer,_instigator]] call GMS_fnc_log;
private _cleanupTimer = (group _unit) getVariable[GMS_bodyCleanupTime,600];
[_unit,_cleanupTimer] call GMS_fnc_addObjectsToDeletionCue;
[_unit] call GMS_fnc_removeAllEventHandlers;
[_unit] call GMS_fnc_removeAllMPEventHandlers;
_unit disableAI "ALL";

//private _removeLauncher = _group getVariable[GMS_removeLauncher,true];
if (_group getVariable[GMS_removeLauncher,true]) then 
{
	_unit call GMS_fnc_removeLauncher;
};
//private _removeNVG = _group getVariable[GMS_removeNVG,true];
if (_group getVariable[GMS_removeNVG,true]) then 
{
	_unit call GMS_fnc_removeNVG;
};

if !((vehicle _unit) isKindOf "Man") then 
{
	if (local _unit) then 
	{
		_unit action ["Eject",vehicle _unit];  // can probably remoteexec this from the server 
	} else {
		// remoteExec the eject action
	};
	if (crew (vehicle _unit) isEqualTo []) then 
	{
		[vehicle _unit] call GMS_fnc_allowPlayerAccess;  // check if vehicle is empty and if so handle it.
	};
};

{_this call _x} forEach ((group _unit) getVariable[GMS_aiKilledCode,[]]);  // Run any external code to be executed upon AI Death.

if (units (group _unit) isEqualTo []) then 
{
	deleteGroup (group _unit);
} else {
	if ([group _unit] call GMS_fnc_updateGroupHitKilledTimer) then // This only allows updates every 15 sec to reduce server load.
	{
		#define searchDistance (group _unit) getVariable [GMS_patrolAlertDistance,500] // Tied to the alertDistance for the group
		#define bumpKnowsAbout (group _unit) getVariable [GMS_patrolIntelligence,0.5] // Tied to intelligence fot the group
		[group _source, serachDistance, bumpKnowsAbout] call GMS_fnc_allertNearbyGroups;
		[group _unit, _killer] call GMS_fnc_huntPlayerGroup;
	};
};
[_unit] joinSilent GMS_graveyardGroup;
