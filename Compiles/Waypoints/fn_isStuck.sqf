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
private _timeStamp =_group getVariable[GMSCore_timeStamp,diag_tickTime];
private _startPos = _group getVariable[GMS_waypointStartPos, getPosATL (leader _group)];
private _distanceMoved = _startPos distance (getPosATL (leader _group));
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,60];
private _timeoutAt = _group getVariable[GMS_waypointTimeoutAt, diag_tickTime + _timeOut];
private _wp = [_group, 0];
private _currWPpos = waypointPosition _wp;
private _target = [_group] call GMSCore_fnc_getHunt;

/*
	Logic here is:

*/
private "_stuck";
try {
	if ((diag_tickTime - _timeStamp) > _timeoutAt) then {
		// The group has not arrived at the waypoint - so send it to a new one 
		throw 1;
	} else {
		if (_distanceMoved < 3) throw 1;
		if (speed (leader _group) < 1) throw 1; 
	};
	throw 2; 
}

catch {
	switch (_exception) do {
		case 1: {_stuck = true};
		case 2: {_stuck = false};
	};
}; 
_stuck 