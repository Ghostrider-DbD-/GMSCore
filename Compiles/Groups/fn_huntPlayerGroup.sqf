/*
	GMSCore_fnc_huntPlayerGroup

	Purpose: force aan AI group to hunt a player group

	Parameters: 
		_GMSGroup: the AI group that will hunt
		_playerGroup: the player group to be hunted
	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group","_target"];
private _timer = [_group] call GMSCore_fnc_getHuntDurationTimer;
if !(diag_tickTime > _timer) exitWith {[format["\x\addons\GMSCore_fnc_huntPlayerGroup: Hunt Timer still running for Group %1 | _timer = %2 | curr time = %3",_group,_timer,diag_tickTime] call GMSCore_fnc_log]};
[_group,_target] call GMSCore_fnc_setHunt; 
[_group] call GMSCore_fnc_setHuntDurationTimer;

_marker = _group getVariable["GMS_patroArealMarker",""];

if (_marker isEqualTo GMS_patrolRoads) then {
	(leader _group) call GMSCore_fnc_nextWapointRoadPatrols;
} else {
	(leader _group) call GMSCore_fnc_nextWaypointAreaPatrol;
};