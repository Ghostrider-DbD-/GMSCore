/*
	GMS_fnc_groupRemoveAllGear

	Purpose: remove all gear from all units in a group. 

	Parameters: 
		_group: the group to remove gear from 

	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
{
	[_x] call GMS_fnc_unitRemoveAllGear;
}forEach (units _group);