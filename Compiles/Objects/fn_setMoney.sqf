/*

	GMS_fnc_setMoney
	
	Purpose: Assign a value to the variable for crypto/tabs for the object

	Parameters: 
		_obj: the object to be handled 
		_money: how much in tabs/crypto to assing to the object 

	Return: nothing
	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params[["_obj",objNull],["_money",-1]];

if (isNull _obj) exitWith {};
private _toAdd = ([_money] call GMS_fnc_getIntegerFromRange);
if (_money > 0) then 
{
	switch(toLower(GMS_modType)) do 
	{
		case "exile": {_obj setVariable["ExileMoney",_toAdd,true]};
		case "epoch": {_obj setVariable["Crypto", _toAdd,true]};
	};
};