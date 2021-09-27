/*
	GMS_fnc_restrictPlayerAccess 

	Purpose: Configure a vehicle to deny players access
	
	Parameters: _veh, the vehicle to be configured 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-	
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_veh"];
_veh lock 2;
_veh enableRopeAttach false;
_veh enableCoPilot false;
