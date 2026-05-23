/*
	Copyright 2020 by Ghostrider-GRG-
*/


// TOD: add handleDamage or hitpoint handler that removes any damage caused by player runovers
class GMSCoreBuild {
	version = 1.12;
	build = 88;
	buildDate = "02/01/2026";
};
class CfgPatches {
	class GMSCore {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};

#include "\x\addons\GMSCore\CfgGMSCore.hpp"

class CfgFunctions {
	class GMSCore {
		class Airdrops {
			file = "\x\addons\GMSCore\Compiles\Airdrops";
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
			file = "\x\addons\GMSCore\Compiles\Client";
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
			file = "\x\addons\GMSCore\Compiles\Crates";
			class addItem {};
			class addItemsFromArray {};  // weighted array either a single array, or array of arrays.
			class attachCrateMarkers {};
			class monitorVisibleMarkers {};
			class spawnCrate {}; // which can be any object, but is a crate by default.			
			class visibleMarker {};
		};
		class Functions {
			file = "\x\addons\GMSCore\Compiles\Functions";
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
			class getGMSside {};
			class groupCanSee {};
			class getRandomLocation {};
			class isClass {};
			class mainThread {};
			class monitorObjectDeletionCue {};		
			class nearestBases {};	
			class nearestGMSAI {};
			class nearestPlayers {};   
			class nearestTarget {};	
			class objectHeight {};		
			class removeBlacklistedItems {};
			class removeNullEntries {};
			class setDirUp {};
			class selectRandomCount {};
			class setMarkerDelete {};
			class setMoney {};
			class setOnRunoverHipointsDamage {};
			class setOnRunoverNumberHitpointsDamaged {};
			class substringsPresentInString {};
		};
		class Groups {
			file = "\x\addons\GMSCore\Compiles\Groups";
			class addToGraveyardGroup {};
			class addUnitEventHandlers {};
			//class airSetupGroupBehavior {};
			class alertNearbyGroups {};
			class boostGroupAttributes {};
			class cleanupEmptyGroups {};
			class createGroup {};	
			class despawnInfantryGroup {};
			class getAreaMarker {};
			class groupCanSee {};
			class setGroupBaseSkill {};
			class getGroupBlacklist {};
			class getGroupDestination {};			
			class getGroupIntelligence {};
			class getGroupVehicle {};
			class getHuntDurationTimer {};	
			class getMaxDistanceTarget {};	
			class groupRemoveAllGear {};
			class initializegroup {};			
			class setGroupDestination {};
			class setupGroupMoney {};	
			class setGroupVehicle {};
			//class setHunt {};
			class setHuntDurationTimer {};
			class setMaxRelaodsGroup {};
			class setGroupBlacklist {};
			class setMaxDistanceTarget {};
			class setupGroupSkills {};
			class setupGroupGear {};
			class setGroupBehavior {};
			class setChanceParaDrop {};
			class setParaInterval {};
			class setChanceDetectedAir {};
			//class updateHunt {};
			class spawnInfantryGroup {};	
			class updateGroupHitKilledTimer {};				
		};		
		class GMS_core_locations {
			file = "\x\addons\GMSCore\Compiles\Locations";
			class addBlacklistedLocation {};
			class addNoAggroLocation {};
			class addMissionNoSpawnZone {};
			class createLocation {};
			class findNearestLocations {};
			class inAllowedLocation {};
			class isBlacklisted {};	
			class inMissionNoSpawnZone {};
			class selectRandomLocation {};
		};
		class GMS_core_Initialization {
			file = "\x\addons\GMSCore\init";
			class configureWorld {};
			class InitializeServer {postInit = 1;};
			class initializeMessages {};
			class InitializeSimulation {};
			class setupLocations {};
		};
		class GMS_core_Objects {
			file = "\x\addons\GMSCore\Compiles\Objects";
			class createObject {};							
			class emptyObjectInventory {};			
			class removeAllEventHandlers {};
			class removeAllMPEventHandlers {};	
			class setMoney {};
		};		
		class GMS_core_Patrols {
			file = "\x\addons\GMSCore\Compiles\Patrols";
			//  class addMonitoredAreaPatrol {};	Unused
			class antiStuckAir {};
			class antiStuckShip {};
			class antiStuckSub {};
			class antiStuckLand {};
			class detectPlayersAir {};
			class detectPlayersLand {};
			class detectPlayersShip {};
			class detectPlayersSub {};	
			class getHunt {};	
			class isStuck {};	
			class getTarget {};				// This is the target upon which the leader of the group is focused 
			class getDetectedTargets {};	// This is a list of all targets known to the group 
			class monitorPatrolsAir {};					
			class monitorPatrolsLand {};	
			class monitorPatrolsShip {};					
			class monitorPatrolsUAV {};
			class setHunt {};
			class setStuck {};	
			class setTarget {};		
			class setDetectedTargets {};	
			class updateGroupDebugMarker {};		
			//class monitorRoadPatrols {};			
		};	
		class GMS_core_Players {
			file = "\x\addons\GMSCore\Compiles\Players";	
			class getNearbyPlayers {};		
			class giveTakeCrypto {};  // Please see credits in the sqf.
			class getKarma {};	  // Please see the credits in the sqf.	
			class giveTakeRespect {};
			class giveTakeTabs {};
			class setKarma {};
			class updatePlayerKills {};
			class unitRunover {};
		};
		class GMS_core_safezoneManagement {
			file = "\x\addons\GMSCore\Compiles\safezoneManagement";
			//class addSafeZone {};
			//class cleanupSafeZones {};
			//class isInSafezone {};
		};		
		class GMS_core_Utilities {
			file = "\x\addons\GMSCore\Compiles\Utilities";
			//class getLocationsForWaypoints {};
			class getMapMarker {};
			class log {};
		};
		class GMS_core_Units {
			file = "\x\addons\GMSCore\Compiles\Units";
			class addChainedMPKilled {};
			class addNVG {};
			class createUnit {}; 
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
		class GMS_core_Vehicles {
			file = "\x\addons\GMSCore\Compiles\Vehicles";
			class addVehicleCrew {};
			class createVehicle {};
			class destroyVehicleAndCrew {};
			class disableVehicleSensors {};
			class disableVehicleWeapons {};
			class checkFuel {};
			class getOutVehicle {};
			class getVehicleType {};
			class initializePatrolVehicle {};
			class isDrone {};
			class isSubmersible {};			
			class loadVehicleCrew {};
			class removeWeapAndMags {};
			class restrictPlayerVehicleAcess {};
			class spawnPatrolAir {};
			class spawnPatrolUAV {};
			class spawnPatrolLand {};
			class spawnPatrolUGV {}; // All manner of drones
			class spawnStatic {};
			class vehicleHandleDamage {};	
			class vehicleHit {};
			class vehicleKilled {};	
		};		
		class GMS_core_Waypoints {
			// general functions for handling waypoints within a patrol area
			file = "\x\addons\GMSCore\Compiles\Waypoints";	
			//class completedWaypointAreaPatrol {};			
			//class completedWaypointAreaPatrolAir {};
			//class completedWaypointAreaPatrolLand {};	
			//class completedWaypointAreaPatrolShip {};
			//class completedWaypointAreaPatrolSub {};

			//class initializeInfantryPatrol {};					
			//class initializePatrolAir {};
			//class initializePatrolLand {};
			class initializeWaypointsAreaPatrolShip {};			
			class initializeWaypointsAreaPatrolSub {};

			class nextWaypointAreaPatrol {};			
			class nextWaypointAreaPatrolAir {};		
			class nextWaypointAreaPatrolLand {};
			class nextWaypointAreaPatrolShip {};
			class nextWaypointAreaPatrolSub {};

			//class setWaypointLastCheckedTime {};
			//class setWaypointStuckValue {};
		};
	};
};

class CfgLocationTypes {
	class GMSCore_BlacklistedArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "GMSCore Blacklist Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};
	class GMSCore_NoAgroArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "GMSCore No-Aggro Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};
	class GMSCore_SafeZoneArea {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "GMSCore Safezone Area";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};	
	class GMSCore_MissionNoSpawnZone {
		color[] = {0.91,0,0,1};
		drawStyle = "name";
		font = "PuristaMedium";
		name = "GMS Mission No Spawn Zone";
		shadow = 1;
		size = 15;
		textSize = 0.05;
		texture = "";
	};	
};
