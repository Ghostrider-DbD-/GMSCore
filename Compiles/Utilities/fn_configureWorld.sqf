/*
	GMSCore_fnc_configureWorld
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
private ["_markerPosn","_markerSize","_markerRotation","_markerShape","_mapRange"];
 GMSCore_maxGradient = 0.20;
 GMSCore_maxSeaSearchDistance = 20000;
switch (toLowerANSI worldName) do 
{// These may need some adjustment - including a test for shore or water should help as well to avoid missions spawning on water.
		//case "altis":{_markerPosn = [16040,15630]; _markerRotation = -20; _markerShape = "ELLIPSE"; _markerSize = [15000, 11000];};
		case "altis":{_markerPosn = [15466.738,15591.715,0]; _mapRange = 24000; _markerSize = [12500,10429]};		
		case "stratis":{_markerPosn = [3900,4500,0]; _mapRange = 4500;}; 
		case "tanoa":{_markerPosn = [9000,9000,0];  _mapRange = 10000;};
		case "malden":{	_markerPosn = [6000,7000,0];	_mapRange = 6000;};		
		case "enoch":{_markerPosn = [6500,6000,0];  _mapRange = 5800;};
		case "gm_weferlingen_summer":{_markerPosn = [10000,10000,0];	_mapRange = 10000;};
		case "gm_weferlingen_winter":{_markerPosn = [10000,10000,0];	_mapRange = 10000;};
		case "chernarus":{_markerPosn = [7100, 7750, 0]; _mapRange = 5300;};	
		case "namalsk":{_markerPosn = [5700, 8700, 0]; _mapRange = 10000;};		
		case "chernarus_summer":{_markerPosn = [7100, 7750, 0]; _mapRange = 6000;}; 
		case "chernarus_winter":{_markerPosn = [7100, 7750, 0]; _mapRange = 6000;}; 
		case "cup_chernarus_a3":{_markerPosn = [7100, 7750, 0]; _mapRange = 6000;};
		case "bornholm":{_markerPosn = [11240, 11292, 0];_mapRange = 14400;};
		case "esseker":{_markerPosn = [6049.26,6239.63,0]; _mapRange = 6000;};
		case "taviana":{_markerPosn = [10370, 11510, 0];_mapRange = 14400;};
		case "napf": {_markerPosn = [10240,10240,0]; _mapRange = 14000;};  
		case "australia": {_markerPosn = [20480,20480, 150];_mapRange = 40960;};
		case "panthera3":{_markerPosn = [4400, 4400, 0];_mapRange = 4400;};
		case "isladuala":{_markerPosn = [4400, 4400, 0];_mapRange = 4400;};
		case "sauerland":{_markerPosn = [12800, 12800, 0];_mapRange = 12800;};
		case "trinity":{_markerPosn = [6400, 6400, 0];_mapRange = 6400;};
		case "utes":{_markerPosn = [3500, 3500, 0];_mapRange = 3500;};
		case "zargabad":{_markerPosn = [4096, 4096, 0];_mapRange = 4096;};
		case "fallujah":{_markerPosn = [3500, 3500, 0];_mapRange = 3500;};
		case "tavi":{_markerPosn = [10370, 11510, 0];_mapRange = 14090;};
		case "lingor":{_markerPosn = [4400, 4400, 0];_mapRange = 4400;};	
		case "takistan":{_markerPosn = [5500, 6500, 0];_mapRange = 5000;};
		case "lythium":{_markerPosn = [10000,10000,0];_mapRange = 8500;};
		case "vt7": {_markerPosn = [9000,9000,0]; _mapRange = 9000};		
		default {_markerPosn = [8000,6000]; _markerRotation = 0; _markerShape = "ELLIPSE"; _markerSize = [5000, 6000];};
};
if (isNil "markerRotation") then {_markerRotation = 0};
if (isNil "_markerSize") then {_markerSize = [_mapRange / 2, _mapRange / 2]};
if (isNil "_markerShape") then {_markerShape = "RECTANGLE"};
if (getNumber(configFile >> "CfgGMSCore" >> "debug") >= 1) then {
	GMSCore_mapMarker = createMarkerLocal ["GMSCore_mapMarker",_markerPosn];	
	GMSCore_mapMarker setMarkerShapeLocal _markerShape;
	GMSCore_mapMarker setMarkerSizeLocal _markerSize;
	GMSCore_mapMarker setMarkerDirLocal _markerRotation;	
	GMSCore_mapMarker setMarkerColor "ColorGreen";
} else {
	GMSCore_mapMarker = createMarkerLocal ["GMSCore_mapMarker",_markerPosn];	
	GMSCore_mapMarker setMarkerShapeLocal _markerShape;
	GMSCore_mapMarker setMarkerSizeLocal _markerSize;
	GMSCore_mapMarker setMarkerDirLocal _markerRotation;
};
GMS_locationsForWaypoints =  ["NameVillage","NameCity","NameCityCapital","NameLocal","HistoricalSite","StrongpointArea","Strategic"];
GMS_patrolLocations = nearestLocations[_markerPosn,GMS_locationsForWaypoints, (_markerSize select 0) max (_markerSize select 1)];
