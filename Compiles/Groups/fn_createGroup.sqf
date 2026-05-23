/*

    GMSCore_fnc_createGroup 
    Purpose: create a group on the side set in params 
    Parameters: 
        "_side", side to tie group to, (default is GMSCore_Side);
        
    Return: group created.

    Copyright 2020 by Ghostrider-GRG-
*/
#include "\x\addons\GMSCore\Init\GMSCore_defines.hpp"
params[["_side",GMSCore_Side],["_deleteWhenEmpty",false]];

private _group = createGroup [_side, _deleteWhenEmpty];
_group setVariable["GMSCore_group", true];
_group