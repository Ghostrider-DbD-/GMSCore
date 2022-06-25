// 
/*
	GMSCore_fnc_deleteObjectsMethod

	Purpose: Delete objects in the deletion cue based on type. 
	
	Notes: this function was written so that it should be able to handle any object including old mission objects, crates, mission vehicles, mission AI bodies, and so forth.
		   This function was set up so that the reference can either be an object itself or an array of objects, such as a list of mission objects due to be deleted.

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_objectParameters"];
//[format["GMSCore_fnc_deleteObjectsMethod: typeName _objectParameters = %1 | _objectParameters = %2",typeName _objectParameters,_objectParameters]] call GMSCore_fnc_log;
if (_objectParameters isEqualType []) then 
{
	{[_x] call GMSCore_fnc_deleteObjectsMethod} forEach _objectParameters;  //  One itteration of recursion should be ok (fingers crossed).
} else {
	if (typeName _objectParameters isEqualTo "OBJECT") then 
	{
		//[format["GMSCore_fnc_deleteObjectsMethod: deleting object %1 | typeOf %2 | at %3",_objectParameters,typeOf _objectParameters,diag_tickTime]] call GMSCore_fnc_log;
		deleteVehicle _objectParameters;
	} else {
		if (typeName _objectParameters isEqualTo "GROUP") then 
		{
			//[format["GMSCore_fnc_deleteObjectsMethod: deleting group %1 at %2",_objectParameters,diag_tickTime]] call GMSCore_fnc_log;
			[_objectParameters] call GMSCore_fnc_despawnInfantryGroup;
		} else {
			if (_objectParameters isEqualType "") then 
			{
				//[format["GMSCore_fnc_deleteObjectsMethod: deleting marker %1 at %2",_objectParameters,diag_tickTime]] call GMSCore_fnc_log;
				deleteMarker _objectParameters;
			};
		};
	};
};
true