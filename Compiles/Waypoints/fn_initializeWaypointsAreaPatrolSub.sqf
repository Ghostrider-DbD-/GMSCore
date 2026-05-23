/*
	GMSCore_fnc_initializeWaypointsAreaPatrolSub
	Purpose: Can be used to configure an area patrol for any kind of group (infantry, land, air sea)

	Parameters:
		_group, the group to configure 
		_patrolAreaMarker a marker defining the patrol area 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 	

	Notes:
		By completing waypoints set within the area proscribed by the marker, the group will move about within the area circumscribed by the parameters below moving from one randome location to the next.
		If an enemy is identified, it will move toward that enemy and try to engage.
		If the group monitor determines tha ta group is 'stuck' meaning has not rotated waypoints within some proscribed period, the group will be disengaged and returned to the center of the patrol area.		
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[
	["_group",grpNull],  // group for which to configure / initialize waypoints
	["_patrolAreaMarker",""]  // a marker or array defining the patrol area center, size and shape

];  

//#ifdef GMSCore_patroArealMarker diag_log format["_initializeWaypointsAreaPatrol: GMSCore_patroArealMarker is defined here"];
//#endif
try {
	//if (GMSCore_patrolLocationsLand isEqualTo [] && (_patrolAreaMarker isEqualTo GMSCore_patroArealMarker)) throw -5; // no locations available for patrols of the entire map
	// Check for any invalid conditions or parameters 
	if ({alive _x} count (units _group) == 0) throw 0; 
	if (isNull _group) throw -3;
	if (_patrolAreaMarker isEqualTo "") throw -2; 
	if (_patrolAreaMarker isEqualType "") then {
		if !(_patrolAreaMarker in allMapMarkers) then {throw -4};	
	};

	// Initialize the group to perform area patrols
	private _veh = objectParent (leader _group);
	private _driver = driver _veh;

	GMSCore_monitoredGroups pushBackUnique _group;
	GMSCore_monitoredPatrolsSea pushBack _group;	
	_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];

	if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
		// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
		{_x enableSimulationGlobal true} forEach (units _group);
		_veh enableSimulationGlobal true;
	} else {
		// These groups patrol smaller regions and can be desimulated when no player is near 
		{_x enableDynamicSimulation true} forEach (units _group);
		_veh enableDynamicSimulation true;
	};
	
	// No problems detected
	throw 1;

} catch {
	switch (_exception) do 
	{
		case -5: {
			// No locations are available for setting destinations for patrols for the entire map.
			// This should never happen but it is best to have a check for it and disable waypoints for this group if that is the case
			[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: No locations were added as destinations - check the list in _fn_configureWorld.sqf"],"warning"] call GMSAI_fnc_log;
		};
		case -4: { // The marker name was not found in allMapMarkers
			[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: Marker name %1 not found in allMapMarkers"],"warning"] call GMSAI_fnc_log;
		};

		case -3:{  //  nullGroup 
			[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: nullGroup passed for marker %1",_patrolAreaMarker],"warning"] call GMSAI_fnc_log
		};
		
		case -2:{   // _patrolAreaarker == "" ; 
			[format['\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: _patrolAreaMarker set to ""'],"warning"] call GMSAI_fnc_log;
		};

		case -1: {  // array describing marker not formatted properly  
			[format["_initializeWaypointsAreaPatrol: _patrolAreaMarker = %1 | Not formated as [[0,0,0], sizeX, sizeY, rotation, delete]",_patrolAreaMarker],'warning'] call GMSAI_fnc_log;
		};

		case 0: { // No alive units left in group
			[format["_initializeWaypointsAreaPatrol: No units were found in _group %1 | _patrolAreaMarker = %2",_group,_patrolAreaMarker],'warning'] call GMSAI_fnc_log;
		};

		case 1: {
			private _wp = [_group,0];
			_wp setWaypointStatements ["true","[this, 'Completed'] call GMSCore_fnc_completedWaypointAreaPatroSub;"];
			[leader _group,"Initialize"] call GMSCore_fnc_nextWaypointAreaPatrolLand;				
						
			//[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol Completed for group %1 | _patrolAreaMarker %2",_group,_patrolAreaMarker]] call GMSCore_fnc_log;
		};
	};
};
