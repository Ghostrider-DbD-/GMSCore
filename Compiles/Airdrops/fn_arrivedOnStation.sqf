/*
	GMS_fnc_arrivedOnStation 
	Purpose: setup aircraft to drop payload at drop position  
	Parameters: those handed down by the waypoint manager of arma (leader _group) 
	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"

private _group = group(_this);
private _aircraft = vehicle (_this);
_aircraft setSpeedMode "LIMITED";
_group setCurrentWaypoint[_group,_aircraft getVariable "wp3Index"];

