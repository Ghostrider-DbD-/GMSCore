/*
	GMS_fnc_healSelf 

	Purpose: causes the unit to heal itself, removing all damage in the process 

	Parameters: 
		_unit, the unit to heal passed as _this 

	Returns: None

	Notes: variables on the group are set in GMS_fnc_spawnInfantryGroup and are passed to that function as parameters.
	
	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_unit","_source"];
if !(vehicle _unit isEqualTo _unit) exitWith {};
private _group = group _unit;

if ((damage _unit) < (_group getVariable[GMS_minDamageForHeal,0.4]) ) exitWith {};

private _maxHeals = _group getVariable [GMS_maxHeals,1];
private _healsDone = _unit getVariable ["GMS_healsDone",0];
if (_healsDone >= _maxHeals) exitWith {};
[_unit,_source] call GMS_fnc_throwSmoke;
_unit setVariable["GMS_healsDone",_healsDone + 1];
_unit addItem "FAK";
_unit action ["HealSoldierSelf", _unit];
_unit setDamage 0;

if ("FAK" in (items _unit)) then {_unit removeItem "FAK"};


