/*
	GMSCore_fnc_isDone

	Purpose: check if an object is a UAV using the isUAV flag in CfgVehicles for that class name 

	Parameters: _this = classname to be tested 

	Returns: True if the object is a 'drone' otherwise false 

	Notes: You can determine whether a drone isKindOf "Plane", "Helicopter", "Car" to establish more about its characteristics
	Copyright 2020 by Ghostrider-GRG-
*/
// _this is the object in question.
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_className"];
if !(_className isEqualType "string") exitWith {[format["%1 pass to _isDrone which expected a string corresponding to a classname",_className],"warning"] call GMSCore_fnc_log};
if!(isClass(configFile >> "CfgVehicles" >> _className)) exitWith {[format["_className %1 not found in CfgVehicles",_classNmae],"warning"] call GMSCore_fnc_log};
private _vehicleclass = getText(configFile >> "CfgVehicles" >> _className >> "vehicleclass");
if (_vehicleClass isEqualTo "Autonomous") then {true} else {false};
