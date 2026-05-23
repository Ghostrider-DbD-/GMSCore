

params[["_location", [[0,0,0], 0, 0]],["_name",""], ["_class", ""]];

private["_posATL", "_size1", "_size2"];
try {
    if !(isClass (configFile >> "CfgLocationTypes" >> _class)) throw 4;
    if (typeName _location isEqualTo "LOCATION") throw 1;
    if ((_location isEqualType []) && !(_location isEqualTo [[0,0,00, 0, 0]])) throw 2;
    throw 3;
} catch {
    switch (_exception) do {
        case 1: {
            _posATL = position _location; 
            private _size = size _location;
            _size1 = _size select 0;
            _size2 = _size select 1;
            private _blLoc = createLocation[_class,_posATL,_size1,_size2];
            _blLoc setText _name;
            //[format["_createLocation: created new location of type %1 at position %2",_class, _posATL]] call GMSCore_fnc_log;
        };
        case 2: {
            _location params["_posATL","_size1","_size2"];
            private _blLoc = createLocation[_class,_posATL,_size1,_size2];
            _blLoc setText _name; 
            //[format["_createLocation: created new location of type %1 at position %2",_class, _posATL]] call GMSCore_fnc_log;
        };
        case 3: {
            
        };
        case 4: {

        };
    };
};