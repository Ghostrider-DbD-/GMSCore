/*
	GMSCore_fnc_getRandomLocation
	Purpose: return a randomly selected location name from the array of locations generated at initialization based on GMS_locationsForWaypoints which is defined in GMSCore_fnc_configureWorlds

*/
params[["_anchor", getMarkerPos GMSCore_mapMarker],["_maxRange",5000]];
if (GMS_patrolLocations isEqualTo []) exitWith {""};
private _distance = 0;
private _destination = "";
while {_distance < 300 || _distance > _maxRange} do {
	_destination = selectRandom GMS_patrolLocations;
	_distance = _anchor distance (position _destination);
};
_destination;