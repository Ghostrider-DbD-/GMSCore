/*
	GMSCore_fnc_groupRemoveAllGear

	Purpose: remove all gear from all units in a group. 

	Parameters: 
		_group: the group to remove gear from 

	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group"];
{
	[_x] call GMSCore_fnc_unitRemoveAllGear;
}forEach (units _group);