/*
	GMS_fnc_huntPlayerGroup

	Purpose: force aan AI group to hunt a player group

	Parameters: 
		_GMSGroup: the AI group that will hunt
		_playerGroup: the player group to be hunted
	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group","_target"];
private _timer = [_group] call GMS_fnc_getHuntDurationTimer;
if !(diag_tickTime > _timer) exitWith {[format["GMS_fnc_huntPlayerGroup: Hunt Timer still running for Group %1 | _timer = %2 | curr time = %3",_group,_timer,diag_tickTime] call GMS_fnc_log]};
[_group,_target] call GMS_fnc_setHunt; 
[_group] call GMS_fnc_setHuntDurationTimer;
(leader _group) call GMS_fnc_nextWaypointAreaPatrol;