/*
	GMS_fnc_updatePlayerKills 

	Purpose: provides a mechanism to update the logs of player kills of AI or other players 

	Parameters:
		_player, the player on which to effect the change 
		_newKills, number of new kills (typically 1)

	Returns: None 
	
	CREDITS: Adapted from scripts by the ExileMod Development team 
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_player","_newKills"];
private _playerKills = _player getVariable ["ExileKills", 0];
_playerKills = _playerKills + _newKills;
_killer setVariable ["ExileKills", _playerKills];
format["addAccountKill:%1", getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
_player call ExileServer_object_player_sendStatsUpdate;