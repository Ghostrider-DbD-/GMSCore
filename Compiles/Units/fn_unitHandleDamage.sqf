/*
	GMSCore_fnc_vehicleHandleDamage 

	Purpose: handle situations where the vehicle sustains damage because of friednly fire or collisions with the environment 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage  
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];	

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Scope Global 
*/
#include "\GMSCore\Init\GMS_defines.hpp"
if !(local (_this select 0)) exitWith {};
params ["_vehicle", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
if !(isPlayer _instigator) then 
{
	_vehicle setDamage 0;  
	_vehicle setHitPointDamage [_hitPoint, 0];
};