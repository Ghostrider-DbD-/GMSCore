/*
    Purpose: set the chance of a paradrop for the group [0-1]
            This allows GMS_RC or GMSAI to configure this parameter for the group. 

    Parameters:
        _group - the group affected 
        _chance - the chance [range 0-1] 

    Returns: None 
*/

params["_group","_chance"];
_group setVariable["paraChance", _chance];