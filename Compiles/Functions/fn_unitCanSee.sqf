/*
	GMS_fnc_unitCanSee 
	Purpose: test if a unit can see an object or player meaning there are no interfering objects.

	Parameters: 
		_unit, the unit we want to know if the _object is visible to
		_object, the object we would like to know if _unit can see

	Returns: true/false (true if the _unit canSee the _object)

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_unit","_object"];
private _veh = vehicle _unit;
private _int = lineIntersects[eyePos _unit, _object, aimPos _veh];
private _canSee = if (_int) then {false} else {true};
_canSee

