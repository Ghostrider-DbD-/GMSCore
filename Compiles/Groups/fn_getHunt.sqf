/*
	GMSCore_fnc_getHunt

	Purpose: store hunt parameters for a group

	Parameters: 
		_GMSGroup: the AI group that will hunt

	Returns: None 
	
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];
// if no target is assigned or the target is 'dead' return objNull
private _hunted = _group getVariable[GMS_target,objNull];
if !(alive _hunted) then 
{
	_hunted = objNull;
	[_group, _hunted] call GMSCore_fnc_setHunt;
};
_hunted
