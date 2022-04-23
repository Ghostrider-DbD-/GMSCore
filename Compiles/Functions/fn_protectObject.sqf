/*
	GMS_fnc_protectObject

	Purpose: configures objects so they are not deleted by the Epoch server.

	Parametsrs:
		_object: the object you wish to have protected

	Returns: None

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_object"];
if (GMS_modType isEqualTo "epoch") then 
{
	_object call EPOCH_server_setVToken;
};
