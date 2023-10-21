/*
	GMSCore_fnc_nextWaypointRoadPatrols

	Purpose: direct a group to engage nearby enemies or, otherwise, to follow roads.

	Parameters:
		"_leader"		

	Returns: nothing 

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params["_leader"];

private _group = group _leader;
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,60];
private _startPos = _group getVariable[GMS_waypointStartPos, getPosATL _vehicle];
private _timeoutAt = _group getVariable[GMS_waypointTimeoutAt, diag_tickTime + _timeOut];
private _wp = [_group, 0];
private _currWPpos = waypointPosition _wp;

private _stuck = [_group] call GMSCore_fnc_isStuck;
[format["_nextWaypointRoadsPatrol (24): _group %1 | _stuck %2",_group,_stuck]] call GMSCore_fnc_log;
if (_stuck) exitWith 
{
	private _newPos = _leader getPos[125,(getDir _leader) - 180];
	private _nearRoads = _newPos nearRoads 500;
	private _newPos = getPosATL (selectRandom _nearRoads);
	private _wp = [_group,0];
	_wp setWPPos _newPos;
	_group setVariable [GMS_waypointStartPos,_newPos];
	_group setVariable [GMS_waypointTimeoutAt, diag_tickTime + _timeout];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 0;
	_wp setWaypointTimeout[0.1,0.2,0.3];
	[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
	_group setCurrentWaypoint [_group,0]; 
	[_group,false] call GMSCore_fnc_setStuck;
	//[format["_nextWaypointRoadsPatrols: waypoint for stuck group %1 in vehicle typeOf %2 set to position %3 at direction %4 and distance %5",_group, vehicle(leader _group),getPosATL (leader _group) getRelDir _newPos, getPosATL (leader _group) distance _newPos]] call GMSCore_fnc_log;
};

private _target = [_group] call GMSCore_fnc_getHunt;
if (isNull _target || !alive _target) then 
{
	#define searchDist 300 
	#define minKnowsAbout 0.2
	_target = [_group, searchDist, minKnowsAbout] call GMSCore_fnc_nearestTarget;
	// If the target is in a blacklisted location discontinue the hunt
	if ([_target, [_group] call GMSCore_fnc_getGroupBlacklist] call GMSCore_fnc_isBlacklisted) then {_target = objNull};
};
//[format["nextWaypointRoadPatrols: _leader %1 | vehicle %1 | current position %3 | current direction %4 | current speed %5",_leader, typeOf (vehicle _leader),getPosATL _leader, getDir _leader,speed _leader]] call GMSCore_fnc_log;
[_group,_target] call GMSCore_fnc_setHunt;
if !(isNull _target) then 
{
	//[format["nextWaypointRoadPatrol: case of target = %1 distance %2",_target, _leader distance _target]] call GMSCore_fnc_log;
	if ([_group,_target] call GMSCore_fnc_groupCanSee) then {
		private _newPos = _currWPpos getPos [10,random (359)];
	} else { // move to a new position to try to see the target
		private _newPos = (position _target) getPos [
			(selectMax [(_leader distance _target)/2,1]),// keep the AI at least 1 m from the target
			(_leader getRelDir (position _target)) + (random(60) * selectRandom[-1,1])
			];
	};

	//[format["GMSCore_fnc_nextWaypointRoadPatrols: _group %1 | _wp %2 | _newPos %3 | _target %4",_group,_wp,_newPos,_target]] call GMSCore_fnc_log;
	_wp setWPPos _newPos;
	_group setVariable[GMS_target,_target];
	_group reveal[_target,1];
	[_group,"combat"] call GMSCore_fnc_setGroupBehaviors;
	_wp setWaypointType "SAD";
	_wp setWaypointCompletionRadius 0;	
	_wp setWaypointTimeout [1,3,5];	
	_group setCurrentWaypoint _wp;
	_group setSpeedMode "SLOW";
	_group setCurrentWaypoint _wp;	
};

if (isNull _target) then
{
	[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
	if !(isOnRoad (getPosATL (vehicle _leader))) then 
	{
		private _roads = ((getPosATL _leader) getPos[100, random(359)]) nearRoads 500;
		private _road = selectRandom _roads;
		diag_log format["(54) _road = %1 | _road posn= %2 | _road distance = %3",_road, getPosATL _road, _road distance (getPosATL (leader _group))];
		_wp setWaypointPosition [(getPosATL _road),0]; //_group addWaypoint [_group,0,0,"movetoRoad"];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 0;
		_wp setWaypointTimeout [0,0.1,0.2];
		[_group] call GMSCore_fnc_setGroupBehaviors; 
		_group setCurrentWaypoint _wp;
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
		_wp setWPPos (getPosATL _r);
		_wp setWaypointCompletionRadius 0;
		_wp setWaypointTimeout [0,0.1,0.15];
		_group setCurrentWaypoint _wp;	
		diag_log format["(124) currPos %1 | waypointPosition %2 | distance %3",_currPos, waypointPosition _wp, (getPosATL _leader) distance (waypointPosition _wp)];
	};
};
