

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
switch (toLowerANSI worldName) do 
{// These may need some adjustment - including a test for shore or water should help as well to avoid missions spawning on water.
		case "altis":{GMS_mapCenter = [12000,10000,0]; GMS_mapRange = 25000;};
		case "stratis":{GMS_mapCenter = [3900,4500,0]; GMS_mapRange = 4500;}; 
		case "tanoa":{GMS_mapCenter = [9000,9000,0];  GMS_mapRange = 10000;};
		case "malden":{	GMS_mapCenter = [6000,7000,0];	GMS_mapRange = 6000;};		
		case "enoch":{GMS_mapCenter = [6500,6000,0];  GMS_mapRange = 5800;};
		case "gm_weferlingen_summer":{GMS_mapCenter = [10000,10000,0];	GMS_mapRange = 10000;};
		case "gm_weferlingen_winter":{GMS_mapCenter = [10000,10000,0];	GMS_mapRange = 10000;};
		case "chernarus":{GMS_mapCenter = [7100, 7750, 0]; GMS_mapRange = 5300;};	
		case "namalsk":{GMS_mapCenter = [5700, 8700, 0]; GMS_mapRange = 10000;};		
		case "chernarus_summer":{GMS_mapCenter = [7100, 7750, 0]; GMS_mapRange = 6000;}; 
		case "chernarus_winter":{GMS_mapCenter = [7100, 7750, 0]; GMS_mapRange = 6000;}; 
		case "cup_chernarus_a3":{GMS_mapCenter = [7100, 7750, 0]; GMS_mapRange = 6000;};
		case "bornholm":{GMS_mapCenter = [11240, 11292, 0];GMS_mapRange = 14400;};
		case "esseker":{GMS_mapCenter = [6049.26,6239.63,0]; GMS_mapRange = 6000;};
		case "taviana":{GMS_mapCenter = [10370, 11510, 0];GMS_mapRange = 14400;};
		case "napf": {GMS_mapCenter = [10240,10240,0]; GMS_mapRange = 14000;};  
		case "australia": {GMS_mapCenter = [20480,20480, 150];GMS_mapRange = 40960;};
		case "panthera3":{GMS_mapCenter = [4400, 4400, 0];GMS_mapRange = 4400;};
		case "isladuala":{GMS_mapCenter = [4400, 4400, 0];GMS_mapRange = 4400;};
		case "sauerland":{GMS_mapCenter = [12800, 12800, 0];GMS_mapRange = 12800;};
		case "trinity":{GMS_mapCenter = [6400, 6400, 0];GMS_mapRange = 6400;};
		case "utes":{GMS_mapCenter = [3500, 3500, 0];GMS_mapRange = 3500;};
		case "zargabad":{GMS_mapCenter = [4096, 4096, 0];GMS_mapRange = 4096;};
		case "fallujah":{GMS_mapCenter = [3500, 3500, 0];GMS_mapRange = 3500;};
		case "tavi":{GMS_mapCenter = [10370, 11510, 0];GMS_mapRange = 14090;};
		case "lingor":{GMS_mapCenter = [4400, 4400, 0];GMS_mapRange = 4400;};	
		case "takistan":{GMS_mapCenter = [5500, 6500, 0];GMS_mapRange = 5000;};
		case "lythium":{GMS_mapCenter = [10000,10000,0];GMS_mapRange = 8500;};
		case "vt7": {GMS_mapCenter = [9000,9000,0]; GMS_mapRange = 9000};		
		default {GMS_mapCenter = [6322,7801,0]; GMS_mapRange = 6000};
};
GMS_mapMarker = createMarkerLocal ["GMS_mapMarker",GMS_mapCenter];
GMS_mapMarker setMarkerShapeLocal "RECTANGLE";
GMS_mapMarker setMarkerSizeLocal [GMS_mapRange,GMS_mapRange];
GMS_world = worldname;
GMS_worldSize = worldSize;
GMS_axis = GMS_worldSize / 2;
GMS_mapCenter = [GMS_axis, GMS_axis, 0];
GMS_mapRadius = sqrt 2 * GMS_axis;
GMS_maxRangePatrols =  GMS_axis * 2 / 3;
GMS_locationsForWaypoints =  ["NameVillage","NameCity","NameCityCapital","NameLocal"];
GMS_patrolLocations = nearestLocations[GMS_mapCenter,GMS_locationsForWaypoints,GMS_mapRange];