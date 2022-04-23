/*
	GMS_fnc_destroyVehicleAndCrew 

	Parameters: _vehicle with crew to be destroyed

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: 	None	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_group"];

{
	if (!((vehicle _x) isEqualTo _x) && (local (vehicle _x))) then (deleteVehicle (vehicle _x));
	deleteVehicle _x;
} forEach (units _group);
