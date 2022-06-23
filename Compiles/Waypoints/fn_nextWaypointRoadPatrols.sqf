/*
	GMSCore_fnc_nextWaypointRoadPatrols

	Purpose: direct a group to engage nearby enemies or, otherwise, to follow roads.

	Parameters:
		"_leader"		

	Returns: nothing 

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_leader"];

private _group = group _leader;
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
_group setVariable[GMS_waypointTeminationTime,diag_tickTime + _timeout];
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

private _target = [_group] call GMSCore_fnc_getHunt;
if (isNull _target|| {!alive _target}) then 
{
	#define searchDist 300 
	#define minKnowsAbout 2
	_target = [_group, searchDist, minKnowsAbout] call GMSCore_fnc_nearestTarget;
	// If the target is in a blacklisted location discontinue the hunt
	if ([_target, [_group] call GMSCore_fnc_getGroupBlacklist] call GMSCore_fnc_isBlacklisted) exitWith {_target = objNull};
};
//[format["nextWaypointRoadPatrols: _leader %1 | vehicle %1 | current position %3 | current direction %4 | current speed %5",_leader, typeOf (vehicle _leader),getPosATL _leader, getDir _leader,speed _leader]] call GMSCore_fnc_log;
[_group] call GMSCore_fnc_setHunt;
if !(isNull _target) then 
{
	// If the target is in a blacklisted location discontinue the hunt
	if ([_target, [_group] call GMSCore_fnc_getGroupBlacklist] call GMSCore_fnc_isBlacklisted) exitWith {_target = objNull};	
	//[format["nextWaypointRoadPatrol: case of target = %1 distance %2",_target, _leader distance _target]] call GMSCore_fnc_log;
	private _newPos = (position _target) getPos [
		(selectMax [(_leader distance _target)/2,1]),// keep the AI at least 1 m from the target
		(_leader getRelDir (position _target)) + (random(25) * selectRandom[-1,1])
		];
	//[format["GMSCore_fnc_nextWaypointRoadPatrols: _group %1 | _wp %2 | _newPos %3 | _target %4",_group,_wp,_newPos,_target]] call GMSCore_fnc_log;
	_wp setWPPos _newPos;
	_group setVariable[GMS_target,_target];
	_group reveal[_target,1];
	[_group,"combat"] call GMSCore_fnc_setGroupBehaviors;
	_wp setWaypointType "SAD";
	_wp setWaypointTimeout [45,60,75];	
	_group setCurrentWaypoint _wp;
	_group setSpeedMode "SLOW";
	_group setCurrentWaypoint _wp;	
};

if (isNull _target) then
{
	[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
	if !(isOnRoad (getPosATL (vehicle _leader))) then 
	{
		private _road = [(getPosATL _leader) getPos[100,getDir _leader],1000] call BIS_fnc_nearestRoad;
		private "_roads";
		//diag_log format["(54) _road = %1 | _road posn= %2",_road, getPosATL _road];
		if (((getPosATL _road) distance _leader) < 30) then 
		{
			private _radius = 100;
			_roads = (getPosATL _leader) nearRoads _radius;
			//diag_log format["(59) _roads = %1",_roads];
			while {_roads isEqualTo []} do 
			{
				_radius = _radius * 2;
				_roads = (getPosATL _leader) nearRoads _radius;
				//diag_log format["(64) _roads = %1",_roads];
			};
			_road = _roads select 0;
			private _index = 0;
			while {((getPosATL _road) distance _leader) < 50 && {_index < count _roads}} do {
				_index = _index + 1;
				_road = _roads select _index;
			};
		};
		_wp setWaypointPosition [(getPosATL _road),0]; //_group addWaypoint [_group,0,0,"movetoRoad"];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 0;
		[_group] call GMSCore_fnc_setGroupBehaviors; 
		_group setCurrentWaypoint [_group,0]; 
	}
	else
	{
		private "_searchPos"; 
		private _roads = [];
		private _searchDist = 100;
		while {_roads isEqualTo []} do 
		{
			_searchPos =  _leader getPos[_searchDist, getDir _leader];
			_roads = _searchPos nearRoads _searchDist;
			_searchDist = _searchDist + 25;			
		};
		private _r = _roads select 0;
		private _currPos = waypointPosition _wp;
		private _furthestPos = getPos _r;
		{
			if (_currPos distance (getPosATL _x) > (_currPos distance _furthestPos)) then 
			{
				_r = _x;
				_furthestPos = getPosATL _r;
			};
		} forEach _roads;
				
		_wp setWaypointType "MOVE";
		_wp setWPPos (position _r);
		_wp setWaypointCompletionRadius 0;
		_wp setWaypointTimeout [5,10,15];
		_group setCurrentWaypoint _wp;	
		//diag_log format["(124) currPos %1 | waypointPosition %2 | distance %3",_currPos, waypointPosition _wp, _currentPos distance (waypointPosition _wp)];
	};
};
