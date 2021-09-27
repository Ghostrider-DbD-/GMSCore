/*
	GMS_fnc_nextWaypointAreaPatrol 

	Purpose: set the next waypoint for a group patroling within a proscribed area set by a map marker 

	Parameters:
		_this: leader of the group to handle 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
private _leader = _this;
private _group = group _leader;
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
_group setVariable[GMS_waypointTeminationTime,diag_tickTime + _timeout];
private _wp = [_group,0];
private _patrolType = _group getVariable["GMS_areaPatrolType",GMS_infrantryPatrol];
// TODO: variable flyinheight for Air units
[_group] call GMS_fnc_setWaypointLastCheckedTime;
private _patrolAreaMarker = _group getVariable["GMS_patroArealMarker",""];

if (_patrolAreaMarker isEqualTo "") exitWith 
{
	[format["No Marker Defined for Patrol Area for group %1",_group],"error"] call GMS_fnc_log;
};
private "_maxDistanceTarget";
switch {_patrolType} do 
{
	case GMS_vehiclePatrol: {_maxDistanceTarget = 500};
	case GMS_airPatrol: {
		_maxDistanceTarget = 1000;
		private _veh = _group getVariable[GMS_groupVehicle,objNull];
		_height = _group getVariable [GMS_flyinHeight,0];
		if (_height > 0) then 
		{
			_veh flyInHeight (height + random(selectRandom[-15,15]));
		};
	};
	case GMS_submersiblePatrol: {_maxDistanceTarget = 200};
	default {_maxDistanceTarget = 300};
};

private _blacklisted = _group getVariable "GMS_blackListedAreas";
private _huntTimer = [_group] call GMS_fnc_getHuntDurationTimer;
private _patrolAreaCenter = markerPos _patrolAreaMarker;
private _patrolAreaSize = markerSize _patrolAreaMarker;

private _target = [_group] call GMS_fnc_getHunt;  // This can be set by the hunting logic or here for nearest player about which teh AI knows something
//diag_log format["_nextWaypointAreaPatrol: _target = %1",_target];
if !(isNull _target) then 
{
	if ((leader _group knowsAbout _target) < 1) then {_target == objNull};
	if ( (leader _group distance _target) > _maxDistanceTarget) then {_target = objNull};
	if (diag_tickTime > _huntTimer) then {_target == objNull};
	if !(alive _target) then {_target = objNull};
};
[_group] call GMS_fnc_setHunt;
if (isNull _target) then 
{
	// Hunting waypoints
	if (isNull _target || !(alive _target)) then
	{
		_target =  [_group,_maxDistanceTarget,2] call GMS_fnc_nearestTarget;
		[_group] call GMS_fnc_setHuntDurationTimer;
	};
};
//diag_log format["GMS_fnc_nextWaypointAreaPatrol:(58} _group %3 | _target = %1 | _vehicle %2 | nearestEnemy = %3",_target,typeOf vehicle _leader, _leader findNearestEnemy (position _leader),_group];
private _stuck = [_group] call GMS_fnc_isStuck;

if (_stuck && (isNull _target)) exitWith 
{
	private _newPos = _leader getPos[50,(getDir _leader) - 180];
	private _wp = [_group,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 0;
	[_group,"disengage"] call GMS_fnc_setGroupBehaviors; 
	_group setCurrentWaypoint [_group,0]; 
	[_group,false] call GMS_fnc_setStuck;
	{_x forceSpeed -1} forEach (units _group);	
};
if !(isNull _target && !_stuck) exitWith
{
	// Enemies nearby, set group to combat mode and engage them
	
	//[format["GMS_fnc_nextWaypointAreaPatrol (65) : enemies nearby condition : _group = %1",_group]] call GMS_fnc_log;
	private _nextPos = (position _target) getPos [
			(selectMax [(_leader distance _target)/2,10]),// keep the AI at least 10 m from the target
			(_leader getRelDir (position _target))
		];

	// Try to keep the patrol from wandering too far outside the designated patrol area, e.g., chasing players across the map
	if !([_patrolAreaCenter,_patrolAreaSize,_nextPos] call BIS_fnc_isInsideArea) then {_nextPos = _patrolAreaCenter};
	//diag_log format["_nextWaypointAreaPatrol (73): enemies detected, configuring SAD waypoint at _nextPos = %1",_nextPos];	
	_group setVariable["GMS_timeStamp",diag_tickTime];	
	_group reveal[_target,1];
	_wp setWaypointPosition [_nextPos,0];
	_wp setWaypointType "SAD";
	_wp setWaypointTimeout [45,60,75];	
	_group setCurrentWaypoint _wp;
	[_group, "combat"] call GMS_fnc_setGroupBehaviors;
	_group setSpeedMode "NORMAL";
	_group setCurrentWaypoint _wp;	
	{_x forceSpeed -1} forEach (units _group);	
	//diag_log format["_nextWaypointAreaPatrol (83): waypoint for group %1 updated to SAD waypoint at %2",_group,_nextPos];
// Patrol waypoints	
};
if (isNull _target) exitWith 
{
	// Normal execution for next waypoint 
	private "_maxDim";
	if (typeName _patrolAreaSize isEqualTo "ARRAY") then 
	{
		if (count _patrolAreaSize == 1) then {_maxDim = _patrolAreaSize select 0};
		if (count _patrolAreaSize == 2) then {_maxDim = selectMax _patrolAreaSize};
	};
	private _nextPos = [];
	private _currWPpos = getWPPos _wp;	
	if (_patrolAreaMarker isEqualTo GMS_mapMarker) then 
	{
		private _locs = nearestLocations[_currWPpos,GMS_locationsForWaypoints,2000];
		//diag_log format["NextWaypointAreaPatrol (107) Nearby Locations Found: %1",_locs];
		private _l = selectRandom _locs;		
		//diag_log format["NextWaypointAreaPatrol (108) new waypoint selected at location %1 position %2 distance %3",name _l, locationPosition _l,_currWPPos distance (locationPosition _l)];
		_nextPos = (locationPosition _l) getPos[300,random(360)];
	} else {
		_nextPos = [0,0];
		for "_i" from 1 to 10 do 
		{
			_nextPos = [[[_patrolAreaCenter,_maxDim]],["water"]] call BIS_fnc_randomPos;
			if !(_nextPos isEqualTo [0,0]) exitWith {};
		};
	};
	// random chance to occupy a house if one is found nearObjectsReady
	private _garison = if (random (1) < (_group getVariable[GMS_garisonChance,0])) then {true} else {false};

	if (_group getVariable["GMS_areaPatrolType",GMS_infrantryPatrol] isEqualTo GMS_infrantryPatrol) then 
	{
		_group setSpeedMode "NORMAL";
	} else {
		_group setSpeedMode "LIMITED";
	};
	if 	(_garison && _patrolType isEqualTo GMS_infrantryPatrol) then 
	{
		private _house = nearestBuilding _nextPos;
		if !(isNull _house) then 
		{
			_nextPos = getPosATL _house;
			_wp waypointAttachObject _house;
			_wp setWaypointPosition [_nextPos,0];
			_wp setWaypointHousePosition 0;
			_wp setWaypointTimeout  [5,7,9];
			_group setVariable["occupyHouse",_house];
			_group setCurrentWaypoint _wp;
			[_group,""] call GMS_fnc_setGroupBehaviors;
			_group setVariable[GMS_groupInHouse,true];			
		};
	} else {
		private _house = _group getVariable["occupyHouse",""];
		if !(_house isEqualTo "") then 
		{
			private _units = units _group;
			{
				if (_units isEqualTo []) exitWith {};
				private _u = _units deleteAt 0;
				_u setPosATL _x;
			} forEach (_house buildingPos -1);
			[_group,"garison"] call GMS_fnc_setGroupBehaviors;
			_wp setWaypointTimeout [15,20,25];
		} else { // wander about aimlessly
			_group setVariable["timeStamp",diag_tickTime];
			private _wp = [_group, 0];
			_wp setWaypointPosition [_nextPos,5];
			_wp setWaypointType "MOVE";
			_group setVariable["occupyHouse",""];
			_wp setWaypointTimeout  [5,7,9];
			_group setCurrentWaypoint _wp;
			[_group,""] call GMS_fnc_setGroupBehaviors;
			{_x forceSpeed -1} forEach (units _group);
			//diag_log format["_nextWaypointAreaPatrol (125): waypoint for group updated to MOVE waypoint at %2",_group,_nextPos];
		};
	};
};

/*
		Logic: If enemies known to the group are neaby, approach a random position close to the nearest enemy else move to a random location within the area to be patrolled and loiter for a period (30 secs);
*/