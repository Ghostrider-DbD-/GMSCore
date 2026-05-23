
/*
	GMSCore_fnc_monitorPatrolsLand 

	Purpose: Checks for groups that are stuck and handles refueling; 
			 Rearming is handled using the reload event handler

	Parameters: None 

	Returns: None 

	Notes: 
		11/3/25 By intention, no groups are deleted from the list here. 
		This may need to be updated 

	Copyright 2020 by Ghostrider-GRG- 
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
private _count = count GMSCore_monitoredPatrolsLand;
if (GMSCore_debug > 0) then {
	[format["_monitorPatrolsLand called at %1 with _count = %2 and groups to monitor = %3",diag_tickTime, _count, count GMSCore_monitoredPatrolsLand]] call GMSCore_fnc_log;
};
private _antiStuck = false;
private _newTarget = false; 

for "_i" from 1 to (_count) do 
{
	if (_i > _count) exitWith {[format["GMSCore_fnc_monitorPatrolsLand: _i > _count"]] call GMSCore_fnc_log};
	
	private _patrol = GMSCore_monitoredPatrolsLand deleteAt 0;
	_patrol params[["_group",grpNull]];
	private _detected = [];

	try {
		// all of the cases for which we need to drop the patrol
		if (_group isEqualTo GMSCore_graveyardGroup) throw -1; 
		if (isNull _group) throw -1; 
		if (({alive _x} count (units _group)) == 0) throw -1; 	
		if (_group getVariable[GMSCore_patroArealMarker, ""] isEqualTo "") throw -1; 
	
		throw 1;
	}

	catch {
		switch (_exception) do {
			case -1: {
				// We will remove the patrol from further processing
			};
			case 1: {
				
				private _refuelRearmTime = _group getVariable["refuelRearm", 300];
				private _antiStuckTime = _group getVariable["antiStuck", 300];
				
				if (diag_tickTime > _refuelRearmTime) then {
					private _veh = objectParent (leader _group);
					_veh setFuel 1.0;
					_group setVariable["refuelRearm", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
					//[format["_monitorPatrolsLand: vehicle %1 refueld",_veh]] call GMSCore_fnc_log;
				};
				if (diag_tickTime > _antiStuckTime)  then {
					_antiStuck = [_group] call GMSCore_fnc_antiStuckLand;
					_group setVariable["antiStuck", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer")];
				};
				if (_antiStuck) then {
					[leader _group, "Disengage"] call GMSCore_fnc_nextWaypointAreaPatrolLand;
				} else {
					private _veh = objectParent (leader _group);
					private _noAgroZones = nearestLocations[getPosATL _veh, [], NO_AGRO_RANGE_AIR];
					if (count _noAgroZones > 0) then {
						[_group, "Ignore"] call GMSCore_fnc_setGroupBehavior;
						//_group setVariable["noAgroState", true];
					} else {
						[_group, "Safe"] call GMSCore_fnc_setGroupBehavior;
					};
				};
				if (GMSCore_debug > 0) then {
					[_group] call GMSCore_fnc_updateGroupDebugMarker;
					private _lastPos = _group getVariable["lastPos", getPosATL (leader _group)];
					private _distanceTraveled = (getPosATL (leader _group)) distance _lastPos;
					private _lastMovedTime = _group getVariable["lastMovedTime", -1];
					[format["_monitorPatrolsLand: _group %1 | _distanceTraveled %2 | speed %3 | lastMoved %4 | serverTime %5", _group, _distanceTraveled, speed (leader _group), _lastMovedTime, diag_tickTime]]  call GMSCore_fnc_log;;
					if (_distanceTraveled > 0) then {_group setVariable["lastMovedTime", diag_tickTime]} else {_group setVariable["lastMovedTime", -1]};
					_group setVariable["lastPos", getPosATL (leader _group)];
				};				
				GMSCore_monitoredPatrolsLand pushBack _patrol;
			};
		};
	};

	
};




