/*
    GMSCore_fnc_monitorObjectDeletionCue 

    Purpose: check objects in the cue for deletion and delete at the proper time. 

    Parameters: None 

    Return: None 

    Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMSCore_defines.hpp"
private _count = count GRGCore_monitoredObjects;
//[format["GMSCore_fnc_monitorObjectDeletionCue: _count %1  |  GRGCore_monitoredObjects %2",_count, GRGCore_monitoredObjects]] call GMSCore_fnc_log;
for "_i" from 1 to count GRGCore_monitoredObjects do
{
   if (_i > count GRGCore_monitoredObjects) exitWith {};
    _o = GRGCore_monitoredObjects deleteAt 0;
    _o params["_objectParameters","_delAt"];
    if (diag_tickTime > _delAt) then 
    {
        //[format["GMSCore_fnc_monitorObjectDeletionCue: deleting object %1",_o]] call GMSCore_fnc_log;        
        [_objectParameters] call GMSCore_fnc_deleteObjectsMethod;
    } else {
        GRGCore_monitoredObjects pushBack _o;
    };
};