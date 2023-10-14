/*
	GMSCore_fnc_setMoney
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params[
	"_obj",				// The object you wish to attach money to 
	"_skillLevel",		// Skill level ['Blue','Red','Green','Orange'] used to determine difficulty bonuses 
	"_money"			// how much money to add - which can be formated as an integer, [integer], or [min,max-integer]
];

private _mode = toLower GMSCore_modType;

private _funds = round([_money] call GMSCore_fnc_getNumberFromRange);

switch (_mode) do 
{
	case "epoch": {_obj setVariable["Crypto", _funds, true]};
	case "exile": {_obj setVariable["ExileMoney", _funds, true]};
};


