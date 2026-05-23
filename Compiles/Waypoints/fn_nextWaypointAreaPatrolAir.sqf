
/*
	GMSCore_fnc_nextWaypointAreaPatrolAir 
	Purpose: set the next waypoint for a group patroling within a proscribed area set by a map marker 
	Parameters:
		_this: leader of the group to handle 
	Returns: None 
	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

/*
	Possible exceptions: -6 - group _leader is objNull
						-5 _group _leader has no alive units 
						-4 _leader is empty array 
						-3 _group is in GMSCore_graveyardGroup 
						-2 _patrolAreaMarker == "" 
						-1 _patrolAreaMarker isTypeOf "" but not (in allMapMarkers)
						0 _patrolAreaMarker isTypeOf [] but does not have valid parameters 
*/
params[
	["_leader",objNull],
	["_state","Completed"]  //  "Initialize", "Completed","Monitor", "outOfArea"
];

//diag_log format["_nextWaypointAreaPatrolAir: _this = %1",_this];

// Information we need to parse descision tree 
private _veh = objectParent (_leader);
private _group = group _leader;
if (isNull _veh) then {_veh = _group getVariable ["assignedToVehicle", objNull]};
private _wp = [_group,0];
private _speed = velocity _veh;
private _isHunting = [_group] call GMSCore_fnc_getHunt;
private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];
private _antiStuckTime = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer");
private _newPos = [0,0,0];
private _isBlackListed = false; 
private _blackList = [];

try {
	// A set of descisions/evaluations needed to understand the state of the group

	if (_patrolAreaMarker isEqualTo "") throw -2; 
	if !(_patrolAreaMarker in allMapMarkers) throw -1;
	if !(_patrolAreaMarker isEqualType "") throw 0;
	//if (_state isEqualTo "Initialize") throw 1; 
	if (_state isEqualTo "Completed") then {
		if (_isHunting)	then {
			throw 3; 
		} else {
			throw 2;
		};
	};	
	//if (_state isEqualTo "Hunt") throw 3;
	if (_state isEqualTo "Disengage") throw 4;

	// Initialized is a special case because there is no prior setup, and no concern about something being where it should not be or being stuck; 
}

catch {
	switch (_exception) do {
		/*  Possible Errors are handled first */ 
		/*
			Possible exceptions:
				-6 - group _leader is objNull
				-5 _group _leader has no alive units 
				-4 _leader is empty array 
				-3 _group is in GMSCore_graveyardGroup 
				-2 _patrolAreaMarker == "" 
				-1 _patrolAreaMarker isTypeOf "" but not (in allMapMarkers)
				0 _patrolAreaMarker !isTypeOf "" but does not have valid parameters 
		*/
		case -6: {
			if (GMSCore_debug > 0) exitWith {
				[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol: for _patrolAreaMarker %1 | _group == nullGrp", _patrolAreaMarker],"warning"] call GMSCore_fnc_log;
			};
		};

		case -5: {
			[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol: for _patrolAreaMarker %1 | group as no alive units", _patrolAreaMarker],"warning"] call GMSCore_fnc_log;
		};

		case -4: {
			[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol: for _patrolAreaMarker %1 | _leader == []", _patrolAreaMarker],"warning"] call GMSCore_fnc_log;
		};

		case -3: {
			[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol: for _patrolAreaMarker %1 | group is in the GMSCore_graveyardGroup", _patrolAreaMarker],"warning"] call GMSCore_fnc_log;
		};

		case -2: {
			[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol: for _patrolAreaMarker == '' "],"warning"] call GMSCore_fnc_log;
		};

		case -1: {
			[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol:  _patrolAreaMarker %1 !(in allMapMarkers)", _patrolAreaMarker],"warning"] call GMSCore_fnc_log;
		};

		case 0: {
			[format["\x\addons\GMSCore_fnc_nextWaypointsAreaPatrol: _patrolAreaMarker %1 is not a string", _patrolAreaMarker],"warning"] call GMSCore_fnc_log;
		};


		/* Actionalble cases are handled next */ 
		/*
	
		*/
		case 1: {  // Initialize Waypoint
			// TODO: Is this still used ?
						
		};

		case 2:  { // Waypoint completed 
			_group setVariable["isStuck", false];	
			_isBlacklisted = true;
			private _minRange = _group getVariable["minWPdist", minDistWP_Air];
			private _maxRange = _group getVariable["maxWPdist", maxDistWP_Air];
			//private _noAgro = _group getVariable["maxDistAgro", NO_AGRO_RANGE_AIR];
				
			if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then {
				#define minimunNumberLocations 10
				private _newLocation = "";					
				private _locationsList = [getPosATL _veh, [LOCATION_TYPES_AIR], _maxRange, minimunNumberLocations] call GMSCore_fnc_findNearestLocations;
				while {_isBlacklisted} do {
					_newLocation =[getPosATL _veh, _minRange, _maxRange * 2, _locationsList] call GMSCore_fnc_getRandomLocation;
					_newPos = (position _newLocation) getPos [100 + random(100), random(359)];
					_blackList = nearestLocations[_newPos, [WAYPOINT_DISALLOWED_AREAS], 300];
					_isBlacklisted = [_newPos, _blackList] call GMSCore_fnc_isBlacklisted;				
				};
			} else {
				_newPos = position leader _group;
				private _tries = 0;
				while {_tries < 25 and (position leader _group distance _newPos < 200) && _isBlackListed} do {
					_newPos = _patrolAreaMarker call BIS_fnc_randomPosTrigger;
					_blackList = nearestLocations[_newPos, [WAYPOINT_DISALLOWED_AREAS], _maxRange];
					_isBlacklisted = [_newPos, _blackList] call GMSCore_fnc_isBlacklisted;
					_tries = _tries + 1;
				};
			};
					
			[_group, "Normal"] call GMSCore_fnc_setGroupBehavior;
			
			_wp setWPpos _newPos; 
			_wp setWPPos _newPos;
			_wp setWaypointType "MOVE";
			_wp setWaypointTimeout [1, 2, 3];
			_wp setWaypointCompletionRadius 150;	
			_wp setWaypointSpeed "NORMAL"; 
			_wp setWaypointStatements ["true","[this] spawn GMSCore_fnc_detectPlayerAir"];

			private _wp1 = [_group, 1];
			_wp1 setWPpos _newPos; 
			_wp1 setWaypointType "MOVE"; 
			_wp1 setWaypointTimeout [1, 2, 3];
			_wp1 setWaypointCompletionRadius 150;				
			_wp1 setWaypointSpeed "LIMITED";
			_wp1 setWaypointStatements ["true","[this,'Completed'] spawn GMSCore_fnc_nextWaypointAreaPatrolAir"];
			private _wp2 = [_group, 2];
			_wp2 setWPpos _newPos; 
			_wp2 setWaypointType "CYCLE";
			_wp2 setWaypointCompletionRadius 150;
			_wp2 setWaypointTimeout [1,2,3];

			_group setCurrentWaypoint _wp;
			_group setSpeedMode "NORMAL";		
			_group setVariable["antiStuckPos", _newPos];
			_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];
			
			if (GMSCore_debug > 0) then {[_group] call GMSCore_fnc_updateGroupDebugMarker};
		};	
		case 3: {  //  Hunt a player 
			private _tries = 0;
			private _newPos = [];
			private _target = [_group] call GMSCore_fnc_getTarget;
			private _detected = +[_group] call GMSCore_fnc_getDetectedTargets;
			private _minRange = _group getVariable["minWPdist", minDistWP_Heli];
			private _maxRange = _group getVariable["maxWPdist", maxDistWP_Heli];
			private _maxDistanceEnemy = _group getVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_AIR];
			private _maxAgroDist = _group getVariable["maxDistAgro", NO_AGRO_RANGE_AIR];
			//private _nearestEnemys = (getPosATL _veh) nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle"]], _maxDistanceEnemy];
			private _continue = true;
			while {(isNull _target) && !(_detected isEqualTo []) && _continue} do {
				_target = _detected deleteAt 0;
				if !(isNull _target) then {_continue = false};
			};
			if (isNull _target) then {
				_group setVariable["isHunting", false];
				[_group, "Safe"] call GMSCore_fnc_setGroupBehavior;
				_group setCurrentWaypoint [_group, _wp];		
				// Completion of this waypoint set will result in a call to GMSC0re_fnc_nextWaypointAreaPatrolAir
				//[leader _group, "Completed"] call GMSCore_fnc_nextWaypointsAreaPatrol;
			} else {
				private _radius =_maxDistanceEnemy;
				private _targetPos = getPosATL _target;
				while {_tries < 10 && _newPos isEqualTo []} do {
					private _testPos = (_targetPos) getPos[(_radius / 2) + (random (_radius / 2)), random 365];
					_blacklist = nearestLocations[_testPos, [WAYPOINT_DISALLOWED_AREAS], _maxAgroDist];
					if !([_testPos, _blacklist] call GMSCore_fnc_isBlacklisted) then {
						if (getPosATL _veh distance _testPos > _minDistAir) then {
							_newPos = _testPos;
						} else {
							_tries = tries + 1;
						};
					};
				};
				if !(_newPos isEqualTo []) then {
					_wp setWaypointPosition [_newPos,15];
					_wp setWaypointTimeout [1,2.5,5];		
					if (count waypoints _grouop > 1) then {
						[_group, 1] setWaypointPosition [_newPos, 15];
						[_group, 1] setWaypointTimeout [1, 2, 3];
					};
					if (count waypoints _group > 2) then {
						[_group, 2] setWaypointPosition [_newPos, 15];
						[_group, 2] setWaypointTimeout [1, 2, 3];
					};
					[_group, "combat"] call GMSCore_fnc_setGroupBehavior;	
					_group setCurrentWaypoint _wp;
					_group setSpeedMode "LIMITED";
					_group setVariable["antiStuckPos", _newPos];
        			_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];      
					if (GMSCore_debug > 0) then {[_group] call GMSCore_fnc_updateGroupDebugMarker};
				};
			} else {
				[leader _group, "Disengage"] call GMSCore_fnc_airCompletedWaypointAreaPatrol;
			};
		};

		case 4: {  // Unit is somewhere it should not be or should disengage 
			_isBlacklisted = true;
			private _minRange = _group getVariable["minWPdist", minDistWP_Heli];
			private _maxRange = _group getVariable["maxWPdist", maxDistWP_Heli];
			private _maxDistanceEnemy = _group getVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_AIR];
			private _maxAgroDist = _group getVariable["maxDistAgro", NO_AGRO_RANGE_AIR];
			private _nearestEnemys = (getPosATL _veh) nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle"]], PLAYER_DETECT_RANGE_AIR];
			{
				_group forgetTarget _x; 
			} forEach _nearestEnemys;

			if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then {
				#define minimunNumberLocations 10
				private _newLocation = "";				
				private _locationsList = [getPosATL _veh, [LOCATION_TYPES_AIR], _maxRange, minimunNumberLocations] call GMSCore_fnc_findNearestLocations;				
				while {_isBlacklisted} do {
					_newLocation =[getPosATL _veh, _minRange, _maxRange * 2, _locationsList] call GMSCore_fnc_getRandomLocation;
					_newPos = (position _newLocation) getPos [100 + random(100), random(359)];
					_blackList = nearestLocations[_newPos, [WAYPOINT_DISALLOWED_AREAS], 300];
					_isBlacklisted = [_newPos, _blackList] call GMSCOre_fnc_isBlacklisted;
				};
			} else {
				_group setVariable[GMS_lastDest, position leader _group];
				// find a new location to patrol 
				_newPos = position leader _group;
				while {_tries < 10 and (position leader _group distance _newPos < 200) && _isBlackListed} do {
					_newPos = _patrolAreaMarker call BIS_fnc_randomPosTrigger;
					_blackList = nearestLocations[_newPos, [WAYPOINT_DISALLOWED_AREAS], 300];					
					_isBlacklisted = [_newPos, _blacklist] call GMSCOre_fnc_isBlacklisted;					
					_tries = _tries + 1;
				};
			};

			_wp setWPPos _newPos;
			_wp setWaypointType "MOVE";
			_wp setWaypointTimeout [1, 2, 3];
			_wp setWaypointCompletionRadius 50;	
			_wp setWaypointStatements ["true",""];
			_wp setWaypointSpeed "NORMAL"; 

			private _wp1 = [_group, 1];
			_wp1 setWPpos _newPos; 
			_wp1 setWaypointType "MOVE"; 
			_wp1 setWaypointTimeout [1, 2, 3];
			_wp1 setWaypointCompletionRadius 40;			
			_wp1 setWaypointSpeed "LIMITED";

			private _wp2 = [_group, 2];
			_wp2 setWPpos _newPos; 
			_wp2 setWaypointType "CYCLE";
			_wp2 setWaypointCompletionRadius 30;
			_wp2 setWaypointTimeout [1,2,3];

			_group setCurrentWaypoint _wp;
			_group setSpeedMode "NORMAL";		
			_group setVariable["antiStuckPos", _newPos];
			_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2];
			[_group, "ignore"] call GMSCore_fnc_setGroupBehavior;	

			[_group, false] call GMSCore_fnc_setStuck;
			[_group, false], call GMSCore_fnc_setHunt; 
			
		};
	};
};
