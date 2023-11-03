
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
	//diag_log format["_monitorAreaPatrols: _patrol = %1",_patrol];
	_patrol params[["_group",grpNull],["_patrolArea",[]],["_deleteOnNullGroup",true]];
	if !(isNull _group) then 
	{
		private _patrolAreaMarker = _group getVariable "GMS_patroArealMarker";
		private _patrolAreaCenter = [];
		private _patrolAreaSize = [];
		if (_patrolAreaMarker isEqualType "") then 
		{
			_patrolAreaCenter = markerPos _patrolAreaMarker;
			_patrolAreaSize = markerSize _patrolAreaMarker;
		};
		if (_patrolAreaMarker isEqualType []) then 
		{
			_patrolAreaCenter = _patrolAreaMarker select 0;
			_patrolareaSize = _patrolAreaMarker select 1;
		};	
		//[format["_monitorAreaPatrols (23): _group %1 | _area %2 | _delete %3",_group,_patrolArea,_deleteOnNullGroup]] call GMSCore_fnc_log;

		// We will not need to update waypoints for units manning static weapons
		//_group enableSimulationGlobal true;
		private _waypointExpires = _group getVariable[GMS_waypointTeminationTime,0];
		if (_waypointExpires == 0) then {_group setVariable [GMS_waypointTeminationTime,0]};

		if (diag_tickTime > _waypointExpires) then 
		{
			/*
				We may want to add some checks for combat.
			*/

			// handle stuck 
			[format["_monitorAreaPatrols: waypoint expired for _group %1 | _patrolAreaMarker %2",_group,_patrolAreaMarker]] call GMSCore_fnc_log;
			private _stuck = [_group] call GMSCore_fnc_isStuck;
			[format["\x\addons\GMSCore_fnc_monitorAreaPatrols (56) group %1 | stuck %2",_group,_stuck]] call GMSCore_fnc_log;
			(leader _group) call GMSCore_fnc_nextWaypointAreaPatrol;
		};
		if !(_patrolareaSize isEqualTo []) then {GMSCore_monitoredAreaPatrols pushBack _patrol};
	} else {
		if (!(_deleteOnNullGroup) && !(_patrolArea isEqualTo [])) then {GMSCore_monitoredAreaPatrols pushBack _patrol};
	};

};


