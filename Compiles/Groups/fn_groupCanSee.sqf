/*
	GMS_fnc_groupCanSee 

	Purpose: test if one or more units of a group can see an object 

	Parameters:
		_group, the group we want to know about 
		_obj, the object we want to know if the group can synchronizeWaypoint trigger

	Returns: true/false, true if a group member has a clear line of sight to the object. 

	Copyright 2020 Ghostrider-GRG-
*/

params["_group","_obj"];
private _veh - vehicle (leader _group);
private _canSee = false;
{
	if !(lineIntersects[eyePos _x, _obj, aimPos _veh]) exitWith {_canSee = true};
} forEach (units _group);
_canSee