/*
	GMS_fnc_vehicleKilled 

	Purpose: Called when the MPKilled EH for a vehicle is fired to do basic housekeeping needed when a vehicle is killed.

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPKilled 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-

	Note: wrecks are deleted at 120 secs by default.
	TODO: check the parameters here.
*/

#include "\GMSCore\Init\GMS_defines.hpp"
if !(local (_this select 0)) exitWith {};
params["_veh","_killer","_instigator"];
if ([_veh] call GMS_fnc_updateGroupHitKilledTimer) then // This only allows updates every 10 sec to reduce server load.
{
	private _group = _veh getVariable["GMS_group",grpNull];
	#define searchDistance (_group) getVariable [GMS_patrolAlertDistance,500] // Tied to the alertDistance for the group
	#define bumpKnowsAbout (_group) getVariable [GMS_patrolIntelligence,0.25] // Tied to intelligence fot the group
	[position _veh,group _killer,searchDistance,bumpKnowsAbout] call GMS_fnc_allertNearbyGroups;
};
{_this call _x} forEach (_veh getVariable[GMS_vehKilledCode,[]]);
[_veh] call GMS_fnc_removeAllLocalEventHandlers;
[_veh] call GMS_fnc_removeAllMPEventHandlers;
if (GMS_modType isEqualTo "epoch") then {_this call EPOCH_server_save_killedVehicle };
GMSCore_monitoredEmptyVehicles pushBack [_veh, diag_tickTime + (_veh getVariable["GMS_deleteEmptyVehicle",300])];




