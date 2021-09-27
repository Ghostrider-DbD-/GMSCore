/*
	GMS_fnc_selectRandomObject
*/

params["_choices",["_blacklists",[]];
private "_choice";

if (count (_choices select 0) == 2) then 
{
	// Use a separate function here so we dont have to test for _weighted with every itteration with blacklisted items.
	_choice = _this call GMS_fnc_selectRandomObjectWeighted;
	_choice
} else {
	if (_blacklists isEqualTo []) then 
	{
			_choice = selectRandom _choices;
		};
	} else {
		for "_i" from 1 to (count _choices) do 
		{
			if (_I >= (count _choices)) exitWith {_choice = ""};
			_choice = _choices deleteAt 0;
			if !(_c in _blacklists) exitWith {};
		};
	};
};
_choice