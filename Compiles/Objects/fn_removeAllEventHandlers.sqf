/*
	GMS_fnc_removeAllEventHandlers 

	Purpose: generic function to remove all types of EH from an object. 

	Parameters: 
		_obj: the object from which to remove EH 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: May not be used 
	TODO: check if this is needed
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[
	"_object",
	["_eh",["Reloaded","Fired","FiredNear","GetIn","GetOUt","HandleDamage"]]
];
//diag_log format["_removeEventHandlers: _object = %1 | _eh = %2",_object,_eh];
{
	_object removeAllEventHandlers _x;
} forEach _eh;