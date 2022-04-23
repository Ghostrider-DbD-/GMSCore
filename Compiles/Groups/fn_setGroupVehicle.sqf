
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_group",grpNull],["_vehicle",objNull]];
if !(isNull _group) then {_group setVariable[GMS_groupVehicle,_vehicle]};
//[format["GMS_fnc_setGroupVehicle: GMS_groupVehicle set to %1 for group %2",_vehicle,_group]] call GMS_fnc_log;