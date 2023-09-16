/*
	GMSCore_fnc_isStuck 
	
	Purpose: test if a group is 'stuck' meaning it has not completed its current waypoitn in a reasonable time. 
		Such groups may have hit a road block or chased players out of the patrol area 

	Parameters: _group, the group about which we want to know things. 

	Returns: true/false  (if true then the group is stuck)

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_group"];
private _timeStamp =_group getVariable["GMS_timeStamp",diag_tickTime];
private _interval = _group getVariable[GMS_waypointTimeoutInterval,300];
private _timeoutAt = _timeStamp + _interval;
private _timedOut = if (diag_tickTime > _timeoutAt) then {true} else {false};
private _target = [_group] call GMSCore_fnc_getHunt;
private _stuck = if ((isNull _target) && {_timedOut}) then {true} else {false};
_group setVariable[GMS_stuckValue,_stuck];
//[format["GMSCore_fnc_isStuck: _stuck %6 | _timeStamp %1 | _interval %2 | _timoutAt %3 | _timedOut %4 | _target %5",_timeStamp,_interval,_timeoutAt,_timedOut,_target,_stuck]] call GMSCore_fnc_log;
_stuck