/*
	GMS_fnc_cleanup 
	Purpose: cleanup a heli and crew that brought in an airdrop 
	Parameters: _heli  // the aircraft to be cleaned up 
	Returns: None

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

_heli = vehicle _this;
[group _this] call GMS_fnc_despawnInfantryGroup;
deleteVehicle _heli;
