/*
	GMSCore_fnc_protectObject

	Purpose: removes null groups or objects from an array

	Parametsrs:
		_array: the array to scan for null objects etc.

	Returns: None

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_array"];
for "_i" from 1 to (count _array) do 
{
	if (_i > count _array) exitWith {};
	private _el = _array deleteAt 0;
	if !(isNull _el) then {_array pushBack _el};
};
_array