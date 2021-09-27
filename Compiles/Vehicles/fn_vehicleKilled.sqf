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
//[format["GMS_fnc_vehicleKilled: _veh %1 | _killer %2 | _instigator %3",_veh,_killer,_instigator]] call GMS_fnc_log;
private _vehKC = _veh getVariable[GMS_vehKilledCode,[]];
//[format["GMS_fnc_vehicleKilled: _killedCodeCount = %1",count _vehKC]] call GMS_fnc_log;
private _deleteTimer = _veh getVariable["GMS_deleteEmptyVehicle",300];
{_this call _x} forEach _vehKC;
[_veh] call GMS_fnc_removeAllLocalEventHandlers;
[_veh] call GMS_fnc_removeAllMPEventHandlers;

GMSCore_monitoredEmptyVehicles pushBack [_veh, diag_tickTime + _deleteTimer];




