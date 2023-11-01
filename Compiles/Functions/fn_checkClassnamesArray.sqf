/*

	GMSCore_fnc_checkClassnNmesArray

	Purpose: to validate classnames used for AI gear or other puposes
			 Handles simple arrays and weighted arrays formated as [className, weight, ... 
	Parametsrs:
		_classnames: an array of strings, each representing a possible className
		_removed: if true then invalid classnames are removed.

	Returns: the array with invalid classnames removed and logged.

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_classnames",[]],["_remove",false]];
private _cfg = "CfgVehicles";
//[format["\x\addons\GMSCore_fnc_checkClassNamePrices: _remove = %1 | typeName _classnames = %2",_remove,typeName _classnames]] call GMSCore_fnc_log;
//[format["\x\addons\GMSCore_fnc_checkClassNamePrices:_classnames = %1",_classnames]] call GMSCore_fnc_log;
private _count = count _classnames;
switch (GMSCore_modType) do 
{
	case "Epoch": {_cfg = "CfgPricing"};
	case "Exile": {_cfg = "CfgExileArsenal"};
};
for "_i" from 1 to count _classnames do 
{
	if (_i > count _classnames) exitWith {};
	private _cn = _classnames deleteAt 0;

	// If this is a weighted array lets grab the weight for that classname as well.

	private _invalid = true;
	if (_cn isEqualType "") then 
	{
		private _cn2 = "";
		private _isWeighted = false;
		if !(_classNames isEqualTo []) then {_cn2 = _classnames select 0};
		if (_cn2 isEqualType 0) then 
		{
			_cn2 = _classnames deleteAt 0;
			_isWeighted = true;
		};
		if (isClass(configFile >> "CfgVehicles" >> _cn)) then {_invalid = false};
		if (isClass(configFile >> "CfgWeapons" >> _cn)) then {_invalid = false};
		if (isClass(configFile >> "CfgMagazines" >> _cn)) then {_invalid = false};
		if (_invalid)  then {[format["Invalid Classname Found: %1",_cn]] call GMSCore_fnc_log};
		if (!(_invalid) || {!(_remove)}) then 
		{
			if !(_isWeighted) then {_classNames pushBack _cn} else {_classNames append [_cn,_cn2]};
		};
	};
	if (_cn isEqualType []) then // probably a subarray with the first element a classname 
	{
		if (count _cn > 1) then 
		{
			_isWeighted = true;
		};
		if (isClass(configFile >> "CfgVehicles" >> _cn select 0)) then {_invalid = false};
		if (isClass(configFile >> "CfgWeapons" >> _cn select 0)) then {_invalid = false};
		if (isClass(configFile >> "CfgMagazines" >> _cn select 0)) then {_invalid = false};		
		if (_invalid)  then {[format["Invalid Classname Found: %1",_cn]] call GMSCore_fnc_log};		
		if (!(_invalid) || {!(_remove)}) then 
		{
			_classNames pushBack _cn;
		};		
	};
};
_classNames
