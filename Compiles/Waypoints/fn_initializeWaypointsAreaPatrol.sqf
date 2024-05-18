/*
	GMSCore_fnc_initializeWaypointsAreaPatrol 
	
	Purpose: Can be used to configure an area patrol for any kind of group (infantry, land, air sea)

	Parameters:
		_group, the group to configure 
		_blackListed, areas the AI should avoid 
		_patrolAreaMarker, a marker defining the patrol area 
		_timeout, // The time that must elapse before the antistuck function takes over.

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
	["_blackListed",[]],  // areas to avoid within the patrol region
	["_patrolAreaMarker",""],  // a marker or array defining the patrol area center, size and shape
	["_timeout",300],	// the anti-stuck function will try to redirect the group after this interval in seconds
	["_garrisonChance",0],  // chance that an infantry group will garison an building of type house - ignored for vehicles.
	["_type",GMS_infrantryPatrol],  // "Soldier","Vehicle","Air","Submersible", "Turret"
	["_deletemarker",false]  //  When true the marker for the patrol will be deleted once all units and groups are gone - useful for dynamicly spawned AI and paratroops.
];  

#ifdef GMSCore_patroArealMarker diag_log format["_initializeWaypointsAreaPatrol: GMSCore_patroArealMarker is defined here"];
#endif
try {
	if (GMS_patrolLocations isEqualTo [] && (_patrolAreaMarker isEqualTo GMSCore_patroArealMarker)) throw -5; // no locations available for patrols of the entire map
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
	_group setVariable[GMS_waypointTimeoutInterval,_timeout];  // time in seconds before the waypoint is considered failed and the group will be redirected
	_group setVariable[GMSCore_patroArealMarker, _patrolAreaMarker];
	_group setVariable[GMSCore_blackListedAreas,_blacklisted];
	_group setVariable["GMS_garisonChance",_garrisonChance];
	_group setVariable["GMS_areaPatrolType",_type];
	_group setVariable[GMSCore_deleteMarker,_deleteMarker];

	[_group] call GMSCore_fnc_setGroupBehaviors;

	GMSCore_monitoredAreaPatrols pushBack [_group,_patrolAreaMarker,_deleteMarker];

	//  Set flags related to the vehicle type doing the patrol
	private _objType = _veh call BIS_fnc_objectType;
	private _cat = _objType select 0;
	private _sub = _objType select 1;
	diag_log format["\x\addons\GMSCore_fnc_updateWaypointConfigs: _veh = %1 | _objType %2 | _cat %3 | _sub %4",typeOf _veh, _objType, _cat, _sub];
	[format["_initializeWaypointAreaPatrol(62): _group = %1 | _patrolAreaMarker = %2 | _timeout = %3 | _garrisonChance = %4 | _type = %5",_group,_patrolAreaMarker,_timeout,_garrisonChance,_type]] call GMSCore_fnc_log;	

	if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then { 
		// These groups patrol the entire map regardless of whether players are nearby and need to be always simulated
		{_x enableSimulationGlobal true} forEach (units _group);
		_veh enableSimulationGlobal true;
	} else {
		// These groups patrol smaller regions and can be desimulated when no player is near 
		{_x enableDynamicSimulation true} forEach (units _group);
		_veh enableDynamicSimulation true;
	};
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
			_wp setWaypointStatements ["true","this call GMSCore_fnc_completedWaypointAreaPatrol;"];
			[leader _group,"Initialize"] call GMSCore_fnc_nextWaypointAreaPatrol;				
						
			[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol Completed for group %1 | _patrolAreaMarker %2",_group,_patrolAreaMarker]] call GMSCore_fnc_log;
		};
	};
};
