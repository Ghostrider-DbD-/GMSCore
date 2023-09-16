/*
	GMSCore_fnc_huntedMessages 

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
#include "\GMSCore\Init\GMSCore_defines.hpp"
params["_msg"];

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
			if (GMSCore_modType isEqualTo "Epoch") then {[_msg,5] call EPOCH_msg};
		};
		case "toast": {
			if (GMSCore_modType isEqualTo "Exile") then {["InfoTitleAndText", [_msg]] call ExileClient_gui_toaster_addTemplateToast};
		};
	};
} forEach GMSCore_huntedMsgTypes;