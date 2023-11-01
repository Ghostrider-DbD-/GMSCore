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

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_pos",[0,0,0]],["_range",300]];
private _nearestPlayers = allplayers select {_x distance _pos < _range};
_nearestPlayers

