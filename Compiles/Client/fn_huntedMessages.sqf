/*
	GMS_fnc_huntedMessages 

	Purpose:
		To be run on players machine 
		Notifies players when dynamic patrols spawn or reinforcements are dropped
		Plan is to run this only on the players machine 

	Parameters: 
		_player: the player in question 
		_type: dynamic patrol or reinforcements 
		_target: used with reinforcements to specify which player is targeted by the reinforcements
		
	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params["_target","_type"];
diag_log format["GMS_fnc_huntedMessages: player %1 | _target %2",player,_target];
private "_msg";
//if (_type isEqualTo "dynamic") then {_msg = "An enemy patrol was spoted nearby"};
//if (_type isEqualTo "reinforce") then 
//{
	if (player isEqualTo _target) then 
	{
		_msg = format["There is the target: %1, lets pursue and eliminate",name player];
	} else {
		_msg = "An enemy patrol was spoted nearby";
	};
//};

{
	switch (_x) do 
	{
		case "systemChat": {
			systemChat _msg;
		};
		case "cutText": {
			cutText[_msg,"PLAIN DOWN",5];
		};
		case "hint": {
			hint _msg;
		};
		case "epochMsg": {
			if (GMS_modType isEqualTo "epoch") then {[_msg,5] call EPOCH_msg};
		};
		case "toast": {
			if (GMS_ModType isEqualTo "exile") then {["InfoTitleAndText", [_msg]] call ExileClient_gui_toaster_addTemplateToast};
		};
	};
} forEach GMS_huntedMsgTypes;