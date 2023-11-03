
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params["_group","_eh"];
private _ceh = _group getVariable["chainedMPKilled",[]];
_group setVariable ["chainedMPkilled",_ceh pushBack _eh];

