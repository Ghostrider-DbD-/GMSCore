/*
	GMSCore_fnc_cleanupSafeZones 

	Purpose - test for units of type GMSCore_unitType in each of the safezones defined in GMSCore_safeZoneList and delete any that have lingered too long. 
	Parameters - none  
	Returns - none 
	Copyright 2020 by Ghostrider-GRG-
*/
private _maxLoiterTime = getNumber(configFile >> "CfgGMSCore" >> "\x\addons\GMSCore_maxSafezoneLoiger");
diag_log format["GMS_Core_fnc_cleanupSafezones: _maxLoiterTime = %1",_maxLoiterTime];
{
	//  Parse the information for this specific safezone.
	_safeZoneSetup = _x;  //  For clarity when reviewing the code later
	_safeZoneSetup params["_safeZone","_maxLoiterTime"];
	// Test if there are any units from GMS systems in the safezone 
	private _units = GMSCore_unitType inAreaArray _safeZone;
	// Just keep assets that are spawned by GMSCore
	_units = _units select {(_x getVariable[GMS_Asset,false]) isEqualTo true};  //  Doing this separately just for easier reading of code  

	{
		private _inSafeZone = _x getVariable ["inSZ", []];
		if (_inSafeZone isEqualTo []) then {
			_x setVariable["inSZ",[_safeZone,diag_tickTime]];
		} else {
			(_x getVariable["inSZ"]) params["_unitSafeZone","_timeIn"];
			if (_unitSafeZone isEqualTo _safeZone) then { // the unit is still in the same safeZone 
				if (diag_tickTime - _timeIn > _maxLoiterTime) then {
					private _group = group _x;
					private _veh = vehicle _x;
					if (_veh isKindOf "Man") then {
						[_group] call GMSCore_fnc_despawnInfantryGroup;
					} else {
						[_veh] call GMSCore_fnc_destroyVehicleAndCrew;
					};
				};
			} else {
				// update the safezone information to the currently occupied safezone
				_x setVariable["inSZ",[_safeZone,diag_tickTime];
			};
		};
	} forEach _units;
} forEach GMSCore_safeZoneList;
