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
//[format["GMSCore_modType = %1",GMSCore_modType]] call GMSCore_fnc_log;


// This block waits for the mod to start but is disabled for now
if ((toLowerANSI GMSCore_modType) isEqualto "epoch") then {
	//["Waiting until EpochMod is ready..."] call GMSCore_fnc_log;
	//waitUntil {!isnil "EPOCH_SERVER_READY"};
	//waitUntil {EPOCH_SERVER_READY};
	//["EpochMod is ready...loading GMSCore"] call GMSCore_fnc_log;
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
		GMSCore_playerUnitTypes = ["Exile_Unit_Player"];
		GMSCore_unitType = "O_Soldier_lite_F";
	};
	case "epoch": 
	{
		GMSCore_Side = RESISTANCE;
		GMSCore_playerUnitTypes = ["Epoch_Male_F","Epoch_Female_F"];
		GMSCore_playerSide = WEST;		
		GMSCore_unitType = "I_Soldier_M_F";			
	};
	default {
		GMSCore_Side = EAST;
		GMSCore_playerUnitTypes = [];
		GMSCore_unitType = "O_Soldier_lite_F";
		GMSCore_playerSide = WEST;		
	};
};

//[format["GMSCore_Side = %1",GMSCore_Side]] call GMSCore_fnc_log;
GMSCore_center = createCenter GMSCore_Side;
if (isNil "GMSCore_graveyardGroup") then 
{
	GMSCore_graveyardGroup = createGroup[GMSCore_Side,false];  // used to store dead units until they are Deleted 
	GMSCore_graveyardGroup setGroupId ["GMS_graveyard"];
};

GMS_formation = "WEDGE";
GMSCore_monitoredVisibleMarkers = [];
//GRGCore_monitoredMarkers = [];
GRGCore_monitoredObjects = [];
GMSCore_monitoredGroups = [];
GMSCore_monitoredPatrolsAir = [];
GMSCore_monitoredPatrolsUAV = [];
GMSCore_monitoredPatrolsLand = [];
gmscore_monitoredpatrolsugv = [];
GMSCore_monitoredPatrolsInfantry = [];
GMSCore_monitoredEmptyVehicles = []; 

GMSCore_waypointLocationsAir = [];	
GMSCore_waypointLocationsLand = [];  

GMSCore_blacklistedAreas = [];		// Never set a waypoint position inside one of these 
GMSCore_noAgroAreas = []; 			 // AI ignore targets while inside one of these 
GMSCore_safeAreas = [];		// Move AI outside of these and re-route to a new waypoint 

GMSCore_onRunoverHitpointDamage = [0.3-0.6];
GMSCore_onRunoverNoHitPointsDamaged = [1,4];

[] call GMSCore_fnc_initializeSimulation;
[] call GMSCore_fnc_configureWorld;
[] call GMSCore_fnc_initializeMessages; 
[] call GMSCore_fnc_setupLocations;
[] spawn GMSCore_fnc_mainThread;  //  Start the scheduler that does all the work.

private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");
GMSCore_Initialized = true;

[format["GMSCore Initialized | Build %1 | Build Date %2 | Initialized at %3 | with GMSCore_modType = %4",_build,_buildDate,diag_tickTime,GMSCore_modType]] call GMSCore_fnc_log;
//[format["GMSCore_Initialized = %", GMSCore_Initialized]] call GMSCore_fnc_log;