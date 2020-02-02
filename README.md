# TTTZombieMinigame
A mini gamemode-in-round for Garry's Mod Trouble in Terrorist Town (TTT)

## How this Works
The mechanics is pretty simple. The gameplay is round-based and will be triggered at any Rounds, and repeats. Or perhaps admin can
control the Event by using special commands.

With this addon enabled, this will allows Any Traitor to become Zombies with Extra HP, Speed, (and possibly armor (coming soon)) and Limitted weapons (and credits removed as well)
Innocent and detective will also do their works to helping each other & working together to kill those Spooky Zombies!

More Zombies = More Challenge + More Extra HP for Zombies will be earned!

The number Extra HP for zombies will be determined on how many players that presents in the server. By Default, Their base HP is 150 and if your server has 10 players in it, it will be multiplied by totalling 1500 HP on each single zombies.

## Use with your Custom Weapons!

Have many addons that seems kinda Powerful? This one will helps! :)

## BETA VERSION!

*Please note that this version is currently under BETA stage. Some unproper balance, or other issues may comes up unexpectedly unless you manage this addon right.*

*Please also note that this has already containing Anti-Karma Reducer which may caused by RDM between same team. The karma points will be stay locked and will be reset
following from Previous Round or follows from ttt_karma_max's ConVar.*

Suggestion are welcomed! Feel free to put your feed back on Steam Workshop Discussion/Comment. You can also support this addon by donating: https://www.wolvindra.net/donate !

## Console Variables
```
ttt_zmode_minply 		(default 10) 	: Minimum Player required to start this mini gamemode
TTT_StartZombieMode 	(default 0) 	: ConVar that allows to start ZombieMode mini gamemode after next round restarts. To force zombie mode, use 'ttt_force_start_zombie_mode' when the round is not in zombie mode state
ttt_zmode_reset_karma   (default 1) 	: Allow reset karma base (following with ttt_karma_max value) after zombie mode ends? Disabling this will use Previous Round (before zombie mode) karma stats
ttt_zmode_healthbase 	(default 150) 	: The base damage for Zombie multiplies Total Players in server. e.g: 150 * 10 (total players) = 1500 each traitors

ttt_zmode_jumpspeed_add (default 290)   : Additional amount for Zombies for Jump Power
ttt_zmode_walkspeed_add (default 35)	: Additional amount for Zombies for Walk Speed

ttt_zmode_roundtostart 	(default 4, can be 8 if you set round_limit to 10)	: Round Number before starting Zombie Mode. Set value more than 99 if you wish to set it manually with 'TTT_StartZombieMode' ConVar

ttt_force_zombie_mode					: Start the game mode immediately after Proper Round begins. DO NOT USE WHEN ON 'PREPARING ROUND' STATE!
```

## Configurations
Currently, configurations can be done under LUA file, so Server Owners must have this downloaded via GitHub instead using from Steam Workshop.
```lua

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

```