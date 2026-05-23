/*
    GMSCore_fnc_setGroupBaseSkill 

    Purpose: set baseSkill for each unit in a group
    Parameters: 
        _group: the group upon which to apply the updatedb baseSkill
        _baseSkill: the base Skill to apply

    Returns: None 
*/

params[["_group", grpNull],["_baseSkill", -1]];
if (_baseSkill isEqualTo -1) exitWith {[format["_setGroupBaseSkill: no parameter passed for _baseSkill"]] call GMSCore_fnc_log};

{
    _x setSkill _baseSkill;
} forEach (units _group);