/*
	GMS_fnc_getWaypointStuckValue 

	Purpose: set "_stuckVal" for the group. 

	Parameters: 
		_group, the group to be handled 
	
	Returns: stuck value 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: 	
	If the group monitor determines tha ta group is 'stuck' meaning has not rotated waypoints within some proscribed period, the group will be disengaged and returned to the center of the patrol area.
	TODO: see why the default is false.
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
_group getVariable["GMS_antiStuck","_stuckVal"];