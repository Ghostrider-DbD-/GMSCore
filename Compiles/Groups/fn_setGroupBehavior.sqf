/*
    GMSCore_fnc_setGroupBehavior 

    Purpose: Set one of three combinations of Behavior and Combat mode based on how we want AI to respond to players.

    Parameters:
        _group - the group of interest
        _mode - one of three states allowed for the groups 

    Returns: None
*/

params[["_group", grpNull], ["_mode", ""]];

switch (toLower _mode) do {
    case "normal": {
        _group setBehaviourStrong "AWARE";
        _group setCombatMode "YELLOW";
    };
    case "combat": {
        _group setBehaviourStrong "AWARE";
        _group setCombatMode "RED";
    };
    case "ignore": {
        _group setBehaviourStrong "CARELESS";
        _group setCombatMode "BLUE";
    };
    case "safe": {
        _group setBehaviourStrong "SAFE";
        _group setCombatMode "YELLOW";
    };
    default {
        _group setBehaviourStrong "SAFE";
        _group setCombatMode "YELLOW";
    };
};