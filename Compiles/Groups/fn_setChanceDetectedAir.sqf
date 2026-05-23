/*
    Purpose: Set a value for the chance a player is detected by crew of aircraft 
             This allows GMS_RC and GMSAI to configure this parameter 

    Params:
        _group - the group that needs to have this value set 
        _chance - the value 

    Returns: None 
*/

params["_group","_chance"];
_group setVariable["chanceDetect", _chance];