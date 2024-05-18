
/*
	GMSCore_fnc_nextWaypointAreaPatrol 
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
	["_state","Monitor"]  //  "Initialize", "Completed","Monitor"
];
diag_log format["_nextWaypointAreaPatrol: _this = %1",_this];

/*
	Possible actions to be performed : have to do thse in case they occur during normal waypoint completion though that seems unlikely 

		1 - the unit is within the area defined by _patrolAreaMarker, not hunting a player and not timed out and its speed is > 0; no action needed 
		2 - the unit is outside the _patrolArea marker, not hunting and needs to be redirected into the area 
		3 - the unit is hunting and has not timed out - no action needed 
		4 - the unit is hunting, outside the area and timed out -> disengage and return to the area 
		5 - the unit is not hunting and is outside the area - redirect inside the area 
		6. the unit reached its waypoint and is not hunting - set the next waypoint within the area 
		7 the unit is inside the area, not moving and not within waypointCompletionRadius -> if it has timed out -> run antistuck logic after checking there is a driver and damage is not severe 
		8 the unit is not moving, has no driver or is too damaged to move (no wheels, no engine etc)
		9. Unit is stuck

		Note - we will let the handleDamage and firedNear event handlers set the hunted player for the group - here we will just clear the flag if teh hunted player is either dead or out of range.

		Branchpoints:
			Inside the area 
				Yes 
					is it hunting?
						yes 
							is the target dead, out of range? 
								yes
									set target to null, set group mode to disengage, set next waypoint within area 
								No 
									is it stuck (no movement in timeout interval, speed 0, has driver, engine, wheels and fuel?)
									Yes
										Effect repairs, or run unStuck logic depending on circumstances 
									No 
										No action
						No 
							is it stuck? (no movement in timeout interval, not close to waypoint, no driver, wheels, engine or fuel trashed?)
							Yes 
								Unstuck logic with repairs if needed 
							No 
								has it timed out, with speed > 0?
								Yes 
									Set new waypoint   
								No 
									Do nothing 
				No 
					is it hunting?
						yes 
							is the target dead, out of range? 
								yes
									set target to null, set group mode to disengage, set next waypoint within area 
								no 
									if the group is more than a certain range outside the area (+200M) then treat as a stuck group. 

									is it stuck (no movement in timeout interval, speed 0, has driver, engine, wheels and fuel?)
									Yes
										Effect repairs, or run unStuck logic depending on circumstances 
									No 
										No action
						No 
							Unstuck logic with repairs if needed 
							Set new waypoint   
*/

// Information we need to parse descision tree 
private _veh = objectParent (_leader);
private _group = group _leader;
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
private _wp = [_group,0];
private _patrolType = _group getVariable["GMS_areaPatrolType",GMS_infrantryPatrol];
private _typeOf = _veh call BIS_fnc_objectType;
private _speed = velocity _veh;
private _blacklisted = _group getVariable [GMSCore_blackListedAreas, []];
private _target = [_group] call GMSCore_fnc_getHunt;
private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];

_group setVariable[GMS_waypointTeminationTime,diag_tickTime + _timeout];
_group setVariable[GMSCore_timeStamp,diag_tickTime];

// 05/05/24 as far as I can tell the huntDurationTimer has no purpose 
//private _huntTimer = [_group] call GMSCore_fnc_getHuntDurationTimer;

try {
	if (_state isEqualTo "Completed") throw 1; 
	if (_state isEqualTo "Initialize") throw 1; 
	if !(_patrolAreaMarker isEqualType "") throw 0;
	if !(_patrolAreaMarker in allMapMarkers) throw -1;
	// Handle all the edge cases that might be picked up by the monitor here 
	if ( _leader inArea _patrolAreaMarker) then {
		if !(isNull _target) then {
			if (alive _target && (_target distance _leader < _maxDistanceTarget)) then {
				if ((_leader knowsAbout _target) == 0) then {
					// The group lost sight of the target so revert to normal waypoint system
					diag_log format["_nextWaypointAreaPatrol (124): finding new destination for vehicle/unit %2 leader %3 _patrolAreaMarker %4 == GMSCore_mapMarker", "", getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];
					[_group, objNull] call GMSCore_fnc_setHunt;
					// set behavior to normal and find a new spot to patrol
					throw 3; 							
				} else {
					// continue the hunt
					diag_log format["_nextWaypointAreaPatrol (128): continuing hunt for target %1 for vehicle/unit %2 leader %3 _patrolAreaMarker %4 == GMSCore_mapMarker", name _target, getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];												
					throw 2;
				};
			} else {
				// clear the target , set behavior to default, move to a new waypoint in the area 
				diag_log format["_nextWaypointAreaPatrol (134): finding new destination for vehicle/unit %2 leader %3 _patrolAreaMarker %4 == GMSCore_mapMarker", "", getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];
				[_group, objNull] call GMSCore_fnc_setHunt;
				// set behavior to normal and find a new spot to patrol
				throw 3; 			
			};
		} else {
			// continue the hunt
			diag_log format["_nextWaypointAreaPatrol (144): finding new destination for vehicle/unit %2 leader %3 _patrolAreaMarker %4 == GMSCore_mapMarker", "", getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];
			throw 1;
		};
	} else {
		[_group, objNull] call GMSCore_fnc_setHunt;
		throw 3; // disengage
	};
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
		case 1: {  // Normal waypoint update 

			/*
				scenarios to consider are:
				a. the group patrols the entire map - use a location-based approach here for simplicity and let the arma engine take care of navigation 
					i. the unit is inside a vehicle on land 
					ii. the unit is inside a vehicle the air 
				b. the group patrols a location or custom region or location on the map 
					i. the unit is on foot 
						- it can occupy a building or move to a new location in the area 
					ii. the unit is in a land vehicle that can move to a new location inside the area 
					iii. the unit is in an aircraft taht can move to a new location inside the area 
			*/

			diag_log format["_nextWaypointAreaPatrol: Starting code for Case 1: _pos %1 | _wpPos %2 | typeOf _veh %3 | _patrolAreaMarker %4", getPos _veh, getWPpos [_group,0], typeOf _veh, _patrolAreaMarker];

			// a. the case of the entire map 
			private ["_newPos","_newLocation","_searchableLocationTypes"];
			_searchableLocationTypes = ["Airport","CityCenter","CivilDefense","CulturalProperty","HistoricSite","NameCity","NameCityCapital","NameMarine","NameVillage","Strategic","ViewPoint"];
			if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then {
				diag_log format["_nextWaypointAreaPatrol (220): finding new  vehicle/unit %2 leader %3 _patrolAreaMarker %4", "--", typeOf _veh , _leader, _patrolAreaMarker];
				
				switch (true) do {
					case (_veh isKindOf "AIR"):  {
						diag_log format["_nextWaypointAreaPatrol (224): finding new destination for vehicle %1 | leader %2 | _patrolAreaMarker %3", typeOf _veh, _leader, _patrolAreaMarker];
						//private _airWPmode = _group getVariable["airWPMode","scan"];
						private _destination = _group getVariable["airWPdestination",[-1000,-1000,0]];
						private _isBlackListed = false; 
						_newPos = getPosATL _veh; 
						if (_state isEqualTo "Initialize" || (_veh distance _destination) < 210) then {  //  Find a new destination 
							private _blacklistedAreas = _group getVariable[GMSCore_blackListedAreas,[]]; // 	_group setVariable[GMSCore_blackListedAreas,_blacklisted];
							private _newLocation =[getPosATL _veh, 5000] call GMSCore_fnc_getRandomLocation;
							_isBlacklisted = [position _newLocation, _blacklistedAreas] call GMSCore_fnc_isBlacklisted;
							if !(_isBlacklisted) then {
								while {_veh distance (position _newLocation) < 1000} do {_newLocation = [getPosATL _veh, 5000] call GMSCore_fnc_getRandomLocation};
								while {_veh distance _newPos < 1000 || surfaceIsWater _newPos} do {_newPos = (position _newLocation) getPos [200 + random(200), random(359)]};
								_group setVariable["airWPdestination",_newPos];
							};
						} else {
							// This may cause the air vehicle to pass through some blacklisted areas but it will not makde them stop there. 
							private _searchRange = _group getVariable["airSearchRange",300];
							private _chanceFound = _group getVariable["airSearchChance",0.5];
							private _nearestTarget = objNull;
							if (random(1) < _chanceFound) then {
								#define minKnowsAbout 0.5
								private _nearestTarget = [_group, _searchRange, minKnowsAbout] call GMSCore_fnc_nearestTarget;
							};
							if !(isNull _nearestTarget && !([_target, _blacklistedAreas] call GMSCore_fnc_isBlacklisted)) then {
								// set a hunted player for the group and find a waypoint near it 
								[_group, _nearestTarget] call GMSCore_fnc_setHunt;
								_newPos = _nearestTarget getPos[50 + random(50), random(259)];
							} else {
								private _segmentLength = 1000 min (_veh distance _destination);
								_newPos = _veh getPos[_segmentLength, _veh getRelDir _destination];  //  assume for aircraft that the _veh is pointed toward the destination. 
							};
						};
						deleteMarker (_group getVariable["wpMarker",""]);
						private _mrkr = createMarker[format["wpMarker%1",_newPos],_newPos];
						_group setVariable["wpMarker",_mrkr];
						_mrkr setMarkerType "hd_dot";
						_mrkr setMarkerColor "COLORORANGE";
						diag_log format["_nextWaypointAreaPatrol (230): evaluating new destination %1 for aircraft %2 leader %3 distance %4", _newLocation, typeOf _veh, _leader, _veh distance _newPos];
						_wp setWPPos _newPos;
						_wp setWaypointType "MOVE";
						_wp setWaypointBehaviour "SAFE";
						_wp setWaypointCombatMode "GREEN"; 
						_wp setWaypointTimeout [10, 20, 30];
						_wp setWaypointCompletionRadius 200;	
						_group setCurrentWaypoint _wp;
						_group setSpeedMode "LIMITED";					
					};

					case (_veh isKindOf "LAND"): {
						diag_log format["_nextWaypointAreaPatrol (224): finding new destination for vehicle %1 | leader %2 | _patrolAreaMarker %3", typeOf _veh, _leader, _patrolAreaMarker];

						_newPos = getPosATL _veh; 
						private _airWPmode = _group getVariable["landWPMode","scan"];
						private _destination = _group getVariable["landWPdestination",[-1000,-1000,0]];
						private _isBlackListed = false; 
						_newPos = getPosATL _veh; 
						if (_destination isEqualTo [-1000,-1000,0] || (_veh distance _destination) < 210) then {  //  Find a new destination 
							private _blacklistedAreas = _group getVariable[GMSCore_blackListedAreas,[]]; // 	_group setVariable[GMSCore_blackListedAreas,_blacklisted];
							private _newLocation =[getPosATL _veh, 1000] call GMSCore_fnc_getRandomLocation;
							_isBlacklisted = [position _newLocation, _blacklistedAreas] call GMSCore_fnc_isBlacklisted;
							if !(_isBlacklisted) then {
								while {_veh distance (position _newLocation) < 1000} do {_newLocation = [getPosATL _veh, 1000] call GMSCore_fnc_getRandomLocation};
								while {_veh distance _newPos < 1000 || surfaceIsWater _newPos} do {_newPos = (position _newLocation) getPos [200 + random(200), random(359)]};
								_group setVariable["landWPdestination",_newPos];
							};
						} else {
							// This may cause the air vehicle to pass through some blacklisted areas but it will not makde them stop there. 
							private _searchRange = _group getVariable["landSearchRange",100];
							private _chanceFound = _group getVariable["landSearchChance",0.5];
							private _nearestTarget = objNull;
							if (random(1) < _chanceFound) then {
								#define minKnowsAbout 0.5
								private _nearestTarget = [_group, _searchRange, minKnowsAbout] call GMSCore_fnc_nearestTarget;
							};
							if !(isNull _nearestTarget && !([_target, _blacklistedAreas] call GMSCore_fnc_isBlacklisted)) then {
								// set a hunted player for the group and find a waypoint near it 
								[_group, _nearestTarget] call GMSCore_fnc_setHunt;
								_newPos = _nearestTarget getPos[50 + random(50), random(259)];
							} else {
								private _segmentLength = 500 min (_veh distance _destination);
								_newPos = _veh getPos[_segmentLength, _veh getRelDir _destination];  //  assume for aircraft that the _veh is pointed toward the destination. 
							};
						};						
						private _newLocation =[] call GMSCore_fnc_getRandomLocation;
						while {_veh distance (position _newLocation) < 300} do {_newLocation = [] call GMSCore_fnc_getRandomLocation};
						while {_veh distance _newPos < 300 || surfaceIsWater _newPos} do {_newPos = (position _newLocation) getPos [200 + random(200), random(359)]};
						deleteMarker (_group getVariable["WPdebugMarker",""]);
						_mrkr = createMarker [format["WPdebugMarker%1",_newPos],_newPos];
						_mrkr setMarkerType "mil_dot";
						_mrkr setMarkerColor "COLORGREEN";
						_group setVariable["WPdebugMarker",_mrkr];	
						_wp setWPPos _newPos;
						_wp setWaypointType "MOVE";
						_wp setWaypointBehaviour "SAFE";
						_wp setWaypointCombatMode "GREEN"; 
						_wp setWaypointTimeout [10, 20, 30];
						_wp setWaypointCompletionRadius 150;	
						_group setCurrentWaypoint _wp;
						_group setSpeedMode "LIMITED";											
						_veh forceFollowRoad true;
						diag_log format["_nextWaypointAreaPatrol (230): evaluating new destination %1 for _veh %2 leader %3 distance %4", "", typeOf _veh, _leader, _veh distance _newPos];
					};

					case (_veh isKindOf "SHIP"): {
						_newPos = getPosATL _veh; 
						private _max = 70;
						while {_newPos distance _veh < 30 || !surfaceIsWater _newPos} do {
							_max = _max + 10;								
							_newPos = [getPos _veh, _max] call BIS_fnc_randomPosTrigger;
						};						
					};

					case (_veh isEqualTo _leader): {
						_newPos = getPosATL _veh; 
						private _max = 20;
						while {_newPos distance _veh < 30 || surfaceIsWater _newPos} do {
							_max = _max + 10;								
							_newPos = [getPos _veh, _max] call BIS_fnc_randomPosTrigger;
						};	
					};
				};

				//_newpos = locationPosition _newLocation;
				//diag_log format["_nextWaypointAreaPatrol(247): _newLocation %1 | locationPosition _newLocation %2",_newLocation, locationPosition _newLocation, _leader distance _newPos];				
				 
			} else { 
			// b. the case of a location or other smaller region 
				diag_log format["_nextWaypointAreaPatrol (273): finding new destination %1 for vehicle/unit %2 leader %3 _patrolAreaMarker %4", "within _patrolAreaMarker", getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];
				private _isInfantry = if (_group getVariable["GMS_areaPatrolType",GMS_infrantryPatrol] isEqualTo GMS_infrantryPatrol) then {true} else {false};
				private _garrison = if (random (1) < (_group getVariable[GMS_garisonChance,0])) then {true} else {false};
				private _garrisoned = if (isNull (waypointAttachedObject _wp)) then {false} else {true};
				// garrison building if needed 
				if (_isInfantry && !_garrisoned && _garrison) then {
					// move units into a nearby building 
					private _newPos = _patrolAreaMarker call BIS_fnc_randomPosTrigger;
					private _building = nearestBuilding _newPos; 
					_wp waypointAttachObject _building; 
					_wp setWPPos _newPos;
					_wp setWaypointBehaviour "SAFE";
					_wp setWaypointCombatMode "GREEN"; 
					_wp setWaypointTimeout [30.1, 60.5, 91.0];  //  delay waypoint completion so they hang out in the building a while 
					_wp setWaypointCompletionRadius 0;	
					_group setCurrentWaypoint _wp;
					_group setSpeedMode "LIMITED";							
				} else {
					// move to a new location witnin the patrol araea 
					// clear any prior garrison locations 
					_wp waypointAttachObject objNull; 
					// find a new location to patrol 
					_newPos = _patrolAreaMarker call BIS_fnc_randomPosTrigger;
					_wp setWPPos _newPos;
					_wp setWaypointBehaviour "SAFE";
					_wp setWaypointCombatMode "GREEN"; 
					_wp setWaypointTimeout [0.1, 0.5, 1.0];
					_wp setWaypointCompletionRadius 30;	
					_group setCurrentWaypoint _wp;
					_group setSpeedMode "LIMITED";						
				};
			};
		};

		case 2: {  //  Hunt a player 
			//[_group,_target] call GMSCore_fnc_updateHunt;		
			diag_log format["_nextWaypointAreaPatrol (310): hunting target %1 with vehicle/unit %2 leader %3 _patrolAreaMarker %4", _target, getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];
			private "_newPos"; 
			private _minWPdist = 10;
			private _minTargetDist = 10; 
			private _distance = _veh distance _target; 
			switch (true) do {
				case (_veh isKindOf "AIR"): {
					_minWPdist = 30;
					_minTargetDist = 30;
				};
				case (_veh isKindOf "LAND"): {

				};
				case (_veh isKindOf "SHIP"): {

				};
			};

			if (_distance > _minTargetDist) then {
				// move closer if possible 
				private _vectorDir = _bearing + (random(45) * (selectRandom[-1,1]));
				_newPos = _leader getRelPos[_vectorDir , (_distance * 0.5)]
			} else {
				_newPos = _leader getPos[_minDistTarget + random(_minDistTarget/2), random(359)];
			};
	
			_leader doSuppressiveFire _target;
			_wp setWaypointPosition [_newPos,15];
			_wp setWaypointBehaviour "COMBAT";
			_wp setWaypointCombatMode "RED"; 
			_wp setWaypointTimeout [45,60,75];
			//_wp setWaypointCompletionRadius 15;	
			_group setCurrentWaypoint _wp;
			_group setSpeedMode "LIMITED";
		};

		case 3: {  // Unit is stuck so turn it around 
			diag_log format["_nextWaypointAreaPatrol (335): handling stuck group %1 with vehicle/unit %2 leader %3 _patrolAreaMarker %4 speed _veh %5", _group, getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker, speed _veh];
			diag_log format["_nextWaypointAreaPatrol (336): simulationEnabled _veh = %1 | simulationEnabled _leader = %2 | dynamicSimulation enabled _veh = %3 | dynamicSimulationEnabled _group = %4", simulationEnabled _veh, simulationEnabled _leader, dynamicSimulationEnabled _veh, dynamicSimulationEnabled _group];
			
			private _newPos = _patrolAreaMarker call BIS_fnc_randomPosTrigger;

			private _wp = [_group,0];
			[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 			
			_wp setWPPos _newPos; 
			_wp setWaypointType "MOVE";
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointCombatMode "GREEN"; 
			_wp setWaypointCompletionRadius 0;
			_wp setWaypointTimeout [0.1, 0.15, 0.2];
			_group setCurrentWaypoint _wp;
			_group setSpeedMode "NORMAL";
			diag_log format["_nextWaypointAreaPatrol(371): _leader %1 | _currPos %2 | _newPos %3 | _distance = %4",_leader, getPosATL _leader,_newPos,  _leader distance _newPos];			
			diag_log format ["_nextWaypointAreaPatrol(373): _leader %1 | _veh %2 | speed %3 | _distance = %4",_leader, _veh, speed _veh,  _leader distance _newPos];		
		};
	};
};
