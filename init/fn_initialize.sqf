/*
	Purpose: initialize GMSCore 
	Parameters: none
	Return: none
	By Ghostrider [GRG]
	Copyright 2020
*/

#include "GMSCore_defines.hpp"
GMSCore_modType = "default";
if (!isNull (configFile >> "CfgPatches" >> "exile_server")) then {GMSCore_modType = "Exile"};
if (!isnull (configFile >> "CfgPatches" >> "a3_epoch_server")) then {GMSCore_modType = "Epoch"}; 
[format["\x\addons\GMSCore_modType = %1",GMSCore_modType]] call GMSCore_fnc_log;
// This block waits for the mod to start but is disabled for now
if ((toLowerANSI GMSCore_modType) isEqualto "epoch") then {
	//["Waiting until EpochMod is ready..."] call GMSCore_fnc_log;
	//waitUntil {!isnil "EPOCH_SERVER_READY"};
	//["EpochMod is ready...loading GMSCore"] call GMSCore_fnc_log;
};
if ((toLowerANSI GMSCore_modType) isEqualTo "exile") then
{
	["Waiting until ExileMod is ready ..."] call GMSCore_fnc_log;
	waitUntil {!isNil "PublicServerIsLoaded"};
	["Exilemod is ready...loading GMSCore"] call GMSCore_fnc_log;	
};
publicVariable "\x\addons\GMSCore_modType";
GMSCore_debug = getNumber(configFile >> "CfgGMSCore" >> "\x\addons\GMSCore_debug");
GMSCore_maxHuntDuration = getNumber(configFile >> "CfgGMSCore" >> "\x\addons\GMSCore_maxHuntDuration");;
GMSCore_huntNearestPlayer = if (getNumber(configFile >> "CfgGMSCore" >> "\x\addons\GMSCore_huntNearestPlayer") == 1) then {true} else {false};;
GMSCore_hitKillEventUpdateInterval = getNumber(configFile >> "CfgGMSCore" >> "\x\addons\GMSCore_hitKillEventUpdateInterval");

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
[format["\x\addons\GMSCore_Side = %1",GMSCore_Side]] call GMSCore_fnc_log;
GMSCore_center = createCenter GMSCore_Side;
if (isNil "\x\addons\GMSCore_graveyardGroup") then 
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

/*
GMSCore_killedMsgTypes = [
	//"toast",
	//"epochMsg",
	//"hint",
	//"cutText",
	"dynamic",
	"systemChat"
];
[GMSCore_killedMsgTypes] call GMSCore_fnc_configureOnKilledMessages;
[format["\x\addons\GMSCore_killedMsgTypes = %1",GMSCore_killedMsgTypes]] call GMSCore_fnc_log;
*/

GMSCore_huntedMsgTypes = [
	//"toast",
	//"epochMsg",
	//"hint",
	//"cutText",
	//"dynamic",
	"systemChat"
];
[GMSCore_huntedMsgTypes] call GMSCore_fnc_configureOnHuntMessages;
[format["\x\addons\GMSCore_huntedMsgTypes = %1",GMSCore_huntedMsgTypes]] call GMSCore_fnc_log;

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

//GMSCore_vehicleGroup = GMSCore_infantryGroup;
//GMSCore_aircraftGroup = GMSCore_infantryGroup; 

private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");

/*
publicVariable "\x\addons\GMSCore_fnc_textAlert";
publicVariable "\x\addons\GMSCore_fnc_titleTextAlert";
publicVariable "\x\addons\GMSCore_fnc_huntedMessages";
publicVariable "\x\addons\GMSCore_fnc_killedMessages";
publicVariable "\x\addons\GMSCore_modType";
publicVariable "\x\addons\GMSCore_killedMsgTypes";
publicVariable "\x\addons\GMSCore_alertMsgTypes";
publicVariable "\x\addons\GMSCore_huntedMsgTypes";
*/

[] call GMSCore_fnc_findWorld;
[] spawn GMSCore_fnc_mainThread;  //  Start the scheduler that does all the work.

[format["Build %1 Build Date %2 Initialized at %3 with GMSCore_modType = %4",_build,_buildDate,diag_tickTime,GMSCore_modType]] call GMSCore_fnc_log;
GMSCore_Initialized = true;

/*

/* set up the onPlayerConnected EH here */
onPlayerConnected {}; // seems this is needed or addMissionEventHandler "PlayerConnected" does not work. as of A3 1.60
addMissionEventHandler ["PlayerConnected", 
{
    params["_id","_uid","_name","_jip","_owner"];
	_owner publicVariableClient "GMSCore_fnc_textAlert";
	_owner publicVariableClient "GMSCore_fnc_titleTextAlert";	
	_owner publicVariableClient "GMSCore_fnc_huntedMessages";		
	_owner publicVariableClient "GMSCore_fnc_killedMessages";			
	_owner publicVariableClient "GMSCore_modType";		
}];
