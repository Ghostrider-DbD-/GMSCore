/*

*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

params["_payload"]; // An object to be spawned somewhere for heli/aircraft drops
private _payload = [_payload,[0,0,0]] call GMSCore_fnc_spawnCrate;
_payload