/*
	GMSCore_fnc_airSetupGroupBehavior

	Prupose: setup behavior parameters for a group.

	Parameters
		_group, the group to be HandleScore
		_garison: when true, the group will not move from its locationNull
		_swimdepth, for scuba units, how far under the surface to swim.

	Returns: None 

	Copyright 2020 Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group",["_garrison",false]];
[format["_setupGroupBehavior: _group = %1 | _garison %2 | _scuba %3",_group,_garrison,_scuba]] call GMSCore_log;
_group setcombatmode "RED";
_group setBehaviour "AWARE";
_group allowfleeing 0;
_group setspeedmode "FULL";
_group setFormation GMS_formation; 
_group setVariable ["GMSCore_group",true];
{
	_x setcombatmode "RED";
	_x setBehaviour "AWARE";
	_x allowfleeing 0;
	_x setspeedmode "FULL";
	_x enableAI "ALL";
	_x allowDammage true;
	_x setunitpos "AUTO";
	_x setVariable[GMS_unit,true];
	//diag_log format["_setupGroupBehavior: _group = %1 | _unit = %2 | side _unit = %3",_group,_x, side _x];
} forEach units _group;