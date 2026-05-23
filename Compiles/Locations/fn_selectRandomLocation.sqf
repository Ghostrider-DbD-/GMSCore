



params[["_anchor",[0,0,0]],["_locations",[]],["_minDist",150],["_maxDist",1000]];

private _newLoc = "";
private _searchDone = false;

while {!_searchDone} do {
    _newLoc = selectRandom _locatoins;
    _newPos = position _newLoc;
    _searchDone = if (_anchor distance _newPos < _minDist || _anchor distance _maxDist) then {false} else {true;}
};

_newLoc

