/*
	GMSCore_fnc_setMoney
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params[
	["_obj",objNull],				// The object you wish to attach money to 
	["_skillLevel",""],	// Skill level ['Blue','Red','Green','Orange'] used to determine difficulty bonuses 
	["_money",-1]			// how much money to add - which can be formated as an integer, [integer], or [min,max-integer]
];
//diag_log format["_setMoney: _obj %1 | _skill %2 | _money %2",_obj,_skillLevel,_money];
try {
	if (isNull _obj) throw -3;
	if (_skillLevel isEqualTo "") throw -2;
	if (_money isEqualTo -1) throw -1;
	private _mode = toLower GMSCore_modType;

	private _funds = round([_money] call GMSCore_fnc_getNumberFromRange);

	switch (_mode) do 
	{
		case "epoch": {_obj setVariable["Crypto", _funds, true]};
		case "exile": {_obj setVariable["ExileMoney", _funds, true]};
	};
}

catch 
{
	switch (_exception) do 
	{
		case -3: {[format["Invalid object or no object passed to GMSCore_fnc_setMoney"],'warning'] call GMSCore_fnc_log};
		case -2: {[format["No skill level passed to to GMSCore_fnc_setMoney"],"warning"] call GMSCore_fnc_log};
		case -1: {[format["no valued passed for money to GMSCore_fnc_setMoney"],'warning'] call GMSCore_fnc_log};
	};
};



