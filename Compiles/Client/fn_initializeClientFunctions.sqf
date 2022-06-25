/*
	GMSCore_fnc_initializeClientFunctions 

	Purpose:
		Called when a player joins 
		To broadcast variables and functions used by the client 

	Parameters: 
		params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
format["%1 joining the server: variables and functions being broadcast",_name] remoteExec["diag_log",_owner];
{
	_owner publicVariableClient _x;
} forEach [
	"GMSCore_fnc_textAlert",
	"GMSCore_fnc_titleTextAlert",
	"GMSCore_fnc_huntedMessages",
	"GMSCore_fnc_killedMessages",
	"GMSCore_modType",
	"GMSCore_killedMsgTypes",
	"GMSCore_alertMsgTypes",
	"GMSCore_huntedMsgTypes"
];

