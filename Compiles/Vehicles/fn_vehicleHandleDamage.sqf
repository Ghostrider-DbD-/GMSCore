/*
	GMSCore_fnc_vehicleHandleDamage 

	Purpose: handle situations where the vehicle sustains damage because of friednly fire or collisions with the environment 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage  
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];	

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Scope Global 
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params ["_vehicle", "_selection", "_newDmg", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
if (isPlayer _instigator) exitWith {};
if (_selection isEqualTo "" || {_selection isEqualTo "?"}) then 
{
	_vehicle setDamage ((damage _vehicle) - _newDmg);
	[format["GMSCore_fnc_vehicleHandleDamage: vehicle %1 | %2 | damage set to %3",_vehicle, typeOf _vehicle, damage _vehicle]] call GMSCore_fnc_log;
} else {
	_vehicle setHit [_hitPoint, (_vehicle getHit _selection) - _damage];
	[format["GMSCore_fnc_vehicleHandleDamage: vehicle %1 | %2 | hitpoint damage set to %3",_vehicle, typeOf _vehicle, _vehicle getHit _selection]] call GMSCore_fnc_log;	
};
