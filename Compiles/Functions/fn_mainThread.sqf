/*
   GMS_fnc_mainThread 

   Purpose: Scheduler for everything that runs on the module.

   Parameters: None 

   Returns: None 

   Copyright 2020 by Ghostrider-GRG- 
*/

#include "\GMSCore\Init\GMS_defines.hpp"

private _timer15 = diag_tickTime;
private _timer30 = diag_tickTime;
private  _timer60 = diag_tickTime;
diag_log format["GMS_fnc_mainLoop: looptime %1 | timerIncrement15 %2", loopTime, timerIncrement15];
while {true} do 
{
   if (diag_tickTime > _timer15) then {
      _timer15 = diag_tickTime + timerIncrement15;
   };
   if (diag_tickTime > _timer30) then {
      _timer30 = diag_tickTime + timerIncrement30;
   };
   if (diag_tickTime > _timer60) then 
   {
       [] call GMS_fnc_monitorAreaPatrols;
       [] call GMS_fnc_monitorMarkers;
       [] call GMS_fnc_monitorObjectDeletionCue;
       _timer60 = diag_tickTime + timerIncrement60;
   };
   uisleep loopTime;
};