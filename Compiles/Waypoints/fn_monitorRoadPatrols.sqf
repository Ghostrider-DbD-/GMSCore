
/*
	GMSCore_fnc_monitorRoadPatrols 

	Purpose: Checks for groups that have not reached their waypoints within a proscribed period
	and redirects them.

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 
*/

// TODO: Test functionality of this
#include "\GMSCore\Init\GMSCore_defines.hpp"
#include "\GMSCore\Init\GMSCore_defines.hpp"
if (GMSCore_monitoredRoadPatrols isEqualTo []) exitWith {};
for "_i" from 1 to (count GMSCore_monitoredRoadPatrols) do 
{
	if (_i > (count GMSCore_monitoredRoadPatrols)) exitWith {};
	private _patrol = GMSCore_monitoredRoadPatrols deleteAt 0;
	private _group = _patrol select 0;
	if !(isNull _group) then {
		private _wp = [_group, 0];
		private _currWPpos = waypointPosition _wp;
		private _stuck = [_group] call GMSCore_fnc_isStuck;

		if (_stuck) exitWith 
		{
			
			private _newPos = _leader getPos[50,(getDir _leader) - 180];
			private _wp = [_group,0];
			_wp setWaypointType "MOVE";
			_wp setWaypointCompletionRadius 0;
			[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
			_group setCurrentWaypoint [_group,0]; 
			[_group,false] call GMSCore_fnc_setStuck;
		};	
		GMSCore_monitoredRoadPatrols pushBack _patrol;
	} else {
		private _deleteOnNulllGroup = _patrol select 2;
		if !(_deleteOnNullGroup) then {
			GMSCore_monitoredRoadPatrols pushBack _patrol;
		};
	}; 
} forEach GMSCore_monitoredRoadPatrols;