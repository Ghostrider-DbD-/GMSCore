/*
    GMSCore_fnc_getVehicleType 

*/


params[["_veh",objNull]];

private "_typeOf";

switch true do {
    case (_veh isKindOf "AIR"): {
        if (_veh isKindOf "Helicopter") then {
            _typeOf = "Helicopter";
        } else {
            _typeOf = "Plane";
        };
    };
    case (_veh  isKindOf "LANDVEHICLE"): {
        _typeOf = "Land";
    };  
    case (_veh  isKindOf "SHIP"): {
        if ([_veh] call GMSCore_fnc_isSubmersible) then {
            _typeOf = "Sub";
        } else {
            _typeOf = "Ship";
        };
   }:

    default {
        _typeOf = "Man";
    };

};
//[format["_getVehicleType: _veh %3 | _veh  %1 | returning _typOf %2", _veh , _typeOf, typeOf _veh]] call GMSCore_fnc_log;
_typeOf 