/*
   GMSCore_fnc_mainThread 

   Purpose: Scheduler for everything that runs on the module.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
 [format["<STARTING> GMSCore_fnc_mainThread at %1",diag_tickTime]] call GMSCore_fnc_log;
//private _timer15 = diag_tickTime;
private  _timer60 = diag_tickTime;
#define loopTime 15
while {true} do 
{
      // [format["<RUNNING> GMSCore_fnc_mainThread at %1",diag_tickTime]] call GMSCore_fnc_log;
       [] call GMSCore_fnc_monitorRoadpatrols;
       [] call GMSCore_fnc_monitorAreaPatrols;  // This checks for groups that failed to make it to a waypoint within the timeout settings and redirects the group if the group is not engaging a player in combat.
       //[] call GMSCore_fnc_monitorMapMarkers;  //  Markers are now deleted in the monotirObjectDeletionCue function.
       [] call GMSCore_fnc_monitorVisibleMarkers;  // These are smokeShells and chemLights attached to objects
       [] call GMSCore_fnc_monitorObjectDeletionCue;  //  These are AI, vehicles, structures, crates and markers scheduled for deletion
       [] call GMSCore_fnc_cleanUpJunk;  // This does a search for things in the left upper corner of the map where objects and AI sometimes spawn and deletes them all.
       [] call GMSCore_fnc_cleanupEmptyGroups;
       //[] call GMSCore_fnc_cleanupSafeZones;       
       uisleep _timer60;
};