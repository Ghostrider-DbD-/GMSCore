/*
	GMSCore_fnc_initializeWaypointRoadsPatrol

	Purpose: setup a group to engage nearby enemies or, otherwise, to follow roads.

	Parameters:
		"_leader"		

	Returns: noting

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params[
		"_leader",
		["_blackListed",[]],  // areas to avoid within the patrol region
		["_timeout",300],
		["_deleteOnNullGroup",true]
];

[format["InitializeWaypointRoadsPatrol: _leader %1 | group %2 | vehicle %3",_leader,group _leader, typeOf (vehicle _leader)]] call GMSCore_fnc_log;
private _group = group _leader;
private _vehicle = vehicle _leader;
//GMSCore_monitoredGroups pushBackUnique _group;
_group setVariable[GMS_waypointTimeoutInterval,_timeout];  // time in seconds before the waypoint is considered failed and the group will be redirected
_group setVariable[GMS_waypointStartPos, getPosATL _vehicle];
_group setVariable[GMS_waypointTimeoutAt, diag_tickTime + timeOut];
_group setVariable["GMS_blackListedAreas",_blacklisted];
private _wp = [_group,0];
_wp setWPpos (getPosATL _leader);
_wp setWaypointStatements ["true","this call GMSCore_fnc_nextWaypointRoadPatrols;"]; 
GMSCore_monitoredRoadPatrols pushBack [_group,_vehicle,_deleteOnNullGroup];
diag_log format["_initializeWaypointRoadsPatrol (32): getWPpos _wp %1 | _group %2 | count GMSCore_monitoredRoadPatrols %3 | GMSCore_monitoredRoadPatrols %4",getWPpos _wp, _group, count GMSCore_monitoredRoadPatrols, GMSCore_monitoredRoadPatrols];
_leader call GMSCore_fnc_nextWaypointRoadPatrols;