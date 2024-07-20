
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
	["_state","Completed"]  //  "Initialize", "Completed","Monitor"
];
diag_log format["_nextWaypointAreaPatrol: _this = %1",_this];

/*
  
*/

// Information we need to parse descision tree 
private _veh = objectParent (_leader);
if (_veh isKindOf "CAR") then {diag_log format["_nextWaypointAreaPatrol: _veh %1 isKindOf 'Car'", typeOf _veh]};
if (_veh isKindOf "TANK") then {diag_log format["_nextWaypointAreaPatrol: _veh %1 isKindOf 'Tank'", typeOf _veh]};
if (_veh isKindOf "AIR") then {diag_log format["_nextWaypointAreaPatrol: _veh %1 isKindOf 'Air'", typeOf _veh]};
if (_veh isKindOf "LANDVEHICLE") then {diag_log format["_nextWaypointAreaPatrol: _veh %1 isKindOf 'LANDVEHICLE'", typeOf _veh]};
private _group = group _leader;
private _timeout = _group getVariable[GMS_waypointTimeoutInterval,300];
private _wp = [_group,0];
private _patrolType = _group getVariable["GMS_areaPatrolType",GMS_infrantryPatrol];
private _typeOf = _veh call BIS_fnc_objectType;
private _speed = velocity _veh;
private _blacklisted = _group getVariable [GMSCore_blackListedAreas, []];
private _target = [_group] call GMSCore_fnc_getHunt;
private _patrolAreaMarker = _group getVariable[GMSCore_patroArealMarker, ""];
private _lastDestination = _group getVariable["lastDest",""];
private _currDestination = _group getVariable["currDest",""];

_group setVariable[GMS_waypointTeminationTime,diag_tickTime + _timeout];
_group setVariable[GMSCore_timeStamp,diag_tickTime];

// 05/05/24 as far as I can tell the huntDurationTimer has no purpose 
//private _huntTimer = [_group] call GMSCore_fnc_getHuntDurationTimer;

try {
	// A set of descisions/evaluations needed to understand the state of teh group
	if (_patrolAreaMarker isEqualTo "") throw -2; 
	if !(_patrolAreaMarker in allMapMarkers) throw -1;
	if !(_patrolAreaMarker isEqualType "") throw 0;

	// Initialized is a special case because there is no prior setup, and no concern about something being where it should not be or being stuck; 
	if (_state isEqualTo "Initialize") throw 1; 


	// Handle all the edge cases that might be picked up by the monitor here 
	if ( _leader inArea _patrolAreaMarker) then {
		if !(isNull _target) then {

			if ([_target, _blacklisted] call GMSCore_fnc_isBlacklisted) then {
				[_group, objNull] call GMSCore_fnc_setHunt; 
				throw 3;
			}; // Don't hunt a target in a blacklisted area 
			if (!alive _target)  then{[_group, objNull] call GMSCore_fnc_setHunt; throw 3}; 
			if (_group knowsAbout _target < 0.1)  then{[_group, objNull] call GMSCore_fnc_setHunt; throw 3}; 
			// continue the hunt
			diag_log format["_nextWaypointAreaPatrol (128): continuing hunt for target %1 for vehicle/unit %2 leader %3 _patrolAreaMarker %4 == GMSCore_mapMarker", name _target, getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker];												
			throw 2;
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

			/***************************************************************************************

				HANDLE PATROLS THAT COVER THE ENTIRE MAP FIRST. THESE HAVE THE MOST POSSIBLE ERRORS

			******************************************************************************************/
			if (_patrolAreaMarker isEqualTo GMSCore_mapMarker) then {
				diag_log format["_nextWaypointAreaPatrol (220): finding new waypoint for vehicle %2 leader %3 _patrolAreaMarker %4", "--", typeOf _veh , _leader, _patrolAreaMarker];
					
					/*
						Air Patrols should not get stuck 
						Cases here are either waypoint completion because the location was reached or monitoring or initialization
					*/
				switch (true) do {
					case (_veh isKindOf "AIR"):  {
						diag_log format["_nextWaypointAreaPatrol (164): finding new destination for vehicle %1 | leader %2 | _patrolAreaMarker %3", typeOf _veh, _leader, _patrolAreaMarker];
						diag_log format["_nextWaypointAreaPatrol (165): waypoints = %1 | currentWaypoint = %2", waypoints _group, currentWaypoint _group];
						//private _airWPmode = _group getVariable["airWPMode","scan"];
						//private _destination = _group getVariable["WPdestination", ""];
						private _newLocation = "";
						private _isBlackListed = false; 
						_newPos = getPosATL _veh; 
						if (_state isEqualTo "Initialize") then {  //  Find a new destination 
							_isBlacklisted = true;
							private _minRange = 1000;
							private _maxRange = 7500;
							if ([_veh] call GMSCore_fnc_isDrone && _veh isKindOf "Helicopter") then {
								// shorten search radius for drones that are of type helicopter as these travel slowly.
								_minRange = 500;
								_maxRange = 2500;  
							};
							while {_isBlacklisted} do {
								_newLocation =[getPosATL _veh, _minRange, _maxRange] call GMSCore_fnc_getRandomLocation;
								_newPos = (position _newLocation) getPos [100 + random(100), random(359)];
								_isBlacklisted = [_newPos, _blacklisted] call GMSCOre_fnc_isBlacklisted;
							};
							_group setVariable["currDestination",_newLocation];
							_group setVariable["lastDestination",_newLocation];
							_group setVariable["LastChecked",diag_tickTime];		
							_group setBehaviourStrong "CARELESS";
							_wp setWPPos _newPos;
							_wp setWaypointType "MOVE";
							//_wp setWaypointBehaviour "SAFE";
							//_wp setWaypointCombatMode "GREEN"; 
							_wp setWaypointTimeout [1, 2, 3];
							_wp setWaypointCompletionRadius 150;	
							_group setCurrentWaypoint _wp;
							_group setSpeedMode "LIMITED";		

							deleteMarker (_group getVariable["wpMarker",""]);
							private _mrkr = createMarker[format["wpMarker%1", random(100000)], _newPos];
							_group setVariable["wpMarker",_mrkr];
							_mrkr setMarkerType "hd_dot";
							_mrkr setMarkerColor "COLORORANGE";
							_mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"Drone"} else {"Air"}];
							//[_mrkr, 300] call GMSCore_fnc_addToDeletionCue;
							diag_log format["_nextWaypointAreaPatrol (209): _newLocation %2 | _veh distance _newPos %3 | _newPos %4 | _mrkr %5 | markerPos %6", "",  _newLocation, _veh distance _newPos, _newPos, _mrkr, getMarkerPos _mrkr];
						} else {
							if (_state isEqualTo "Completed") then {
								private _currDestination = _group getVariable["currDestination",""];
								diag_log format["_nextWaypointAreaPatrol (213): finding new destination for vehicle %1 | leader %2 | _patrolAreaMarker %3", typeOf _veh, _leader, _patrolAreaMarker];
								diag_log format["_nextWaypointAreaPatrol (214): old _currDestingation %3 | _veh distance getWPpos %4 | waypoints = %1 | currentWaypoint = %2", waypoints _group, currentWaypoint _group, _currDestingation, _veh distance getWPpos _wp];								
								
								_isBlacklisted = true;
								private _newLocation = "";
								private _minRange = 1000;
								private _maxRange = 7500;
								if ([_veh] call GMSCore_fnc_isDrone && _veh isKindOf "Helicopter") then {
									// shorten search radius for drones that are of type helicopter as these travel slowly.
									_minRange = 500;
									_maxRange = 2500;  
								};
								while {_isBlacklisted} do {
									_newLocation =[getPosATL _veh, _minRange, _maxRange] call GMSCore_fnc_getRandomLocation;
									_newPos = (position _newLocation) getPos [100 + random(100), random(359)];
									_isBlacklisted = [_newPos, _blacklisted] call GMSCOre_fnc_isBlacklisted;
								};
								//_group setVariable["WPdestination",_newPos];
								_group setVariable["currDestination",_newLocation];
								_group setVariable["lastDestination", _currDestingation];
								_group setVariable["LastChecked",diag_tickTime];
								_group setBehaviourStrong "CARELESS";
								_wp setWPPos _newPos;
								_wp setWaypointType "MOVE";
								_wp setWaypointBehaviour "SAFE";
								//_wp setWaypointCombatMode "GREEN"; 
								_wp setWaypointTimeout [1, 2, 3];
								_wp setWaypointCompletionRadius 150;	
								_group setCurrentWaypoint _wp;
								_group setSpeedMode "LIMITED";	

								deleteMarker (_group getVariable["wpMarker",""]);
								private _mrkr = createMarker[format["wpMarker%1", random(100000)], _newPos];
								_group setVariable["wpMarker",_mrkr];
								_mrkr setMarkerType "hd_dot";
								_mrkr setMarkerColor "COLORORANGE";
								_mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"Drone"} else {"Air"}];
								//[_mrkr, 300] call GMSCore_fnc_addToDeletionCue;		
								diag_log format["_nextWaypointAreaPatrol (251): _currDestination %1 | _newLocation %2 | _veh distance _newPos %3 | _newPos %4 | _mrkr %5 | markerPos %6", _currDestination, _newLocation, _veh distance _newPos, _newPos, _mrkr, getMarkerPos _mrkr];																					
							} else {  // the situation is the group is being monitored 
								// Some monitoring could be done by GMSAI - but keep something here just in case.
								private _destLoc = _group getVariable["currDestination",""];
								private _lstPos = _group getVariable["LastPosition",getPosATL _veh];
								private _lastChecked = _group getVariable["LastChecked",diag_tickTime];	

								if ( (_veh distance _lstPos) < 100 && (diag_tickTime - _lastChecked)  > 60) then {
									private _isBlacklisted = true;
									private _radius = 250;
									while {_isBlacklisted || surfaceIsWater _newPos} do {
										_newPos = _veh getPos[_radius,random(359)];
										_isBlacklisted = [_newPos, _blacklisted] call GMSCore_fnc_isBlacklisted;
										_radius = _radius + 50;
									};

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
				
									deleteMarker (_group getVariable["wpMarker",""]);
									private _mrkr = createMarker[format["wpMarker%1", random(100000)], _newPos];
									_group setVariable["wpMarker",_mrkr];
									_mrkr setMarkerType "hd_dot";
									_mrkr setMarkerColor "COLORBLUE";
									_mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"Drone"} else {"Air"}];
									[_mrkr, 300] call GMSCore_fnc_addToDeletionCue;	
								};

								// Reset lastPosition here since it is used to determine if a vehicle has stalled out for some reason. 
								_group setVariable["LastPosition",getPosATL _veh];
							};
						};
					};

					/*
						Land vehicle patrols need to follow roads from one location to another unless they are hunting a player. 
						They can get stuck at intersections or when trying to navigate around obstacles in a road 
						To avoid them getting too far off track, having them go from one road section to another nearby on their way tot he desitnation
					*/
					//case (_veh isKindOf "Car" || _veh isKindOf "Tank"): {
					case (_veh isKindOf "LANDVEHICLE"): {
						
						switch (true) do { 
							
							case (_state isEqualTo "Monitor"): {
								// It is usually land vehicles that get stuck - either at intersections or near obstacles. 
								// Keep something here in case GMSAI or anything else that calls GMSCore for area patrols does not deal with the instance of a stuck vehicle.
								diag_log format["_nextWaypointAreaPatrol(306): {alive _x} count (units _group) %1 || {alive _x} count (crew _veh) %2", {alive _x} count (units _group), {alive _x} count (crew _veh)];
								if (({alive _x} count (units _group) > ({alive _x} count (crew _veh)))) then {
									_group setVariable["loadingCrew", true];
									// some units got out so lets load them up and continue 
									[_group,"disengage"] call GMSCore_fnc_setGroupBehaviors; 
									_group setBehaviourStrong "CARELESS";								
									_wp setWPpos (getPosATL _veh);
									_wp setWaypointType "LOAD";
									//  [_vehicle,_group] call GMSCore_fnc_loadVehicleCrew;
									_wp setWaypointTimeout [0.1,0.2,0.3];
									_group setVariable["LastChecked", diag_tickTime];
									_group setVariable["60SecTimer", diag_tickTime];
									_group setVariable["60SecStartPos", getPosATL _veh];									
									diag_log format["_nextWaypointAreaPatrol (317): typeOf _veh | loading crew from group %2", typeOf _veh, _group];
									//continue;								
								} else {
									diag_log format["_nextWaypointAreaPatrol(320): _leader %1 || moveToCompleted _leader %2 ||  moveToFailed _leader %3",_leader, moveToCompleted _leader, moveToFailed _leader];
									if (moveToCompleted (_leader)) then {
										// if a doMove was executed test for successful completion and deal with it
										_group setVariable["doMove",false];
										_leader call GMSCore_fnc_nextWaypointAreaPatrol;
										diag_log format["_nextWaypointAreaPatrol(324): doMove to %1 completed",getWPpos _wp];
										//continue;
									} else {

										diag_log format["_nextWaypointAreaPatrol(332): (_veh distance (getWPpos _wp) %1 || (waypointCompletionRadius _wp) %2", (_veh distance (getWPpos _wp)), (waypointCompletionRadius _wp)];  
										if ((_veh distance (getWPpos _wp) < (waypointCompletionRadius _wp))) then { 
											//  The vehicle reached the waypoint; allow normal waypoint completion code to execute once any waits are completed.
											diag_log format["_nextWaypointAreaPatrol (331) typeOf _veh within waypointRadius",typeOf _veh];
											_group setVariable["LastPosition", getPosATL _veh];
											_group setVariable["LastChecked", diag_tickTime];
											//continue;
										} else {

											/*
												_group setVariable["lastRoadSegment", _currRoad];	
												_group setVariable["lastChecked", diag_tickTime];
												_group setVariable["wpInitialized", diag_tickTime];	
												_group setVariable["60SecTimer", diag_tickTime];
												_group setVariable["60SecStartPos", getPosATL _veh];
											*/
											private _60SetStartPos = _group getVariable["60SecStartPos",getPosATL _veh];
											private _60SecStartTime = _group getVariable["60SecTimer", diag_tickTime];
											private _lastChecked = _group getVariable["LastChecked",diag_tickTime];
											private _wpInitialized = _group getVariable["wpInitialized", diag_tickTime];
											private _wpStartPos = _group getVariable["wpStartPos",getPosATL _veh];
											private _speed = speed _veh; 
											private _minSpeed = 10 min (0.1 * (getNumber(configFile >> "CfgVehicles" >> typeOf _veh >> "maxSpeed")));
											diag_log format["_nextWaypointAreaPatrol(344): typeOf _veh %1 || _speed %2 || _minSpeed %3 || _60SetStartPos distance _veh %4 || diag_tickTime - wpStartTime %5", typeOf _veh, _speed, _minSpeed, _60SetStartPos distance _veh, diag_tickTime - _wpInitialized]; 
											diag_log format["_nextWaypointAreaPatrol(345): (diag_tickTime - _60SecStartTime >= 60) %1 || _veh distance _60SetStartPos %2 || _veh distance (getWPpos _wp) %3",(diag_tickTime - _60SecStartTime >= 60), _veh distance _60SetStartPos, _veh distance (getWPpos _wp)];
											//private _doMove = _group getVariable["doMove", false];
											if ( (diag_tickTime - _60SecStartTime >= 60) && (_speed < _minSpeed) && _veh distance _60SetStartPos < 10) then {
												// vehicle has not moved in 60 sec so lets nudge it 
												_veh doMove (getWPpos _wp);
												_group setVariable["d0Move",true];
												_group setVariable["lastChecked", diag_tickTime];
												diag_log format["_nextWaypointAreaPatrol(365): vehicle typeOf %1 stuck at %2 executing doMove to %3", typeOf _veh, getPosATL _veh, getWPpos _wp];
												//continue;
											} else {
												if ((diag_tickTime - _60SecStartTime >= 60) && _speed < _minSpeed) then {
													_group setVariable["60SecTimer", diag_tickTime];
													_group setVariable["60SecStartPos", getPosATL _veh];
													diag_log format["_nextWaypointAreaPatrol(365): updated 60SecTimer to %1 && 60SecStartPos to %2", diag_tickTime, getPosATL _veh];
												};
											};

										};	
							
									};
								};

								deleteMarker (_group getVariable["wpMarker",""]);
								//diag_log format["_nextWaypointAreaPatrol (355):  _isBlacklisted %1 | _newPos %1", _newPos];
								_mrkr = createMarker [format["WPdebugMarker%1",getWPpos _wp], getWPpos _wp];
								_mrkr setMarkerType "mil_dot";
								_mrkr setMarkerColor "COLORGREEN";
								_mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"UGV"} else {"Car"}];
								_group setVariable["wpMarker",_mrkr]; 
							};
							
							case (_state isEqualTo "Completed"): {
								
								private _currRoad = _group getVariable["lastRoadSegment", objNull];
								diag_log format["_nextWaypointAreaPatrol (358): _curRoad %1", _currRoad];
								private _nextRoads = (roadsConnectedTo _currRoad); 

								diag_log format["_nextWaypointAreaPatrol (361): _curRoad %1 | _nextRoads %2 | next road %3", _currRoad, _nextRoads, _nextRoads select 0];
								private _roadInfo = getRoadInfo (_nextRoads deleteAt 0);
								private _endPosn = _roadInfo select 6;
								diag_log format["_nextWaypointAreaPatrol (364): _currRoad %1 | _endPos %2 | _roadInfo %2", _currRoad,_endPosn, _roadInfo];
							
								private _isBlacklisted = true;
								private ["_roadInfo","_endPos","_newPos"];
								_newPos = getPosATL _veh;
								while { (_newPos distance _veh < 200) || !(_nextRoads isEqualTo []) || _isBlackListed} do {
									_currRoad =  getRoadInfo (_nextRoads deleteAt 0);
									private _roadInfo = _currRoad;
									private _endPos = _roadInfo select 7;
									diag_log format["_nextWaypointAreaPatrol (371): _currRoad %1 | _endPos %2 | distance %3 | _roadInfo %4", _currRoad,_endPos, _veh distance _endPos, _roadInfo];
									 _newPos = ASLtoAGL _endPos;  // Position in ASL 
									_isBlacklisted = [_newPos, _blacklisted] call GMSCore_fnc_isBlacklisted;
								};
								
								if (_newPos distance _veh < 200) then {
									while {_isBlacklisted || surfaceIsWater _newPos} do {
										private _locPos = (_newPosn) getPos [250 + random(100), random(359)];
										private _radius =200;					
										private _nearRoads = [];
										while {_nearRoads isEqualTo []} do {
											_radius = _radius + 100;
											_nearRoads = _locPos nearRoads _radius;
											diag_log format["_nextWaypointAreaPatrol (384):  search for nearRoads with _locPos %1 | _radius %2 | _pos nearRoads _radius returned count _newRoads %3, _nearRoads %4",_locPos, _radius, count _nearRoads, _nearRoads];
										};		
										_nextRoads = roadsConnectedTo (_nearRoads select 0);
										private _roadInfo = getRoadInfo (_nextRoads select 0); 
										_newPos = ASLtoAGL (_roadInfo select 6);  // Position in ASL 							
										_isBlacklisted = [_newPos, _blacklisted] call GMSCore_fnc_isBlacklisted;
									};
								};

								_wp setWPPos _newPos; 
								_veh setDriveOnPath [getPosATL _veh, newPos];
								_wp setWPPos _newPos;
								_wp setWaypointType "MOVE";

								_group setBehaviourStrong "CARELESS";
								_wp setWaypointBehaviour "SAFE";
								_wp setWaypointCombatMode "YELLOW"; 
								_wp setWaypointTimeout [0.1, 0.11, 0.12];
								_wp setWaypointCompletionRadius 150;	
								_group setCurrentWaypoint _wp;
								_group setSpeedMode "LIMITED";	
								_group setVariable["lastRoadSegment", _currRoad];	
								_group setVariable["lastChecked", diag_tickTime];
								_group setVariable["wpInitialized", diag_tickTime];	
								_group setVariable["60SecTimer", diag_tickTime];
								_group setVariable["60SecStartPos", getPosATL _veh];
								_group setVariable["wpStartPos",getPosATL _veh];

								deleteMarker (_group getVariable["wpMarker",""]);
								diag_log format["_nextWaypointAreaPatrol (408):  _newPos %1 | _currRoad %2", getWPpos _wp, _currRoad];
								_mrkr = createMarker [format["WPdebugMarker%1",getWPpos _wp], getWPpos _wp];
								_mrkr setMarkerType "mil_dot";
								_mrkr setMarkerColor "COLORGREEN";
								_mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"UGV"} else {"Car"}];
								_group setVariable["wpMarker",_mrkr]; 								
							};
							
							case (_state isEqualTo "Initialize"): {
								private _currDestination = _group getVariable["currDestination",""];
								private _newPos = [0,0,0];
								private _isBlacklisted = true;
								private _newLocation = "";
								private _nextRoads = [];
								while {_isBlacklisted || surfaceIsWater _newPos || _newLocation isEqualTo _currDestination} do {
									_newLocation =[getPosATL _veh, 500, 1500] call GMSCore_fnc_getRandomLocation;
									private _locPos = (position _newLocation) getPos [100 + random(100), random(359)];
									private _radius =200;					
									private _nearRoads = [];
									while {_nearRoads isEqualTo []} do {
										_radius = _radius + 100;
										_nearRoads = _locPos nearRoads _radius;
										diag_log format["_nextWaypointAreaPatrol (447):  search for nearRoads with _locPos %1 | _radius %2 | _pos nearRoads _radius returned count _newRoads %3, _nearRoads %4",_locPos, _radius, count _nearRoads, _nearRoads];
									};		
									_nextRoads = roadsConnectedTo (_nearRoads select 0);
									private _roadInfo = getRoadInfo (_nextRoads select 0); 
									_newPos = ASLtoAGL (_roadInfo select 6);  // Position in ASL 							
									_isBlacklisted = [_newPos, _blacklisted] call GMSCOre_fnc_isBlacklisted;
									diag_log format["_nextWaypointAreaPatrol (453):  _isBlacklisted %1 | _newPos %2 | _newLoc %3 | _currDestination %4",_isBlacklisted, _newPos, _newLocation, _currDestination]; 
									diag_log format["_nextWaypointAreaPatrol (454):  distance to location %1 | distance to waypoint/road %2", _veh distance (position _newLocation), _veh distance _newPos];							
									diag_log format["_nextWaypointAreaPatrol (455): _nextRoads select 0 = %1", _nextRoads select 0];
								};
			 
								_group setVariable["lastRoadSegment", _currRoad];	
								_group setVariable["lastChecked", diag_tickTime];
								_group setVariable["wpInitialized", diag_tickTime];	
								_group setVariable["60SecTimer", diag_tickTime];
								_group setVariable["60SecStartPos", getPosATL _veh];
								_group setVariable["wpStartPos",getPosATL _veh];

								_veh setDriveOnPath [getPosATL _veh, newPos];
								_wp setWPPos _newPos;
								_wp setWaypointType "MOVE";
					
								_group setBehaviourStrong "CARELESS";
								_wp setWaypointBehaviour "SAFE";
													_wp setWaypointTimeout [0.1, 0.11, 0.12];
								_wp setWaypointCompletionRadius 150;	
								_group setCurrentWaypoint _wp;
								_group setSpeedMode "LIMITED";	
								_group setVariable["lastRoadSegment", _nextRoads select 0];										
								
																deleteMarker (_group getVariable["wpMarker",""]);
								diag_log format["_nextWaypointAreaPatrol (475):  _isBlacklisted %1 | _newPos %1", _newPos];
								_mrkr = createMarker [ format["WPdebugMarker%1",_newPos], _newPos];
								_mrkr setMarkerType "mil_dot";
								_mrkr setMarkerColor "COLORGREEN";
								_mrkr setMarkerText format["group%1|type %2",_group, if ([typeOf _veh] call GMSCore_fnc_isDrone) then {"UGV"} else {"Car"}];
								_group setVariable["wpMarker",_mrkr];
								diag_log format["_nextWaypointAreaPatrol (481):  _group = %1 || destination %2 || posWP %3 || distance to waypoint %4 || _nextRoads select  0  %5", _group, _newLocation, _newPos, (getPos _veh) distance _newPos, _nextRoads select 0];		
							};
						};
						
					///  ******************
					// End case LANDVEHICLE
					// ********************

					};

					/*
						WE WANT SHIPS TO PATROL AREAS NEAR THE SHORE  
					*/
					case (_veh isKindOf "SHIP"): {
							private _vehPos = getPosASL _veh;
							_newPos = [];
							private _max = 70;
							while {_newPos isEqualTo []} do {
								_newPos = [
									_vehPos, // center of search area
									25, // min distance to search 
									_max, // max distance to search
									0, // distance to nearest object
									2, // water mode [2 = water only]
									100, // max gradient
									0  // shoreMode [0 = anywhere]
								] call BIS_fnc_findSafePos;
								_newPos = ASLtoATL (_newPos append [0]); // BIS_fnc_findSafePos returns a position as [x,y] so we need to add the ASL z coordinate.
								if (_newPos select 2 > 100) then {_newPos = []};
								_max = _max + 15;
							};
							_wp setWPPos _newPos; 
							_wp setWaypointType "MOVE";
							_wp setWaypointBehaviour "SAFE";
							_wp setWaypointCombatMode "GREEN"; 
							_wp setWaypointCompletionRadius 0;
							_wp setWaypointTimeout [0.1, 0.15, 0.2];
							_group setCurrentWaypoint _wp;					
					};

					/*

					// This should never happen for infantry patrols as these do not patrol the entire map, only specific smaller regions.
					
					*/
					case (_veh isEqualTo _leader): {
						_newPos = getPosATL _veh; 
						private _max = 20;
						while {_newPos distance _veh < 30 || surfaceIsWater _newPos} do {
							_max = _max + 10;								
							_newPos = [getPos _veh, _max] call BIS_fnc_randomPosTrigger;
						};	
						_wp setWPPos _newPos; 
						_wp setWaypointType "MOVE";
						_wp setWaypointBehaviour "SAFE";
						_wp setWaypointCombatMode "GREEN"; 
						_wp setWaypointCompletionRadius 0;
						_wp setWaypointTimeout [0.1, 0.15, 0.2];
						_group setCurrentWaypoint _wp;								
					};
				};

				//_newpos = locationPosition _newLocation;
				//diag_log format["_nextWaypointAreaPatrol(247): _newLocation %1 | locationPosition _newLocation %2",_newLocation, locationPosition _newLocation, _leader distance _newPos];

			/***********************************************************************************************
				HANDLE PATROLS WITHIN A PRSCRIPBED MARKER - THSE HAVE ONLY A FEW EDGE CASES OR ERROR STATES
			************************************************************************************************/
			
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
			private _distance = _veh distance _target; 
			switch (true) do {
				case (_veh isKindOf "AIR"): {
					if (_distance > 100) then {
						_newPos = _veh getPos[_distance / 2, _veh getRelDir _target];
					} else {
						_newPos = _target getPos [100 + random (20), random(359)];
					};
				};
				case (_veh isKindOf "LAND"): {
					if (_distance > 50) then {
						_newPos = _veh getPos[_distance / 2, _veh getRelDir _target];
					} else {
						_newPos = _target getPos [50 + random (20), random(359)];
					};
				};
				case (_veh isKindOf "SHIP"): {
					if (_distance > 50) then {
						_newPos = _veh getPos[_distance / 2, _veh getRelDir _target];
					} else {
						_newPos = _target getPos [50 + random (20), random(359)];
					};
				};
				case (_veh isEqualTo _leader): {
					if (_distance > 20) then {
						_newPos = _veh getPos[_distance / 2, _veh getRelDir _target];
					} else {
						_newPos = _target getPos [5 + random (10), random(359)];
					};
				};
			};
			{ _x doSuppressiveFire _target} forEach units _group;
			_wp setWaypointPosition [_newPos,15];
			_wp setWaypointBehaviour "COMBAT";
			_wp setWaypointCombatMode "RED"; 
			_wp setWaypointTimeout [45,60,75];
			_group setCurrentWaypoint _wp;
			_group setSpeedMode "LIMITED";
		};

		case 3: {  // Unit is somewhere it should not be or should disengage 
			diag_log format["_nextWaypointAreaPatrol (335): handling stuck group %1 with vehicle/unit %2 leader %3 _patrolAreaMarker %4 speed _veh %5", _group, getText(configFile >> "CfgVehicles" >> typeOf _veh >> "name"), _leader, _patrolAreaMarker, speed _veh];
			diag_log format["_nextWaypointAreaPatrol (336): simulationEnabled _veh = %1 | simulationEnabled _leader = %2 | dynamicSimulation enabled _veh = %3 | dynamicSimulationEnabled _group = %4", simulationEnabled _veh, simulationEnabled _leader, dynamicSimulationEnabled _veh, dynamicSimulationEnabled _group];
			private _isBlacklisted = true;
			private _radius = 250;
			while {_isBlacklisted || surfaceIsWater _newPos} do {
				_newPos = _veh getPos[_radius,random(359)];
				_isBlacklisted = [_newPos, _blacklisted] call GMSCore_fnc_isBlacklisted;
				_radius = _radius + 50;
			};

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
			diag_log format["_nextWaypointAreaPatrol(635): _leader %1 | _currPos %2 | _newPos %3 | _distance = %4",_leader, getPosATL _leader,_newPos,  _leader distance _newPos];			
			diag_log format ["_nextWaypointAreaPatrol(636): _leader %1 | _veh %2 | speed %3 | _distance = %4",_leader, _veh, speed _veh,  _leader distance _newPos];		
		};
	};
};
