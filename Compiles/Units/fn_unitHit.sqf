/*
	GMSCore_fnc_unitHit 

	Purpose: fired by the "MPHit" eventhandler for the unit. 
		It should put the group in combat mode 
		And test if the unit should heal. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
	
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
if !(local (_this select 0)) exitWith {};
params ["_unit", "_source", "_damage", "_instigator"];
//[format["GMSCore_fnc_unitHit: _this = %1",_this]] call GMSCore_fnc_log;
if !(isPlayer _instigator) exitWith 
{
	private _newDamage = damage _unit;
	_unit setDamage (_newDamage - _damage);
};

if ([group _unit] call GMSCore_fnc_updateGroupHitKilledTimer) then // This only allows updates every 10 sec to reduce server load.
{
	#define searchDistance (group _unit) getVariable [GMS_patrolAlertDistance,500] // Tied to the alertDistance for the group
	#define bumpKnowsAbout (group _unit) getVariable [GMS_patrolIntelligence,0.5] // Tied to intelligence fot the group
	[group _source, searchDistance, bumpKnowsAbout] call GMSCore_fnc_allertNearbyGroups;
	[group _unit, _source] call GMSCore_fnc_huntPlayerGroup;
	[_unit,_source] call GMSCore_fnc_healSelf;
};

{_this call _x} forEach ((group _unit)  getVariable[GMS_aiHitCode,[]]);
