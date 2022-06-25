
/*
	GMSCore_fnc_monitorAreaPatrols 

	Purpose: Checks for groups that have not reached their waypoints within a proscribed period
	and redirects them.

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 
*/

// TODO: Test functionality of this
#include "\GMSCore\Init\GMSCore_defines.hpp"
//[format["GMSCore_fnc_monitorAreaPatrols called at %1 with %2 groups to monitor",diag_tickTime,count GMSCore_monitoredAreaPatrols]] call GMSCore_fnc_log;
private _count = count GMSCore_monitoredAreaPatrols;
for "_i" from 1 to (_count) do 
{
	if (_i > _count) exitWith {};
	private _patrol = GMSCore_monitoredAreaPatrols deleteAt 0;
	_patrol params["_group","_patrolArea","_deleteOnNullGroup"];
	//diag_log format["_monitorAreaPatrols (23): _group %1 | _area %2 | _delete %3",_group,_patrolArea,_deleteOnNullGroup];
	if !(isNull _group) then   
	{
		// We will not need to update waypoints for units manning static weapons
		//_group enableSimulationGlobal true;
		if !(_group getVariable["soldierType",""] isEqualTo "emplaced") then 
		{
			private _waypointExpires = _group getVariable[GMS_waypointTeminationTime,0];
			if (_waypointExpires == 0) then {_group setVariable [GMS_waypointTeminationTime,0]};

			if (diag_tickTime > _waypointExpires) then 
			{
				/*
					We may want to add some checks for combat.
				*/
	
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

				// handle stuck 
				if !([_patrolAreaCenter,_patrolAreaSize,getPos(leader _group)] call BIS_fnc_isInsideArea) then 
				{
					[format["GMSCore_fnc_monitorAreaPatrols (56) group %1 stuck",_group]] call GMSCore_fnc_log;
					[_group,true] call GMSCore_fnc_setStuck;					
					(leader _group) call GMSCore_fnc_nextWaypointAreaPatrol;
				};
			//} else {
				// Nothing to do here, let the group try to complete the waypoint
				//[format["GMSCore_fnc_monitorAreaPatrols (62) group %1 last checked timestamp updated",_group]] call GMSCore_fnc_log;
				//[_group] call GMSCore_fnc_setWaypointLastCheckedTime;
			};
		};
		GMSCore_monitoredAreaPatrols pushBack _patrol;
	};
};


