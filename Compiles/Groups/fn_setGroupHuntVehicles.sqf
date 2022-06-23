/*
	GMSCore_fnc_setGroupHuntVehicles 

	Purpose: set the huntVehicle variable for a group 
	Parameters
		_group: the group to be processed
		_hunt: true / false 
		 
	Return: none

	Copyright 2020 Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_group","_hunt"];
_group setVariable [GMS_huntVehicles, _hunt];