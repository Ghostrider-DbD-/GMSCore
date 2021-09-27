
/*
	GMS_fnc_monitorAreaPatrols 

	Purpose: Checks for groups that have not reached their waypoints within a proscribed period
	and redirects them.

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 
*/

// TODO: Test functionality of this
#include "\GMSCore\Init\GMS_defines.hpp"
//[format["GMS_fnc_monitorAreaPatrols called at %1 with %2 groups to monitor",diag_tickTime,count GMSCore_monitoredAreaPatrols]] call GMS_fnc_log;
for "_i" from 1 to (count GMSCore_monitoredAreaPatrols) do 
{
	if (_i > (count GMSCore_monitoredAreaPatrols)) exitWith {};
	private _patrol = GMSCore_monitoredAreaPatrols deleteAt 0;
	_patrol params["_group","_patrolArea","_deleteOnNullGroup"];
	//diag_log format["_monitorAreaPatrols (23): _group %1 | _area %2 | _delete %3",_group,_patrolArea,_deleteOnNullGroup];
	if (isNull _group) then   
	{
		// group is empty or delete so lets clean up anything associated with it.
		[format["GMS_fnc_monitorAreaPatrols (27): group null, removing it from cue"]];
		if (_deleteOnNullGroup) then 
		{
			[format["GMS_fnc_monitorAreaPatrols (29): deleted markers for a Null group"]] call GMS_fnc_log;
			deleteMarker _patrolArea;
		};
	} else {
		// We will not need to update waypoints for units manning static weapons
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
				private _patrolAreaCenter = markerPos _patrolAreaMarker;
				private _patrolAreaSize = markerSize _patrolAreaMarker;

				// handle stuck 
				if !([_patrolAreaCenter,_patrolAreaSize,getPos(leader _group)] call BIS_fnc_isInsideArea) then 
				{
					[format["GMS_fnc_monitorAreaPatrols (56) group %1 stuck",_group]] call GMS_fnc_log;
					[_group,true] call GMS_fnc_setWaypointStuckValue;					
					(leader _group) call GMS_fnc_nextWaypointAreaPatrol;
				};
			} else {
				// Nothing to do here, let the group try to complete the waypoint
				//[format["GMS_fnc_monitorAreaPatrols (62) group %1 last checked timestamp updated",_group]] call GMS_fnc_log;
				//[_group] call GMS_fnc_setWaypointLastCheckedTime;
			};
		};
		GMSCore_monitoredAreaPatrols pushBack _patrol;
	};
};


