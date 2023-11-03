
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull],["_vehicle",objNull]];
if !(isNull _group) then {_group setVariable[GMS_groupVehicle,_vehicle]};
//[format["\x\addons\GMSCore_fnc_setGroupVehicle: GMS_groupVehicle set to %1 for group %2",_vehicle,_group]] call GMSCore_fnc_log;