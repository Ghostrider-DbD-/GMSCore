/*
	GMS_fnc_giveTakeTabs 

	Purpose: change amount of tabs for a player 

	Parameters:
		_player, the player for which to effect the change 
		_amtTabs, the change in tabs 

	Return: None 

	CREDITS: Adapted from scripts by the ExileMod Development team 	
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_player","_amtTabs"];
//diag_log format["giveTakeTabs: _this = %1",_this];
private _tabs = _player getVariable ["ExileMoney", 0];
_tabs = _tabs + _amtTabs;
_player setVariable ["ExileMoney", _tabs, true];
format["setPlayerMoney:%1:%2", _tabs, _player getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
_player call ExileServer_object_player_sendStatsUpdate;
