/*
	GMSCore_fnc_configureMapParameters 

	Purpose: set map center and size based on worldName 
	Notes: I included this because the worldSize/Mapcenter returned from configs is sometimes not sufficiently accurate for this kind of application 

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
switch (toLowerANSI worldName) do 
{
		case "altis":{
			_markerPosn = [6322,7801,0]; 
			_mapRange = 21000; 
		};
		case "stratis":{
			_markerPosn = [6322,7801,0]; 
			_mapRange = 4500; 
		}; 
		case "chernarus":{
			_markerPosn = [7100, 7750, 0]; 
			_mapRange = 5300;
		};	
		case "chernarus_summer":{_markerPosn = [7100, 7750, 0]; _mapRange = 6000;}; 
		case "bornholm":{
			_markerPosn = [11240, 11292, 0];
			_mapRange = 14400;
		};
		case "esseker":{
			_markerPosn = [6049.26,6239.63,0]; 
			_mapRange = 6000;
		};
		case "taviana":{_markerPosn = [10370, 11510, 0];_mapRange = 14400;};
		case "namalsk":{_markerPosn = [4352, 7348, 0];_mapRange = 10000;};
		case "napf": {_markerPosn = [10240,10240,0]; _mapRange = 14000};  
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
		case "malden":{_markerPosn = [6000,7000,0];_mapRange = 5500;};
        default {_markerPosn = [6322,7801,0]; _mapRange = 6000};
};