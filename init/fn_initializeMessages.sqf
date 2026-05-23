/*
    GMSCore_fnc_initializeMessages 

    Purpose: Configure and broadcast messages and messaging settings 

    Parameters: None 

    Returns: None 

*/


//set default group composition 
GMSCore_infantryGroup = getArray(configFile >> "CfgGMSCore" >> "GMSInfantryGroup");
GMSCore_killedMsgTypes = getArray(configFile >> "CfgGMSCore" >> "GMSCore_killedMsgTypes");
GMSCore_huntedMsgTypes = getArray(configFile >> "CfgGMSCore" >> "GMSCore_huntedMsgTypes");
GMSCore_alertMsgTypes = getArray(configFile >> "CfgGMSCore" >> "GMSCore_alertMsgTypes");

[GMSCore_killedMsgTypes] call GMSCore_fnc_configureOnKilledMessages;
[GMSCore_huntedMsgTypes] call GMSCore_fnc_configureOnHuntMessages;
[GMSCore_huntedMsgTypes] call GMSCore_fnc_configureOnHuntMessages;
[GMSCore_alertMsgTypes] call GMSCore_fnc_configureAlertMessages; 

if (GMSCore_debug > 0) then {
	[format["GMSCore_huntedMsgTypes = %1",GMSCore_huntedMsgTypes]] call GMSCore_fnc_log;
	[format["GMSCore_huntedMsgTypes = %1",GMSCore_huntedMsgTypes]] call GMSCore_fnc_log;
	[format["GMSCore_killedMsgTypes = %1",GMSCore_killedMsgTypes]] call GMSCore_fnc_log;
	[format["GMS_alertMsgTypes = %1",GMSCore_alertMsgTypes]] call GMSCore_fnc_log;
	[format["GMSCore_antiStuckTimer = %1", getNumber(configFile >> "CfgGMSCore" >> "GMSCore_antiStuckTimer")]] call GMSCore_fnc_log;
};

publicVariable "GMSCore_fnc_textAlert";
publicVariable "GMSCore_fnc_titleTextAlert";
publicVariable "GMSCore_fnc_huntedMessages";
publicVariable "GMSCore_fnc_killedMessages";
publicVariable "GMSCore_modType";
publicVariable "GMSCore_killedMsgTypes";
publicVariable "GMSCore_alertMsgTypes";
publicVariable "GMSCore_huntedMsgTypes";
