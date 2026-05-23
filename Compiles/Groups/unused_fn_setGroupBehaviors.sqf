/*
	GMSCore_fnc_setGroupBehaviors 

	Purpose: Set group Behavior and Combat Mode 

	Parameters:
		_group, the group to act on 
		_mode, can be one of three choices:
			disengage - settings are applies to the group will ignore enemies 
			combat - ai are agressive, use cover, engage at will 
			none specified - ai are aware but less aggressive.

	Returns: None 

	Copyright 2020 Ghostrider-GRG-
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group",["_mode",""]];
switch(_mode) do 
{
	case "disengage": {
			_group setCombatMode "BLUE";
			_group setBehaviour "CARELESS";
			{_x forceSpeed -1} forEach (units _group);
			[_group,objNull] call GMSCore_fnc_setHunt;
	};
	case "combat": {
		_group setCombatMode "YELLOW";
		_group setBehaviour "AWARE";
		{_x forceSpeed -1} forEach (units _group);		
	};
	case "garison": {
		_group setCombatMode "RED";
		_group setBehaviour "AWARE";
		{_x forceSpeed -1} forEach (units _group);		
	};
	default {
		_group setCombatMode "YELLOW";
		_group setBehaviour "AWARE";
		{_x forceSpeed -1} forEach (units _group);
	};
};