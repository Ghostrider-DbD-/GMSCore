/*
	fn_hoverAndDropoff = {
*/
#include "\GMSCore\Init\GMS_defines.hpp"
private _group = group _this;
private  _aircraft = vehicle (_this);
[_aircraft] spawn GMS_fnc_dropPayload;	 
_group setCurrentWaypoint[_group,_aircraft getVariable "finalWPIndex"];
_m = format["hoverAndDropoff: waypoint set to %1",currentWaypoint _group];
