/*
	GMSCore_fnc_initializeWaypointsAreaPatrol 
	
	Purpose: Can be used to configure a patrol area for any kind of group (infantry, land, air sea)

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
	["_timeout",300],
	["_garrisonChance",0],  // chance that an infantry group will garison an building of type house - ignored for vehicles.
	["_type",GMS_infrantryPatrol],  // "Soldier","Vehicle","Air","Submersible", "Turret"
	["_deletemarker",false]
];  
private _veh = vehicle (leader _group);
private _driver = driver _veh;
//diag_log format["_initializeWaypointsAreaPatrol(34): _group %1 | typeOf _veh %2 | _driver %3 | _patrolAreaMarker %4",_group,typeOf _veh,_driver,_patrolAreaMarker];
if ((isNull _group) || _patrolAreaMarker isEqualTo ""  ) exitWith {[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: invalad parameters passed for _group = %1 AND/OR _patrolAreaMarker = %3",_group,_patrolAreaMarker],"error"] call GMSCore_fnc_log};
if (_patrolAreaMarker isEqualTo []) exitWith {
	[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: Empty array passed for _patrolAreaMarker"]] call GMSCore_fnc_log;
};

//[format["initializeWaypointAreaPatrol: _group = %1 | _patrolAreaMarker = %2 | _timeout = %3 | _garrisonChance = %4 | _type = %5",_group,_patrolAreaMarker,_timeout,_garrisonChance,_type]] call GMSCore_fnc_log;
try {
	private _valid = false;
	if (isNull _group) throw 1;
	if (_patrolAreaMarker isEqualTypeParams [[0,0,0],[0,0]]) then{_valid = true; throw 3}; 	
	if (_patrolAreaMarker isEqualType "" && (_patrolAreaMarker in allMapMarkers)) then {_valid = true;throw 3};
	if (_patrolAreaMarker isEqualTo "") throw 2; 
	if !(_patrolAreaMarker isEqualTypeParams [[0,0,0],[0,0]]) throw 2; 
	if !(_valid) throw 2;
} catch {
	switch (_exception) do {
		case 1:{  //  nullGroup 
			//[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: invalad parameters passed -   _group = %1",_group],"error"] call GMSCore_fnc_log
		};
		case 2:{
			if (_patrolAreaMarker isEqualType "") then {[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: No valid marker name passed"],"warning"] call GMSCOre_fnc_log};
			if (_patrolAreaMarker isEqualType []) then {[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: invalid position array passed: %!",_patrolAreaMarker],"warning"] call GMSCore_fnc_log};
		};
		case 3: {
			GMSCore_monitoredGroups pushBackUnique _group;
			_group setVariable[GMS_waypointTimeoutInterval,_timeout];  // time in seconds before the waypoint is considered failed and the group will be redirected
			_group setVariable["GMS_patroArealMarker",_patrolAreaMarker];
			_group setVariable["GMS_blackListedAreas",_blacklisted];
			_group setVariable["GMS_garisonChance",_garrisonChance];
			_group setVariable["GMS_areaPatrolType",_type];
			_group setVariable["GMS_deleteMarker",_deleteMarker];

			[_group] call GMSCore_fnc_setGroupBehaviors;

			[_group] call GMSCore_fnc_updateWaypointConfigs;

			//[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol: calling GMSCore_fnc_nextWaypointAreaPatrol for _group %1 | _patrolAreaMarker %2 | _type %3",_group,_patrolAreaMarker,_type]] call GMSCore_fnc_log;
			GMSCore_monitoredAreaPatrols pushBack [_group,_patrolAreaMarker,_deleteMarker];
			if !(_type isEqualTo "Turret") then {
				private _wp = [_group,0];
				_wp setWaypointStatements ["true","this call GMSCore_fnc_nextWaypointAreaPatrol;"];
				(leader _group) call GMSCore_fnc_nextWaypointAreaPatrol;				
			};		
			//[format["\x\addons\GMSCore_fnc_initializeWaypointsAreaPatrol Completed for group %1",_group]] call GMSCore_fnc_log;		
		};
	};
};