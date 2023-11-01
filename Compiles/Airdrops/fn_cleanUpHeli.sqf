/*
	GMSCore_fnc_cleanupHeli 
	Purpose: cleanup a heli and crew that brought in an airdrop 
	Parameters: _heli  // the aircraft to be cleaned up 
	Returns: None

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

_heli = vehicle _this;
[group _this] call GMSCore_fnc_despawnInfantryGroup;
deleteVehicle _heli;
