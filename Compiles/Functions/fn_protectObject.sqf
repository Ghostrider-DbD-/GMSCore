/*
	GMSCore_fnc_protectObject

	Purpose: configures objects so they are not deleted by the Epoch server.

	Parametsrs:
		_object: the object you wish to have protected

	Returns: None

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_object"];
if (GMSCore_modType isEqualTo "epoch") then 
{
	_object call EPOCH_server_setVToken;
};
