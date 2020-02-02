--[[
	TTT Mini Zombie Mode
	
	Copyright (c) 2020, Wolvindra-Vinzuerio. All Rights Reserved.
	
	www.wolvindra.net
]]

if engine.ActiveGamemode("terrortown") then

print("<--------- Wolvindra-Vinzuerio Mini Zombie Gamemode Initializing... --------->")

TTZ = {}
TTZ.__index = TTZ

TTZ.Cvar = {}

TTZ.Cvar.minPlayer  	= CreateConVar("ttt_zmode_minply", 		"10", 	{FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum Player required to start this mini gamemode.")
TTZ.Cvar.startZmode 	= CreateConVar("TTT_StartZombieMode", 	"0", 	FCVAR_SERVER_CAN_EXECUTE, "ConVar that allows to start ZombieMode mini gamemode after next round restarts. To force zombie mode, use 'ttt_force_start_zombie_mode' when the round is not in zombie mode state.")
TTZ.Cvar.ResetKarma 	= CreateConVar("ttt_zmode_reset_karma", "1", 	{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Allow reset karma base (following with ttt_karma_max value) after zombie mode ends? Disabling this will use Previous Round (before zombie mode) karma stats.")
TTZ.Cvar.ZombieHealth 	= CreateConVar("ttt_zmode_healthbase", 	"150", 	{FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The base damage for Zombie multiplies Total Players in server. e.g: 150 * 10 (total players) = 1500 each traitors.")

TTZ.Cvar.ZombieJumpPower = CreateConVar("ttt_zmode_jumpspeed_add", "290", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Additional amount for Zombies for : Jump Power")
TTZ.Cvar.ZombieWalkSpeed = CreateConVar("ttt_zmode_walkspeed_add", "35",{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Additional amount for Zombies for : Walk Speed")

TTZ.Cvar.RoundToStart 		= CreateConVar("ttt_zmode_roundtostart", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Round Number before starting Zombie Mode. Set value more than 99 if you wish to set it manually with 'TTT_StartZombieMode' convar.")

-- do not modify this.
cvars.AddChangeCallback("TTT_StartZombieMode",function(con,old,new)
	if tonumber(new) > 0 then
		PrintMessage(HUD_PRINTTALK, "[TTZ] TTT Mini Zombie Mode has been set and it will automatically started after Next proper round begin.")
	end
end)

TTZ.Config = {}
-- default karma multiplier once the mini game mode starts. You can set it to "1" to keep as default following with your ttt_karma_max's value.
-- To solely prevent TTT's RDM which will result someone's karma dropped to 0, any RDM attempts while this mode is active WILL locks their karma at >= 1000 points until the round ends.
-- It then resets based on previous round (or use ttt_zmode_reset_karma 1) or ttt_karma_max's default value (or use ttt_zmode_reset_karma 0).
TTZ.Config.KarmaMultiplier = 3
-- custom weapon for zombies on slot 7, example: {"weapon_ttt_knife", "weapon_firemagic"}... Be sure this must be Traitor Equipable Items and Not Spawnable items!
TTZ.Config.CustomWeaponSlot7 = { "weapon_ttt_knife" }
-- custom weapon for zombies on slot 8, example: {"weapon_ttt_homebat", "weapon_ttt_traitor_lightsaber"}... Be sure this must be Traitor Equipable Items and Not Spawnable items!
TTZ.Config.CustomWeaponSlot8 = { }
-- custom additional weapon for role innocent/detective. This will be selected Randomly, even though player can still get weapons. Keep in mind to keep low amount as possible.
TTZ.Config.CustomInnoWeapons = {
	"weapon_zm_molotov",
	"weapon_ttt_confgrenade",
	"weapon_ttt_flaregun"
}
-- Adjust your custom models here.
TTZ.Config.CustomModels = {
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/skeleton.mdl"
}
-- configure who can control this addon beside admins. LOWER CASE ONLY!
TTZ.Config.Admins = {
	"admin",
	"superadmin",
	"owner",
	"moderator"
}

include("zmod/sv_zombiemod.lua")
include("zmod/sv_playermeta.lua")

print("<--------- TTT Zombie Mini Gamemode has been initialized. --------->\n<--------- Please note that this currently running on Beta Version. --------->\n<--------- Kindly support by donating: https://www.wolvindra.net/donate thank you! --------->")

end