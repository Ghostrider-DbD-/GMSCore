/*
	GMS_fnc_getDimensions

	Purpose: returns width, length and height based on boundingBoxReal
	
	parameters: 
		_object: the object for which the dimensions are desired 

	Returns:
		an array containing  [_maxWidth,_maxLength,_maxHeight]

	CREDITS: https://community.bistudio.com/wiki/boundingBoxReal
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_object"];
_bbr = boundingBoxReal vehicle player;
_p1 = _bbr select 0;
_p2 = _bbr select 1;
_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
_maxLength = abs ((_p2 select 1) - (_p1 select 1));
_maxHeight = abs ((_p2 select 2) - (_p1 select 2));
_return = [_maxWidth,_maxLength,_maxHeight];
_return