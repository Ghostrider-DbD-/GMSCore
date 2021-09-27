# GMSCore
Core functions for future mission and apps
Dependencies: None
Copyright 2020 by Ghostrider-GRG-

Overall Purpose: To provide a coding framework for GMSAI, a new roaming AI package, and GMSMS, a new dynamic/static mission system.

Key features:
    The heart of GMSCore lies in several capabilities:

    1. Built in waypoint and hunting based on markers. The waypoint logic will continue directing the group to locations within the area described by the marker until a player enemy is found, when the player will engaged by hunting logic until the player is killed or all memebers of the group are dead. Area based waypoint management can be used for roaming or mission AI.

    2. GMSCore functions make no assumptions about what loadout should be applied, what skill settings should be, or what vehicles should spawn. All parameters for area patrols such as cooldonw/respawn time and respawn time are passed to GMSCore. 

    3. GMSCore appplies weighted arrays for gear/uniform selection

    4. GMSCore provides classname checking

    5. GMSCore provides many helpful core functions for crate loading, selecting numbers or intergers within a range and other handy features.

    6. GMSCore includes scripts to drop paratroops a location, drop a payload there, or fly these things in and drop them from aircraft. 

    7. GMSCore is written from the ground up to provide get/set functions for variables that other AI systems would need to know about.
