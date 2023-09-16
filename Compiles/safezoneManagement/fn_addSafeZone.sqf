/*
	GMSCore_fnc_addSafeZone

	Purpose - add a safezone. Markers and locations are most efficient. 
	_safezone - the safezone to be added. Allowable formates are defined here: https://community.bistudio.com/wiki/inAreaArray
	These include:
		markers 
		locations 
		shapes formated as follows: 

		center: Array format Position2D or PositionAGL,
		Arma 3 logo black.png
		2.14
		Object or Group
		a: Number - x axis (x / 2)
		b: Number - y axis (y / 2)
		angle: Number - (Optional, default 0) rotation angle
		isRectangle: Boolean - (Optional, default false) true if rectangle, false if ellipse
		c: Number - (Optional, default -1: unlimited) z axis (z / 2)
	_loiterTime 
		The maximum time a unit, group or vehicle and be in a safezone before deletion.
		The default is 30 seconds.
	Returns - none 
	Copyright 2020 by Ghostrider-GRG-
*/
private _defaultLoiterTime =getNumber(configFile >> "CfgGMSCore" >> "GMSCore_maxSafezoneLoiter");
params [["_safeZone",[]],["_loiterTime",_defaultLoiterTime]];  //["_center","_width","_height","_rotation","_maxTime"];
if !(_safeZone isEqualTo []) then {
	GMSCore_safeZoneList pushBack [_safeZone,_loiterTime];
    diag_log format["GMSCore\Compiles\fn_addSafeZone: added %1",[_safeZone,_loiterTime]];
};

