/*
	GMSCore_fnc_getRandomLocation
	Purpose: return a randomly selected location name from the array of locations generated at initialization based on GMS_locationsForWaypoints which is defined in GMSCore_fnc_configureWorlds

*/
params[["_anchor", getMarkerPos GMSCore_mapMarker],["_minRange",300],["_maxRange",5000],["_locationsList", []]];

if (_locationsList isEqualTo []) exitWith {""};

private _distance = 0;
private _destination = "";
while {_distance < _minRange || _distance > _maxRange} do {
	_destination = selectRandom _locationsList;
	_distance = _anchor distance (position _destination);
	//[format["_minRange %1 | _maxRange %2 | _destination %3 | _distance %4 | _anchor %5",_minRange,_maxRange,_destination,_distance,_anchor]] call GMSCore_fnc_log;	
};
_destination;