/*
    GMSCore_fnc_selectRandomCount
    Purpose: randomly select N elements from an array
    Parameters:
        _inputArray - contains the elements from which to select items
        _count - the number of items to select
    Returns
        _outputArray - contains the elements selected
*/

params[["_inputArray",[]],["_count",0]];
//[format["_selectRandomCount: _count %1 | _inputArray %2", _count, _inputArray]] call GMSCore_fnc_log;

private _outputArray = [];
if (_count < 1) exitWith {_outputArray};
if (_inputArray isEqualTo []) exitWith {_outputArray};
if ((count _inputArray < _count)) exitWith {_inputArray};

private _input = +_inputArray;
while {count _outputArray < _count} do {
    private _rnd = round(random(count _input));
    if (_rnd < (count _input) - 1) then {
        private _selection = _input deleteAt _rnd;
        //[format["_selectRandomCount: _rnd %1 _input %2", _rnd, _input]] call GMSCore_fnc_log;
        //[format["_selectRandomCount: _selection %1", _selection]] call GMSCore_fnc_log;
        _outputArray pushback _selection;
    };
};
//[format["_selectRandomCount: _outputArray %1", _outputArray]] call GMSCore_fnc_log;
_outputArray