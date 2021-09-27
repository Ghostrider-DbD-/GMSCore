/*

	GMS_fnc_nearestTarget

	Purpose: returns true if one unit in group can see one unit in an array from another Side

	Parametsrs:
		_group: the group doing the search 
		_units: units to look for

	Returns: returns a player or objNull if none found nearby

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params[["_group",grpNull],["_searchRange",300],["_minKnowsAbout",1]];
private _leader = leader _group;
private _vehicle = vehicle _leader;
private _huntVehicles = _group getVariable[GMS_huntVehicles,false];
private _enemy = _leader findNearestEnemy (getPos _leader);
private _knows = if !(isNull _enemy) then {_leader knowsAbout _enemy} else {-1};
if (isNull _enemy || (_leader knowsAbout _enemy) < _minKnowsAbout) then 
{
	_enemies = allPlayers select{(_x distance _leader) < _searchRange};
	{
		if ([_group,_x] call GMS_fnc_groupCanSee || (_leader knowsAbout _x) > _minKnowsAbout) exitWith {_enemy = _x};
	} forEach _enemies; 
};
[format["GMS_fnc_nearestTarget: returning _enemy = %1",_enemy]] call GMS_fnc_log;
_enemy 





