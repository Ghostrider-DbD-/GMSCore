/*
	GMSCore_fnc_findRandomPosWithinArea

	Purpose: Returns N positions within an area with spacing from nearby units/players and each other.

	Parameters
		_areaMarker: a marker designating the area to be search (rectangualr only)
		_noPositionsToFind: number of positions within the area to search for.
		_testIsAllowed - when true will test for positions in blacklisted, no-Agro or safe zones 
		_allowWater - when true will allow positions over water 

	Returns: an array of the positions found within the area proscribed by _areaMarker 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_areaMarker",""],["_noPositionsToFind",0],["_testIsAllowed", true],["_allowWater", false]];
//[format["_findRandomPosWithinArea:  _areaMarker %1 | _noPositionsToFind %2 | _testIsAllowed %3 | _allowWater %4",_areaMarker,_noPositionsToFind,_testIsAllowed, _allowWater]] call GMSCore_fnc_log;
private _spawnPos = [0,0];
private _posnFound = [];
private _center = [];
private _size = 0;
if (_areaMarker isEqualType "") then 
{
	_center = markerPos _areaMarker;
	_size = markerSize _areaMarker;
};
if (_areaMarker isEqualType []) then 
{
	_center = _areaMarker select 0;
	_size = _areaMarker select 1;
};

_size = (_size select 0) max (_size select 1);
private _separation = 10;
private _blackList = [];
private _tries = 0;
//[format["_findRandomPosWithinArea: _tries %1 | count _posnFound %2",_tries, count _posnFound]] call GMSCore_fnc_log;
while {_tries < 25 && (count _posnFound) < _noPositionsToFind} do{
	_spawnPos = _areaMarker call BIS_fnc_randomPosTrigger;
	//[format["_findRandomPosWithinArea: evaluating _spawnPos %1", _spawnPos]] call GMSCore_fnc_log;
	private _disallowed = nearestLocations[_spawnPos, [WAYPOINT_DISALLOWED_AREAS], 50];
	private _isAllowed = [_spawnPos, 30] call GMSCore_fnc_inAllowedLocation;
	//[format["_findRandomPosWithinArea - evaluating _spawnPos %1 | _isAllowed %2 | surfaceIsWater _spawnPos %3 | _disallowed %4", _spawnPos, _isAllowed, surfaceIsWater _spawnPos, count _disallowed]] call GMSCore_fnc_log;
	if (_isAllowed) then {
		if (_allowWater || (!_allowWater && !(surfaceIsWater _spawnPos))) then {
			_posnFound pushBack _spawnPos;
			_blackList pushBack [_spawnPos, _separation, _separation];
			//[format["_findRandomPosWithinArea : adding _spawnPos %1 to _posnFound", _spawnPos]] call GMSCore_fnc_log;
		};
	};
	_tries = _tries + 1;
};
//[format["_findRandomPosWithinArea: _posnFound %1",_posnFound]] call GMSCore_fnc_log;
_posnFound