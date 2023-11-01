/*
	GMSCore_fnc_throwSmoke 

	Purpose: force a unit to throw a smoke grenade 

	Parameters: 
		_unit: the unit that should throw smoke 
		_enemy: direction of enemy if one is known 

	Returns: 
		Nothing
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_unit","_enemy"];
private _group = group _unit;
private _smokeShell = _group getVariable[GMS_smokeShell,""];
_smokeShell createVehicle (position _unit getPos[1,random(359)]);


