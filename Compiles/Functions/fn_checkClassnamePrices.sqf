/*

	GMSCore_fnc_checkClassNamePrices

	Purpose: to check whether there is pricing for each classname in a weighted array and flag or remove those that don't.
			 Handles simple arrays and weighted arrays formated as [className, weight, ... 
	Parametsrs:
		_classnames: an array of strings, each representing a possible className
		_remove: 	 whether to remove classnames without prices // defalut is remove and log

	Returns: the array with classnames without prices logged and where _removved == true, removed from the array.

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
params[["_classnames",[]],["_remove",true]];
private "_cfg";
//[format["GMSCore_fnc_checkClassNamePrices: _remove = %1 | typeName _classnames = %2",_remove,typeName _classnames]] call GMSCore_fnc_log;
//[format["GMSCore_fnc_checkClassNamePrices:_classnames = %1",_classnames]] call GMSCore_fnc_log;
private _count = count _classnames;
switch (GMSCore_modType) do 
{
	case "Epoch": {_cfg = "CfgPricing"};
	case "Exile": {_cfg = "CfgExileArsenal"};
	default {_cfg = ""};
};
if !(_cfg isEqualTo "") then 
{
	for "_i" from 1 to count _classnames do 
	{
		if (_i > count _classnames) exitWith {};
		private _cn = _classnames deleteAt 0;

		// If this is a weighted array lets grab the weight for that classname as well.

		private _invalid = false;
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
			if !(isClass(missionConfigFile >> _cfg >> _cn)) then 
			{
				_invalid = true;
				[format["There is no pricing in %1 for classname %2",GMSCore_modType,_cn],'warning'] call GMSCore_fnc_log;			
			};
			if (!(_invalid) || {!(_remove)}) then 
			{
				if (_isWeighted) then 
				{
					_classnames append [_cn,_cn2];
				} else {
					_classnames pushBack _cn;
				};
			};
		};
		if (_cn isEqualType []) then // weighted 
		{
			if !(isClass(missionConfigFile >> _cfg >> (_cn select 0))) then 
			{
				_invalid = true;
				[format["There is no pricing in %1 for classname %2",GMSCore_modType,(_cn select 0)],'warning'] call GMSCore_fnc_log;			
			};
			if (!(_invalid) || {!(_remove)}) then 
			{
				_classnames pushBack _cn;
			};
		};
	};
};
//[format["GMSCore_fnc_checkClassNamePrices:_classnames after cleanup = %1",_classnames]] call GMSCore_fnc_log;
_classnames