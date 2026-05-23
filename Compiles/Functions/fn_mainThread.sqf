/*
   GMSCore_fnc_mainThread 

   Purpose: Scheduler for everything that runs on the module.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
//[format["<STARTING> GMSCore_fnc_mainThread at %1",diag_tickTime]] call GMSCore_fnc_log;

private  _timer60 = diag_tickTime + 60;
private _timer30 = diag_tickTime + 30;
private _timer15 = diag_tickTime + 15;

// Constants defined for pre-processor
#define loopTime 15  //  loopTime should be the shortest time over which any of the above groups of functions is executed.

while {true} do 
{
   if (diag_tickTime > _timer15) then {
       // Do the checks for aircraft every 15 sec to scan for players and activate hunt if needed. 
      [] call GMSCore_fnc_monitorPatrolsAir;
      [] call GMSCore_fnc_monitorPatrolsUAV;
      [] call GMSCore_fnc_monitorPatrolsLand;
      _timer15 = diag_tickTime + 15;
   };
   if (diag_tickTime > _timer30) then {
      [] call GMSCore_fnc_monitorVisibleMarkers;  // These are smokeShells and chemLights attached to objects
      _timer30 = diag_tickTime + 30;
   };
   if (diag_tickTime > _timer60) then {
;      
       [] call GMSCore_fnc_monitorObjectDeletionCue;  //  These are AI, vehicles, structures, crates and markers scheduled for deletion
       [] call GMSCore_fnc_cleanUpJunk;  // This does a search for things in the left upper corner of the map where objects and AI sometimes spawn and deletes them all.
       [] call GMSCore_fnc_cleanupEmptyGroups;
       //[] call GMSCore_fnc_cleanupSafeZones;       
      _timer60 = diag_tickTime + 60;
   };

   uisleep loopTime;
};