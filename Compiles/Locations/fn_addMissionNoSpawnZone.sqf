/*
    GMSCore_fnc_addMissionNoSpawnZone

    Parameters
        _location 
            syntax 1: _location is a text value that specifies and exisiting location
                      _name is ignored 
            syntax 2: _location is an array of [
                position relative to terain (getposATL) 
                size 1
                size 2
            ];
                      _name is an optional name 

    Returns: None 
*/
params[["_location", [[0,0,0], 0, 0]],["_name",""]];
[format["_addMissionNoSpawnZone: _x %1 | _location %2 | _name %3", _x, _location, _name]] call GMSCore_fnc_log; 
[_location, _name, "GMSCore_MissionNoSpawnZone"] call GMSCore_fnc_createLocation; 

/*
[format["_addMissionNoSpawnZone : _location %1  |  _name %2",_location,_name]] call GMSCore_fnc_log;
private _isLoc = if (typeName _location isEqualTo "LOCATION") then {true} else {false};
[format["_addMissionNoSpawnZone : _location %1 | _isLoc = %2", _location, _isLoc]] call GMSCore_fnc_log;

//  GMSCore_MissionNoSpawnZone

if (_location isEqualType []) then {
        if !(_location isEqualTo [[0,0,0], 0, 0]) then {
        _location params["_posATL","_size1","_size2"];
        [format["_addMissionNoSpawnZone: _posATL  %1 | _size1 %2 | _size2 %3", _posATL, _size1, _size2]] call GMSCore_fnc_log; 
        private _isClass = isClass (configFile >> "CfgLocationTypes" >>"GMSCore_MissionNoSpawnZone"); 
       [format["_addMissionNoSpawnZone: _isClass = %1", _isClass]] call GMSCore_fnc_log;
        private _blLoc = createLocation["GMSCore_MissionNoSpawnZone",_posATL,_size1,_size2];
        _blLoc setText _name; 
        GMSCore_noAgroAreas pushBack _blLoc;
    };
} else {
    if (typeName _location isEqualTo "LOCATION") then {
        GMSCore_noAgroAreas pushBack _blLoc;
    };
};
*/
