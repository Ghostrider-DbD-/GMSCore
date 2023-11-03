/*
	GMSCore_fnc_nextWaypointRoadPatrols

	Purpose: direct a group to engage nearby enemies or, otherwise, to follow roads.

	Parameters:
		"_leader"		

	Returns: nothing 

	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params["_leader"];

private _group = group _leader;
private _wp = [_group, 0];
private _currWPpos = waypointPosition _wp;

try {
	if (isNull _group) throw 1; 
	private _timeout = _group getVariable[GMS_waypointTimeoutInterval,60];
	private _vehicle = vehicle (leader _group);
	private _startPos = _group getVariable[GMS_waypointStartPos, getPosATL _vehicle];
	private _timeoutAt = _group getVariable[GMS_waypointTimeoutAt, diag_tickTime + _timeOut];
	private _stuck = [_group] call GMSCore_fnc_isStuck;
	private _target = [_group] call GMSCore_fnc_getHunt;	

	if (isNull _target || !alive _target) then 
	{
		#define searchDist 300 
		#define minKnowsAbout 0.2
		_target = [_group, searchDist, minKnowsAbout] call GMSCore_fnc_nearestTarget;
		// If the target is in a blacklisted location discontinue the hunt
		if ([_target, [_group] call GMSCore_fnc_getGroupBlacklist] call GMSCore_fnc_isBlacklisted) then {_target = objNull};
	};

	[_group,_target] call GMSCore_fnc_setHunt;
	if !(isNull _target) throw 2; 
	if (_stuck || !(isOnRoad (getPosATL (vehicle _leader)))) throw 3;
	if (true) throw 4; 
} 

catch {
	switch (_exception) do 
	{
		case 1: {
			// Do nothing if a null group is found. 
		};
		case 2: { // The group is hunting a target
			// If the target is now in a blacklisted location discontinue the hunt
			[_group,_target] call GMSCore_fnc_updateHunt;
		};
		case 3: { // The group is not on a road and/or is stuck 
			private _nearestVillage = nearestLocation[_currWPpos,"NameVillage"];
			private _nearestCity = nearestLocation[_currWPpos,"NameCity"];
			private _newPos = if (_currWPpos distance _nearestVillage > _currWPpos distance _nearestCity) then {locationPosition _nearestCity} else {locationPosition _nearestVillage};
			[format["_nextWaypointRoadsPatrol (58): _currWPpos %1 | _newPos %2 | distance between them %3",_currWPpos,_newPos,_currWPpos distance _newPos]] call GMSCore_fnc_log;
			[format["_nearestWaypointRoadspatrol (31):  _nearestVillage %1 | _nearestCity %2 | _nextLocation %3",name _nearestVillage,name _nearestCity,_newPos]] call GMSCore_fnc_log;
			//private _nearRoads = _newPos nearRoads 50;
			//private _newPos = getPosATL (selectRandom _nearRoads);
			_wp setWPPos _newPos;
			_group setVariable [GMS_waypointStartPos,_newPos];
			_group setVariable [GMS_waypointTimeoutAt, diag_tickTime + _timeout];
			//_wp setWaypointType "MOVE";
			_wp setWaypointType "SENTRY";
			_wp setWaypointCompletionRadius 50;
			_wp setWaypointTimeout[0.1,0.2,0.3];
			[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
			_group setCurrentWaypoint [_group,0]; 
			[_group,false] call GMSCore_fnc_setStuck;
		};
		case  4: {  //  Normal Waypoint Termination 
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
			_wp setWaypointTimeout [0,0.01,0.2];
			_group setCurrentWaypoint _wp;
		};
	};
}; 

