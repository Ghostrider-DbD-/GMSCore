/*
	GMS_fnc_initializeWaypointsAreaPatrol 
	
	Purpose: Can be used to configure a patrol area for any kind of group (infantry, land, air sea)

	Parameters:
		_group, the group to configure 
		_blackListed, areas the AI should avoid 
		_patrolAreaMarker, a marker defining the patrol area 
		_timeout, // The time that must elapse before the antistuck function takes over.

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 	

	Notes:
		By completing waypoints set within the area proscribed by the marker, the group will move about within the area circumscribed by the parameters below moving from one randome location to the next.
		If an enemy is identified, it will move toward that enemy and try to engage.
		If the group monitor determines tha ta group is 'stuck' meaning has not rotated waypoints within some proscribed period, the group will be disengaged and returned to the center of the patrol area.		
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params[
	["_group",grpNull],  // group for which to configure / initialize waypoints
	["_blackListed",[]],  // areas to avoid within the patrol region
	["_patrolAreaMarker",""],  // a marker defining the patrol area center, size and shape
	["_timeout",300],
	["_garrisonChance",0],  // chance that an infantry group will garison an building of type house - ignored for vehicles.
	["_type",GMS_infrantryPatrol],  // "infantry","vehicle","air","submersible"
	["_deletemarker",false]
];  

GMSCore_monitoredGroups pushBackUnique _group;
_group setVariable[GMS_waypointTimeoutInterval,_timeout];  // time in seconds before the waypoint is considered failed and the group will be redirected
_group setVariable["GMS_patroArealMarker",_patrolAreaMarker];
_group setVariable["GMS_blackListedAreas",_blacklisted];
_group setVariable["GMS_garisonChance",_garrisonChance];
_group setVariable["GMS_areaPatrolType",_type];
_group setVariable["GMS_deleteMarker",_deleteMarker];

private _wp = [_group,0];
_wp setWaypointStatements ["true","this call GMS_fnc_nextWaypointAreaPatrol;"];	
[_group,_patrolAreaMarker,_deleteMarker] call GMS_fnc_addMonitoredAreaPatrol;  //  Add the group to the list of groups that are checked for 'stuck' conditions and for cleanup of markers when the group is deleted
[format["GMS_fnc_initializeWaypointsAreaPatrol: calling GMS_fnc_nextWaypointAreaPatrol for _group %1 | _patrolAreaMarker %2 | _type %3",_group,_patrolAreaMarker,_type]] call GMS_fnc_log;
[_group] call GMS_fnc_setGroupBehaviors;
if !(_type isEqualTo GMS_infrantryPatrol) then 
{
	// be sure group leader is the driver so the vehicle continues to move about until he is dead 
	_veh = vehicle((units _group) select 0);
	_group selectLeader (driver(_veh));
} else {
	_group selectLeader ((units _group) select 0);
};
(leader _group) call GMS_fnc_nextWaypointAreaPatrol;

[format["GMS_fnc_initializeWaypointsAreaPatrol Completed for group %1",_group]] call GMS_fnc_log;