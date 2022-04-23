

#include "\GMSCore\Init\GMS_defines.hpp"
params[
	"_group",
	["_baseSkill",0.7],
	["_alertDistance",500], 	 // How far GMS will search from the group leader for enemies to alert to the kiillers location
	["_intelligence",0.5],  	// how much to bump knowsAbout after something happens
	["_bodycleanuptimer",600],  // How long to wait before deleting corpses for that group
	["_maxReloads",-1], 			// How many times the units in the group can reload. If set to -1, infinite reloads are available.
	["_removeLaunchers",true],
	["_removeNVG",true],
	["_minDamageToHeal",0.4],
	["_maxHeals",1],
	["_smokeShell",""],
	["_aiHitCode",[]],
	["_aiKilledCode",[]],
	["_chanceGarison",0]
];
_group setVariable[GMS_patrolAlertDistance,_alertDistance];
_group setVariable[GMS_patrolIntelligence,_intelligence];
_group setVariable[GMS_bodyCleanupTime,_bodycleanuptimer];
_group setVariable[GMS_maxReloads,_maxReloads];
_group setVariable[GMS_removeLauncher,_removeLaunchers];
_group setVariable[GMS_removeNVG,_removeNVG];
_group setVariable[GMS_maxHeals,_maxHeals];
_group setVariable[GMS_minDamageForHeal,_minDamageToHeal];
_group setVariable[GMS_smokeShell,""];
_group setVariable[GMS_aiHitCode,_aiHitCode]; 
_group setVariable[GMS_aiKilledCode,_aiKilledCode];
_group setVariable[GMS_garisonChance,0];