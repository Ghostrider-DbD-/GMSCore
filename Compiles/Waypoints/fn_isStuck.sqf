/*
	GMSCore_fnc_isStuck 
	
	Purpose: test if a group is 'stuck' meaning it has not completed its current waypoitn in a reasonable time. 
		Such groups may have hit a road block or chased players out of the patrol area 

	Parameters: _group, the group about which we want to know things. 

	Returns: true/false  (if true then the group is stuck)

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group"];
private _timeStamp =_group getVariable["GMS_timeStamp",diag_tickTime];
private _startPos = _group getVariable[GMS_waypointStartPos, getPosATL (leader _group)];
private _distanceMoved = _startPos distance (getPosATL (leader _group));
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,60];
private _timeoutAt = _group getVariable[GMS_waypointTimeoutAt, diag_tickTime + _timeOut];
private _wp = [_group, 0];
private _currWPpos = waypointPosition _wp;
private _target = [_group] call GMSCore_fnc_getHunt;

/*
	Logic here is:
	if the group is not chasing a target 
	and
	the distance to the position of the current waypoint > 10 meters 
	and the time elapsed since the last update is > _timeout 
	then _stuck = true;
*/
private _stuck = false;
if (isNull _target) then 
{
	if ((diag_tickTime - _timeStamp > _timeoutAt) && ((((getPosATL (leader _group)) distance _currWPpos) > 2)) || _distanceMoved < 3) then {_stuck = true};
};

_group setVariable[GMS_stuckValue,_stuck];
//[format["\x\addons\GMSCore_fnc_isStuck: _stuck %6 | _timeStamp %1 | _timeout %2 | _timoutAt %3 | _timedOut %4 | _target %5",_timeStamp,_timeout,_timeoutAt,diag_tickTime > _timeoutAt, _target,_stuck]] call GMSCore_fnc_log;
_stuck