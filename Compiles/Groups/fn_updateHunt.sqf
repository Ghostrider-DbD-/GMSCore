/*
	GMSCore_fnc_updateHunt

	Purpose: 
		Decides whether to end a hunt based on certain parameters. 

	Parameters
		_group - the group to look at 
		_target - the groups target

	Return:
		None

	Copyright 2020 Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group","_target"];

// These could be set by other functions; provide a default just in case 
private _maxDistanceTarget = _group getVariable[GMS_maxDistanceTarget,200];	
private _huntTimer = [_group] call GMSCore_fnc_getHuntDurationTimer;

// Stop hunt if certain criteria are met 
if ((leader _group knowsAbout _target) < 0.5) then {_target == objNull};
if ( (leader _group distance _target) > _maxDistanceTarget) then {_target = objNull};
if (diag_tickTime > _huntTimer) then {_target == objNull};

// Set the variable that tracks the groups target to the updated value
[_group,_target] call GMSCore_fnc_setHunt;