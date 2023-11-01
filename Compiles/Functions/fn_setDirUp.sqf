/*
	GMSCore_fnc_setDirUp
*/

params["_obj","_dir"];
if (_dir isEqualType 0) exitWith {_obj setDir _dir};
if (_dir isEqualTypeArray [[0,0,0],[0,0,0]]) then {
	_obj setVectorDir (_dir select 0); 
	_obj setVectorUp (_dir select 1);
};