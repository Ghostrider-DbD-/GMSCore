/*
	GMS_fnc_selectRandomObject
*/

params["_choices",["_blacklists",[]];
private "_choice";

if (_blacklists isEqualTo []) then 
{
	_choice = selectRandom _choices;
} else {
		private _tried = [];
		_choice = 0;
		while { ((count _tried) < (count _choices)) && _choice == 0} do 
		{
			_choice = selectRandomWeighted _choices;
			if (_choice in _blacklists) then 
			{
				_tried pushBack _choice;
				_choice = 0;
			};
		};
	};
};

_choice