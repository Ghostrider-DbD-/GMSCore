/*

	GMS_fnc_checkClassnamesWeightedArray

	Purpose: to validate classnames in a weighted array
	Notes: Array format is assumed to be "classname",weight,"classname2",weight2 ...

	Parametsrs:
		_classnames: an array of strings, each representing a possible className
	
	Returns: the array with invalid classnames logged and removed.

	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_classNames"];

private _return = [];
for "_i" from 0 to (count _classNames) step 2 do 
{
	diag_log format["[GMS] _checkClassNamesWeightArray:  _item = %1 | _weight = %2",_classNames select _i,_classNames select (_i +1)];
	private _item = _className select _i;

	if ([_item] call GMS_fnc_isClass) then 
	{
		private _weight = _classNames select (_i +1);		
		_return pushBack [_item,_weight];
	} else {
		diag_log format["[GMSCore] fn_checkClassNames: invalid classname %1",_x];
	};
};

_return