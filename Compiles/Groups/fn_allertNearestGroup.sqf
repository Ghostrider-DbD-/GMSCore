/*
	allertNearestGroup

	Purpose: increases all units ofthe group nearest to a target other than the targets group.

	Parameters:
		_group 
		_target
		_alertValue

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-	
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params ["_unit","_killer","_alertDistance","_alertDefaultValue"]; 			
private _ng = group(nearestObject[getPosATL _unit,GMSCore_unitType]);
if ((side _ng) isEqualTo GMSAI_side) then 
{
	_x reveal["_target",_alertValue];
} forEach (units _ng);
