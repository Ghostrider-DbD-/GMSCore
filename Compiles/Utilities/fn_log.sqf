/*

	GMS_fnc_log

	Purpose: to write a message to the server log

	Parametsrs:
		_msg: message to be logged
		_type: 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-	
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_msg",["_type",""]];
if !(typeName _type isEqualTo "STRING") then 
{
	[format["Invalid _type %1 passed to GMS_fnc_log",_type]] call GMS_fnc_log;
	_type = "";
};
//diag_log format["GMS_fnc_log: _this = %1",_this];
private _log = "";
#define basemsg "[GMSCore]%1 %2"
switch (tolower _type) do 
{
	case "warning": {_log = format[basemsg," <WARNING> ",_msg]};
	case "error": {_log = format[basemsg," <ERROR> ",_msg]};
	case "information": {_log = format[basemsg,"<INFORMATION>",_msg]};
	default {_log = format[basemsg,"",_msg]};
};
diag_log _log;