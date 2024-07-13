  

  Schatten — Today at 7:24 AM
I use such code for group:
{
    deleteWaypoint _x;
} forEachReversed (waypoints _group);

_group setBehaviourStrong "CARELESS";

Such code for waypoints:
_waypoint setWaypointBehaviour "SAFE";

I also have a monitor script that periodically runs such code:
_groupLeader = leader _group;
_groupLeaderVehicle = objectParent _groupLeader;

{
    if (((abs (speed _x)) >= 5) or { (behaviour (effectiveCommander _x)) == "COMBAT" }) then {
        continue;
    };

    if (_x == _groupLeaderVehicle) then {
        _waypoint = [_group, currentWaypoint _group];
        _waypointPosition = waypointPosition _waypoint;

        if ((_x distance2D _waypointPosition) > ((waypointCompletionRadius _waypoint) max 10)) then {
            _x doMove _waypointPosition;
        };
    } else {
        if ((_x distance _groupLeaderVehicle) > 50) then {
            _x doFollow _groupLeader;
        };
    };
} forEach _vehicles;

In general it works, but not ideally -- sometimes either leader's vehicle, or the others, or all of them get stuck. 