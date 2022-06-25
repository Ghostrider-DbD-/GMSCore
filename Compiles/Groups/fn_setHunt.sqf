/*
	GMSCore_fnc_setHunt

	Purpose: store hunt parameters for a group

	Parameters: 
		_GMSGroup: the AI group that will hunt

	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_group",["_player",objNull]];
_group setVariable[GMS_target,_player];