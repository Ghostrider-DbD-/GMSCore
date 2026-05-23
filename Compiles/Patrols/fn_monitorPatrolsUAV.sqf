
/*
	GMSCore_fnc_monitorPatrolsAir 

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
private _count = count GMSCore_monitoredPatrolsUAV;
if (GMSCore_debug > 0) then {
	[format["_monitorPatrolsUAV called at %1 with _count = %2 and groups to monitor = %3",diag_tickTime, _count, count GMSCore_monitoredPatrolsUAV]] call GMSCore_fnc_log;
};
private _antiStuck = false;
private _newTarget = false; 

for "_i" from 1 to (_count) do 
{
	if (_i > _count) exitWith {[format["GMSCore_fnc_monitorAreaPatrols: _i > _count"]] call GMSCore_fnc_log};
	
	private _patrol = GMSCore_monitoredPatrolsUAV deleteAt 0;
	_patrol params[["_group",grpNull]];
	private _leader = leader _group;
	private _aircraft = objectParent (_leader);
	//private _assignedVeh = _group getVariable["vehicleAssigned", objNull];
	private _altitude = (getPosATL _leader) select 2;
	private _detected = [];
	//[format["_monitorPatrolsUAV: _patrol %1 | _group %2 | _leader %3 _aircraft %4 | crew _aircraft %5",_patrol, _group, _leader, objectParent (_leader), crew _aircraft]] call GMSCore_fnc_log;
	//[format["_monitorPatrolsUAV: assignedVehicle _leader = %1", assignedVehicle _leader]] call GMSCore_fnc_log;
	//[format["_monitorPatrolUAV: leader posn %1 | leader speed %2", getPosATL _leader, speed _leader]] call GMSCore_fnc_log;
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
					private _uav = objectParent (leader _group);
					_uav setFuel 1.0;
					_group setVariable["refuelRearm", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_refuelTimer")];
					//[format["_monitorPatrolsUAV: vehicle %1 refueld",_uav]] call GMSCore_fnc_log;
				};
				if (diag_tickTime > _antiStuckTime)  then {
					_antiStuck = [_group] call GMSCore_fnc_antiStuckAir;
					if (_antiStuck) then {
						[leader _group, "Disengage"] call GMSCore_fnc_nextWaypointAreaPatrolAir;
						//_group setVariable["isStuck", true];
					};
					_antiStuckTimer = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
					_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTimer];
				} else {
					//private _veh = objectParent (leader _group);
					private _noAgroZones = nearestLocations[getPosATL leader _group, [], NO_AGRO_RANGE_LAND];
					if (count _noAgroZones > 0) then {
						[_group, "Ignore"] call GMSCore_fnc_setGroupBehavior;
						_group setVariable["noAgro", true];;
					};
				};
				if (GMSCore_debug > 0) then {
					[_group] call GMSCore_fnc_updateGroupDebugMarker;
					private _lastPos = _group getVariable["lastPos", getPosATL (leader _group)];
					private _distanceTraveled = (getPosATL (leader _group)) distance _lastPos;
					private _lastMovedTime = _group getVariable["lastMovedTime", -1];
					[format["_monitorPatrolsAir: _group %1 | _altitude %5 | _distanceTraveled %2 | speed %3 | _lastMoved %4", _group, _distanceTraveled, speed (leader _group)], _lastMovedTime, (getPosATL (leader _group)) select 2]  call GMSCore_fnc_log;;
					if (_distanceTraveled > 0) then {_group setVariable["lastMovedTime", diag_tickTime]} else {_group setVariable["lastMovedTime", -1]};
					_group setVariable["lastPos", getPosATL (leader _group)];					
				};

				GMSCore_monitoredPatrolsUAV pushBack _patrol;
			};
		};
	};
	
};




