/*
	GMS_fnc_unitRemoveAllGear

	Purpose: strip all gear from a unit.

	Parameters: The unit to be dealt with. 
	
	Return: true

	Copyright 2020 by Ghostrider-GRG-	
*/

#include "\GMSCore\Init\GMS_defines.hpp"
private "_unit";
if (typeName _this isEqualTo "ARRAY") then 
{
	_unit = _this select 0;
} else {
	_unit = _this;
};
 
removeVest _unit;
removeHeadgear _unit;
removeGoggles _unit;
removeAllItems _unit;
removeAllWeapons _unit;
removeBackpackGlobal _unit;
removeUniform _unit;
