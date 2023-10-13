/*
	GMSCore_fnc_setGroupMoney

	Purpose: set the mony for units in a group.

	Parameters:
		_group, the group to be processed 
		_skillLevel: skill level of the group 
		_money: an array of money to add based on skill leaveVehicle

	Return: none

	Copyright 2020 Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_group","_skillLevel","_money"];
diag_log format["GMSCore_fnc_setGroupMoney(18): _group %1 | _skillLevel %2 | _money %3",_group,_skillLevel,_money];
{
	[_x, _skillLevel, _money] call GMSCore_fnc_setMoney; 
} forEach (units _group);

