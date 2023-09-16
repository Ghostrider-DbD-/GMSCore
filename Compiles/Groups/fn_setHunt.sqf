/*
	GMSCore_fnc_setHunt

	Purpose: store hunt parameters for a group

	Parameters: 
		_group: the AI group that will hunt
		_player: the player to hunt

	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull],["_player",objNull]];
_group setVariable[GMS_target,_player];