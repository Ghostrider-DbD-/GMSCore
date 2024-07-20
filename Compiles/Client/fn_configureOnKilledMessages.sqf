/*
	GMSCore_fnc_configureOnKilledMessages

	Purpose:
		Updates the list of types of messages to be shown to players when units are killed by a player.

	Parameters: 
		_config: array of strings allowed in GMS_validUnitKilledMsgTypes

	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_config",[]]];
private _passedCfgs = [];
{
	switch (GMSCore_modType) do 
	{
		case "Epoch": {if ((_x in GMS_validUnitKilledMsgTypes) && !(_x isEqualTo "toast")) then {_passedCfgs pushBack _x}};
		case "Exile": {if ((_x in GMS_validUnitKilledMsgTypes) && !(_x isEqualTo "epochMsg")) then {_passedCfgs pushBack _x}};
		default {if ((_x in GMS_validUnitKilledMsgTypes)  && !(_x isEqualTo "epochMsg") && !(_x isEqualTo "toast")) then {_passedCfgs pushBack _x}};
	};
} forEach _config;
_passedCfgs;