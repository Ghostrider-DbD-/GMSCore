/*
    GMA_fnc_nearestPlayers

    Purpose: Identify nearest players

    Parameters: 
		_pos: where to search 
		_range: search radius 

    Return: 
		array of players
		[] if none found

    Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params[["_pos",[0,0,0]],["_range",300]];
if (_pos isEqualTo [0,0,0]) exitWith {["GMS_fnc_nearestPlayers: no location specified or location == [0,0,0]","warning"] call GMS_fnc_log};
private _nearestPlayers = allplayers select {_x distance _pos < _range};
diag_log format["GMS_fnc_nearestPlayers: _nearestPlayers = %1",_nearestPlayers];
_nearestPlayers

