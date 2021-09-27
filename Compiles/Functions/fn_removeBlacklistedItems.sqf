/*
	    GMS_fnc_removeBlacklistedItems 

		Copyright 2020 by Ghostrider-GRG-
*/

params["_items","_blacklist"];

private _filtered = [];
if !(_items isEqualTo [] || _blacklist isEqualTo []) then 
{
	private _mode = if (count _items >= 2) then {1} else {0};; // weighed

	if (_mode == 1) then 
	{
		if !(typeName (_items select 1) isEqualTo "SCALAR") then {_mode = 0;};
	};
	if (_mode == 1) then  // case of weighted array
	{
		while {!(_items isEqualTo [])} do 
		{
			private _cn = _items deleteAt 0;
			private _wt = _items deleteAt 0;
			if !(_cn in _blacklist) then 
			{
				_filtered append [_cn,_wt];
				//diag_log format["[GMS] _removeBlackLlistedItems: keeping weighted Classname _cn = %1 | _wt = %2 | _filtered updated to %3",_cn,_wt,_filtered];				
			} else {
				diag_log format["[GMS] _removeBlackLlistedItems: removing blacklisted weighted Classname _cn = %1 | _wt = %2",_cn,_wt];			
			};
		};
	} else {  // case of not a weighted array.
		while {!(_items isEqualTo [])} do 
		{
			private _cn = _items deleteAt 0;
			if ([_cn] call GMS_fnc_isClass) then
			{
				_filtered pushBack _cn;
			};
		};
	};
} else {
	_filtered = _items;
};

_filtered