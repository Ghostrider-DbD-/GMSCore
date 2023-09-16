/*

*/
#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_player"];
private _idx = EPOCH_communityStats find "Karma";
private _cStats = _player getVariable["COMMUNITY_STATS", EPOCH_defaultStatVars];
private _karma = _cStats select _idx;
//diag_log format["GMSCore_fnc_getKarma _player = %1 | _karma = %2 | _cStats = %3",_player,_karma,_cStats];
_karma