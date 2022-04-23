/*
    GMS_fnc_monitorObjectDeletionCue 

    Purpose: check objects in the cue for deletion and delete at the proper time. 

    Parameters: None 

    Return: None 

    Copyright 2020 by Ghostrider-GRG-
*/

#include "\GMSCore\Init\GMS_defines.hpp"
for "_i" from 1 to (count GRGCore_monitoredObjects) do
{
    _o = GRGCore_monitoredObjects deleteAt 0;
    _o params["_objectParameters","_deleteTime"];
    if (diag_tickTime > _deleteTime) then 
    {
       
        [format["GMS_fnc_monitorObjectDeletionCue: deleting object %1",_o]] call GMS_fnc_log;        
        [_objectParameters] call GMS_fnc_deleteObjectsMethod;
    } else {
        GRGCore_monitoredObjects pushBack _o;
    };
};