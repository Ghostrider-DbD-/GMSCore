/*
	GMS_fnc_giveTakeRespect 

	Purpose: change players respect both on the player and database. 

	Parameters: 
		_player, the player on which to effect the change 
		_amtRespect, the change in respect 

	Returns: None 

	CREDITS: Adapted from scripts by the ExileMod Development team 
*/

#include "\GMSCore\Init\GMS_defines.hpp"
params["_player","_amtRespect"];
//diag_log format["giveTakeRespect: _this = %1",_this];
private _respect = _player getVariable ["ExileScore", 0];
_respect = _respect + (_amtRespect);
_player setVariable ["ExileScore", _respect];
format["setAccountScore:%1:%2", _respect,getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
_player call ExileServer_object_player_sendStatsUpdate;
