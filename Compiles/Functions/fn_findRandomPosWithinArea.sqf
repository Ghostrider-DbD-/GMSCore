/*
	GMSCore_fnc_findRandomPosWithinArea

	Purpose: Returns N positions within an area with spacing from nearby units/players and each other.

	Parameters
		_areaMarker: a marker designating the area to be search (rectangualr only)
		_noPositionsToFind: number of positions within the area to search for.
		_units: players or units from which a certain spacing should be kbRemoveTopic
		_separation: the spacing to use for positions, players/units, effectiveCommander
		_blackList: a list of areas to be avoided.
	
	Returns: an array of the positions found within the area proscribed by _areaMarker 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_areaMarker","_noPositionsToFind",["_units",[]],["_separation",10],["_blackList",["water"]]];
//diag_log format["\x\addons\GMSCore_fnc_findRandomPosWithinArea:  _areaMarker %1 | _noPositionsToFind %2 | _separation %3",_areaMarker,_noPositionsToFind,_separation];
private _spawnPos = [0,0];
private _posnFound = [];
private _center = [];
private _size = [];
if (_areaMarker isEqualType "") then 
{
	_center = markerPos _patrolAreaMarker;
	_size = markerSize _patrolAreaMarker;
};
if (_areaMarker isEqualType []) then 
{
	_center = _patrolAreaMarker select 0;
	_size = _patrolAreaMarker select 1;
};
if (( _size) isEqualType []) then {_size = (_size select 0) max (_size select 1)};
//diag_log format["\x\addons\GMSCore_fnc_findRandomPosWithinArea: _size = %1",_size];
private _localBlacklist = +_blackList;
{_localBlacklist pushBack [getPosATL _x, _separation]} forEach _units;
for "_i" from 1 to _noPositionsToFind do
{
	_spawnPos = [[[_center,_size]],_localBlacklist/* add condition that the spawn is not near a trader*/] call BIS_fnc_randomPos;
	if !(_spawnPos isEqualTo [0,0] || {surfaceIsWater _spawnPos}) then 
	{
		_posnFound pushBack _spawnPos;
		_localBlackList pushBack [_spawnPos,_separation];
	};
};
//diag_log format["_findRandomPosWithinArea: _posnFound = %1",_posnFound];
_posnFound