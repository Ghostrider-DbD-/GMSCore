/*
	GMS_fnc_setWaypointPatrolAreaMarker 

	Purpose: Set a variable on the group with the name of the marker defining that groups patrol area 

	Parameters: 
		_group, the group to handle 
		_patrolAreaMarker, the marker to use 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 	

	Notes: this can be used for AI patroling an area of any sort, whether they by static or dynamic mission AI, roaming AI spawned by location or near players, etc.
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_group",["_patrolAreaMarker",""]];
_group setVariable["GMS_patroArealMarker","_patrolAreaMarker"];
