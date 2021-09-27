/*
	GMS_fnc_setupGroupGear
	Purpose: to add gear to units of a group.
	Parameters
		_group: the group to be processed
		_gear: an array of gear and probabiliteis it will be added.
		_launchers per group: number of units to have launchers
		_useNVG: whether to use NVG if it is darl
	Return: none

	Copyright 2020 Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_group","_despawnTimer"];
_group setVariable["GMS_deleteDeadTimer",_despawnTimer];
