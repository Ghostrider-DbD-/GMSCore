/*
   GMSCore_fnc_mainThread 

   Purpose: Scheduler for everything that runs on the module.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"

//private _timer15 = diag_tickTime;
//private _timer30 = diag_tickTime;
private  _timer60 = diag_tickTime;
#define loopTime 15
while {true} do 
{
   /*
   if (diag_tickTime > _timer15) then {
      _timer15 = diag_tickTime + timerIncrement15;
   };
   if (diag_tickTime > _timer30) then {
      _timer30 = diag_tickTime + timerIncrement30;
   };
   */
   if (diag_tickTime > _timer60) then 
   {
       [] call GMSCore_fnc_monitorAreaPatrols;
       [] call GMSCore_fnc_monitorMarkers;
       [] call GMSCore_fnc_monitorObjectDeletionCue;
       [] call GMSCore_fnc_cleanUpJunk;
       _timer60 = diag_tickTime + timerIncrement60;
   };
   uisleep loopTime;
};