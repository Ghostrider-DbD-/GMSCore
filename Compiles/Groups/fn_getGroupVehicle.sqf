
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_group",grpNull]];
private _vehicle = objNull;
if !(isNull _group) then {_vehicle = _group getVariable[GMS_groupVehicle,objNull]};
//[format["\x\addons\GMSCore_fnc_getGroupVehicle: vehicle for group %1 = %2  || _return = %3",_group,typeOf _vehicle,_vehicle]] call GMSCore_fnc_log;
_vehicle