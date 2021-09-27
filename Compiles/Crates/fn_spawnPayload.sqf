/*

*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_payload"]; // An object to be spawned somewhere for heli/aircraft drops
private _payload = [_payload,[0,0,0]] call GMS_fnc_spawnCrate;
_payload