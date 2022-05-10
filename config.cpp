/*
	Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
// TOD: add handleDamage or hitpoint handler that removes any damage caused by player runovers
class GMSCoreBuild {
	version = 0.26;
	build = 26;
	buildDate = "5-08-22";
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
	class GMS {
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
			class spawnCrate {}; // which can be any object, but is a crate by default.
			class addItem {};
			class addItemsFromArray {};  // weighted array either a single array, or array of arrays.
			class spawnPayload {};
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
			class nearestTarget {};
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
			class monitorMarkers {};
			class monitorObjectDeletionCue {};			
			class nearestGMSAI {};
			class nearestPlayers {};
			class removeBlacklistedItems {};
			//class setGroupHuntVehicles {};
			class removeNullEntries {};
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
			//class addObjectToDeletionCue {};
			class createObject {};	
			//class deleteObjectMethod {};							
			class emptyObjectInventory {};	
			//class monitorObjectDeletionCue {};			
			class removeAllEventHandlers {};
			class removeAllMPEventHandlers {};	
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
			//class assignTargetAreaPatrol {};
			class getWaypointLastCheckedTime {};
			//class getWaypointPatrolAreaMarker {};  This variable is only set in one place and read in one place so not sure we need this complexity
			class initializeWaypointsAreaPatrol {};
			class initializeWaypointRoadsPatrol {};
			class nextWaypointRoadPatrols {};
			class monitorAreaPatrols {};			
			class monitorRoadPatrols {};
			class nextWaypointAreaPatrol {};
			class setStuck {};
			class setWaypointStuckValue {};
			class setWaypointLastCheckedTime {};
			//class setWaypointPatrolAreaMarker {};
		};
	};
};
