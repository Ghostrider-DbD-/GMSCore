/*
	Purpose: initialize GMSCore 
	Parameters: none
	Return: none
	By Ghostrider [GRG]
	Copyright 2020
*/

/*
	Setup toggline of dynamic simulation debug here
	Each remoteExec should be configure to execute as part of the JIP cue.
*/
		

/* set up the onPlayerConnected EH here */
onPlayerConnected {}; // seems this is needed or addMissionEventHandler "PlayerConnected" does not work. as of A3 1.60
addMissionEventHandler [
	"PlayerConnected", 
	{
		params["_id","_uid","_name","_jip","_owner"];
		[format["Initializing Player Configs for player _uid %1 | _name %2",_uid,_name]] call GMSCore_fnc_log;
		_owner publicVariableClient "GMSCore_fnc_textAlert";
		_owner publicVariableClient "GMSCore_fnc_titleTextAlert";	
		_owner publicVariableClient "GMSCore_fnc_huntedMessages";		
		_owner publicVariableClient "GMSCore_fnc_killedMessages";			
		_owner publicVariableClient "GMSCore_modType";	

		_dynSimDebug = getNumber(configFile >> "CfgGMSCore" >> "debugDynamicSimulation");
		[format["Initialize: _dynSimDebug = %1",_dynSimDebug]] call GMSCore_fnc_log;	
		if (_dynSimDebug >= 1) then {
			switch (_dynSimDebug) do {
				case 1: {
					["DynSimEntities"] remoteExec ["diag_toggle", _owner];
				};

				case 2: {
					["DynSimGroups"] remoteExec ["diag_toggle", _owner];
				};

				case (1 + 3): {  // grid and entities 
					["DynSimEntities"] remoteExec ["diag_toggle", _owner];
					["DynSimGrid"] remoteExec ["diag_toggle", _owner];				
				};

				case (1 + 4): {  // grid and groups
					["DynSimGroups"] remoteExec ["diag_toggle", _owner];
					["DynSimGrid"] remoteExec ["diag_toggle", _owner];				
				};
			};
		};			
	}
];

[] spawn {
	#include "GMSCore_defines.hpp"
	GMSCore_modType = "default";
	if (!isNull (configFile >> "CfgPatches" >> "exile_server")) then {GMSCore_modType = "Exile"};
	if (!isnull (configFile >> "CfgPatches" >> "a3_epoch_server")) then {GMSCore_modType = "Epoch"}; 
	[format["GMSCore_modType = %1",GMSCore_modType]] call GMSCore_fnc_log;
	// This block waits for the mod to start but is disabled for now
	if ((toLowerANSI GMSCore_modType) isEqualto "epoch") then {
		//["Waiting until EpochMod is ready..."] call GMSCore_fnc_log;
		//waitUntil {!isnil "EPOCH_SERVER_READY"};
		//["EpochMod is ready...loading GMSCore"] call GMSCore_fnc_log;
	};
	if ((toLowerANSI GMSCore_modType) isEqualTo "exile") then
	{
		["Waiting until ExileMod is ready ..."] call GMSCore_fnc_log;
		//waitUntil { "PublicServerIsLoaded"};
		waitUntil {!ExileServerIsLocked};
		["Exilemod is ready...loading GMSCore"] call GMSCore_fnc_log;	
	};
	publicVariable "GMSCore_modType";
	GMSCore_debug = getNumber(configFile >> "CfgGMSCore" >> "debug");
	GMSCore_maxHuntDuration = getNumber(configFile >> "CfgGMSCore" >> "maxHuntDuration");;
	GMSCore_huntNearestPlayer = if (getNumber(configFile >> "CfgGMSCore" >> "huntNearestPlayer") == 1) then {true} else {false};;
	GMSCore_hitKillEventUpdateInterval = getNumber(configFile >> "CfgGMSCore" >> "hitKillEventUpdateInterval");

	switch (toLowerANSI GMSCore_modType) do 
	{
		case "exile": 
		{
			GMSCore_Side = EAST;
			GMSCore_playerSide = WEST;
			GMSCore_unitType = "O_Soldier_lite_F";
		};
		case "epoch": 
		{
			GMSCore_Side = RESISTANCE;
			GMS_playerUnitTypes = ["Epoch_Male_F","Epoch_Female_F"];
			GMSCore_playerSide = WEST;		
			GMSCore_unitType = "I_Soldier_M_F";			
		};
		default {
			GMSCore_Side = EAST;
			GMSCore_unitType = "O_Soldier_lite_F";
			GMSCore_playerSide = WEST;		
		};
	};
	[format["GMSCore_Side = %1",GMSCore_Side]] call GMSCore_fnc_log;
	GMSCore_center = createCenter GMSCore_Side;
	if (isNil "GMSCore_graveyardGroup") then 
	{
		GMSCore_graveyardGroup = createGroup[GMSCore_Side,false];  // used to store dead units until they are Deleted 
		GMSCore_graveyardGroup setGroupId ["GMS_graveyard"];
	};

	GMS_formation = "WEDGE";
	GRGCore_monitoredMarkers = [];
	GRGCore_monitoredObjects = [];
	GMSCore_monitoredGroups = [];
	GMSCore_monitoredAreaPatrols = [];
	GMSCore_monitoredRoadPatrols = [];
	GMSCore_monitoredEmptyVehicles = []; 
	GMSCore_monitoredVisibleMarkers = [];  //  List of objects to which visible markers are attached: variables used are "\x\addons\GMSCoreVMStart" [float], "\x\addons\GMSCoreVMEnd" [float], "\x\addons\GMSCoreMarkers [smoke,chemlight], "\x\addons\GMSCoreMarkerTypes [_smokeShell,_chemLight]
	GMSCore_safeZoneList = [];
	GMSCore_onRunoverHitpointDamage = [0.3-0.6];
	GMSCore_onRunoverNoHitPointsDamaged = [1,4];

	// set default group composition 
	GMSCore_infantryGroup = 
	[
		["CAPTAIN","assault"],
		["LIEUTENANT","assault"],
		["SERGEANT","support"],
		["CORPORAL","sniper"],
		["PRIVATE","assault"]
	];


	GMSCore_killedMsgTypes = [
		//"toast",
		//"epochMsg",
		//"hint",
		//"cutText",
		"dynamic",
		"systemChat"
	];
	//[GMSCore_killedMsgTypes] call GMSCore_fnc_configureOnKilledMessages;
	[format["GMSCore_killedMsgTypes = %1",GMSCore_killedMsgTypes]] call GMSCore_fnc_log;


	GMSCore_huntedMsgTypes = [
		//"toast",
		//"epochMsg",
		//"hint",
		//"cutText",
		//"dynamic",
		"systemChat"
	];
	[GMSCore_huntedMsgTypes] call GMSCore_fnc_configureOnHuntMessages;
	[format["GMSCore_huntedMsgTypes = %1",GMSCore_huntedMsgTypes]] call GMSCore_fnc_log;

	GMSCore_alertMsgTypes = [
		//"toast",
		//"epochMsg",
		//"hint",
		//"cutText",
		//"dynamic",
		"systemChat"
	];
	[GMSCore_alertMsgTypes] call GMSCore_fnc_configureAlertMessages; 
	[format["GMS_alertMsgTypes = %1",GMSCore_alertMsgTypes]] call GMSCore_fnc_log;

	private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
	private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
	private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");

	[] call GMSCore_fnc_findWorld;
	[] spawn GMSCore_fnc_mainThread;  //  Start the scheduler that does all the work.

	enableDynamicSimulationSystem true; 

	"IsMoving" setDynamicSimulationDistanceCoef 3;
	"Group" setDynamicSimulationDistance 2500;
	"Vehicle" setDynamicSimulationDistance 2500; 
	"EmptyVehicle" setDynamicSimulationDistance 1500; 
	"Prop" setDynamicSimulationDistance 1500;

	[format["Dynamic simulation configured at %1",diag_tickTime]]  call GMSCore_fnc_log;

	[format["Build %1 Build Date %2 Initialized at %3 with GMSCore_modType = %4",_build,_buildDate,diag_tickTime,GMSCore_modType]] call GMSCore_fnc_log;
	GMSCore_Initialized = true;
};