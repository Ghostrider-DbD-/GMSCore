/*
	GMSCore_fnc_setGroupBlacklist 

	Purpose: Set the list of blacklisted areas 

	Parameters:
		_group 
		_list

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_group",grpNull],["_list",[]]];
if (isNull _group) exitWith {["null group passed to GMSCore_fnc_setGroupBlacklist"] call GMSCore_fnc_log};
if (_list isEqualTo []) then {[format["empty blacklist passed to GMSCore_fnc_setGroupBlacklist for group %1",_group]] call GMSCore_fnc_log};
_group setVariable["GMS_blacklist",_list];