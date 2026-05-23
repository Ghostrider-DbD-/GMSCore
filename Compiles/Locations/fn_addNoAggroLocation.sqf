/*
    GMSCore_fnc_addNoAgroLocation 

    Parameters
        _location 
            syntax 1: _location is a text value that specifies and exisiting location
                      _name is ignored 
            syntax 2: _location is an array of [
                position relative to teraint (getposATL) 
                size 1
                size 2
            ];
                      _name is an optional name 

    Returns: None 
*/
params[["_location", [[0,0,0], 0, 0]],["_name",""]];
[_location, _name, "GMSCore_NoAgroArea"] call GMSCore_fnc_createLocation;

/*
[format["_addNoAgroLocation : _location %1  |  _name %2",_location,_name]] call GMSCore_fnc_log;
private _isLoc = if (typeName _location isEqualTo "LOCATION") then {true} else {false};
[format["_addNoAgroLocation : _location %1 | _isLoc = %2", _location, _isLoc]] call GMSCore_fnc_log;

if (_location isEqualType []) then {
        if !(_location isEqualTo [[0,0,0], 0, 0]) then {
        _location params["_posATL","_size1","_size2"];
        [format["_addNoAggroLocation: _posATL  %1 | _size1 %2 | _size2 %3", _posATL, _size1, _size2]] call GMSCore_fnc_log; 
        private _isClass = isClass (configFile >> "CfgLocationTypes" >>"GMSCore_NoAgroArea"); 
       //[format["_addNoAggroLocation: _isClass = %1", _isClass]] call GMSCore_fnc_log;
        private _blLoc = createLocation["GMSCore_NoAgroArea",_posATL,_size1,_size2];
        _blLoc setText _name; 
        GMSCore_noAgroAreas pushBack _blLoc;
    };
} else {
    if (typeName _location isEqualTo "LOCATION") then {
        GMSCore_noAgroAreas pushBack _blLoc;
    };
};

private["_posATL", "_size1", "_size2"];
try {
    if (typeName _location isEqualTo "LOCATION") throw 1;
    if (_location isEqualType []) && !(_location isEqualTo [[0,0,00, 0, 0]]) throw 2;
    throw 3;
} catch {
    switch (_exception) do {
        case 1: {
            _posATL = position _location; 
            private _size = size _location;
            _size1 = _size select 0;
            _size2 = _size select 1;
            private _blLoc = createLocation["GMSCore_BlacklistedArea",_posATL,_size1,_size2];
            _blLoc setText _name;
        };
        case 2: {
            _location params["_posATL","_size1","_size2"];
            private _blLoc = createLocation["GMSCore_BlacklistedArea",_posATL,_size1,_size2];
            _blLoc setText _name; 
        };
        case 3: {
            
        };
    };
};
*/