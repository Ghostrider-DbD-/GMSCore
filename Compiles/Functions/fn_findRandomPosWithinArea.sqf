/*
	GMS_fnc_findRandomPosWithinArea

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

#include "\GMSCore\Init\GMS_defines.hpp"
params["_areaMarker","_noPositionsToFind",["_units",[]],["_separation",100],["_blackList",[]]];
diag_log format["GMS_fnc_findRandomPosWithinArea:  _areaMarker %1 | _noPositionsToFind %2",_areaMarker,_noPositionsToFind];
private _spawnPos = [0,0];
private _posnFound = [];
private _center = markerPos _areaMarker;
private _size = markerSize _areaMarker;
if ((typeName _size) isEqualTo "ARRAY") then {_size = (_size select 0) max (_size select 1)};
diag_log format["GMS_fnc_findRandomPosWithinArea: _size = %1",_size];
private _localBlacklist = +_blackList;
{_localBlacklist pushBack [getPos _x, _separation]} forEach _units;
for "_i" from 1 to _noPositionsToFind do
{
	_spawnPos = [[[_center,_size]],_localBlacklist/* add condition that the spawn is not near a trader*/] call BIS_fnc_randomPos;
	if !(_spawnPos isEqualTo [0,0] || surfaceIsWater _spawnPos) then 
	{
		_posnFound pushBack _spawnPos;
		_localBlackList pushBack [_spawnPos,_separation];
	};
};
diag_log format["_findRandomPosWithinArea: _posnFound = %1",_posnFound];
_posnFound