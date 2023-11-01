/*
	GMSCore_fnc_getNumberFromRange

	Purpose: find a random number within a range of N1 and N2.
	Parameters: _data 
		Allowed formats for _data: [_min,_max], [_min] or _min. 
		1. [_min,_max]: a random value between _min and _max is returned. 
			If _min == _max, _min is returned. 
		2. [_min]: _min is ruturned.
		3. _min: _min is returned 

	Returns: a random number within the specified range.

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
private _validData = params[["_data",[]]];
if !(_validData) exitWith {
	[format["_getNumberFromRange:No value passed,  with _parentScript = %2",_this,_fnc_scriptNameParent]]  call GMSCore_fnc_log;
	// return a negative value so the script calling this function knows something probably went wrong. 
	-1;
};
if !(_this isEqualTypeParams [0] || _this isEqualTypeParams [[0]] || _this isEqualTypeParams [[0,0]]) exitWith {
	[format["_getNumberFromRange: invald values %1 passed with _parentScript = %2",_this,_fnc_scriptNameParent]] call GMSCore_fnc_log;
	-1;
};

private _value = 0;  // so the function returns something valid a calling function can check to establish that it ran correctly
if (_data isEqualTo []) exitWith {[]};
if (_data isEqualType []) then
{
	if (_data isEqualTypeArray [0]) then
	{
		_value = _data select 0;
	} else {
		if (_data isEqualTypeArray [0,0]) then
		{
			_data params[["_min",0],["_max",1]];
			if (_max > _min) then 
			{
				_value = _min + random(_max - _min);
			} else {
				_value = _min;
			};
		} else {
			diag_log format["[GMSAI] Error: Array %1 must have 1 or 2 scalar elements",_data];
			_value = [];
		};
	};
} else {
	if (_data isEqualType 0) then
	{
		_value = _data;
	};
};
_value