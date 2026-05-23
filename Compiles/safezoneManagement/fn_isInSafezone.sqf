/*
    GMSCore_fnc_isInSafezone 

    Purpose: test if a position is within any safezone in GMSCore_safeZoneList 

    Parameters: _pos - the position to be tested 

    Returns: true if the positin is in a safezone, false if not
*/

params["_pos"];
private _return = false;
{
    _x params["_safezone"];
    // _safezone must be a marker, trigger, location or area described by an array of a specified format. Marker is the easiest system.
    if (_pos inArea _safezone) exitWith {_return = true};
} forEach GMSCore_safeZoneList;

_return 