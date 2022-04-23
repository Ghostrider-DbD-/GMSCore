/*
	GMS_fnc_isUAV

	Purpose: check if an object is a UAV using the isUAV flag in CfgVehicles for that class name 

	Parameters: _this = the object to be tested 

	Returns: True if the object is a UAV otherwise false 

	Copyright 2020 by Ghostrider-GRG-
*/
// _this is the object in question.

private _isUAV = false;
if (isNumber(configFile >> "CfgVehicles" >> typeOf _this >> "isUAV")) then 
{
	_isUAV = if (getNumber(configFile >> "CfgVehicles" >> typeOf _this >> "isUAV") == 1) then {true} else {false};
};
_isUAV