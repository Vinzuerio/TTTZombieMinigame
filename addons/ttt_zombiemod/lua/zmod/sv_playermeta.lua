--[[
	TTT Mini Zombie Mode
	
	Copyright (c) 2020, Wolvindra-Vinzuerio. All Rights Reserved.
	
	www.wolvindra.net
]]

local plmeta = FindMetaTable("Player")
if !plmeta then return end

function plmeta:SetHeBecomeZombie(bool)
	self.HasZombiefied = bool
end

function plmeta:DoesHeZombiefied()
	return self.HasZombiefied
end

function plmeta:BecomeZombie()
	
	print("[TTZ Debug] -> " .. self:Nick() .. " has been Zombified!")
	
	self:SetModel(Model(table.Random(TTZ.Config.CustomModels)))
	local TotalPlayer = player.GetCount()
	self:SetHealth(TTZ.Cvar.ZombieHealth:GetInt() * TotalPlayer)
	
	self:SetWalkSpeed(self:GetWalkSpeed() + TTZ.Cvar.ZombieWalkSpeed:GetInt())
	self:SetJumpPower(self:GetJumpPower() + TTZ.Cvar.ZombieJumpPower:GetInt())
	
	timer.Simple(0.2, function()
		if self:Alive() && self:Team() ~= TEAM_SPECTATOR then
			-- Slot 7
			if table.Count(TTZ.Config.CustomWeaponSlot7) > 0 then self:Give(table.Random(TTZ.Config.CustomWeaponSlot7)) end
			-- Slot 8
			if table.Count(TTZ.Config.CustomWeaponSlot8) > 0 then self:Give(table.Random(TTZ.Config.CustomWeaponSlot8)) end
			-- Normal Slot, Give a Crowbar. todo: Zombie claw.
			self:Give("weapon_zm_improvised")
		end
	end)
	
	self:SetHeBecomeZombie(true)

end