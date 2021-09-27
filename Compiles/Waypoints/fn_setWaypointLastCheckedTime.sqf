/*
	GMS_fnc_setWaypointLastCheckedTime 

	Purpose: updates the timestamp on a group 

	Parameters: 
		_group, the group to handle 
		_time, the updated time 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group",["_time",diag_tickTime]];
_group setVariable["GMS_lastChecked",_time];
true