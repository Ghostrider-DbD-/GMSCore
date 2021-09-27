/*
	GMS_fnc_nextWaypointRoadPatrols

	Purpose: direct a group to engage nearby enemies or, otherwise, to follow roads.

	Parameters:
		"_leader"		

	Returns: nothing 

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params[
	"_leader"
];

private _group = group _leader;
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
_group setVariable[GMS_waypointTeminationTime,diag_tickTime + _timeout];
private _wp = [_group, 0];
private _currWPpos = waypointPosition _wp;
private _target = [_group] call GMS_fnc_getHunt;
if (isNull _target|| !alive _target) then 
{
	#define searchDist 300 
	#define minKnowsAbout 2
	_target = [_group, searchDist, minKnowsAbout] call GMS_fnc_nearestTarget;
};
//[format["nextWaypointRoadPatrols: _leader %1 | vehicle %1 | current position %3 | current direction %4 | current speed %5",_leader, typeOf (vehicle _leader),getPosATL _leader, getDir _leader,speed _leader]] call GMS_fnc_log;

if !(isNull _target) then 
{
	//[format["nextWaypointRoadPatrol: case of target = %1 distance %2",_target, _leader distance _target]] call GMS_fnc_log;
	_group setVariable[GMS_target,_target];
	private _newPos = (position _target) getPos [
		(selectMax [(_leader distance _target)/2,10]),// keep the AI at least 10 m from the target
		(_leader getRelDir (position _target)) + (random(25) * selectRandom[-1,1])
		];
	_wp setWaypointPosition _newPos;
	_group setVariable[GMS_target,_target];
	_group reveal[_target,1];
	[_group,"combat"] call GMS_fnc_setGroupBehaviors;
	_wp setWaypointPosition [_nextPos,0];
	_wp setWaypointType "SAD";
	_wp setWaypointTimeout [45,60,75];	
	_group setCurrentWaypoint _wp;
	_group setSpeedMode "SLOW";
	_group setCurrentWaypoint _wp;	
} else {
	private _stuck = [_group] call GMS_fnc_isStuck;
	if (_stuck) exitWith 
	{
		private _newPos = _leader getPos[50,(getDir _leader) - 180];
		private _wp = [_group,0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 0;
		[_group,"disengage"] call GMS_fnc_setGroupBehaviors; 
		_group setCurrentWaypoint [_group,0]; 
		[_group,false] call GMS_fnc_setStuck;
	};

	if !(isOnRoad (getPosATL (vehicle _leader))) exitWith 
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
			while {((getPosATL _road) distance _leader) < 50 && _index < count _roads} do {
				_index = _index + 1;
				_road = _roads select _index;
			};
		};
		//[format["nextWaypointRoadPatrols: case of no target and off road: current pos %1 | nearest road %2 at distance of %3",getPosATL _leader, getPosATL _road, _leader distance _road]] call GMS_fnc_log;
		//[format["nextWaypointRoadPatrols: Distance to next waypoint = %1",_leader distance _road]] call GMS_fnc_log;
		_wp setWaypointPosition [(getPosATL _road),0]; //_group addWaypoint [_group,0,0,"movetoRoad"];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 0;
		[_group] call GMS_fnc_setGroupBehaviors; 
		_group setCurrentWaypoint [_group,0]; 
	};
	if (isOnRoad (getPosATL (vehicle _leader))) then 
	{
		private "_searchPos"; 
		private _roads = [];
		private _searchDist = 100;
		while {_roads isEqualTo []} do 
		{
			_searchPos =  _leader getPos[_searchDist, getDir _leader];
			_roads = _searchPos nearRoads _searchDist;
			//diag_log format["(106) leader pos %1 | _searchPos %2 | searchDist %3 | distance to searchPos %4",position _leader, _searchPos, _searchDist, _leader distance _searchPos];
			_searchDist = _searchDist + 25;			
		};
		private _r = _roads select 0;
		private _currPos = waypointPosition _wp;
		private _furthestPos = getPos _r;
		{
			if (_currPos distance (getPos _x) > (_currPos distance _furthestPos)) then 
			{
				_r = _x;
				_furthestPos = getPos _r;
			};
		} forEach _roads;
				
		//diag_log format["(109) _group = %1 | _groupPos %2 |_wp = %3 | _currPos %4 | _searchPos %5 | _searchDist %6 | _road %7 | _r %8 | pos _r %9 | distance %10",_group,getPos _leader,_wp,_currPos,_searchPos,_searchDist,_roads, _r, getPos _r, _leader distance _r,_wp, _group];
		_wp setWaypointType "MOVE";
		_wp setWPPos (position _r);
		_wp setWaypointCompletionRadius 0;
		_wp setWaypointTimeout [5,10,15];
		_group setCurrentWaypoint _wp;	
		//diag_log format["(124) currPos %1 | waypointPosition %2 | distance %3",_currPos, waypointPosition _wp, _currentPos distance (waypointPosition _wp)];
		[_group] call GMS_fnc_setGroupBehaviors;  // set the default group behaviors
	};
};
