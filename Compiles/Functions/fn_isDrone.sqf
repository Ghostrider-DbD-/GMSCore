/*
	GMS_fnc_isUAV

	Purpose: check if an object is a UAV using the isUAV flag in CfgVehicles for that class name 

	Parameters: _this = classname to be tested 

	Returns: True if the object is a UAV otherwise false 

	Copyright 2020 by Ghostrider-GRG-
*/
// _this is the object in question.

["GMS_fnc_isUAV: _this  = %1"] call GMS_fnc_log;
params["_className"];
if!(isClass(configFile >> "CfgVehicles" >> _className)) exitWith 
{
	[format["GMS_fnc_isDrone: invalid classname %1",_className],"warning"] call GMS_fnc_log;
};
private _vehicleclass = getText(configFile >> "CfgVehicles" >> _className >> "vehicleclass");
private _isDrone = if (_vehicleClass isEqualTo "Autonomous") then {true} else {false};
_isDrone