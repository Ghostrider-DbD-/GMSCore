// 
/*
	GMS_fnc_deleteObjectMethod

	Purpose: Delete objects in the deletion cue based on type. 
	
	Notes: this function was written so that it should be able to handle any object including old mission objects, crates, mission vehicles, mission AI bodies, and so forth.
		   This function was set up so that the reference can either be an object itself or an array of objects, such as a list of mission objects due to be deleted.

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_objectParameters"];

if (typeName _objectParameters isEqualTo "ARRAY") then 
{
	{[_x] call GMS_fnc_deleteObjectMethod} forEach _objectParameters;  //  One itteration of recursion should be ok (fingers crossed).
} else {
	if (typeName _objectParameters isEqualTo "OBJECT") then 
	{
		deleteVehicle _objectParameters;
	} else {
		if (typeName _objectParameters isEqualTo "GROUP") then 
		{
			[_objectParameters] call GMS_fnc_despawnInfantryGroup;
		};
	};
};
true