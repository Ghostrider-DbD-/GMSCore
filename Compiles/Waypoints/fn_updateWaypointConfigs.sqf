/*
	GMSCore_fnc_updateWaypointConfigs
	Purpose: set the Maxximum Distance form a target for the group. 

	Parameters: 
		_group, the group to be handled 
	
	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 

	Notes: 	
	If the group monitor determines tha ta group is 'stuck' meaning has not rotated waypoints within some proscribed period, the group will be disengaged and returned to the center of the patrol area.
	TODO: see why the default is false.
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_group"];
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