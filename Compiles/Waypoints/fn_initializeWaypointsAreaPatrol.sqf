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

#include "\GMSCore\Init\GMSCore_defines.hpp"
params[
	["_group",grpNull],  // group for which to configure / initialize waypoints
	["_blackListed",[]],  // areas to avoid within the patrol region
	["_patrolAreaMarker",""],  // a marker or array defining the patrol area center, size and shape
	["_timeout",300],
	["_garrisonChance",0],  // chance that an infantry group will garison an building of type house - ignored for vehicles.
	["_type",GMS_infrantryPatrol],  // "infantry","vehicle","air","submersible", "turret"
	["_deletemarker",false]
];  


if ((isNull _group) || _patrolAreaMarker isEqualTo ""  ) exitWith {[format["GMSCore_fnc_initializeWaypointsAreaPatrol: invalad parameters passed for _group = %1 AND/OR _patrolAreaMarker = %3",_group,_patrolAreaMarker],"error"] call GMSCore_fnc_log};
if (_patrolAreaMarker isEqualTo []) exitWith {[format["GMSCore_fnc_initializeWaypointsAreaPatrol: Empty array passed for _patrolAreaMarker"]] call GMSCore_fnc_log};
if (_patrolAreaMarker isEqualType [] && (count _patrolAreaMarker >= 2) && (_patrolAreaMarker select 1) isEqualTo []) exitWith {[format["GMSCore_fnc_initializeWaypointsAreaPatrol: No size specified for patrol area | _patrolAreaMarker = %1",_patrolAreaMarker]] call GMSCore_fnc_log};
//[format["initializeWaypointAreaPatrol: _group = %1 | _patrolAreaMarker = %2 | _timeout = %3 | _garrisonChance = %4 | _type = %5",_group,_patrolAreaMarker,_timeout,_garrisonChance,_type]] call GMSCore_fnc_log;
try {
	if (isNull _group) throw 1;
	if (_patrolAreaMarker isEqualTo "") throw 2; 
	if (_patrolAreaMarker isEqualTo []) throw 2; 
	if ((_patrolAreaMarker isEqualTypeArray) {&& (count _patrolAreaMarker) isEqualTo 2 {&& (_patrolAreaMarker select 1 isEqualTo [])}}) throw 2;
	if (_patrolAreaMarker isEqualTypeArray || _patrolAreaMarker isEqualType "") throw 3;
} catch {
	switch (_exception) do {
		case 1:{  //  nullGroup 
			[format["GMSCore_fnc_initializeWaypointsAreaPatrol: invalad parameters passed -   _group = %1",_group],"error"] call GMSCore_fnc_log
		};
		case 2:{
			if (_patrolAreaMarker isEqualTo "") then {[format["GMSCore_fnc_initializeWaypointsAreaPatrol: No marker name passed"]"warning"] call GMSCOre_fnc_log};
			if (_patrolAreaMarker isEqualTypeArray) then {[forma["GMSCore_fnc_initializeWaypointsAreaPatrol: invalide position array passed: %!",_patrolArrayMarker],"warning"] call GMSCore_fnc_log};
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

			private _veh = vehicle (leader _group);
			private _objType = _veh call BIS_fnc_objectType;
			private _cat = _objType select 0;
			private _sub = _objType select 1;
			diag_log format["GMSCore_fnc_initializeWaypointsAreaPatrol: _veh = %1 | _objType %2 | _cat %3 | _sub %4",typeOf _veh, _objType, _cat, _sub];
			private _wp = [_group,0];

			//diag_log format["_objType = %1",_objType];
			switch (_cat) do
			{
				case "Vehicle": { 
					//hint "Vehicle";
					switch (_sub) do 
					{
						case "Plane": {
							//diag_log "Vehicle:Plane";
							_group setVariable[GMS_maxDistanceTarget,500];
						};
						case "Helicopter": {
							//diag_log "Vehicle:Helicopter";
							_group setVariable[GMS_maxDistanceTarget,300];				
						};
						case "Ship": {
							//diag_log "Vehicle:Ship";
							_group setVariable[GMS_maxDistanceTarget,150];				
						};
						case "Submarine": {
							//diag_log "Vehicle:Submarine";
							_group setVariable[GMS_maxDistanceTarget,50];				
						};
						case "Tank": {
							//diag_log "Vehicle:Tank";
							_group setVariable[GMS_maxDistanceTarget,200];				
						};
						case "TrackedAPC": {
							//diag_log "Vehicle:TrackedAPC";
							_group setVariable[GMS_maxDistanceTarget,200];				
						};
						case "WheeledAPC": {
							//diag_log "Vehicle:WheeledAPC";
							_group setVariable[GMS_maxDistanceTarget,200];				
						};
						case "Car": {
							//diag_log "Vehicle:Car";
							_group setVariable[GMS_maxDistanceTarget,100];				
						};
						case "StaticWeapon": {
							_group setVariable[GMS_maxDistanceTarget,300];	
						};
						default {
							//diag_log "Vehicle";
							_group setVariable[GMS_maxDistanceTarget,100];				
						};
					};
				};
				case "VehicleAutonomous": { 
					hint "VehicleAutonomous";
					switch (_sub) do 
					{
						case "Plane": {
							//diag_log "Plane";
							_group setVariable[GMS_maxDistanceTarget,300];				
						};
						case "Helicopter": {
							//diag_log "Helicopter";
							_group setVariable[GMS_maxDistanceTarget,300];				
						};
						case "Car": {
							//diag_log "Car";
							_group setVariable[GMS_maxDistanceTarget,100];				
						};
						default {
							//diag_log "Vehicle";
							_group setVariable[GMS_maxDistanceTarget,100];				
						};		
					};
				};
				case "Soldier": {
					//diag_log "Soldier";
					_group setVariable[GMS_maxDistanceTarget,50];	
				};
				default { 
					//diag_log "default";
					_group setVariable[GMS_maxDistanceTarget,50];		
				};
			};
			[format["GMSCore_fnc_initializeWaypointsAreaPatrol: calling GMSCore_fnc_nextWaypointAreaPatrol for _group %1 | _patrolAreaMarker %2 | _type %3",_group,_patrolAreaMarker,_type]] call GMSCore_fnc_log;
			GMSCore_monitoredAreaPatrols pushBack [_group,_patrolAreaMarker,_deleteMarker];
			_wp setWaypointStatements ["true","this call GMSCore_fnc_nextWaypointAreaPatrol;"];		
			(leader _group) call GMSCore_fnc_nextWaypointAreaPatrol;
			[format["GMSCore_fnc_initializeWaypointsAreaPatrol Completed for group %1",_group]] call GMSCore_fnc_log;			
		};
	};
}:


