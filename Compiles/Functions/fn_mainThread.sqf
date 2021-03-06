/*
   GMS_fnc_mainThread 

   Purpose: Scheduler for everything that runs on the module.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMS_defines.hpp"
#define timerIncrement 60
private  _timer60 = diag_tickTime;
while {true} do 
{
   if (diag_tickTime > _timer60) then 
   {
       [] call GMS_fnc_monitorMarkers;
       [] call GMS_fnc_monitorObjectDeletionCue;
      // [] call GMS_fnc_monitorAreaPatrols;
       _timer60 = diag_tickTime + timerIncrement;
   };
   uisleep timerIncrement;
};