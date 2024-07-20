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
[format["GMSCore_modType = %1",GMSCore_modType]] call GMSCore_fnc_log;


// This block waits for the mod to start but is disabled for now
if ((toLowerANSI GMSCore_modType) isEqualto "epoch") then {
	["Waiting until EpochMod is ready..."] call GMSCore_fnc_log;
	waitUntil {!isnil "EPOCH_SERVER_READY"};
	waitUntil {EPOCH_SERVER_READY};
	["EpochMod is ready...loading GMSCore"] call GMSCore_fnc_log;
};
if ((toLowerANSI GMSCore_modType) isEqualTo "exile") then
{
	["Waiting until ExileMod is ready ..."] call GMSCore_fnc_log;

	//waitUntil {!isNil "PublicServerIsLoaded" && PublicServerIsLoaded};
	
	["Exilemod is ready...loading GMSCore"] call GMSCore_fnc_log;	
};

publicVariable "GMSCore_modType";

GMSCore_debug = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_debug");
GMSCore_maxHuntDuration = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_maxHuntDuration");;
GMSCore_huntNearestPlayer = if (getNumber(configFile >> "CfgGMSCore" >> "GMSCore_huntNearestPlayer") == 1) then {true} else {false};;
GMSCore_hitKillEventUpdateInterval = getNumber(configFile >> "CfgGMSCore" >> "GMSCore_hitKillEventUpdateInterval");

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
GMSCore_safeZoneList = [];
GMSCore_onRunoverHitpointDamage = [0.3-0.6];
GMSCore_onRunoverNoHitPointsDamaged = [1,4];

// set default group composition 
GMSCore_infantryGroup = getArray(configFile >> "CfgGMSCore" >> "GMSInfantryGroup");
GMSCore_killedMsgTypes = getArray(configFile >> "CfgGMSCore" >> "GMSCore_killedMsgTypes");
GMSCore_huntedMsgTypes = getArray(configFile >> "CfgGMSCore" >> "GMSCore_huntedMsgTypes");
GMSCore_alertMsgTypes = getArray(configFile >> "CfgGMSCore" >> "GMSCore_alertMsgTypes");

[GMSCore_killedMsgTypes] call GMSCore_fnc_configureOnKilledMessages;
[format["GMSCore_killedMsgTypes = %1",GMSCore_killedMsgTypes]] call GMSCore_fnc_log;
[GMSCore_huntedMsgTypes] call GMSCore_fnc_configureOnHuntMessages;
[format["GMSCore_huntedMsgTypes = %1",GMSCore_huntedMsgTypes]] call GMSCore_fnc_log;
[GMSCore_huntedMsgTypes] call GMSCore_fnc_configureOnHuntMessages;
[format["GMSCore_huntedMsgTypes = %1",GMSCore_huntedMsgTypes]] call GMSCore_fnc_log;
[GMSCore_alertMsgTypes] call GMSCore_fnc_configureAlertMessages; 
[format["GMS_alertMsgTypes = %1",GMSCore_alertMsgTypes]] call GMSCore_fnc_log;


private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");

publicVariable "GMSCore_fnc_textAlert";
publicVariable "GMSCore_fnc_titleTextAlert";
publicVariable "GMSCore_fnc_huntedMessages";
publicVariable "GMSCore_fnc_killedMessages";
publicVariable "GMSCore_modType";
publicVariable "GMSCore_killedMsgTypes";
publicVariable "GMSCore_alertMsgTypes";
publicVariable "GMSCore_huntedMsgTypes";

enableDynamicSimulationSystem true; 

"IsMoving" setDynamicSimulationDistanceCoef 3;
"Group" setDynamicSimulationDistance 2000;
"Vehicle" setDynamicSimulationDistance 20000; 
"EmptyVehicle" setDynamicSimulationDistance 500; 
"Prop" setDynamicSimulationDistance 50;
if ( GMSCore_debug > 0) then {[format["Dynamic simulation configured at %1",diag_tickTime]]  call GMSCore_fnc_log};

[] call GMSCore_fnc_configureWorld;

[] spawn GMSCore_fnc_mainThread;  //  Start the scheduler that does all the work.

/* set up the onPlayerConnected EH here */


//onPlayerConnected {}; // seems this is needed or addMissionEventHandler "PlayerConnected" does not work. as of A3 1.60

/*
	// Hangs on Exile servers so leave this out. 
addMissionEventHandler [
	"PlayerConnected", 
	{
		params["_id","_uid","_name","_jip","_owner"];
		[format["Broadcasting Client Code for player _uid %1 | _name %2",_uid,_name]] call GMSCore_fnc_log;
		_owner publicVariableClient "GMSCore_fnc_textAlert";
		_owner publicVariableClient "GMSCore_fnc_titleTextAlert";	
		_owner publicVariableClient "GMSCore_fnc_huntedMessages";		
		_owner publicVariableClient "GMSCore_fnc_killedMessages";			
		_owner publicVariableClient "GMSCore_modType";			
	}
];
*/


[format["Build %1 Build Date %2 Initialized at %3 with GMSCore_modType = %4",_build,_buildDate,diag_tickTime,GMSCore_modType]] call GMSCore_fnc_log;
GMSCore_Initialized = true;
