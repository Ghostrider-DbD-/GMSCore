/*
	GMS_fnc_titleTextAlert

	Purpose:
		Display an alert with title and optional sound 

	Parameters: 
		_label: the title for the alert 
		_msg: the message for the alert 
		_sound: an optional sound for the alert

	Returns: 
		Nothing 

	Notes: None 

	Copyright 2020 by Ghostrider-GRG-
*/
#include "\GMSCore\Init\GMS_defines.hpp"
params[["_label",""],["_msg",""],["_sound",""]];
private "_labelColor";
playSound _sound;
{
	switch (_x) do 
	{
		case "systemChat": {
			systemChat _msg;
		};
		case "cutText": {
			cutText[_msg,"PLAIN DOWN",5]; 
			uiSleep 5; cutText["","PLAIN DOWN"];
		};
		case "hint": {
			hint parseText format[
				"<t align='center' size='2.0' color='#B22222'>%1</t><br/>
				<t size='1.5' color='#B22222'>______________</t><br/><br/>
				<t size='1.5' color='#ffff00'>%2</t><br/>
				<t size='1.5' color='#F0F0F0'>______________</t><br/><br/>
				<t size='1.5' color='#F0F0F0'>Any loot you find is yours as payment for eliminating the threat!</t>",
				_label,_msg
			];	
		};
		case "epochMsg": {
			if (GMS_ModType isEqualTo "epoch") then {[_msg,5] call Epoch_message};
		};
		case "toast": {
			if (GMS_modType isEqualTo "exile") then {["InfoTitleAndText", [_label, _msg]] call ExileClient_gui_toaster_addTemplateToast};
		};
		case "dynamic": {
			_text = format[
				"<t align='left' size='1.0' color='#B22222'>%1</t><br/><br/>
				<t align='left' size='0.6' color='#F0F0F0'>%2</t><br/>",
				_label,_msg
				];
			_ycoord = [safezoneY + safezoneH - 0.8,0.7];
			_xcoord = [safezoneX + safezoneW - 0.5,0.35];
			[_text,_xcoord,_ycoord,_screentime,0.5] spawn BIS_fnc_dynamicText;
		};
	};
} forEach GMS_alertMsgTypes;
