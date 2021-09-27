/*
	GMS_fnc_getWaypointLastCheckedTime 

	Purpose: a simple get to determine the last time the groups waypoint was updated 
		If no timestamp is set then it is set to diag_tickTime (pehaps will cause minor delays in the first unstuck functions but there you are)

	Parameters: _group, the group about which the info is desired. 

	Returns: _time, the last time the waypoint was updated

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
private _time = _group getVariable["GMS_lastChecked",0];
if (_time isEqualTo 0) then 
{
	[_group] call GMS_fnc_setWaypointLastCheckedTime;
	_time = _group getVariable["GMS_lastChecked",0];
};
_time