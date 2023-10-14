/*
	Copyright 2020 by Ghostrider-GRG-
*/

class GMSCoreBuild {
	version = 1.058;
	build = 40;
	buildDate = "10-14-23";
};
class CfgPatches {
	class GMSCore {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};

#include "CfgGMSCore.hpp"
class CfgFunctions {
	class GMSCore {
		class Airdrops {
			file = "GMSCore\Compiles\Airdrops";
			class arrivedOnStation {};
			class cleanUpHeli {};
			class dropParatroops {};
			class dropPayload {};
			class flyInCargoToLocation {};			
			class hoverAndDropOff {};
			class selectDropWaypoint {};
			class setAircraftPayload {};							
		};		
		class Client {
			file = "GMSCore\Compiles\Client";
			class configureAlertMessages {};
			class configureOnHuntMessages {};
			class configureOnKilledMessages {};
			class initializeClientFunctions {};
			class huntedMessages {};
			class textAlert {};
			class titleTextAlert {};
			class killedMessages {};
		};
		class Crates {
			file = "GMSCore\Compiles\Crates";
			class addItem {};
			class addItemsFromArray {};  // weighted array either a single array, or array of arrays.
			class attachCrateMarkers {};
			class monitorVisibleMarkers {};
			class spawnCrate {}; // which can be any object, but is a crate by default.			
			class visibleMarker {};
		};
		class GMS_Functions {
			file = "GMSCore\Compiles\Functions";
			class addToDeletionCue {};
			class checkClassnamesArray {};
			class checkClassNamePrices {};
			class cleanUpJunk {};
			class deleteObjectsMethod {};
			class dynamicConfigs {};
 			class findRandomPosWithinArea {};	
			class getDimensions {};			 				
			class getNumberFromRange {};
			class getIntegerFromRange {};
			class getCfgType {};
			class getModType {};
			class groupCanSee {};
			class isBlacklisted {};			
			class isClass {};
			class isDrone {};
			class mainThread {};
			class monitorMapMarkers {};
			class monitorObjectDeletionCue {};			
			class nearestGMSAI {};
			class nearestPlayers {};
			class nearestTarget {};	
			class objectHeight {};		
			class removeBlacklistedItems {};
			//class setGroupHuntVehicles {};
			class removeNullEntries {};
			class setMoney {};
			class setOnRunoverHipointsDamage {};
			class setOnRunoverNumberHitpointsDamaged {};
			class substringsPresentInString {};
		};		
		class GMS_Groups {
			file = "GMSCore\Compiles\Groups";
			class addToGraveyardGroup {};
			class addUnitEventHandlers {};
			class alertNearbyGroups {};
			class boostGroupAttributes {};
			class createGroup {};	
			class despawnInfantryGroup {};
			class getAreaMarker {};
			class groupCanSee {};
			class getGroupBlacklist {};				
			class getGroupIntelligence {};
			class getGroupVehicle {};
			class getHunt {};
			class getHuntDurationTimer {};		
			//class groupOutOfArea {};	
			class groupRemoveAllGear {};
			class initializegroup {};
			class setGroupBehaviors {};
			class setupGroupMoney {};	
			class setGroupVehicle {};
			class setHunt {};
			class setHuntDurationTimer {};
			class setMaxRelaodsGroup {};
			class setGroupBlacklist {};
			class setupGroupSkills {};
			class setupGroupGear {};
			class setupGroupBehavior {};
			class spawnInfantryGroup {};	
			class updateGroupHitKilledTimer {};				
		};		
		class GMS_Initialization {
			file = "GMSCore\init";
			class Initialize {postInit = 1;};
		};
		class GMS_Objects {
			file = "GMSCore\Compiles\Objects";
			class createObject {};							
			class emptyObjectInventory {};			
			class removeAllEventHandlers {};
			class removeAllMPEventHandlers {};	
			class setMoney {};
		};				
		class GMS_Players {
			file = "GMSCore\Compiles\Players";			
			class giveTakeCrypto {};  // Please see credits in the sqf.
			class getKarma {};	  // Please see the credits in the sqf.	
			class giveTakeRespect {};
			class giveTakeTabs {};
			class setKarma {};
			class updatePlayerKills {};
			class unitRunover {};
		};
		class GMS_safezoneManagement {
			file = "GMSCore\Compiles\safezoneManagement";
			//class addSafeZone {};
			//class cleanupSafeZones {};
		};
		class GMS_Utilities {
			file = "GMSCore\Compiles\Utilities";
			class findWorld {};
			class getLocationsForWaypoints {};
			class getMapMarker {};
			class log {};
		};
		class GMS_Units {
			file = "GMSCore\Compiles\Units";
			class addChainedMPKilled {};
			class healSelf {};			
			class removeNVG {};
			class removeLauncher {};			
			class throwSmoke {};
			class unitCanSee {};
			class unitHit {};
			class unitKilled {};
			class unitReloaded {};
			class unitRemoveAllGear {};			
		};
		class GMS_Vehicles {
			file = "GMSCore\Compiles\Vehicles";
			//class allowPlayerVehicleAccess {};
			class createVehicle {};
			class destroyVehicleAndCrew {};
			class disableVehicleSensors {};
			class disableVehicleWeapons {};
			class getOutVehicle {};
			class initializePatrolVehicle {};
			class loadVehicleCrew {};
			class removeWeapAndMags {};
			class restrictPlayerVehicleAcess {};
			class spawnPatrolAircraft {};
			class spawnPatrolUAV {};
			class spawnPatrolVehicle {};
			class spawnUnmannedVehicle {}; // All manner of drones
			class vehicleHandleDamage {};	
			class vehicleHit {};
			class vehicleKilled {};	
		};		
		class GMS_Waypoints {
			// general functions for handling waypoints within a patrol area
			file = "GMSCore\Compiles\Waypoints";
			class addMonitoredAreaPatrol {};			
			class isStuck {};
			class getWaypointLastCheckedTime {};
			class initializeWaypointsAreaPatrol {};
			class initializeWaypointRoadsPatrol {};
			class nextWaypointRoadPatrols {};
			class monitorAreaPatrols {};			
			class monitorRoadPatrols {};
			class nextWaypointAreaPatrol {};
			class setStuck {};
			class setWaypointLastCheckedTime {};
			class setWaypointStuckValue {};
			class updateWaypointConfigs {};
		};
	};
};
