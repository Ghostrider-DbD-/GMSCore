/*
	GMSCore_fnc_setHunt

	Purpose: store hunt parameters for a group

	Parameters: 
		_group: the AI group that will hunt
		_hunt: true / false 
	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull],["_hunt", false]];
_group setVariable["isHunting", _hunt];