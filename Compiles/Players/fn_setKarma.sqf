/*

*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_player","_incrementKarma"];
//diag_log format["GMSCore_fnc_giveTakeKarma: _player %1 | _karma %2 ",_player,_incrementKarma];
#define toClient true 
#define isTotal false
[_player, "Karma", _incrementKarma, toClient, isTotal] call EPOCH_server_updatePlayerStats;