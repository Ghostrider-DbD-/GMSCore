/*
	GMSCore_fnc_setGroupSkills

	Purpose: set skills for all units in a group.

	Parameters
		_group: the group to which this ACE_explosives_fnc_getPlacedExplosives
		_skills: an array of skills

	Return: none

	Copyright 2020 Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_group","_skills"];

_skills params["_accuracy","_aimingSpeed","_shake","_spotDistance","_spotTime","_courage","_reloadSpeed","_commanding","_general"];
{
	//_x setSkill _general;
	_x setSkill ["aimingAccuracy", [_accuracy] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["aimingSpeed", [_aimingSpeed] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["aimingShake", [_shake] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["commanding", [_commanding] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["courage", [_courage] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["general", [_general] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["reloadSpeed", [_reloadSpeed] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["spotDistance", [_spotDistance] call GMSCore_fnc_getNumberFromRange];
	_x setSkill ["spotTime", [_spotTime] call GMSCore_fnc_getNumberFromRange];
} forEach (units _group);