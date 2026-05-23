/*
    GMSCore_fnc_createUnit 

    Parameters: 
        _group - group to which to link the unit 
        _pos - position at which to create the unit 

    Returns: _unit - the unit created 
*/

params[
    ["_group", grpNull], 
    ["_pos",[0,0,0]],
    ["_baseSkill", 0.5]
];

private _unit = _group createUnit[GMSCore_unitType, _pos, [], 0, "NONE"];
_unit setSkill _baseSkill; 
if (GMSCore_modType isEqualTo "Epoch") then {_unit setVariable ["LAST_CHECK",28800,true]};
_unit enableAI "ALL";
_unit 