/*
	GMS_fnc_configureMapParameters 

	Purpose: set map center and size based on worldName 
	Notes: I included this because the worldSize/Mapcenter returned from configs is sometimes not sufficiently accurate for this kind of application 

	Parameters: None 

	Returns: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
switch (toLower worldName) do 
{
		case "altis":{
			GMS_mapCenter = [6322,7801,0]; 
			GMS_mapRange = 21000; 
		};
		case "stratis":{
			GMS_mapCenter = [6322,7801,0]; 
			GMS_mapRange = 4500; 
		}; 
		case "chernarus":{
			GMS_mapCenter = [7100, 7750, 0]; 
			GMS_mapRange = 5300;
		};	
		case "chernarus_summer":{GMS_mapCenter = [7100, 7750, 0]; GMS_mapRange = 6000;}; 
		case "bornholm":{
			GMS_mapCenter = [11240, 11292, 0];
			GMS_mapRange = 14400;
		};
		case "esseker":{
			GMS_mapCenter = [6049.26,6239.63,0]; 
			GMS_mapRange = 6000;
		};
		case "taviana":{GMS_mapCenter = [10370, 11510, 0];GMS_mapRange = 14400;};
		case "namalsk":{GMS_mapCenter = [4352, 7348, 0];GMS_mapRange = 10000;};
		case "napf": {GMS_mapCenter = [10240,10240,0]; GMS_mapRange = 14000};  
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
		case "malden":{GMS_mapCenter = [6000,7000,0];GMS_mapRange = 5500;};
        default {GMS_mapCenter = [6322,7801,0]; GMS_mapRange = 6000};
};