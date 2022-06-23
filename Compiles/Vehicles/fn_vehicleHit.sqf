/*
	GMSCore_fnc_vehicleHit 
	
	Purpose: called when the GMS MPHit EH is fired for the vehicle to handle allerting crew to enemy activities. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit  

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Notes: TODO: check the parameters here to be sure they are correct.	
*/

#include "\GMSCore\Init\GMS_defines.hpp"
if !(local (_this select 0)) exitWith {};
params ["_veh", "_source", "_damage", "_instigator"];
private _group = _veh getVariable["GMS_group",grpNull];
//[format["GMSCore_fnc_vehicleHit: _this = %1",_this]] call GMSCore_fnc_log;
if ([_veh] call GMSCore_fnc_updateGroupHitKilledTimer) then // This only allows updates every 10 sec to reduce server load.
{
	#define searchDistance _group getVariable [GMS_patrolAlertDistance,500] // Tied to the alertDistance for the group
	#define bumpKnowsAbout _group getVariable [GMS_patrolIntelligence, 0.5]  // Tied to intelligence fot the group
	[group _source, _searchDistance, _bumpKnowsAbout] call GMSCore_fnc_allertNearbyGroups;
	[_group, _source] call GMSCore_fnc_huntPlayerGroup;
	{_this call _x} forEach (_veh getVariable[GMS_vehHitCode, []]);
};



