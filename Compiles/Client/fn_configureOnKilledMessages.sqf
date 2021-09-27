/*
	GMS_fnc_configureOnKilledMessages

	Purpose:
		Updates the list of types of messages to be shown to players when units are killed by a player.

	Parameters: 
		_config: array of strings allowed in GMS_validUnitKilledMsgTypes

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
		case "epoch": {if ((_x in GMS_validUnitKilledMsgTypes) && !(_x isEqualTo "toast")) then {_passedCfgs pushBack _x}};
		case "exile": {if ((_x in GMS_validUnitKilledMsgTypes) && !(_x isEqualTo "epochMsg")) then {_passedCfgs pushBack _x}};
		default {if ((_x in GMS_validUnitKilledMsgTypes)  && !(_x isEqualTo "epochMsg") && !(_x isEqualTo "toast")) then {_passedCfgs pushBack _x}};
	};
} forEach _config;
GMS_killedMsgTypes = _passedCfgs;