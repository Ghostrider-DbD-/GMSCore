/*
	GMSCore_init 
	Purpose initialize key global variables and log version number and build information.
	Parameters: None
	Return: none 
	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
GMS_modType = 0;
if (isClass (configFile >> "CfgPatches" >> "exile_server")) then {GMS_modType = "Exile"};
if (isClass(configFile >> "CfgPatches" >> "A3_epoch_server")) then {GMS_modType = "Epoch"};
if (GMS_modType == 0) then {GMS_modType = "default"};

if ((GMS_modType) isEqualto "Epoch") then {
	["Configuring GMSCore for Epoch"] call GMS_fnc_log;
	GMS_Side = RESISTANCE;
	GMS_unitType = "I_Soldier_M_F";	
};
if ((GMS_modType) isEqualTo "Exile") then
{
	["Configuring GMSCore for Exile"] call GMS_fnc_log;	
	GMS_Side = EAST;
	GMS_unitType = "O_Soldier_lite_F";	
};
if (toLowerANSI GMS_modType isEqualTo "default") then 
{
	["Configuring GMSCore for Default Mode"] call GMS_fnc_log;	
	GMS_Side = EAST;
	GMS_unitType = "O_Soldier_lite_F";
};
GMS_center = createCenter GMS_Side;
GMSCore_Initialized = true;
GMS_formation = "WEDGE";
GRGCore_monitoredMarkers = [];
GRGCore_monitoredObjects = [];
GMSCore_monitoredGroups = [];
GMSCore_monitoredAreaPatrols = [];

if (GMS_modType isEqualTo "Epoch") then
{
	GMS_soldierType = "I_Soldier_EPOCH";
};
if (GMS_modType isEqualTo "Exile" || GMS_modType isEqualTo "default") then
{
	GMS_soldierType = "i_g_soldier_unarmed_f";
};
if (GMS_modType isEqualTo "default") then 
{
	GMS_soldierType = "i_g_soldier_unarmed_f";
};

[] spawn GMS_fnc_mainThread;  //  Start the scheduler that does all the work.
private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");
[format["GMSCore Build %1 Build Date %2 Initialized at %3 with GMS_modType = %4",_build,_buildDate,diag_tickTime,GMS_modType]] call GMS_fnc_log;

