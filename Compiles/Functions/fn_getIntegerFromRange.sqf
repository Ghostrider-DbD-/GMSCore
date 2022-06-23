/*
	GMSCore_fnc_getIntegerFromRange

	Purpose: to find a random integer within a specified removeMagazineGlobal
	Parameters: 
		_data,
			Allowed formats for _data are: 
				1. the range to be used in the format [_min,_max]; will return an integer within the range of _min to _max
					if _min == _max, the rounded off value of _min is returned.
				2. [_min]; will return the rounded off value for _min
				3. _min will return the rounded off value of _min; 
	Return: an integer the value of which was determined as above.

	copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_data"];
round([_data] call GMSCore_fnc_getNumberFromRange);
