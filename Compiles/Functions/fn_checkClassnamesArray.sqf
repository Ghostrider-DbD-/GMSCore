/*

	GMS_fnc_checkClassnNmesArray

	Purpose: to validate classnames used for AI gear or other puposes

	Parametsrs:
		_classnames: an array of strings, each representing a possible className

	Returns: the array with invalid classnames removed and logged.

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_classNames"];
private _return = [];
//diag_log format["[GMS] _checkClassnamesArray: _classNames select 0 = %1 | _classNames = %2",_classNames select 0,_classNames];
if !(_classNames isEqualTo []) then 
{
	private _mode = if (count _classNames >= 2) then {1} else {0}; // weighed
	if (_mode == 1) then 
	{
		if !(typeName (_classNames select 1) isEqualTo "SCALAR") then {_mode = 0};
	};
	if (_mode == 1) then  // case of weighted array
	{
		while {!(_classNames isEqualTo [])} do 
		{
			private _cn = _classnames deleteAt 0; 
			private _wt = _classnames deleteAt 0;
			if([_cn] call GMS_fnc_isClass) then 
			{
				//diag_log format["[GMS] validated classname %1 and adding it with its weight to _return which now = %2",_cn,_return];				
				_return append [_cn,_wt];
			} else {
				[format["Removing invalid classname %1 from configurations",_cn,"warning"]] call GMS_fnc_log;
			};
		};
	} else {  //  Case of normal array

		{
			if ([_x] call GMS_fnc_isClass) then 
			{
				//diag_log format["[GMS] validated classname %1 and adding it to _return which now = %2",_x,_return];
				_return pushBack _x;
			} else {
				[format["Removing invalid classname %1 from configurations",_x],"warning"] call GMS_fnc_log;
			};
		} forEach _classNames;

	};
} else {
		_return = _classNames;
};

_return