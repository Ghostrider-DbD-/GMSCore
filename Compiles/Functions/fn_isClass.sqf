/*
	GMS_fnc_isClass

	Purpose: determine if a string is a valid className
	Parameters: 
		_item, a string to be interrogated.

	Returns: 
		true if the string is a valid classname.

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_item"];
private _result = false;
if ((typeName _item) isEqualTo "STRING") then
{
  	_result = if ([_item] call GMS_fnc_getCfgType isEqualTo "") then {false} else {true};
};
_result