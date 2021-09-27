/*
	GMS_fnc_getWaypointPatrolAreaMarker 

	Purpose: a simple get function to return the name of the marker use to define the groups patrol area 

	Parameters: _group, the group about which the info is needed 

	Returns: the marker 

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
private _m = _group getVariable["GMS_patroArealMarker",""];
_m