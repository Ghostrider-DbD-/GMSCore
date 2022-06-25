/*
	fn_selectDropWaypoint = {
*/
#include "\GMSCore\Init\GMSCore_defines.hpp"

private _aircraft = vehicle _this;
_aircraft setSpeedMode "LIMITED";	
(group _this) setCurrentWaypoint [group _this,_aircraft getVariable "dropCargoIndex"];

