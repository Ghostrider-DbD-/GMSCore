/*
	GMSAI_fnc_isBlacklisted

    Purpose: Check if a position/player is in one of the blacklisted locations/positions.
    
    Parameters: _position/object, _list of locations/markers/positions to check

    Returns: _true if the position tested is in one of the blacklisted areas

    Copyright 2020 Ghostrider-GRG-

*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_position",[0,0,0]],["_list",[]]];
//[format["GMS_fnc_isBlacklisted called with position = %1 | _list = %2",_position, _list]] call GMS_fnc_log;
private _return = false;
if (_position isEqualTo [0,0,0]) exitWith {false}; // handle the case where no pparameters were passed
if (_list isEqualTo []) exitWith {false};  // handle the case where an empty list was passed
{
    //[format["GMS_fnc_isBlacklisted: evaluating for _pos %1 | _x %2",_position,_x]] call GMS_fnc_log;
    if (_position inArea _x) exitWith {_return = true};
} forEach _list;

_return