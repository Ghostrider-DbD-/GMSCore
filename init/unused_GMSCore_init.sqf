/*
	GMSCore_init 
	Purpose initialize key global variables and log version number and build information.
	Parameters: None
	Return: none 
	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
GMSCore_modType = 0;
if (isClass (configFile >> "CfgPatches" >> "exile_server")) then {GMSCore_modType = "Exile"};
if (isClass(configFile >> "CfgPatches" >> "A3_epoch_server")) then {GMSCore_modType = "Epoch"};
if (GMSCore_modType == 0) then {GMSCore_modType = "default"};

if ((GMSCore_modType) isEqualto "Epoch") then {
	["Configuring GMSCore for Epoch"] call GMSCore_fnc_log;
	GMSCore_Side = RESISTANCE;
	GMSCore_unitType = "I_Soldier_M_F";	
};
if ((GMSCore_modType) isEqualTo "Exile") then
{
	["Configuring GMSCore for Exile"] call GMSCore_fnc_log;	
	GMSCore_Side = EAST;
	GMSCore_unitType = "O_Soldier_lite_F";	
};
if (toLowerANSI GMSCore_modType isEqualTo "default") then 
{
	["Configuring GMSCore for Default Mode"] call GMSCore_fnc_log;	
	GMSCore_Side = EAST;
	GMSCore_unitType = "O_Soldier_lite_F";
};
GMSCore_center = createCenter GMSCore_Side;
GMSCore_Initialized = true;
GMS_formation = "WEDGE";
GRGCore_monitoredMarkers = [];
GRGCore_monitoredObjects = [];
GMSCore_monitoredGroups = [];
GMSCore_monitoredAreaPatrols = [];

if (GMSCore_modType isEqualTo "Epoch") then
{
	GMS_soldierType = "I_Soldier_EPOCH";
};
if (GMSCore_modType isEqualTo "Exile" || GMSCore_modType isEqualTo "default") then
{
	GMS_soldierType = "i_g_soldier_unarmed_f";
};
if (GMSCore_modType isEqualTo "default") then 
{
	GMS_soldierType = "i_g_soldier_unarmed_f";
};

[] spawn GMSCore_fnc_mainThread;  //  Start the scheduler that does all the work.
private _ver =  getNumber(configFile >> "GMSCoreBuild" >> "version");
private _build = getNumber(configFile >> "GMSCoreBuild" >> "build");
private _buildDate = getText(configFile >> "GMSCoreBuild" >> "buildDate");
[format["GMSCore Build %1 Build Date %2 Initialized at %3 with GMSCore_modType = %4",_build,_buildDate,diag_tickTime,GMSCore_modType]] call GMSCore_fnc_log;

