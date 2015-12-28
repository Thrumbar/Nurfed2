--[[
	Nurfed2 UI Suite
		By: Apoco, Tivoli
		www.nurfedui.net
		(c) and all that good shit
]]
local wowmenu = {
	{ CHARACTER, function() ToggleCharacter("PaperDollFrame"); end },
	{ SPELLBOOK, function() SpellbookMicroButton:Click() end },
	{ TALENTS, function() TalentMicroButton:Click() end },
	{ ACHIEVEMENTS, function() AchievementMicroButton:Click() end },
	{ QUESTLOG_BUTTON, function() QuestLogMicroButton:Click() end },
	{ SOCIAL_BUTTON, function() SocialsMicroButton:Click() end },
	{ PLAYER_V_PLAYER, function() if PVPFrame:IsShown() then PVPFrame:Hide() else PVPFrame:Show() end end },
	{ LFG_BUTTON, function() LFGMicroButton:Click() end },
	{ BINDING_NAME_TOGGLEGAMEMENU, function() MainMenuMicroButton:Click() end },
	{ KNOWLEDGE_BASE, function() HelpMicroButton:Click() end },
	{ KEYRING, function() KeyRingButton:Click() end },
}

local Nurfed2_LoadList = {
	"Chat",
	"SpellAlert",
	"ActionBars",
	"UnitFrames",
}

local function MiniMap_OnUpdate(self)
	if self.isMoving then
		local xpos, ypos = GetCursorPosition()
		local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

		xpos = xmin - xpos/Minimap:GetEffectiveScale() + 70
		ypos = ypos / Minimap:GetEffectiveScale() - ymin - 70
		local angle = math.deg(math.atan2(ypos, xpos))
		
		if Nurfed2DB.Core.SquareMinimap then
			xpos = 110 * cos(angle)
			ypos = 110 * sin(angle)
			xpos = math.max(-82, math.min(xpos,84))
			ypos = math.max(-86, math.min(ypos,82))
		else
			xpos = 80 * cos(angle)
			ypos = 80 * sin(angle)
		end
		self:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52-xpos, ypos-52)
	end
end
-- Event Functions
-----------------------------------------------------------
local function ADDON_LOADED(self, name)
end

local sellFrame = CreateFrame("Frame")
local function MERCHANT_SHOW(self, ...)
	local isRepairing, startRepMoney
	if Nurfed2DB.Core.AutoRepair then	-- opt AutoRepair
		local limit = tonumber(Nurfed2DB.Core.RepairLimit)	--Opt RepairLimit
		local money = tonumber(math.floor(GetMoney() / COPPER_PER_GOLD))
		if money >= limit then
			local repairAllCost, canRepair = GetRepairAllCost()
			if canRepair then
				startRepMoney = GetMoney()
				local gold = math.floor(repairAllCost / (COPPER_PER_SILVER * SILVER_PER_GOLD))
				local silver = math.floor((repairAllCost - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
				local copper = math.fmod(repairAllCost, COPPER_PER_SILVER)
				if CanGuildBankRepair() and min(GetGuildBankWithdrawMoney(), GetGuildBankMoney()) > repairAllCost then
					RepairAllItems(1)
					Nurfed2:Print("|cffffffffSpent|r |c00ffff66"..gold.."g|r |c00c0c0c0"..silver.."s|r |c00cc9900"..copper.."c|r |cffffffffOn Repairs (Guild).|r")
				else
					isRepairing = true
					RepairAllItems()
					Nurfed2:Print("|cffffffffSpent|r |c00ffff66"..gold.."g|r |c00c0c0c0"..silver.."s|r |c00cc9900"..copper.."c|r |cffffffffOn Repairs.|r")
				end
			end
		end
	end
	if Nurfed2DB.Core.AutoSell then
		if isRepairing then
			local timer = 1
			sellFrame:Show()
			sellFrame:SetScript("OnUpdate", function()
				timer = timer + 1
				if timer >= 15 then
					if GetMoney() == startRepMoney then
						timer = 0
						return
					else
						sellFrame:SetScript("OnUpdate", nil)
						Nurfed2_LockButton:GetScript("OnEvent")(Nurfed2_LockButton, "MERCHANT_SHOW")
					end
				end
			end)
			return
		end
		
		local sold, startMoney = nil, GetMoney()
		for bag=0,4,1 do
			for slot=1, GetContainerNumSlots(bag), 1 do
				if GetContainerItemLink(bag, slot) then
					local name, link, rarity = GetItemInfo(GetContainerItemLink(bag, slot))
					if name and not Nurfed2DB.Core.DoNotSell[name] and not Nurfed2DB.Core.DoNotSell[tonumber(link:match("Hitem:(%d+)"))] and rarity == 0 then
						UseContainerItem(bag, slot)
						sold = true
					end
				end
			end
		end
		if sold then
			local timer = 1
			sellFrame:Show()
			sellFrame:SetScript("OnUpdate", function()
				timer=timer+1
				if timer >= 15 then
					local money = GetMoney() - startMoney
					if money == 0 then 
						timer = 0
						return
					end

					local gold = math.floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
					local silver = math.floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
					local copper = math.fmod(money, COPPER_PER_SILVER)
					Nurfed2:Print("|cffffffffReceived|r |c00ffff66"..gold.."g|r |c00c0c0c0"..silver.."s|r |c00cc9900"..copper.."c|r |cfffffffffrom selling trash loot.|r")
					sellFrame:SetScript("OnUpdate", nil)
				end
			end)
		end
	end
end

local pingFlood, lastInvite, flooding = {}
local function flood()
	local now = GetTime()
	if lastInvite and now - lastInvite > 1 then lastInvite = nil end
	for n, t in pairs(pingFlood) do
		if now - t > 1 then pingFlood[n] = nil end
	end
	for i,v in pairs(pingFlood) do return end
	if lastInvite then return end
	Nurfed2:Unschedule(flood, true)
	flooding = not flooding
end

local function MINIMAP_PING(self, ...)
	local name = UnitName(arg1)
	if name ~= UnitName("player") and not pingFlood[name] then
		Nurfed2:Print(name.." Ping.", 1, 1, 1, 0)
		pingFlood[name] = GetTime()
		if not flooding then
			Nurfed2:Schedule(0.5, flood, true)
			flooding = not flooding
		end
	end
end


local function CHAT_MSG_WHISPER(self, ...)
	if not Nurfed2DB.Core.AutoInvite.Enable then return end	-- Opt AutoInvite.Enable

	if IsPartyLeader() or IsRaidLeader() or IsRaidOfficer() or 
	(GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0) then
		if arg1:find("^"..Nurfed2DB.Core.AutoInvite.Keyword) then	-- Opt AutoInvite.Keyword
			if Nurfed2DB.Core.AutoInvite.GuildOnly and IsInGuild() then		-- Opt AutoInvite.GuildOnly
				local name, rank, inviteRank = nil, nil, Nurfed2DB.Core.AutoInvite.GuildRank -- Opt AutoInvite.GuildRank
				for i=1, GetNumGuildMembers(true) do
					name, rank = GetGuildRosterInfo(i)
					-- Opt AutoInvite.GuildRankList
					if name == arg2 and (not inviteRank or inviteRank and Nurfed2DB.Core.AutoInvite.GuildRankList[rank]) then
						InviteUnit(arg2)
						lastInvite = GetTime()
						if not flooding then
							Nurfed2:Schedule(0.5, flood, true)
							flooding = not flooding
						end
						return
					end
				end
			else
				InviteUnit(arg2)
				lastInvite = GetTime()
				if not flooding then
					Nurfed2:Schedule(0.5, flood, true)
					flooding = not flooding
				end
			end
		end
	end
end

local inGroup = Nurfed2:formatgs(ERR_ALREADY_IN_GROUP_S, true)
local function CHAT_MSG_SYSTEM(self, ...)
	if not Nurfed2DB.Core.AutoInvite.Enable or not Nurfed2DB.Core.AutoInvite.InviteReply then return end	-- Opt AutoInvite.Enable

	if IsPartyLeader() or IsRaidLeader() or IsRaidOfficer() then
		if arg1:find(ERR_GROUP_FULL, 1, true) and lastInvite then
			local lastTell = ChatEdit_GetLastTellTarget(DEFAULT_CHAT_FRAME.editBox)
			if lastTell ~= "" then
				SendChatMessage("Party Full", "WHISPER", nil, lastTell)
			end
		else
			local result = { arg1:find(inGroup) }
			if result[1] then
				-- Opt AutoInvite.Keyword
				SendChatMessage(string.format("Drop group and resent '%s'", Nurfed2DB.Core.AutoInvite.Keyword), "WHISPER", nil, result[3])
			end
		end
	end
end

-- Wipe Mode
--------------------------------------------
local inwipe, weapstrip
local function StartWipe()
	if not inwipe then return end
	if not InCombatLockdown() then
		Nurfed2:Print("Wipe Recovery: Out Of Combat, Stripping Gear!")
		local Strip_Order = { 16, 17, 18, 5, 7, 1, 3, 10, 8, 6, 9 };
		local start = 1
		local finish = table.getn(Strip_Order)
		for bag=0, 4 do
			local slots, type = GetContainerNumFreeSlots(bag)
			if slots > 0 and type == 0 then
				for slot = 1, GetContainerNumSlots(bag) do
					if not GetContainerItemLink(bag, slot) then
						for i = start, finish do
							if GetInventoryItemLink("player", Strip_Order[i]) then
								PickupInventoryItem(Strip_Order[i])
								PickupContainerItem(bag, slot)
								start = i + 1
								break
							end
						end
					end
				end
			end
		end
		inwipe = nil
		weapstrip = nil
		Nurfed2:Unschedule(StartWipe, true)
	else
		if not weapstrip then
			Nurfed2:Print("Wipe Recovery: In Combat, Removing Weapons!")
			local Strip_Order = { 16, 17, 18 };
			local start = 1
			local finish = table.getn(Strip_Order)
			for bag=0, 4 do
				local slots, type = GetContainerNumFreeSlots(bag)
				if slots > 0 and type == 0 then
					for slot = 1, GetContainerNumSlots(bag) do
						if not GetContainerItemLink(bag, slot) then
							for i = start, finish do
								if GetInventoryItemLink("player", Strip_Order[i]) then
									PickupInventoryItem(Strip_Order[i])
									PickupContainerItem(bag, slot)
									start = i + 1
									break
								end
							end
						end
					end
				end
			end

			weapstrip = true
		end
	end
end

-- Start Raid Mode
--------------------------------------------
local function Nurfed2_CreateRaid()
	if GetNumPartyMembers() ~= 0 and not UnitInRaid("player") and IsPartyLeader() then
		ConvertToRaid()
	end
	if UnitInRaid("player") then
		Nurfed2:Unscheduled(Nurfed2_CreateRaid, true)
	end
end

function Nurfed2_StartRaidMode()
	if IsPartyLeader() or IsRaidLeader() or IsRaidOfficer() then
		if not UnitInRaid("player") then
			Nurfed2:Schedule(0.1, Nurfed2_CreateRaid, true)
		end
		for rank in pairs(Nurfed2DB.Core.RaidMode.GuildRankList) do
			for i=1, GetNumGuildMembers(true) do
				local name, memrank, _, _, _, _, _, officernote, online = GetGuildRosterInfo(i);
				if online then
					if memrank == rank and Nurfed2DB.Core.RaidMode.NoInviteOfficerNote ~= officernote then
						InviteUnit(name)
					elseif memrank ~= rank and Nurfed2DB.Core.RaidMode.InviteOfficerNote == officernote then
						InviteUnit(name)
					end
				end
			end
		end
	end
end

CastingBarFrame.O_OnEvent = CastingBarFrame:GetScript("OnEvent")
CastingBarFrame.O_OnUpdate = CastingBarFrame:GetScript("OnUpdate")

function Nurfed2_ToggleCastBar()
	if Nurfed2DB.Core.HideCastBar then
		CastingBarFrame:SetScript("OnEvent", nil)
		CastingBarFrame:SetScript("OnUpdate", nil)
		CastingBarFrame:Hide()
	else
		CastingBarFrame:SetScript("OnEvent", CastingBarFrame.O_OnEvent)
		CastingBarFrame:SetScript("OnUpdate", CastingBarFrame.O_OnUpdate)
	end
end

local NRF2DEBUG
local function PLAYER_ENTERING_WORLD(self, ...)
	if not NRF2DEBUG then
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:RegisterEvent("PLAYER_LOGIN")
		f:SetScript("OnEvent", function()
			if not UnitIsDND("player") and Nurfed2DB.Core.Debug == true then
				SendChatMessage("Coding.  If I miss a tell, get over it.", "DND")
			end
			
			Nurfed2:AddSlash(function() 
					Swatter.Error:Hide()
					SwatterData.errors = {}
					Swatter.errorOrder = {}
					ReloadUI()
			end, "/rls")
		end)
		NRF2DEBUG = true
	end
	
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	Nurfed2:Print(".|cff3300D2NurfedUI|r|cff3355FD 2|r |cffD23322-Core-|r Version: <r20100308041333>")
	for _, name in ipairs(Nurfed2_LoadList) do
		local loaded = LoadAddOn("Nurfed2_"..name)
		if loaded then
			if _G["Nurfed2_"..name.."ver"] then
				Nurfed2:Print(".|cff3300D2NurfedUI|r|cff3355FD 2|r |cffD23322-"..name.."-|r Version: <".._G["Nurfed2_"..name.."ver"]..">")
			else
				Nurfed2:Print(".|cff3300D2NurfedUI|r|cff3355FD 2|r |cffD23322-"..name.."-|r Version: Unknown")
			end
		end
	end
	Nurfed2:UpdateBindings()
	Nurfed2:AddSlash(function() 
		if not inwipe then
			inwipe = true; 
			Nurfed2:Schedule(0.1, StartWipe, true) 
		end
	end, "/wipe")
end


local function VARIABLES_LOADED(self, ...)
	self:UnregisterEvent("VARIABLES_LOADED")
	if self:IsUserPlaced() then
		self:SetUserPlaced(nil)
	end
	self:SetPoint(unpack(Nurfed2DB.Core.MinimapLoc))
	-- dont taint this shit!w
	--for _, val in pairs(RAID_CLASS_COLORS) do
	--	val.hex = Nurfed2:rgbhex(val.r, val.g, val.b)
	--end
	CameraPanelOptions.cameraDistanceMaxFactor.maxValue = 4
	Nurfed2_ToggleCastBar()
end

local function PARTY_INVITE_REQUEST(self, ...)
	local accept
	if Nurfed2DB.Core.AutoAcceptFriendInvite then	-- Option AutoAcceptFriendInvite
		for i=1, GetNumFriends() do 
			if GetFriendInfo(i) == arg1 then
				accept = true
			end
		end
	end
	if Nurfed2DB.Core.AutoAcceptGuildInvite and not accept then	-- Option AutoAcceptGuildInvite
		if IsInGuild() then
			for i=1, GetNumGuildMembers() do 
				if GetGuildRosterInfo(i) == arg1 then
					accept = true
				end 
			end 
		end
	end
	if accept then
		AcceptGroup()
		for i=1, STATICPOPUP_NUMDIALOGS do
			local popup = _G["StaticPopup"..i]
			if popup.which == "PARTY_INVITE" then
				popup.inviteAccepted = 1
				break
			end
		end
		StaticPopup_Hide("PARTY_INVITE")
	end
end

local function TRAINER_SHOW()
	SetTrainerServiceTypeFilter("unavailable", 0)
end

-- lock button
---------------------------------------------
Nurfed2:Create("Nurfed2_LockButton", {
	type = "CheckButton",
	size = { 33, 33 },
	FrameStrata = "LOW",
	Checked = NRF_LOCKED,
	Movable = true,
	events = {
		"ADDON_LOADED",
		"MERCHANT_SHOW",
		"TRAINER_SHOW",
		"MINIMAP_PING",
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_SYSTEM",
		"PLAYER_ENTERING_WORLD",
		"VARIABLES_LOADED",
		"PARTY_INVITE_REQUEST",
	},
	children = {
		dropdown = { type = "Frame" },
		Border = {
			type = "Texture",
			size = { 52, 52 },
			layer = "ARTWORK",
			Texture = "Interface\\Minimap\\MiniMap-TrackingBorder",
			Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
		},
		HighlightTexture = {
			type = "Texture",
			size = { 33, 33 },
			alphaMode = "ADD",
			Texture = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight",
			Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
		},
		icon = {
			type = "Texture",
			size = { 23, 23 },
			layer = "BACKGROUND",
			Texture = NRF2_IMG.."locked",
			Anchor = { "CENTER", "$parent", "CENTER", -1, 1 },
		},
	},
	OnLoad = function(self)
		self.icon = _G[self:GetName().."icon"]
	end,
	OnEvent = function(self, event, ...)
		if event == "ADDON_LOADED" then ADDON_LOADED(self, ...)
		elseif event == "MERCHANT_SHOW" then MERCHANT_SHOW(self, ...)
		elseif event == "TRAINER_SHOW" then TRAINER_SHOW(self, ...)
		elseif event == "MINIMAP_PING" then MINIMAP_PING(self, ...)
		elseif event == "CHAT_MSG_WHISPER" then CHAT_MSG_WHISPER(self, ...)
		elseif event == "CHAT_MSG_SYSTEM" then CHAT_MSG_SYSTEM(self, ...)
		elseif event == "PLAYER_ENTERING_WORLD" then PLAYER_ENTERING_WORLD(self, ...)
		elseif event == "VARIABLES_LOADED" then VARIABLES_LOADED(self, ...)
		elseif event == "PARTY_INVITE_REQUEST" then PARTY_INVITE_REQUEST(self, ...)
		end
	end,
	OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:AddLine("Nurfed UI 2", 0, 0.75, 1)
		if Nurfed2:IsLocked() then
			GameTooltip:AddLine("Left Click - |cffff0000Unlock|r UI", 0.75, 0.75, 0.75)
		else
			GameTooltip:AddLine("Left Click - |cff00ff00Lock|r UI", 0.75, 0.75, 0.75)
		end
		GameTooltip:AddLine("Right Click - Nurfed Menu", 0.75, 0.75, 0.75)
		GameTooltip:AddLine("Middle Click - WoW Micro Menu", 0.75, 0.75, 0.75)
		GameTooltip:Show()
	end,
	OnClick = function(self, button)
		if button == "LeftButton" then
			if Nurfed2:IsLocked() then
				Nurfed2:Unlock()
			else
				Nurfed2:Lock()
			end
			PlaySound("igMainMenuOption")
			self:GetScript("OnEnter")(self)
		else
			Nurfed2:Lock()
			if button == "RightButton" then
				Nurfed2_ToggleOptions()
			else
				local drop = Nurfed2_LockButtondropdown
				local info = {}
				if not drop.initialize then
					drop.displayMode = "MENU"
					drop.initialize = function()
						info.text = "WoW Menu"
						info.isTitle = 1
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info)
						info = {}

						for _, v in ipairs(wowmenu) do
							info.text = v[1]
							info.func = v[2]
							info.notCheckable = 1
							UIDropDownMenu_AddButton(info)
						end
					end
				end
				ToggleDropDownMenu(1, nil, drop, "cursor")
			end
		end
	end,
	OnLeave = function() GameTooltip:Hide() end,
	OnDragStart = function(self)
		self.isMoving = true
		self:SetScript("OnUpdate", MiniMap_OnUpdate)
	end,
	OnDragStop = function(self)
		self.isMoving = nil
		self:SetScript("OnUpdate", nil)
		Nurfed2DB["Core"]["MinimapLoc"] = { self:GetPoint() }
		Nurfed2DB["Core"]["MinimapLoc"][2] = "Minimap"
	end,
}, Minimap)


Nurfed2_LockButton:RegisterForClicks("AnyUp")
Nurfed2_LockButton:RegisterForDrag("LeftButton")
Nurfed2:RegEvent("N2_LOCK_STATUS_UPDATE", function(event, status)
	-- lock button gfx change
	if status then Nurfed2_LockButton.icon:SetTexture(NRF2_IMG.."locked")
	else Nurfed2_LockButton.icon:SetTexture(NRF2_IMG.."unlocked")
	end
end)

Nurfed2:Create("Nurfed2_SpecButton", {
	type = "Button",
	uitemp = "UIPanelButtonTemplate",
	size = { 75, 25 },
	FrameStrata = "HIGH",
	Point = { "TOPLEFT", _G["CharacterWristSlot"], "BOTTOMLEFT", 10, -7 },
	SetText = "Swap Spec",
	OnLoad = function(self)
		self:ClearAllPoints();
		self:SetPoint("TOPLEFT", _G["CharacterWristSlot"], "BOTTOMLEFT", 10, -7)
		if GetNumTalentGroups() ~= 1 then
			self:Show()
		else
			self:Hide()
		end
	end,
	OnClick = function(self, button)
		local gp = GetActiveTalentGroup()
		gp = gp == 1 and 2 or gp == 2 and 1
		SetActiveTalentGroup(gp)
	end,
}, PaperDollFrame)

--[[
-- Create Default Options Thinger
--------------------------------------------
Nurfed2:Createtemp("uipanel", {
	type = "Frame",
	children = {
		Title = {
			type = "FontString",
			Point = {"TOPLEFT", 16, -16},
			FontObject = "GameFontNormalLarge",
			JustifyH = "LEFT",
			JustifyV = "TOP",
		},
		SubText = {
			type = "FontString",	
			Point = {"TOPLEFT", "$parentTitle", "BOTTOMLEFT", 0, -8},
			Point2 = {"RIGHT", -32, 0},
			FontObject = "GameFontHighlightSmall",
			JustifyH = "LEFT",
			JustifyV = "TOP",
			Height = 32,
			NonSpaceWrap = true,
		},
		VerText = {
			type = "FontString",
			Point = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 16, 16 },
			FontObject = "GameFontHighlightSmall",
			JustifyH = "LEFT",
			JustifyV = "TOP",
		},
	}
})

local panel = Nurfed2:Create("Nurfed2_OptionsFrame", "uipanel")
panel:SetScript("OnShow", function(self)
    LoadAddOn("Nurfed2_Options")
    self:SetScript("OnShow", nil)
end)
panel.name = "Nurfed 2"
Nurfed2_OptionsFrameTitle:SetText("Nurfed 2")
Nurfed2_OptionsFrameSubText:SetText("This is the main Nurfed options menu, please select a subcategory to change options.")
InterfaceOptions_AddCategory(panel)
]]
if UnitName("player") == "Apoco" or UnitName("player") == "Adkpoco" or UnitName("player") == "Chetvipoco" then
	local updateTooltips = function(self)	
		self:SetBackdropBorderColor(1, 1, 1, 0)
		if self:IsShown() then
			local parent = GetMouseFocus()
			if parent then
				local pname = parent:GetName()
				if pname and pname:find("^Nurfed_Button") then
					self:ClearAllPoints()
					self:SetPoint("BOTTOMLEFT", parent, "TOPRIGHT", 0, 0)
					return
				elseif pname and pname:find("^Grid") and InCombatLockdown() then
					return self:Hide()
				end
			end
			local p1, p2, p3, p4, p5 = self:GetPoint()
			if p1 == "BOTTOMRIGHT" and p2 == UIParent and p3 == "BOTTOMRIGHT" then
				self:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 13, 150)
			end
		end
	end

	if GameTooltip:GetScript("OnShow") then
		GameTooltip:HookScript("OnShow", updateTooltips)
	else
		GameTooltip:SetScript("OnShow", updateTooltips)
	end
	if ItemRefTooltip:GetScript("OnShow") then
		ItemRefTooltip:HookScript("OnShow", updateTooltips)
	else
		ItemRefTooltip:SetScript("OnShow", updateTooltips)
	end
end
-- Animating First Run Shit.
-- Move to a different file eventually.\
-------------------------------------------------------------
do
	return
end

do
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetWidth(256)
	f:SetHeight(256)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = nil,
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	f.titletext = f:CreateFontString(nil, "OVERLAY")
	f.titletext:SetFontObject("GameFontNormalSmall")
	f.titletext:SetText("Nurfed 2")
	f.titletext:SetPoint("TOP", f, "TOP", 0, -5)
	local anim = f:CreateAnimationGroup("Nurfed2Test")
	anim:SetScript("OnLoad", function(self) self:Play() end)
	local rotate = anim:CreateAnimation("Rotation")
	rotate:SetDegrees(360)
	local scale = anim:CreateAnimation("Scale")
	scale:SetScale(1, 200)
	local alpha = anim:CreateAnimation("Alpha")
	alpha:SetChange(1)
	f:SetPoint("CENTER")
	f:Show()
end