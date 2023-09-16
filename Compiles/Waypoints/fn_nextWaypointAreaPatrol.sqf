
/*
	GMSCore_fnc_nextWaypointAreaPatrol 
	Purpose: set the next waypoint for a group patroling within a proscribed area set by a map marker 
	Parameters:
		_this: leader of the group to handle 
	Returns: None 
	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
private _leader = _this;
if (_leader isEqualType []) then {_leader = _leader select 0};
//[format["GMSCore_fnc_nextWaypointAreaPatrol: _leader = %1",_leader]] call GMSCore_fnc_log;
if !(typeOf _leader isEqualTo GMSCore_unitType) exitWith 
{
	//[format["GMSCore_fnc_nextWaypointAreaPatrol: _leader %1 passed with typeOf = %2",_leader,typeOf _leader]] call GMSCore_fnc_log;
};
private _group = group _leader;
if (_group isEqualTo GMSCore_graveyardGroup) exitWith {};
private _veh = vehicle _leader;
private _GMSgroup = _group getVariable["GMS_group",false];
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
_group setVariable[GMS_waypointTeminationTime,diag_tickTime + _timeout];
private _wp = [_group,0];
private _patrolType = _group getVariable["GMS_areaPatrolType",GMS_infrantryPatrol];
[_group] call GMSCore_fnc_setWaypointLastCheckedTime;
private _patrolAreaMarker = _group getVariable["GMS_patroArealMarker",""];
//[format["GMSCore_fnc_nextWaypointAreaPatrol: _group %1 | _GMSgroup = %5 | typeOf _veh %2 | _patrolType %3 | _patrolAreaMarker %4 ",_group, typeOf _veh, _patrolType, _patrolAreaMarker, _GMSgroup]] call GMSCore_fnc_log;
if (_patrolAreaMarker isEqualTo "") exitWith 
{
	[format["No Marker Defined for Patrol Area for group %1",_group],"error"] call GMSCore_fnc_log;
};

private _typeOf = _veh call BIS_fnc_objectType;
private _maxDistanceTarget = _group getVariable[GMS_maxDistanceTarget,50];
//diag_log format["_nextWaypointAreaPatrol: _maxDistanceTarget = %1",_maxDistanceTarget];
private _blacklisted = _group getVariable "GMS_blackListedAreas";
private _huntTimer = [_group] call GMSCore_fnc_getHuntDurationTimer;
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

private _target = [_group] call GMSCore_fnc_getHunt;  // This can be set by the hunting logic or here for nearest player about which teh AI knows something
//diag_log format["_nextWaypointAreaPatrol: _target = %1",_target];
if !(isNull _target) then 
{
	// If the target is now in a blacklisted location discontinue the hunt
	if ([_target, [_group] call GMSCore_fnc_getGroupBlacklist] call GMSCore_fnc_isBlacklisted) exitWith {_target = objNull};
	if ((leader _group knowsAbout _target) < 1) then {_target == objNull};
	if ( (leader _group distance _target) > _maxDistanceTarget) then {_target = objNull};
	if (diag_tickTime > _huntTimer) then {_target == objNull};
	if !(alive _target) then {_target = objNull};
};

if (isNull _target || {!(alive _target)}) then
{
	private _retest = true;
	_target =  [_group,_maxDistanceTarget,2] call GMSCore_fnc_nearestTarget;
	// Check if the new target is in a blacklisted location and if so deal with that.
	if ([_target, [_group] call GMSCore_fnc_getGroupBlacklist] call GMSCore_fnc_isBlacklisted) then {_target = objNull};
	[_group,_target] call GMSCore_fnc_setHunt;
	[_group] call GMSCore_fnc_setHuntDurationTimer;
};

//diag_log format["GMSCore_fnc_nextWaypointAreaPatrol:(58} _group %3 | _target = %1 | _vehicle %2 | nearestEnemy = %3",_target,typeOf vehicle _leader, _leader findNearestEnemy (position _leader),_group];
 private _stuck = [_group] call GMSCore_fnc_isStuck;

if (_stuck && {(isNull _target)}) exitWith 
{
	private _newPos = _leader getPos[50,(getDir _leader) - 180];
	private _wp = [_group,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 0;
	[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
	_group setCurrentWaypoint [_group,0]; 
	[_group,false] call GMSCore_fnc_setStuck;
	{_x forceSpeed -1} forEach (units _group);	
};

if !(isNull _target && {!_stuck}) exitWith
{
	// Enemies nearby, set group to combat mode and engage them
	
	//[format["GMSCore_fnc_nextWaypointAreaPatrol (65) : enemies nearby condition : _group = %1",_group]] call GMSCore_fnc_log;
	private _nextPos = (position _target) getPos [
			(selectMax [(_leader distance _target)/2,1]),// keep the AI at least 1 m from the target
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
	_wp setWaypointCompletionRadius 5;	
	_group setCurrentWaypoint _wp;
	[_group, "combat"] call GMSCore_fnc_setGroupBehaviors;
	_group setSpeedMode "NORMAL";
	_group setCurrentWaypoint _wp;	
	{_x forceSpeed -1} forEach (units _group);	
	//diag_log format["_nextWaypointAreaPatrol (83): waypoint for group %1 updated to SAD waypoint at %2",_group,_nextPos];
// Patrol waypoints	
};

if (isNull _target) then 
{
	// Normal execution for next waypoint 
	private "_maxDim";
	if (_patrolAreaSize isEqualType []) then 
	{
		if (count _patrolAreaSize == 1) then {_maxDim = _patrolAreaSize select 0};
		if (count _patrolAreaSize == 2) then {_maxDim = selectMax _patrolAreaSize};
	};
	private _nextPos = [];
	private _currWPpos = getWPPos _wp;	
	if (_patrolAreaMarker isEqualTo GMS_mapMarker) then 
	{
		if (GMS_patrolLocations isEqualTo []) then 
		{
				private _gmsMarker = [] call GMSCore_fnc_getMapMarker;
				private _center = markerPos _gmsMarker;
				private _radius = ((markerSize _gmsMarker) select 0)/3;
				_nextPos = [[[_center,_radius]],["water"]] call BIS_fnc_randomPos;
				//[format["GMSCore_fnc_nextWaypointAreaPatrol: No Patrol Locations specified, new waypoint found by BIS_fnc_randompos of %1",_nextPos]] call GMSCore_fnc_log;
		} else {
			private _l = selectRandom GMS_patrolLocations;
			_nextPos = (locationPosition _l) getPos[300,random(360)];
			//[format["GMSCore_fnc_nextWaypointAreaPatrol: Location based waypoint selected using location = %1 at postion = %2",_l,_nextPos]] call GMSCore_fnc_log;
		};
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
	if 	(_garison && {_patrolType isEqualTo GMS_infrantryPatrol}) then 
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
			[_group,""] call GMSCore_fnc_setGroupBehaviors;
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
			[_group,"garison"] call GMSCore_fnc_setGroupBehaviors;
			_wp setWaypointTimeout [15,20,25];
		} else { // wander about aimlessly
			_group setVariable["timeStamp",diag_tickTime];
			private _wp = [_group, 0];
			_wp setWaypointPosition [_nextPos,5];
			_wp setWaypointType "MOVE";
			_group setVariable["occupyHouse",""];
			_wp setWaypointTimeout  [5,7,9];
			_wp setWaypointCompletionRadius 5;
			_group setCurrentWaypoint _wp;
			[_group,""] call GMSCore_fnc_setGroupBehaviors;
			{_x forceSpeed -1} forEach (units _group);
			//diag_log format["_nextWaypointAreaPatrol (125): waypoint for group updated to MOVE waypoint at %2",_group,_nextPos];
		};
	};
};

/*
		Logic: If enemies known to the group are neaby, approach a random position close to the nearest enemy else move to a random location within the area to be patrolled and loiter for a period (30 secs);
*/