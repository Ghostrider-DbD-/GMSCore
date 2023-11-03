/*

	GMSCore_fnc_log

	Purpose: to write a message to the server log

	Parametsrs:
		_msg: message to be logged
		_type: 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-	
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_msg",["_type",""]];
if !(_type isEqualType "") then 
{
	[format["Invalid _type %1 passed to GMSCore_fnc_log",_type]] call GMSCore_fnc_log;
	_type = "";
};
private "_log"; 
#define basemsg "[GMSCore]%1 %2"
switch (toLowerANSI _type) do 
{
	case "warning": {_log = format[basemsg," <WARNING> ",_msg]};
	case "error": {_log = format[basemsg," <ERROR> ",_msg]};
	case "information": {_log = format[basemsg,"<INFORMATION>",_msg]};
	default {_log = format[basemsg,"",_msg]};
};
diag_log _log;