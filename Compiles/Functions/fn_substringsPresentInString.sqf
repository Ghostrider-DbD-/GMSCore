/*
	GMS_fnc_substringPresentInString

	Purpose: determine how many of the substringe listed in an array are present in a string.

	Parameters
		_string: a string to be searched.
		_substring: an array of strings to search for

	Returns
		0 if none of the substrings are found
		1 - N repreenting the number of substrings found, if one or more is found.

	Copyright 2020 by Ghostrider-GRG-
		
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_string","_substrings"];  // returns the number of substrings present in a string.
private _count = 0;
{
	if ([_x,_string,false] call BIS_fnc_inString) then {_count = _count + 1;}
}forEach _substrings;
_count