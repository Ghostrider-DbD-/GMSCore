/*
	GMS_fnc_alertGroup

	Purpose: increases all units of a group of a target.

	Parameters:
		_group 
		_target
		_alertValue

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/

params["_unit","_target",["_alertValue",0.2]];
{
	_x reveal[_target,_alertValue];
}forEach (units (group _unit));