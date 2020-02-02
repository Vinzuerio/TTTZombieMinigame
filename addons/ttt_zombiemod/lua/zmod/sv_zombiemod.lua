--[[
	TTT Mini Zombie Mode
	
	Copyright (c) 2020, Wolvindra-Vinzuerio. All Rights Reserved.
	
	www.wolvindra.net
]]

local isAllowedToBeForcedZ 	= false
local isGamemodeRunning 	= false
local isRoundBegin 			= false
local DefaultKarma 			= 1000

-- because server do not have NOTIFY_ERROR error so...
local NOTIFY_ERROR = 1

TTZ.RoundBeforeZMode = TTZ.Cvar.RoundToStart:GetInt()

function TTZ.ResetStats()
	isAllowedToBeForcedZ = false
	isGamemodeRunning 	 = false
	isRoundEnd 	 		= false
	isRoundBegin 		= false
end

function TTZ.Notify( ply, msg, icon )
	ply:SendLua("notification.AddLegacy(\""..msg.."\", "..icon..", 10)")
end

function TTZ.NotifyChat( ply, msg, Col )
	local r,g,b = Col.r,Col.g,Col.b
	ply:SendLua("chat.AddText(Color("..r..","..g..","..b.."), \""..msg.."\")")
end

local function overrideKarma(ply)
	ply:SetBaseKarma(DefaultKarma * TTZ.Config.KarmaMultiplier)
	ply:SetLiveKarma(DefaultKarma * TTZ.Config.KarmaMultiplier)
end

function TTZ.StartZombieMode()
	isGamemodeRunning = true
	TTZ.RoundBeforeZMode = TTZ.Cvar.RoundToStart:GetInt() -- resets
	
	local plyrandom = player.GetAll()

	for _,pl in RandomPairs(plyrandom) do
		if pl:GetTraitor() then
			pl:StripWeapons()
			pl:BecomeZombie()
			pl:SetCredits(0)
		end
	end
	
	timer.Simple(0.25, function()		
		for _,pl in pairs(plyrandom) do
			
			if (pl and IsValid(pl)) then
			
				TTZ.NotifyChat( pl, "[TTZ] Kill any Zombies in this round!", Color(250,190,0))
				TTZ.NotifyChat( pl, "[TTZ] The Zombie Apocalypse has Begun...", Color(255,0,0))
				
				overrideKarma(pl)
			
				if pl:DoesHeZombiefied()  then
					TTZ.Notify( pl, "[TTZ] You are the ZOMBIE. Kill all Inoccents around!", NOTIFY_ERROR)
				else
					TTZ.Notify( pl, "[TTZ] There are Traitorous-Zombies around you! Kill 'em all!", NOTIFY_ERROR)
				end
				
				timer.Simple(0.25, function()
					
					if pl:Alive() and (pl:GetRole() == ROLE_INNOCENT or pl:GetRole() == ROLE_DETECTIVE) then
						pl:Give(table.Random(TTZ.Config.CustomInnoWeapons))
					end
					
				end)
				
			end
		end
		
	end)
	
end

function TTZ.ZombieHurtPlayer(ent, dmginfo)
	local targwep = dmginfo:GetInflictor():GetClass()
	local atk = dmginfo:GetAttacker()
	
	if isGamemodeRunning and ent:IsPlayer() and atk:IsPlayer() and (atk:DoesHeZombiefied() and atk:GetTraitor() and targwep == "weapon_zm_improvised") then
		dmginfo:ScaleDamage(math.Rand(1.25,4.00))
	end
end
hook.Add("EntityTakeDamage", "TTZ.ZombieHurtPlayer", TTZ.ZombieHurtPlayer)

function TTZ.ShouldTakeWeapon(ply, wep)
	if isGamemodeRunning and ply:GetTraitor() and ply:DoesHeZombiefied() and 
		wep:GetClass() ~= "weapon_zm_improvised" and
		(not table.HasValue(TTZ.Config.CustomWeaponSlot7, wep:GetClass())) and 
		(not table.HasValue(TTZ.Config.CustomWeaponSlot8, wep:GetClass())) then 
		return false 
	end
end
hook.Add("PlayerCanPickupWeapon", "TTZ.ZombieShouldntPickupWeps", TTZ.ShouldTakeWeapon)

function TTZ.ShouldTakeDamage(ply,atk)
	if isGamemodeRunning then
		if ply:IsPlayer() and atk:IsPlayer() then
			if (ply:GetRole() == atk:GetRole()) then overrideKarma(ply) overrideKarma(atk) return false end
			if (ply:GetRole() == ROLE_INNOCENT and atk:GetRole() == ROLE_DETECTIVE) then overrideKarma(ply) overrideKarma(atk) return false end
			if (ply:GetRole() == ROLE_DETECTIVE and atk:GetRole() == ROLE_INNOCENT) then overrideKarma(ply) overrideKarma(atk) return false end
		end
	end
end
hook.Add("PlayerShouldTakeDamage", "TTZ.ShouldTakeDamage", TTZ.ShouldTakeDamage)

hook.Add("PlayerDeath","TTZ.DoNotGiveCredits",function(ply,inf,atk)
	if isGamemodeRunning and atk:IsPlayer() and atk:GetTraitor() then atk:SetCredits(0) end
end)

function ConCmd_StartZombie(ply, cmd, arg)
	if isRoundBegin and (not isRoundEnd) and isAllowedToBeForcedZ and (not isGamemodeRunning) and (ply:IsAdmin() or table.HasValue(TTZ.Config.Admins, string.lower(ply:GetUserGroup()))) then
		ply:ChatPrint("[TTZ] Forcing Gamemode...")
		TTZ.StartZombieMode()
	else
		ply:ChatPrint("[TTZ] Cannot Start the gamemode! It must be in normal proper round or maybe the Minigame is still active!")
	end
end
local FCVAR_HIDDEN = 0x10
concommand.Add("ttt_force_zombie_mode", ConCmd_StartZombie, nil, "Start Zombie Mode Immediately (Use this when the round is started!)", FCVAR_HIDDEN)

hook.Add("PlayerInitialSpawn", "TTZ.initPlayer", function(ply)
	ply._oriWalkSpeed = ply:GetWalkSpeed()
	ply._oriJumpPower = ply:GetJumpPower()
	
	ply._oriBaseKarma = 1000
	ply._oriLiveKarma = 1000
	
	ply.HasZombiefied = false
	
	timer.Simple(6, function()
		TTZ.NotifyChat(ply, "[TTZ] This server is running TTT Zombie Mode [Mini Game] addon by Wolvindra-Vinzuerio. Enjoy and Have Fun!", Color(230,20,0))
	end)
end)

hook.Add("TTTBeginRound", "Start.TTZ.ZombieMode", function()
	isRoundBegin = true
	
	if TTZ.Cvar.startZmode:GetBool() or TTZ.RoundBeforeZMode == 0 then
		RunConsoleCommand("TTT_StartZombieMode", 0)
		isAllowedToBeForcedZ = false
		print("[TTZ DEBUG:] !XX :: CANNOT BE FORCED!!")
		timer.Simple(1.5, function()
			TTZ.StartZombieMode()
		end)
	else
		print("[TTZ DEBUG:] !OK :: IT IS NOW ABLE TO BE FORCED!")
		isAllowedToBeForcedZ = true
	end
end)

hook.Add("PostCleanupMap", "PostClean.TTZ.ombieMode", function()
	TTZ.ResetStats()
	
	DefaultKarma = GetConVar("ttt_karma_max"):GetInt()
	if player.GetCount() >= TTZ.Cvar.minPlayer:GetInt() then
		-- decrement round.
		TTZ.RoundBeforeZMode = TTZ.RoundBeforeZMode - 1
		for _,ply in pairs(player.GetAll()) do
			if TTZ.RoundBeforeZMode ~= 0 or TTZ.RoundBeforeZMode >= GetConVar("ttt_round_limit"):GetInt() then
				TTZ.NotifyChat( ply, TTZ.RoundBeforeZMode .. " Round left before Zombie mode is started.", Color(220,80,0) )
			end
		end
		
		if TTZ.Cvar.startZmode:GetBool() or TTZ.RoundBeforeZMode == 0 then
			timer.Simple( 2, function()
				for _,ply in pairs(player.GetAll()) do
					if (ply and IsValid(ply)) then
						-- save for later.
						ply._oriBaseKarma = ply:GetBaseKarma()
						ply._oriLiveKarma = ply:GetLiveKarma()
						TTZ.Notify( ply, "CRN-Virus outbreak has been spread... Quick, Grab some weapons!", NOTIFY_ERROR )
					end
				end
			end)
		end
		
	end
	
	if player.GetCount() <= TTZ.Cvar.minPlayer:GetInt() and (TTZ.Cvar.startZmode:GetBool() or TTZ.RoundBeforeZMode == 0) then
		TTZ.NotifyChat( ply, "ERROR: There are not enough Players to start Zombie Mod because server has less than ".. TTZ.Cvar.minPlayer:GetInt().. " total players!",Color(80,220,0))
	end
end)

hook.Add("TTTEndRound", "ResetAllZombieStats", function()
	isRoundEnd = true
	
	if isGamemodeRunning then
	
		for _,ply in pairs(player.GetAll()) do
		
			ply:SetHeBecomeZombie(false)
			ply:SetWalkSpeed(ply._oriWalkSpeed)
			ply:SetJumpPower(ply._oriJumpPower)
			
			if TTZ.Cvar.ResetKarma:GetBool() then
				ply:SetBaseKarma(DefaultKarma)
				ply:SetLiveKarma(DefaultKarma)
			else
				ply:SetBaseKarma(ply._oriBaseKarma)
				ply:SetLiveKarma(ply._oriLiveKarma)
			end
			
		end
		
		isRoundBegin = false
		isGamemodeRunning = false
	end
	
end)