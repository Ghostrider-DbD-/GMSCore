/*
	GMSCore_fnc_inAllowedLocation

    Purpose: Check if a position/player is in one of the blacklisted, noAgro or safeZone locations/positions.
    
    Parameters: _position/object,

    Returns: _true if the position tested is not in one of the blacklisted areas

    Copyright 2020 Ghostrider-GRG-

*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_position",[0,0,0]], ["_radius",150]];

//[format["_inAllowLocation called with position = %1 | _radius = %2",_position, _radius]] call GMSCore_fnc_log;

if (!(_position isEqualType []) && _position isEqualTo [0,0,0]) exitWith {false}; // handle the case where no pparameters were passed
if (_radius < 0) exitWith {[format["GMSCore_fnc_inAllowedLocation: _radius must be a positive integer"]] call GMSCore_fnc_log}; 

private _isAllowed = true; 

_blackList = nearestLocations[_position, [WAYPOINT_DISALLOWED_AREAS], _radius];
{
    if (_position inArea _x) exitWith {_isAllowed = false};
} forEach _blackList;

_isAllowed