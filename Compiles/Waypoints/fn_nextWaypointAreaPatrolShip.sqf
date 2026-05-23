
/*
	GMSCore_fnc_nextWaypointAreaPatrolSea
	Purpose: set the next waypoint for a group patroling within a proscribed area set by a map marker 
	Parameters:
		_this: leader of the group to handle 
	Returns: None 
	Copyright 2020 by Ghostrider-GRG- 	
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"

params[
	["_leader",objNull],
	["_state","Completed"]  //  "Initialize", "Completed","Hunt", "Disengage"
];
diag_log format["_nextWaypointAreaPatrolASea: _this = %1",_this];


// Information we need to parse descision tree 

private _group = group _leader;
private _wp = [_group,0];
//private _speed = velocity _veh;
private _veh = objectParent (_leader);
private _group = group _leader;
private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];

// 05/05/24 as far as I can tell the huntDurationTimer has no purpose 
//private _huntTimer = [_group] call GMSCore_fnc_getHuntDurationTimer;

try {
	// A set of descisions/evaluations needed to understand the state of teh group
	if (_patrolAreaMarker isEqualTo "") throw -2; 
	if !(_patrolAreaMarker in allMapMarkers) throw -1;
	if !(_patrolAreaMarker isEqualType "") throw 0;
	
	// Initialized is a special case because there is no prior setup, and no concern about something being where it should not be or being stuck; 
	if (_state isEqualTo "Initialize") throw 1; 
	if (_state isEqualTo "Complete") throw 2; 
	if (_state isEqualTo "Hunt") throw 3; 
	if (_state isEqualTo "Disengage") throw 4; 
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

		case 1: {  // Initialize 

			_group setVariable["minWPdist", MIN_WP_DIST_SEA];
			_group setVariable["maxWPdist", MAX_WP_DIST_SEA];
			_group setVariable["maxEnemyDist", DISTANCE_NEAREST_ENEMY_SEA];
			_group setVariable["maxDistAgro", NOAGRO_RANGE_SEA];
			_group setVariable["antiStuckDist", ANTISTUCK_MIN_DIST_SEA];
			_group setVariable["antiStuck", diag_tickTime + getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer")];

			private _newPos = [];
			private _playerNear = true;
			private _temp = createMarkerLocal [format["Temp%1",random(100000)], markerPos _patrolAreaMarker];
			private _size = markerSize _patrolAreaMarker;
			_size params["_sizeA","_sizeB"];
			_temp setMarkerSizeLocal (getMarkerSize _temp);
			private _tries = 0;
			while {_playerNear ||!surfaceIsWater _newPos} do {
				_newPos = _patrolAreaMarker call BIS_fnc_randomPosTrigger;
				if (_tries < 10 && !(_newPos isEqualTo [])) then {
					private _tempPos = selectBestPlaces [_newPos, 50, "waterdepth" > 1];
					if !(_tempPos isEqualTo []) then {_newPos = _tempPos select 0};
					_tries = _tries + 1;
				};
				private _detected = _newPos nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle","SHIP"]], PLAYER_DETECT_RANGE_AIR];
				_nearPlayer = if (count _detected > 0) then {true} else {false};
				_sizeA = _sizeA + 50;
				_sizeB = _sizeB + 50;
				_temp setMarkerSizeLocal [_sizeA, _sizeB];
				_tries = _tries + 1;
			};					
			deleteMarkerLocal _temp;
			_wp setWPPos _newPos;
			_wp setWaypointTimeout [0.1, 0.5, 1.0];
			_wp setWaypointCompletionRadius 30;	
			_group setCurrentWaypoint _wp;
			[_group, "Normal"] call GMSCore_fnc_setGroupBehavior;
			_group setSpeedMode "NORMAL";						
			_group setVariable["antiStuckPos", _newPos];
			_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2]; 
		};

		case 2: {
			private _anchor = getPosATL _veh;
			private _newPos = _anchor;
			private _playerNear = true;
			private _temp = createMarkerLocal [format["Temp%1",random(100000)], markerPos _patrolAreaMarker];
			private _size = markerSize _patrolAreaMarker;
			_size params["_sizeA","_sizeB"];
			_temp setMarkerSizeLocal (getMarkerSize _temp);
			private _minWPdist = _group getVariable["minWPdist", MIN_WP_DIST_SEA];
			private _tries = 0;
			while {_playerNear ||!surfaceIsWater _newPos && (_anchor distance2D _newPos) < 10} do {
				_newPos = _temp call BIS_fnc_randomPosTrigger;
				if (_tries < 10 && !(_newPos isEqualTo [])) then {
					private _tempPos = selectBestPlaces [_newPos, 50, "waterdepth" > 1];
					if !(_tempPos isEqualTo []) then {_newPos = _tempPos select 0};
				};
				private _detected = _newPos nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle","SHIP"]], PLAYER_DETECT_RANGE_AIR];
				_nearPlayer = if (count _detected > 0) then {true} else {false};
				_sizeA = _sizeA + 50;
				_sizeB = _sizeB + 50;
				_temp setMarkerSizeLocal [_sizeA, _sizeB];
				_tries = _tries + 1;
			};					
			deleteMarkerLocal _temp;
			_wp setWPPos _newPos;
			_wp setWaypointTimeout [0.1, 0.5, 1.0];
			_wp setWaypointCompletionRadius 30;	
			_group setCurrentWaypoint _wp;
			[_group, "Normal"] call GMSCore_fnc_setGroupBehavior;
			_group setSpeedMode "NORMAL";						
			_group setVariable["antiStuckPos", _newPos];
			_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2]; 
		};

		case 3: {  //  Hunt a player 
			private _anchor = getPosATL _veh;
			private _newPos = _anchor;
			private _playerNear = true;
			private _temp = createMarkerLocal [format["Temp%1",random(100000)], markerPos _patrolAreaMarker];
			private _size = markerSize _patrolAreaMarker;
			_size params["_sizeA","_sizeB"];
			_temp setMarkerSizeLocal (getMarkerSize _temp);
			private _tries = 0;
			while {!surfaceIsWater _newPos && (_anchor distance2D _newPos) < 10} do {
				_newPos = _temp call BIS_fnc_randomPosTrigger;
				if (_tries < 10 && !(_newPos isEqualTo [])) then {
					private _tempPos = selectBestPlaces [_newPos, 50, "waterdepth" > 1];
					if !(_tempPos isEqualTo []) then {_newPos = _tempPos select 0};
				};
				_sizeA = _sizeA + 20;
				_sizeB = _sizeB + 20;
				_temp setMarkerSizeLocal [_sizeA, _sizeB];
				_tries = _tries + 1;
			};					
			deleteMarkerLocal _temp;
			private _distance = _veh distance _target; 
			if (_distance > 50) then {
				_newPos = _veh getPos[_distance / 2, _veh getRelDir _target];
			} else {
				_newPos = _target getPos [50 + random (20), random(359)];
			};
			_wp setWaypointPosition [_newPos,15];
			_wp setWaypointTimeout [5,6,75];
			_group setCurrentWaypoint _wp;
			[_group] call GMSCore_fnc_setGroupBehavior;
			_group setSpeedMode "LIMITED";
		};

		case 4: {  // Unit is somewhere it should not be or should disengage 
			private _anchor = getPosATL _veh;
			private _newPos = _anchor;
			private _playerNear = true;
			private _temp = createMarkerLocal [format["Temp%1",random(100000)], markerPos _patrolAreaMarker];
			private _size = markerSize _patrolAreaMarker;
			_size params["_sizeA","_sizeB"];
			_temp setMarkerSizeLocal (getMarkerSize _temp);
			private _noAgroDist = _group getVariable["maxDistAgro", NOAGRO_RANGE_SEA];
			private _tries = 0;
			while {_playerNear ||!surfaceIsWater _newPos || (_anchor distance2D _newPos) < 10} do {
				_newPos = _temp call BIS_fnc_randomPosTrigger;
				if (_tries < 10 && !(_newPos isEqualTo [])) then {
					private _tempPos = selectBestPlaces [_newPos, 50, "waterdepth" > 1];
					if !(_tempPos isEqualTo []) then {_newPos = _tempPos select 0};
				};
				private _detected = _newPos nearEntities[[GMSCore_playerUnitTypes append ["LandVehicle","SHIP"]], _noAgroDist];
				_nearPlayer = if (count _detected > 0) then {true} else {false};
				_sizeA = _sizeA + 50;
				_sizeB = _sizeB + 50;
				_temp setMarkerSizeLocal [_sizeA, _sizeB];
				_tries = _tries + 1;
			};					
			deleteMarkerLocal _temp;
			private _nearestEnemys = _group targets [true, 250];
			{
				_group forgetTarget _x; 
			} forEach _nearestEnemys;				
			[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
			_group setSpeedMode "NORMAL";						
			_group setVariable["antiStuckPos", _newPos];
			_group setVariable["antiStuckTime", diag_tickTime + _antiStuckTime / 2]; 			
			_wp setWPPos _newPos; 
			_wp setWaypointType "MOVE";
			_wp setWaypointCompletionRadius 30;
			_wp setWaypointTimeout [0.1, 0.15, 0.2];
			_group setCurrentWaypoint _wp;

		};
	};
};
