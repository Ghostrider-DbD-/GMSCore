/*
	Purpose: initialize GMSCore 
	Parameters: none
	Return: none
	By Ghostrider [GRG]
	Copyright 2020
*/

#include "GMS_defines.hpp"

GMS_debug = getNumber(configFile >> "CfgGMSCore" >> "GMS_debug");
GMS_maxHuntDuration = getNumber(configFile >> "CfgGMSCore" >> "GMS_maxHuntDuration");;
GMS_huntNearestPlayer = if (getNumber(configFile >> "CfgGMSCore" >> "GMS_huntNearestPlayer") == 1) then {true} else {false};;
GMS_hitKillEventUpdateInterval = getNumber(configFile >> "CfgGMSCore" >> "GMS_hitKillEventUpdateInterval");
GMS_modType = "default";
if (!isNull (configFile >> "CfgPatches" >> "exile_server")) then {GMS_modType = "Exile"};
if (!isnull (configFile >> "CfgPatches" >> "a3_epoch_server")) then {GMS_modType = "Epoch"}; 
diag_log format["GMS_fnc_initialize: GMS_modType = %1",GMS_modType];
switch (toLower GMS_modType) do 
{
	case "Exile": 
	{
		GMS_Side = EAST;
		GMS_playerSide = WEST;
		GMS_unitType = "O_Soldier_lite_F";
	};
	case "Epoch": 
	{
		GMS_Side = RESISTANCE;
		GMS_playerUnitTypes = ["Epoch_Male_F","Epoch_Female_F"];
		GMS_playerSide = WEST;		
		GMS_unitType = "I_Soldier_M_F";			
	};
	default {
		GMS_Side = EAST;
		GMS_unitType = "O_Soldier_lite_F";
		GMS_playerSide = WEST;		
	};
};
diag_log format["GMS_fnc_initialize: GMS_Side = %1",GMS_Side];
GMS_center = createCenter GMS_Side;
if (isNil "GMS_graveyardGroup") then 
{
	GMS_graveyardGroup = createGroup[GMS_Side,false];  // used to store dead units until they are Deleted 
	GMS_graveyardGroup setGroupId ["GMS_graveyard"];
};

GMS_formation = "WEDGE";
GRGCore_monitoredMarkers = [];
GRGCore_monitoredObjects = [];
GMSCore_monitoredGroups = [];
GMSCore_monitoredAreaPatrols = [];
GMSCore_monitoredRoadPatrols = [];
GMSCore_monitoredEmptyVehicles = []; 

GMSCore_onRunoverHitpointDamage = [0.3-0.6];
GMSCore_onRunoverNoHitPointsDamaged = [1,4];

// set default group composition 
GMS_infantryGroup = 
[
	["CAPTAIN","assault"],
	["LIEUTENANT","assault"],
	["SERGEANT","support"],
	["CORPORAL","sniper"],
	["PRIVATE","assault"]
];

GMS_killedMsgTypes = [
	//"toast",
	//"epochMsg",
	//"hint",
	//"cutText",
	"dynamic",
	"systemChat"
];
[GMS_killedMsgTypes] call GMS_fnc_configureOnKilledMessages;
diag_log format["GMSCore: Initilize - GMS_killedMsgTypes = %1",GMS_killedMsgTypes];

GMS_huntedMsgTypes = [
	//"toast",
	//"epochMsg",
	//"hint",
	//"cutText",
	//"dynamic",
	"systemChat"
];
[GMS_huntedMsgTypes] call GMS_fnc_configureOnHuntMessages;
diag_log format["GMSCore: Initilize - GMS_huntedMsgTypes = %1",GMS_huntedMsgTypes];

GMS_alertMsgTypes = [
	//"toast",
	//"epochMsg",
	//"hint",
	//"cutText",
	//"dynamic",
	"systemChat"
];
[GMS_alertMsgTypes] call GMS_fnc_configureAlertMessages; 
diag_log format["GMSCore: Initilize - GMS_alertMstTypes = %1",GMS_alertMsgTypes];

GMS_vehicleGroup = GMS_infantryGroup;
GMS_aircraftGroup = GMS_infantryGroup; 

private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");

publicVariable "GMS_fnc_textAlert";
publicVariable "GMS_fnc_titleTextAlert";
publicVariable "GMS_fnc_huntedMessages";
publicVariable "GMS_fnc_killedMessages";
publicVariable "GMS_ModType";
publicVariable "GMS_killedMsgTypes";
publicVariable "GMS_alertMsgTypes";
publicVariable "GMS_huntedMsgTypes";

[] call GMS_fnc_findWorld;
[] spawn GMS_fnc_mainThread;  //  Start the scheduler that does all the work.

[format["GMSCore Build %1 Build Date %2 Initialized at %3 with GMS_modType = %4",_build,_buildDate,diag_tickTime,GMS_modType]] call GMS_fnc_log;
GMSCore_Initialized = true;
