
#include "\GMSCore\Init\GMS_defines.hpp"
//private _junk = nearestObjects[[0,0,0],["Man","Air","Ship","Car","Tank","House","ThingX"], 100];
private _junk = [0,0,0] nearEntities[["Man","Air","Ship","Car","Tank","House","ThingX"], 100];
//[format["Running cleanUp of %1 junk items at %2",count _junk, diag_tickTime]] call GMS_fnc_log;
{
	deleteVehicle _x;
} forEach _junk;