/*
    GMSCore_fnc_getNearbyPlayers 

    parammeters:
        _pos - anchor position for search
        _range - range of search 

    Returns
        Array of alive players or [] of none detected 
*/

//	GMSCore_playerUnitTypes = ["Epoch_Male_F","Epoch_Female_F"];
private _players = _pos nearEntities[GMSCore_playerUnitTypes, _range];
_players

