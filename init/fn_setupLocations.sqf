/*
    GMSCore_fnc_locations 

    Purpose: Initialize lists of locations including
        Blacklisted positions such as traders
        No Agro positions such as traders 

    Parameters: None 

    Returns: None 
*/

#include "GMSCore_defines.hpp"
// Add any Epoch Traders 
// This runs before GMSAI or GMS_RC run so the lists of blacklisted and noAgro locations should be empty. 
if ((toLowerANSI GMSCore_modType) isEqualto "epoch") then {
    {
        private _telePos = _x select 3; 
        private _blName = format["Telepos%1",_forEachIndex];
        [[_telePos, 300, 300], _blName] call GMSCore_fnc_addBlacklistedLocation;
        [[_telePos, 300, 300], _blName] call GMSCore_fnc_addNoAggroLocation;
    } forEach ([configFile >> "CfgEpoch" >> worldName,"telePos",[]] call BIS_fnc_returnConfigEntry);
};

private _markerSize = getMarkerSize GMSCore_mapMarker;
private _markerPos = getMarkerPos GMSCore_mapMarker; 
private _radius = (_markerSize select 0) max (_markerSize select 1);

private _blacklist = nearestLocations[_markerPos, [WAYPOINT_DISALLOWED_AREAS], _radius];
private _locationsAir = nearestLocations[_markerPos, [LOCATION_TYPES_AIR], _radius];

{
    if !([position _x, _blacklist, "GMSCore_fnc_setupLocations"] call GMSCore_fnc_isBlacklisted) then {
        GMSCore_waypointLocationsAir pushBack _x;
    };
} forEach _locationsAir;

/*
private _locationsLand = nearestLocations[_markerPos, [LOCATION_TYPES_LAND], (_markerSize select 0) max (_markerSize select 1)];
{
    if !(surfaceIsWater position _x) then {
        
        if !([position _x, _blacklist] call GMSCore_fnc_isBlacklisted) then {
            GMSCore_waypointLocationsLand pushBack _x;
        };
    };
} forEach _locationsLand;
*/

