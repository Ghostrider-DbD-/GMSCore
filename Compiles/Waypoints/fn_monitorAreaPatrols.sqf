
/*
	GMSCore_fnc_monitorAreaPatrols 

	Purpose: Checks for groups that have not reached their waypoints within a proscribed period
	and redirects them.

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 
*/

// TODO: Test functionality of this
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
//[format["\x\addons\GMSCore_fnc_monitorAreaPatrols called at %1 with %2 groups to monitor",diag_tickTime,count GMSCore_monitoredAreaPatrols]] call GMSCore_fnc_log;
private _count = count GMSCore_monitoredAreaPatrols;
for "_i" from 1 to (_count) do 
{
	if (_i > _count) exitWith {};
	private _patrol = GMSCore_monitoredAreaPatrols deleteAt 0;
	_patrol params[["_group",grpNull],["_patrolArea",[]],["_deleteOnNullGroup",true]];
	private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];	
	if ((leader _group) inArea _patrolAreaMarker) then {
		diag_log format["_monitorareapatrols(26): leader group %1 is inarea for marker %2",_group,_patrolareamarker];
	} else {
		diag_log format["_monitorareapatrols(26): leader group %1 is outside area for marker %2",_group,_patrolareamarker];
	};
	#ifDef GMSCore_patroArealMarker
	diagLog format["_monitorAreaPatrols: GMSCore_patroArealMarker is = %1",_patrolAreaMarker];
	#endif 

	try {
		if (_group isEqualTo GMSCore_graveyardGroup) throw -1; 
		if (isNull _group) throw -1; 
		if (({alive _x} count (units _group)) == 0) throw -1; 	
		if (_patrolAreaMarker isEqualTo "") throw -1; 
		throw 1;
	}

	catch {
		switch (_exception) do {
			case -1: {
				// nothing to do here except possibly log 
			};
			case 1: {
				private _waypointExpires = _group getVariable[GMS_waypointTeminationTime,0];
				private _veh = objectParent (leader _group);
				private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
				private _wp = [_group,0];
				private _target = [_group] call GMSCore_fnc_getHunt;
				private _speed = speed _veh; 
				diag_log format["_monitorAreaPatrols933): _group %1 | typeOf _veh %2 | speed %3 | distance to waypoint %4 | _target %5",_group, typeOf _veh, speed _veh, _veh distance (getWPpos _wp),_target];
				if (diag_tickTime > _waypointExpires && isNull _target && speed _veh < 1) then {
					[leader _group, "Monitor"] call GMSCore_fnc_nextWaypointAreaPatrol;
				};
				GMSCore_monitoredAreaPatrols pushBack _patrol;
			};
		};
	};
};




