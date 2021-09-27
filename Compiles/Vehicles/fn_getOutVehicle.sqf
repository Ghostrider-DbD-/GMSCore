/*
	GMS_fnc_getOutVehicle 

	Purpose: fired locally when the "GetOut" EH fires for the object/vehicle. 
		This will allow us to track empty vehicles in real time on clients or HC. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#GetOut

	Returns: None

	Copyright 2020 by Ghostrider-GRG- 

	Notes: can be assigned remotely but only fires on the client owning teh object.	
	TODO: address locality for this function.
*/
#include "\GMSCore\Init\GMS_defines.hpp"
#define veh _this select 0
// TODO: redirect to the correct function
if ((isServer) || local (veh)) then {[veh] call blck_fnc_checkForEmptyVehicle};