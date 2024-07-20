/*

	GMSCore_fnc_setMoney
	
	Purpose: Assign a value to the variable for crypto/tabs for the object

	Parameters: 
		_obj: the object to be handled 
		_money: how much in tabs/crypto to assing to the object 

	Return: nothing
	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params[["_obj",objNull],["_money",-1]];

if (isNull _obj) exitWith {};

private _toAdd = ([_money] call GMSCore_fnc_getIntegerFromRange);

//[format["_setMoney: _toAdd %3 | _obj %1 |  _money %2",_obj,_money,_toAdd]] call GMSCore_fnc_log;

if (_toAdd > 0) then 
{
	switch(toLower(GMSCore_modType)) do 
	{
		case "exile": {_obj setVariable["ExileMoney",_toAdd,true]};
		case "epoch": {_obj setVariable["Crypto", _toAdd,true]};
	};
};