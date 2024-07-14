
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
private _count = count GMSCore_monitoredAreaPatrols;
//[format["\x\addons\GMSCore_fnc_monitorAreaPatrols called at %1 with _count = %2 and groups to monitor = %3",diag_tickTime, _count, count GMSCore_monitoredAreaPatrols]] call GMSCore_fnc_log;



for "_i" from 1 to (_count) do 
{
	if (_i > _count) exitWith {[format["GMSCore_fnc_monitorAreaPatrols: _i > _count"]] call GMSCore_fnc_log};
	private _patrol = GMSCore_monitoredAreaPatrols deleteAt 0;
	_patrol params[["_group",grpNull],["_patrolArea",[]],["_deleteOnNullGroup",true]];
	private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];	
	if ((leader _group) inArea _patrolAreaMarker) then {
		//diag_log format["_monitorareapatrols(29): leader group %1 is inarea for marker %2",_group,_patrolareamarker];
	} else {
		//diag_log format["_monitorareapatrols(31): leader group %1 is outside area for marker %2",_group,_patrolareamarker];
	};

	//diag_Log format["_monitorAreaPatrols(34): GMSCore_patroArealMarker is = %1",_patrolAreaMarker];
	
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
				//[format["GMSCore_fnc_monitorAreaPatrols(48): handling error exception type %1",_exception]] call GMSCore_fnc_log;
			};
			case 1: {
				[leader _group, "Monitor"] call GMSCore_fnc_nextWaypointAreaPatrol;
				GMSCore_monitoredAreaPatrols pushBack _patrol;
				//[format["GMSCore_fnc_monitorAreaPatrols(48): handling normal monitoring of group %1 type %2",_group, _exception]] call GMSCore_fnc_log;
			};
		};
	};
	
	//GMSCore_monitoredAreaPatrols pushBack _patrol;
};




