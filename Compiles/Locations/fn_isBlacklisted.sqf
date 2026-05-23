/*
	GMSCore_fnc_isBlacklisted

    Purpose: Check if a position/player is in one of the blacklisted locations/positions.
    
    Parameters: _position/object, _list of locations/markers/positions to check

    Returns: _true if the position tested is in one of the blacklisted areas

    Copyright 2020 Ghostrider-GRG-

*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_position",[0,0,0]],["_list",[]],["_calledBy","notDefined"]];
//[format["_isBlacklisted: _position %1 | _list %2",_position, _list, _calledBy]] call GMSCore_fnc_log; 
private _return = false;
{
    if (_position inArea _x) exitWith {_return = true};
} forEach _list;

_return