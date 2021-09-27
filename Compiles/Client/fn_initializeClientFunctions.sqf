/*
	GMS_fnc_initializeClientFunctions 

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
#include "\GMSCore\Init\GMS_defines.hpp"
params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
format["%1 joining the server: variables and functions being broadcast",_name] remoteExec["diag_log",_owner];
{
	_owner publicVariableClient _x;
} forEach [
	"GMS_fnc_textAlert",
	"GMS_fnc_titleTextAlert",
	"GMS_fnc_huntedMessages",
	"GMS_fnc_killedMessages",
	"GMS_ModType",
	"GMS_killedMsgTypes",
	"GMS_alertMsgTypes",
	"GMS_huntedMsgTypes"
];

