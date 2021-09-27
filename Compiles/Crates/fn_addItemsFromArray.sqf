/**
    GMS_fnc_addItemsFromArray

	Purpose: Adds N items randomly selected from a weighted array to a container.

    Params: container, weighted array.
		_container: the object into which the materials should be loaded 
		_
    Returns: container

    Array format: [count, [item1,weight, .. itemn,weight], count2, [item1,weight .. itemN,weight] ... ]

	TODO: think about this a bit more, I dont think it is quite right
*/
#include "\GMSCore\Init\GMS_defines.hpp"

params["_container","_loadout",["_addAmmo" /* a number > 0 forces addition of that number of magazines randomly selected from all possible ones for that weapon*/,0]];
//diag_log format["_addItemsfromArray: _container = %1 | _loadout = %2",_container,_loadout];
for "_i" from 1 to (count _loadout) step 2 do
{
	private _count = _loadout select (_i - 1);
	private _itemLIst = _loadout select _i;
	diag_log format["_count = %1 | _itemList = %2",_count,_itemList];
	for "_i" from 1 to _count do
	{
		private _item = selectRandomWeighted _itemList;
		//diag_log format["item selected = %1",_item];
		[_container, _item,_addAmmo] call GMS_fnc_addItem;
	};
};
//diag_log format["addItemsFromArray:  crate inventory = %1",[_container] call BIS_fnc_invString];
_container