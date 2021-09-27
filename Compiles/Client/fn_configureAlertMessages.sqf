/*
	GMS_fnc_configureAlertMessages 

	Purpose:
		Updates the list of types of messages to be shown to players when alerts are sent out.

	Parameters: 
		_config: array of strings allowed in GMS_validAlertMsgTypes

	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_config",[]]];
private _passedCfgs = [];
{
	switch (GMS_ModType) do 
	{
		case "epoch": {if ((_x in GMS_validAlertMsgTypes) && !(_x isEqualTo "toast")) then {_passedCfgs pushBack _x}};
		case "exile": {if ((_x in GMS_validAlertMsgTypes) && !(_x isEqualTo "epochMst")) then {_passedCfgs pushBack _x}};
		default {if ((_x in GMS_validAlertMsgTypes)  && !(_x isEqualTo "epochMst") && !(_x isEqualTo "toast")) then {_passedCfgs pushBack _x}};
	};
} forEach _config;
GMS_alertMsgTypes = _passedCfgs;