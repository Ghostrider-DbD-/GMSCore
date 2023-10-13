/*
	GMSCore_fnc_initializeWaypointRoadsPatrol

	Purpose: setup a group to engage nearby enemies or, otherwise, to follow roads.

	Parameters:
		"_leader"		

	Returns: noting

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params[
		"_leader",
		["_blackListed",[]],  // areas to avoid within the patrol region
		["_timeout",300],
		["_deleteOnNullGroup",true]
];
//[format["InitializeWaypointRoadsPatrol: _leader %1 | group %2 | vehicle %3",_leader,group _leader, typeOf (vehicle _leader)]] call GMSCore_fnc_log;
private _group = group _leader;
private _vehicle = vehicle _leader;
//GMSCore_monitoredGroups pushBackUnique _group;
_group setVariable[GMS_waypointTimeoutInterval,_timeout];  // time in seconds before the waypoint is considered failed and the group will be redirected
_group setVariable["GMS_blackListedAreas",_blacklisted];
private _wp = [_group,0];
_wp setWaypointStatements ["true","this call GMSCore_fnc_nextWaypointRoadPatrols;"]; 
GMSCore_monitoredRoadPatrols pushBack [_group,_vehicle,_deleteOnNullGroup];
_leader call GMSCore_fnc_nextWaypointRoadPatrols;