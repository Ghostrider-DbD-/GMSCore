/*
    GMSCore_fnc_findNearestLocations 
    Purpose: find 1 or more locations of the specified type within a range of a location 
    Parameters:
        _pos - anchor position for search
        _types: array of strings with the types of locations to identify 
        _range: starting point for radius of search
        _minLocs: minimum number of locations to return 
*/

params[["_pos",[0,0,0]],["_types",[]],["_radius",300],["_minLocs",0]];
//[format["_findNearestLocations: _pos %1 | _radius %2 | _minLocs %3 | _types %4", _pos, _radius, _minLocs, _types]] call GMSCore_fnc_log;
private _nearestLocs = [];
while {count _nearestLocs < _minLocs} do {
    _nearestLocs = nearestLocations[_pos, _types, _radius];
    //[format["_findNearestLocations: %1 locations found with _radius %2", count _nearestLocs, _radius]] call GMSCore_fnc_log;
    _radius = _radius+ 100;  
};
_nearestLocs