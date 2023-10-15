/*
   GMSCore_fnc_mainThread 

   Purpose: Scheduler for everything that runs on the module.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"

private _timer15 = diag_tickTime;
//private _timer30 = diag_tickTime;
private  _timer60 = diag_tickTime;
#define loopTime 15
while {true} do 
{
   
   //if (diag_tickTime > _timer15) then {

     // _timer15 = diag_tickTime + timerIncrement15;
   //};
   /*
   if (diag_tickTime > _timer30) then {
      _timer30 = diag_tickTime + timerIncrement30;
   };
   */
   if (diag_tickTime > _timer60) then 
   {
       [] call GMSCore_fnc_monitorAreaPatrols;  // This checks for groups that failed to make it to a waypoint within the timeout settings and redirects the group if the group is not engaging a player in combat.
       //[] call GMSCore_fnc_monitorMapMarkers;
       [] call GMSCore_fnc_monitorVisibleMarkers;  // These are smokeShells and chemLights attached to objects
       [] call GMSCore_fnc_monitorObjectDeletionCue;  //  These are AI, vehicles, structures, crates and markers scheduled for deletion
       [] call GMSCore_fnc_cleanUpJunk;  // This does a search for things in the left upper corner of the map where objects and AI sometimes spawn and deletes them all.
       //[] call GMSCore_fnc_cleanupSafeZones;       
       _timer60 = diag_tickTime + timerIncrement60;
   };
   uisleep loopTime;
};