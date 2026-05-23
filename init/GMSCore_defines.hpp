/*
	Purpose: define widely used constants 

	Copyright 2020 by Ghostrider-GRG-
*/

/*
	Defines for messages to players
*/
#define GMS_validUnitKilledMsgTypes ["toast","epochMsg","hint","cutText","systemChat"]
#define GMS_validMsgEpoch ["epochMsg"]
#define GMS_validdMsgExile ["toast"]
//#define gms_validunitkilledmsgtypes ["systemChat","hint","cutText","toast","epochMsg"]
#define GMS_validHuntedMsgTypes ["systemChat","hint","cutText","toast","epochMsg"]
#define GMS_validAlertMsgTypes ["systemChat","hint","cutText","dynamic","toast","epochMsg"]

/*
	Defines for all assets (units, groups, vehicles) 
*/
#define GMS_Asset "GMS_asset"
#define GMS_unit "GMS_Unit"
#define GMSCore_group "GMSCore_group"

/*
	Distances 
*/


/*
	Defines for Drones and Helicopters
*/
#define GMS_flyinHeight "flyInHeight"
#define GMS_flyinVariation "flyinVar"

/*
	Defins for Main Thread 
*/
#define timerIncrement15 15
#define timerIncrement30 30
#define timerIncrement60 60
#define timerIncrement90 90
#define timerIncrement120 120

/*
	Defines for groups 
*/

#define GMS_stuckValue "GMS_stuck"
#define GMS_stuckTimer "GMS_stuckTimer"
#define GMS_stuckTimerAir 300 

#define GMSCore_groupDestination "GMS_grpDestination"

/*
	Defines for Vehicles
*/

// No longer used
//#define GMS_vehicle "GMS_vehicle"

#define GMS_vehHitCode "vehHitCode"
#define GMS_vehKilledCode "vehKilledCode"
#define GMSCore_groupVehicle "grpVeh"
#define GMS_disableVehicle "GMS_disable"
#define GMS_removeFuel "GMS_removeFuel"
#define GMS_allowAccess "GMS_allowAccess"
#define GMS_deleteEmptyVehicle "GMS_deleteEmptyVeh"
/*
	Defines for Units (genearal)
*/
#define GMS_patrolAlertDistance "patrolAlertDist"
#define GMS_patrolIntelligence "patrolIntel"
#define GMS_huntVehicles "huntVeh"
#define GMS_infrantryPatrol "infantry"
#define GMS_airPatrol "air"
#define GMS_vehiclePatrol "vehicle"
#define GMS_submersiblePatrol "submersible"
#define GMS_playerTarget "GMS_target"

/*
	Defines for Units (specific)
*/
#define GMS_maxReloads "maxReloads"
#define GMS_removeLauncher "removeLauncher"
#define GMS_removeNVG "removeNVG"
#define GMS_maxHeals "maxHeals"
#define GMS_aiHitCode "aiHitCode"
#define GMS_aiKilledCode "aiKilledCode"
#define GMS_smokeShell "smokeShell"
#define GMS_bodyCleanupTime "bodyCleanupTime"
#define GMS_minDamageForHeal "minDamageToHeal"

/*
	Defines for vehicles 
*/


/*
	Defines for Waypoints
*/
#define GMS_garisonChance "garisonChance"
#define GMS_huntOverAt "huntOver"
#define GMS_deleteDeadTimer "deleteDeadTimer"
#define GMS_groupInHouse "inHouse"
#define GMS_target "target"
#define GMS_maxDistanceTarget "maxDistTarget"
#define GMS_waypointTimeoutInterval "wpTimeout"
#define GMS_waypointTeminationTime "killWP"
#define GMS_waypointStartPos "startPosWP"
#define GMS_waypointTimeoutAt "timeoutWP"
#define GMS_patrolRoads 1
#define GMS_lastChecked "lastChecked"
#define GMS_lastDest "lastDest"
#define GMS_currDest "currDest"

/*
	Defines for Groups 
*/

#define GMSCore_maxDistanceTarget "maxDistTarg"
#define GMSCore_deleteMarker "deleteMarkr"
#define GMSCore_patroArealMarker  "patroAreaMarker"
#define GMSCore_blackListedAreas blackListedAreas"
#define GMSCore_garrisonChance "_garisonChance"
#define GMSCore_timeStamp "GMSCore_timeStamp"
#define GMS_baseSkill "baseSkill"


// Classnames 
//  #define Player_Class_Names "Epoch_Male_F","Epoch_Female_F" // Replaced with GMS_playerUnitTypes which is defined in fn_initialize.sqf
#define WAYPOINT_DISALLOWED_AREAS "GMSCore_BlacklistedArea","GMSCore_NoAgroArea","GMSCore_SafeZoneArea" 
#define WAYPOINT_DISALLOWED_DISTANCE_AIR 300 

// Distances 
#define minDistWP_Air 1000 
#define maxDistWP_Air 3000 
#define minDistWP_Heli 1200 
#define maxDistWP_Heli 2500 
#define minDistWP_Drone 1000 
#define maxDistWP_Drone 2000 

#define DISTANCE_NEAREST_ENEMY_AIR 350 
#define antiStuckMinTravelDistance_Air 750
#define NO_AGRO_RANGE_LAND 300
#define PLAYER_DETECT_RANGE_AIR 350 
#define PLAYER_NOAGRO_RANGE_SEA 250
#define MIN_WP_DIST_SEA 40 
#define MAX_WP_DIST_SEA 60 
#define DISTANCE_NEAREST_ENEMY_SEA 150 
#define NO_AGRO_RANGE_AIR 900
#define NOAGRO_RANGE_SEA 200 
#define ANTISTUCK_MIN_DIST_SEA 250 
#define MIN_WP_DIST_LAND 50 
#define MAX_WP_DIST_LAND 1500
#define DISTANCE_NEAREST_ENEMY_LAND 400
#define NO_AGRO_RANGE_LAND 500 
#define antiStuckMinTravelDistance_LAND 250
#define DISTANCE_NEAREST_ENEMY_INFANTRY 150
#define NO_AGRO_RANGE_INFANTRY 200 
#define antiStuckMinTravelDistance_INFANTRY 30 
#define DISTANCE_NEAREST_ENEMY_UGV 150
#define NO_AGRO_RANGE_UGV 150 
#define antiStuckMinTravelDistance_UGV 30

// Heights 
#define FLYIN_HEIGHT_AIR_BASE 75
#define FLYIN_HEIGHT_AIR_VARIANCE 25 

// Locations 
#define LOCATION_TYPES_AIR  "NameVillage","NameCity","NameCityCapital","NameMarine","NameLocal","HistoricalSite","StrongpointArea","Strategic"
#define LOCATION_TYPES_LAND  "NameVillage","NameCity","NameCityCapital","NameMarine","NameLocal","HistoricalSite","StrongpointArea","Strategic"

//Times 
#define refuelTimeAir 300 
#define WAYPOINT_TIMEOUT_LAND 300 
#define HELI_PARADROP_COOLDOWN 300 