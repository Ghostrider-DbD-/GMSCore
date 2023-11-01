/*
	    GMSCore_fnc_removeBlacklistedItems 

		Purpose: provide a generic tool for removing items in a black list from array.
			The array may be a list of strings, strings and weights, are subarrays where the first element is a string.

		Parameters:
			_items: the array to be checked.
			_blacklist: the list of blacklisted classnames 

		Returns:
			_items after cleaning to remove blacklisted classnames 
			
		Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_items",[]],["_blacklist",[]]];
if (_blacklist isEqualTo []) exitWith {};
private _count = count _items;
for "_i" from 1 to count _items do 
{
	if (_i > count _items) exitwith {};
	private _i1 = _items deleteAt 0;
	private _blacklisted = false;
	if (_i1 isEqualType "") then 
	{
		if (_i1 in _blacklist) then {_blacklisted = true};
		if (_blacklisted) then 
		{
			[format["\x\addons\GMSCore_fnc_removeBlacklistedItems: removing blacklisted item %1 from list",_i1]] call GMSCore_fnc_log;
			if ((_items select 0) isEqualType 0) then 
			{
				// assume this is a normal weighted array 
				_items deleteAt 0;
			};
		} else {
			if ((_items select 0) isEqualType 0) then 
			{
				// assume this is a normal weighted array 
				private _i2 = _items deleteAt 0;
				_items append [_i1,_i2];
			};
			if ((_items select 0) isEqualType "") then 
			{
				_items pushBack _i1;
			};		
		};
	} else {
		if (_i1 isEqualType []) then 
		{
			if ((_i1 select 1) in _blacklist) then {_blacklisted = true};
			if (_blacklisted) then 
			{
				[format["\x\addons\GMSCore_fnc_removeBlacklistedItems: removing blacklisted item %1 from list",_i1]] call GMSCore_fnc_log;
			} else {
				_items pushBack _i1;
			};
		};
	};
};
_items;

