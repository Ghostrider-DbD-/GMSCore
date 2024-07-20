/*
	GMSCore_fnc_updateGroupHitKilledTimer

	Purpose: spawn a group of N infantry units as a specified position.

	Parameters
		_GMSGr_objoup - the object or group to handle

	Return: the group that was spawned.

	Copyright 2020 Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_obj"];
private _lastUpdate = _obj getVariable["lastHitKill",1000];
private _return = true;
if (diag_tickTime  < _processHitKill) then 
{
	_return = false;
} else {
	_obj setVariable ["lastHitKill",diag_tickTime + GMSCore_hitKillEventUpdateInterval];
};
_return