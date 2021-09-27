/*
	GMS_fnc_setHuntDurationTimer

	Purpose: update the hunting timers

	Parameters: 
		_GMSGroup: the AI group that will hunt

	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group",["_maxTime",GMS_maxHuntDuration]];
_group setVariable[GMS_huntOverAt,diag_tickTime + _maxTime];

