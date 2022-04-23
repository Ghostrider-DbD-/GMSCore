/*
	GMS_fnc_getGroupBlacklist 

	Purpose: Set the list of blacklisted areas 

	Parameters:
		_group 

	Returns: _list 

	Copyright 2020 by Ghostrider-GRG-	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_group",grpNull]];
if (isNull _group) exitWith 
{
	["GMS_fnc_getGroupBlacklist called with null group"] call GMS_fnc_log;
	[]
};
_group setVariable["GMS_blacklist",[]];
