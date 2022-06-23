/*
	GMSCore_fnc_vehicleKilled 

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
//[format["GMSCore_fnc_vehicleKilled: _veh %1 | typeOf _veh %2 | name _instigator %3",_veh,typeOf _veh, name _instigator]] call GMSCore_fnc_log;
if ([_veh] call GMSCore_fnc_updateGroupHitKilledTimer) then // This only allows updates every 10 sec to reduce server load.
{
	private _group = _veh getVariable["GMS_group",grpNull];
	#define searchDistance (_group) getVariable [GMS_patrolAlertDistance,500] // Tied to the alertDistance for the group
	#define bumpKnowsAbout (_group) getVariable [GMS_patrolIntelligence,0.25] // Tied to intelligence fot the group
	[position _veh,group _killer,searchDistance,bumpKnowsAbout] call GMSCore_fnc_allertNearbyGroups;
};
{_this call _x} forEach (_veh getVariable[GMS_vehKilledCode,[]]);
[_veh] call GMSCore_fnc_removeAllLocalEventHandlers;
[_veh] call GMSCore_fnc_removeAllMPEventHandlers;
if (GMSCore_modType isEqualTo "epoch") then {_this call EPOCH_server_save_killedVehicle };
private _deleteEmptyVeh = _veh getVariable["GMS_deleteEmptyVehicle",300];
GMSCore_monitoredEmptyVehicles pushBack [_veh, diag_tickTime + _deleteEmptyVeh];




