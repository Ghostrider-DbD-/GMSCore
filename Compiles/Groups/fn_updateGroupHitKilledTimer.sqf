/*
	GMS_fnc_updateGroupHitKilledTimer

	Purpose: spawn a group of N infantry units as a specified position.

	Parameters
		_GMSGroup - the group to handle

	Return: the group that was spawned.

	Copyright 2020 Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_group"];
private _lastUpdate = _group getVariable["lastHitKill",1000];
private _return = true;
if (diag_tickTime  < _processHitKill) then 
{
	_return = false;
} else {
	_group setVariable ["lastHitKill",diag_tickTime + GMS_hitKillEventUpdateInterval];
};
_return