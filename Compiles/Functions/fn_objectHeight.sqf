/*

	GMSCore_fnc_objecHeight
	Purpose: returns height above terrain or -1 if no object passed

	Parametsrs:
		_obj: the object

	Returns: returns a player or objNull if none found nearby

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params[["_obj",objNull]];
if !(_obj isEqualType []) exitWith {-1};
private _alt = (getPosATL _obj) select 2;
_alt 