--[[
	Nurfed Version 2
	By: Apoco, Tivoli
	http://www.nurfed.com
	irc.gamesurge.net #nurfed, #nurfedui
	---
	Nurfed Core Library
	---
]]--

local version = 2.0
local _G = getfenv(0)
local util = _G["Nurfed2"]

if util and util.version >= version then
	return
end

util = {}
_G["Nurfed2"] = util
util.name = "Nurfed2"
util.version = version
--[[
	OtherMods = {
		["Auracle"] = { [1] = "DPS", [2] = "tank", ["type"] = "Ace3", },
	}
]]
local Nurfed2DBDefaults = {
	["MultiSpec"] = {
		["Core"] = false,
		["Bindings"] = false,
		["OtherMods"] = { },
	},
	["MultiSpecSettings"] = {	-- if something is using multi-spec settings, then store the 
		[1] = { },				-- variables here.  The variables are copied and moved when you change specs
		[2] = { },				-- this causes slightly more garbage, but that will be cleaned up within 60 seconds
	},							-- and makes coding/efficiency a lot better.
	["Core"] = {
		["MinimapLoc"] = { "CENTER" },
		["AutoInvite"] = {
			["Enable"] = true,
			["Keyword"] = "invite",
			["GuildOnly"] = true,
			["GuildRank"] = false,
			["GuildRankList"] = { },
		},
		["AutoRepair"] = true,
		["RepairLimit"] = 100,
		["AutoSell"] = true,
		["HideCastBar"] = true,
		["DoNotSell"] = { },
		["RaidMode"] = {
			["GuildRankList"] = {},
			["NoInviteOfficerNote"] = "",
			["InviteOfficerNote"] = "",
		},
	},
	["Bindings"] = {
		["Click"] = { },	-- click = { ["1"] = "Nurfed2_Button1", ["f"] = "Nurfed2_Button2", }
		["Item"] = { },
		["Spell"] = { },
		["Macro"] = { },
	},
}

local frame = CreateFrame("Frame")
local virtual = {}
local pairs = pairs
local ipairs = ipairs
local type = type

NRF2_IMG = "Interface\\AddOns\\Nurfed2\\Images\\"
NRF2_FONT = "Interface\\AddOns\\Nurfed2\\Fonts\\"
-- Add round function to math
math.round = function(num, idp)
	return tonumber(string.format("%."..(idp or 0).."f", num))
end

-- Add capitalize function to string
string.capital = function(text)
	local up = function(first, rest)
		return string.upper(first)..string.lower(rest)
	end
	text = string.gsub(string.lower(text), "(%l)([%w_']*)", up)
	return text
end

----------------------------------------------------------------
-- Utility functions
----------------------------------------------------------------
-- Dev Shit
function util:debug(...)
	if Nurfed2DB.Core.DebugMode then
		if not AceLibrary and not Rock and not LibStub then return end
		local frame = ChatFrame3 or ChatFrame2
		if AceLibrary and AceLibrary:HasInstance("AceConsole-2.0") then
			AceLibrary("AceConsole-2.0"):CustomPrint(nil, nil, nil, frame, nil, true, ...)
		elseif Rock and Rock:HasLibrary("LibRockConsole-1.0") then
			Rock("LibRockConsole-1.0"):CustomPrint(nil, nil, nil, frame, nil, true, ...)
		else
			LibStub("AceConsole-3.0"):Print(frame, ...)
		end
	end
end
-->

-- Settings Shit

-- Settings sub-functions
------------------------------------------------------
	
	--Check the table for old, unused, variables, if they exist, remove them.
local function checktable(tbl, dtbl)
	for varname, varvalue in pairs(dtbl) do
		local ttype = type(tbl[varname])
		if ttype == "nil" then -- if it doest exist in the dest table, remove it from the source table
			tbl[varname] = varvalue
		elseif ttype == "table" then
			checktable(tbl[varname], varvalue)
		end
	end
end

local function SetupDefaultN2Settings()
	if not Nurfed2DB then Nurfed2DB = { } end
	for varname, varvalue in pairs(Nurfed2DBDefaults) do
		if type(varvalue) == "table" then	-- if the value is a table, check if it exists
			if not Nurfed2DB[varname] then	-- if it does not exist, then just copy it over and continue
				Nurfed2DB[varname] = varvalue
			else							-- if it does exist, then check all values for new variables
				checktable(Nurfed2DB[varname], varvalue)
			end
		else
			if type(Nurfed2DB[varname]) == "nil" then
				Nurfed2DB[varname] = varvalue
			end
		end
	end
end

function util:FeedDefaultSettings(name, defaultSettings, nomultispec)
	if type(name) ~= "string" or type(defaultsettings) ~= "table" then assert("Improper feedsettings") end
	if not nomultispec then
		Nurfed2DBDefaults["MultiSpec"][name] = false;
	end
	Nurfed2DBDefaults[name] = defaultSettings
	SetupDefaultN2Settings()
end

-- Initial Multi-talent setup
local function N2TalentChanged(event, newspec, lastspec)
	if not Nurfed2DB then return end
	for name, val in pairs(Nurfed2DB["MultiSpec"]) do
		if name ~= "OtherMods" then	-- check for Nurfed changes
			if val then
				-- copy the current settings to last spec tbl
				--copytable(Nurfed2DB[name], Nurfed2DB["MultiSpecSettings"][lastspec][name])
				Nurfed2DB["MultiSpecSettings"][lastspec][name] = Nurfed2:copytable(Nurfed2DB[name])
				
				if Nurfed2DB["MultiSpecSettings"][newspec][name] then
					if Nurfed2DB[name] then
						table.wipe(Nurfed2DB[name])-- clear out current variables
					end
					Nurfed2:Print("Swapped Settings for: "..name)
				else
					Nurfed2DB["MultiSpecSettings"][newspec][name] = Nurfed2:copytable(Nurfed2DB[name])
					Nurfed2:Print("No new spec settings for new spec / "..name.."  ~ retaining old settings")
				end
				-- copy the newspec settings to the main table
				--copytable(Nurfed2DB["MultiSpecSettings"][newspec][name], Nurfed2DB[name])
				Nurfed2DB[name] = Nurfed2:copytable(Nurfed2DB["MultiSpecSettings"][newspec][name])
			end
		end
	end
	for name, tbl in pairs(Nurfed2DB["MultiSpec"]["OtherMods"]) do	-- check for other mod changes?
		if IsAddOnLoaded(name) then
			if tbl["type"] == "Ace3" then
				local mod = _G[name]
				if mod.db and mod.db.SetProfile then
					if type(mod.db.SetProfile) == "function" then
						_G.LibStub("AceAddon-3.0"):GetAddon(name).db:SetProfile(tbl[newspec])
					end
				end
			end
		end
	end
	SetupDefaultN2Settings()
	Nurfed2:SendEvent("N2_SETTINGS_UPDATE")
	if Nurfed2DB.MultiSpec.Bindings then
		Nurfed2:UpdateBindings(lastspec)
	end
end

-- Add cooldown text
local function UpdateCooling(self, start, duration, enable)
	if not self:GetName() or not self.text then return end
	if start > 2 and duration > 2 then
		self.cool = true;
		self.start = start;
		self.duration = duration;
	else
		self.cool = nil;
		self.text:SetText(nil);
	end
end
hooksecurefunc("CooldownFrame_SetTimer", UpdateCooling)

function util:CooldownText(btn)
	if type(btn) == "number" then btn = self; end
	local cd = _G[btn:GetName().."Cooldown"]
	if cd and cd.text and cd.cool then
		local cdscale = cd:GetScale()
		local r, g, b = 1, 0, 0
		local height = floor(20 / cdscale)
		local fheight = select(2, cd.text:GetFont())
		local remain = (cd.start + cd.duration) - GetTime()
		if remain >= 0 then
			remain = math.round(remain)
		
			if remain >= 3600 then
				remain = math.floor(remain / 3600).."h"
				r, g, b = 0.6, 0.6, 0.6
				height = floor(12 / cdscale)
			
			elseif remain >= 60 then
				local min = math.floor(remain / 60)
				r, g, b = 1, 1, 0
				height = floor(12 / cdscale)

				if min < 10 then
					local secs = math.floor(math.fmod(remain, 60))
					remain = string.format("%2d:%02s", min, secs)
				else
					remain = min.."m"
				end
			end
			cd.text:SetText(remain)
			cd.text:SetTextColor(r, g, b)
			if height ~= fheight and not cd.disableheight then
				if cd.scalesize then
					height = height * cd.scalesize
				end
				if cd.text.font then
					cd.text:SetFont(select(1, cd.text.font:GetFont()), height, select(3, cd.text.font:GetFont()))
				else
					cd.text:SetFont("Fonts\\FRIZQT__.TTF", height, "OUTLINE")
				end
				cd:SetFrameLevel(30)
			end
		else
			cd.text:SetText(nil)
			cd.cool = nil
		end
	end
end

--//
-- Bindings Updating
local bfunc
function util:UpdateBindings(remove)
	if remove then
		for type, tbl in pairs(Nurfed2DB.MultiSpecSettings[remove].Bindings) do
			for btn, key in pairs(tbl) do
				SetBinding(key)
			end
		end
		--SaveBindings(GetCurrentBindingSet())
	end
	for type, tbl in pairs(Nurfed2DB.Bindings) do
		bfunc = _G["SetBinding"..type]
		for btn, key in pairs(tbl) do
			bfunc(key, btn)
		end
	end
	SaveBindings(GetCurrentBindingSet())
	util:SendEvent("N2_BINDINGS_UPDATE")
end


--//
-- Locking Functions
function util:CreateHandle(name, title)
	--if not name or not title then return end
	if not title then return end
	local f = CreateFrame("Frame", name, UIParent)
	f:SetWidth(110)
	f:SetHeight(13)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
	f:SetBackdropColor(0, 0, 0, 50)
	f:SetMovable()
	f:EnableMouse()
	f:RegisterForDrag("LeftButton")
	f:SetClampedToScreen()
	f:Hide()
	if not f:IsUserPlaced() then
		f:SetPoint("CENTER")
	end
	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetPoint("CENTER")
	f.text:SetFontObject("GameFontNormalSmall")
	f.text:SetText(title)
	f.text:SetTextColor(1, 1, 1)
	f:SetScript("OnDragStart", function(self)
		if not Nurfed2:IsLocked() and not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	f:SetScript("OnDragStop", function(self)
		if not Nurfed2:IsLocked() and not InCombatLockdown() then
		  self:StopMovingOrSizing()
		  self:SetUserPlaced(true)
		 end
	end)
	return f
end

local lockList = { }
local isLocked = true
function util:IsLocked()
	return not not isLocked
end

function util:Unlock()
	isLocked = false
	self:SendEvent("N2_LOCK_STATUS_UPDATE", false)
	for _, frame in ipairs(lockList) do
		frame:Show()
	end
end

function util:Lock()
	isLocked = true
	self:SendEvent("N2_LOCK_STATUS_UPDATE", true)
	for _, frame in ipairs(lockList) do
		frame:Hide()
	end
end

function util:RegisterLock(lock)
	util:insert(lockList, lock)
end
-- Clean Table Inserting.
function util:insert(tbl, val)
	if not tbl or type(tbl) ~= "table" then return end
	for i,v in pairs(tbl) do
		if i == val or v == val then
			return false
		end
	end
	return table.insert(tbl, val)
end

-- printing of messages
function util:Print(msg, out, r, g, b, ...)
	if type(out) == "string" then
		msg = msg:format(out, r, g, b, ...)
	end
	out	= _G["ChatFrame"..(type(out) == "number" and out or 1)]
	out:AddMessage(msg, (type(r) == "number" and r or 1), (type(g) == "number" and g or 1), (type(b) == "number" and b or 1))
end

function util:print(...)
	util:Print("N2Error: Use 'Print' not 'print'")
	util:Print(...)
end

-- converts rgb numbers to hex values:
-- ie: 1.0, 0.0, 0.0 to ff0000
function util:RGBHex(r, g, b)
	if type(r) == "table" then
		if r.r then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end
	return string.format("|cff%02x%02x%02x", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255)
end

-- copies tables
function util:copytable(tbl)
	local new = {}
	local key, value = next(tbl, nil)
	while key do
		if type(value) == "table" then
			value = self:copytable(value)
		end
		new[key] = value
		key, value = next(tbl, key)
	end 
	return new
end

function util:mergetable(target, source)
	local key, value = next(source, nil)
	while key do
		if not target[key] then
			target[key] = value
		elseif type(target[key]) == "table" and type(value) == "table" then
			target[key] = self:mergetable(target[key], value)
		end
		key, value = next(source, key)
	end
	return target
end

local function basicSerialize(o)
	if type(o) == "number" or type(o) == "boolean" then
		return tostring(o)
	else
		return string.format("%q", o)
	end
end

local function save(name, value, out, indent)
	indent = indent or 0
	local iname = string.rep(" ", indent)..name
	if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
		util:insert(out, iname.." = "..basicSerialize(value)..",")
	elseif type(value) == "table" then
		util:insert(out, iname.." = {")
		for k, v in pairs(value) do
			local fieldname
			if type (k) == "string" and string.find (k, "^[_%a][_%a%d]*$") then
				fieldname = k
			else
				fieldname = string.format("[%s]", basicSerialize(k))
			end
			save(fieldname, v, out, indent + 2)
		end
		if indent == 0 then
			util:insert(out, string.rep(" ", indent).."}")
		else
			util:insert(out, string.rep(" ", indent).."},")
		end
	end
end

function util:Serialize(what, tbl)
	local out = {}
	save(what, tbl, out)
	return out
end

function util:Binding(bind)
	bind = bind:gsub("CTRL%-", "C-")
	bind = bind:gsub("ALT%-", "A-")
	bind = bind:gsub("SHIFT%-", "S-")
	bind = bind:gsub("Num Pad", "NP")
	bind = bind:gsub("NUMPAD", "NP")
	bind = bind:gsub("Backspace", "Bksp")
	bind = bind:gsub("Spacebar", "Space")
	bind = bind:gsub("Page", "Pg")
	bind = bind:gsub("Down", "Dn")
	bind = bind:gsub("Arrow", "")
	bind = bind:gsub("Insert", "Ins")
	bind = bind:gsub("Delete", "Del")
	return bind
end

function util:formatgs(gstring, anchor)
	gstring = gstring:gsub("([%^%(%)%.%[%]%*%+%-%?])", "%%%1")
	gstring = gstring:gsub("%%s", "(.+)")
	gstring = gstring:gsub("%%d", "(%-?%%d+)")
	if anchor then gstring = "^"..gstring end
	return gstring
end

----------------------------------------------------------------
-- Frame functions
local frameinit = {
	size = function(obj, val)
		obj:SetWidth(val[1])
		obj:SetHeight(val[2])
	end,
	vars = function(obj, val)
		for k, v in pairs(val) do
			obj[k] = v
		end
	end,
	events = function(obj, val)
		for _, v in ipairs(val) do
			obj:RegisterEvent(v)
		end
	end,
	children = function(obj, val)
		if obj:GetName() then
			for k, v in pairs(val) do
				local cobj = Nurfed2:Createobj(obj:GetName()..k, v, obj)
				if k:find("Texture") then
					local method = obj["Set"..k]
					if method then
						method(obj, cobj)
					end
				end
			end
		end
	end,
}

local framecomp = {
	Text = {},
	Anchor = {},
	BackdropColor = {},
	BackdropBorderColor = {},
}

function util:CreateTemp(name, layout)
	local objtype = rawget(layout, "type") or rawget(layout, "Type")
	if objtype == "Font" then
		self:Createobj(name, layout)
	else
		virtual[name] = layout
	end
end

function util:Create(name, layout, parent)
	if _G[name] then 
		print("Not creating", name, "Already exists")
		return 
	end
	local obj = self:Createobj(name, layout, (parent or UIParent))
	local tbl, anchor

	for i = #framecomp.Anchor, 1, -1 do
		tbl = framecomp.Anchor[i]
		if type(tbl[2]) ~= "table" then
			if tbl[2] == "all" then
				tbl[1]:SetAllPoints(tbl[1]:GetParent())
			else
				tbl[1]:SetPoint(tbl[2])
			end
			table.remove(framecomp.Anchor, i)
		else
			anchor = self:copytable(tbl[2])
			if type(anchor[2]) == "string" then
				anchor[2] = string.gsub(anchor[2], "$parent", tbl[1]:GetParent():GetName())
			end
			if not anchor[2] or type(anchor[2]) == "number" or _G[anchor[2]] then
				tbl[1]:SetPoint(unpack(anchor))
				table.remove(framecomp.Anchor, i)
			end
		end
	end

	for i = #framecomp.BackdropColor, 1, -1 do
		tbl = framecomp.BackdropColor[i]
		tbl[1]:SetBackdropColor(unpack(tbl[2]))
		table.remove(framecomp.BackdropColor, i)
	end

	for i = #framecomp.BackdropBorderColor, 1, -1 do
		tbl = framecomp.BackdropBorderColor[i]
		tbl[1]:SetBackdropBorderColor(unpack(tbl[2]))
		table.remove(framecomp.BackdropBorderColor, i)
	end

	for i = #framecomp.Text, 1, -1 do
		tbl = framecomp.Text[i]
		tbl[1]:SetText(tbl[2])
		table.remove(framecomp.Text, i)
	end
	return obj
end

function util:Createobj(name, layout, parent)
	local obj, objtype, inherit, onload
	if type(parent) == "string" then
		parent = _G[parent]
	end
	if type(layout) == "string" and virtual[layout] then
		layout = self:copytable(virtual[layout])
	end
	if layout.template then
		local template = layout.template
		while template do
			layout.template = nil
			layout = self:mergetable(layout, virtual[template])
			template = layout.template
		end
	end
	objtype = rawget(layout, "type") or rawget(layout, "Type")
	if not objtype then return end
	
	inherit = layout.uitemp or nil
	
	if objtype == "Texture" then
		obj = parent:CreateTexture(name, (layout.layer or "ARTWORK"), inherit)
	elseif objtype == "FontString" then
		obj = parent:CreateFontString(name, (layout.layer or "ARTWORK"), inherit)
	elseif objtype == "Font" then
		obj = CreateFont(name)
	else
		obj = CreateFrame(objtype, name, parent, inherit)
	end

	for k, v in pairs(layout) do
		if type(v) == "table" and v.template then
			local template = v.template
			while template do
				v.template = nil
				v = self:mergetable(v, virtual[template])
				template = v.template
			end
		elseif type(v) == "string" and virtual[v] then
			v = virtual[v]
		end

		if obj.HasScript and obj:HasScript(k) then
			if type(v) == "function" then
				obj:SetScript(k, v)
			else
				if obj:GetScript(k) then
					obj:HookScript(k, assert(loadstring(v)))
				else
					obj:SetScript(k, assert(loadstring(v)))
				end
			end
			if k == "OnLoad" then
				onload = obj:GetScript("OnLoad")
			end
		
		elseif frameinit[k] then
			if type(v) == "string" and v:find("loadstring") then
				v = assert(loadstring(v)(obj))
			end
			
			frameinit[k](obj, v)
		elseif framecomp[k] then
			table.insert(framecomp[k], { obj, v })
		elseif string.find(k, "^Point") or string.find(k, "^Anchor") then
			table.insert(framecomp.Anchor, { obj, v })
		else
			local method = obj[k] or obj["Set"..k] or obj["Enable"..k]
			if method then
				if type(v) == "table" and k ~= "Backdrop" then
					method(obj, unpack(v))
				else
					method(obj, v)
				end
			end
		end
	end
  
	if onload then onload(obj) end
	return obj
end

function util:GetFrames(frame, tbl, recurse)
	if frame.GetChildren then
		local children = { frame:GetChildren() }
		for _, child in ipairs(children) do
			if child:GetName() then
				self:insert(tbl, child:GetName())
				if recurse then 
					self:GetFrames(child, tbl) 
				end
			end
		end
	end

	if frame.GetRegions then
		local regions = { frame:GetRegions() }
		for _, region in ipairs(regions) do
			if region:GetName() then
				self:insert(tbl, region:GetName())
			end
		end
	end
end

----------------------------------------------------------------
-- OnEvent database
local events = {}

function util:RegEvent(event, func)
	event = string.upper(event)
	frame:RegisterEvent(event)
	if not events[event] then
		events[event] = {}
	end
	util:insert(events[event], func)
	--[[
	for _, v in ipairs(events[event]) do
		if v == func then return end
	end
	table.insert(events[event], func)
	]]
end

function util:UnregEvent(event, func)
	event = string.upper(event)
	if not events or not events[event] then
		return
	end
	local tbl = events[event]

	for k, v in ipairs(tbl) do
		if v == func then
			table.remove(tbl, k)
			break
		end
	end

	if #tbl == 0 then
		frame:UnregisterEvent(event)
	end
end

local function OnEvent(self, event, ...)
	if events[event] then
		for _, func in ipairs(events[event]) do
			func(event, ...)
		end
	end
end

frame:SetScript("OnEvent", OnEvent)

function util:SendEvent(event, ...)
	return OnEvent(frame, event, ...)
end

----------------------------------------------------------------
-- OnUpdate database
local timers, timerfuncs
local loops, loopfuncs, looptimes

function util:Schedule(sec, func, loop)
	if loop then
		if not loops then
			loops, loopfuncs, looptimes = {}, {}, {}
		end
		table.insert(loopfuncs, func)
		table.insert(looptimes, sec)
		table.insert(loops, sec)
	else
		if not timers then
			timers, timerfuncs = {}, {}
		end
		table.insert(timerfuncs, func)
		table.insert(timers, sec)
	end
	frame:Show()
end

function util:Unschedule(func, isloop)
	if isloop then
		if not loops then return end
		for k, v in ipairs(loopfuncs) do
			if v == func then
				table.remove(loops, k)
				table.remove(loopfuncs, k)
				table.remove(looptimes, k)
				break
			end
		end
	else
		if not timers then return end
		for k, v in ipairs(timerfuncs) do
			if v == func then
				table.remove(timers, k)
				table.remove(timerfuncs, k)
				break
			end
		end
	end
end

local function OnUpdate(self, e)
	local update, val
	if timers and #timers > 0 then
		for i = #timers, 1, -1 do
			if timers[i] == "combat" then
				if not InCombatLockdown() then
					table.remove(timerfuncs, i)()
					table.remove(timers, i)
				end
			else
				timers[i] = timers[i] - e
				if timers[i] <= 0 then
					table.remove(timerfuncs, i)()
					table.remove(timers, i)
				end
			end
		end  
		update = true
	end

	if loops and #loops > 0 then
		for k, v in ipairs(loops) do
			loops[k] = loops[k] - e
			if loops[k] <= 0 then
				loopfuncs[k](k)
				loops[k] = looptimes[k]
			end
		end
		update = true
	end

	if not update then
		frame:Hide()
	end
end

frame:Hide()
frame:SetScript("OnUpdate", OnUpdate)

-- Slash Commands
local numSlashCmds = 0
function util:AddSlash(func, ...)
	numSlashCmds = numSlashCmds + 1
	local id = "NURFED2" .. numSlashCmds
	SlashCmdList[id] = func
	for i = 1, select('#', ...) do
		setglobal("SLASH_" .. id .. i, select(i, ...))
	end
end

util:AddSlash(function() 
		Swatter.Error:Hide()
		SwatterData.errors = {}
		Swatter.errorOrder = {}
		ReloadUI()
end, "/rls")

local hasLoaded
function Nurfed2_ToggleOptions()
	local loaded, reason = LoadAddOn("Nurfed2_Options")
	if loaded then
		if not hasLoaded then
			Nurfed2:SendEvent("N2_OPTIONS_LOADED")
			hasLoaded = true
		end
		if InterfaceOptionsFrame:IsShown() then
			PlaySound("igAbilityClose");
			InterfaceOptionsFrame:Hide();
		else
			PlaySound("igAbilityOpen");
			UIFrameFadeIn(InterfaceOptionsFrame, 0.25);
			InterfaceOptionsFrame_OpenToCategory("Nurfed 2");
		end
	end
end

----------------------------------------------------------------
-- Spell database
local spells

CreateFrame("GameTooltip", "Nurfed2_Tooltip", UIParent, "GameTooltipTemplate")
Nurfed2_Tooltip:Show()
Nurfed2_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function updatespelltab(tab)
	local spellid, name, rank
	local _, _, offset, numSpells = GetSpellTabInfo(tab)
	for i = 1, numSpells do
		spellid = offset + i
		if not IsPassiveSpell(spellid, BOOKTYPE_SPELL) then
			name, rank = GetSpellName(spellid, BOOKTYPE_SPELL)
			spells[name] = spellid
			if rank:find(RANK) or string.len(rank) == 0 then
				name = name.."("..rank..")"
				spells[name] = spellid
			end
		end
	end
end

local function updatespells(event, arg1)
	if not spells then
		spells = {}
	end
	for i = 1, GetNumSpellTabs() do
		updatespelltab(i)
	end
end

function util:GetSpell(spell, rank)
	if not spells then
		updatespells()
	end
	if rank then
		spell = spell.."("..RANK.." "..rank..")"
	end
	spell = spell:gsub("%(%)", "")
	return spells[spell]
end

function util:GetSpells(search)
	local spells = {}
	local tabs = GetNumSpellTabs()
	for tab = 1, tabs do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		spells[tab] = {}
		for i = 1, numSpells do
			local spell = offset + i
			if search then
				local spellname, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
				if search == spellname or search == spellname.."("..spellrank..")" then
					return spell, spellrank, BOOKTYPE_SPELL
				end
			elseif not IsPassiveSpell(spell, BOOKTYPE_SPELL) then
				local spellname, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
				if not spells[tab][spellname] then
					spells[tab][spellname] = {}
					table.insert(spells[tab], spellname)
				end
				table.insert(spells[tab][spellname], spell)
			end
		end
	end
	return spells
end
util:RegEvent("LEARNED_SPELL_IN_TAB", UpdateSpells)

local function N2_OnLoad()
	if not Nurfed2DB then
		Nurfed2DB = Nurfed2DBDefaults
		Nurfed2:Print("Nurfed2:  Setting Up Default Values For This Character.")
	end
	SetupDefaultN2Settings()			
	Nurfed2:AddSlash(Nurfed2_ToggleOptions, "/n2", "/nurfed2")
	Nurfed2:AddSlash(function() Nurfed2DB = nil; ReloadUI(); end, "/n2reset")
	Nurfed2:AddSlash(function() Nurfed2DB.UnitFrames = nil; ReloadUI(); end, "/n2ufreset")
end
Nurfed2:RegEvent("VARIABLES_LOADED", N2_OnLoad)
Nurfed2:RegEvent("ACTIVE_TALENT_GROUP_CHANGED", N2TalentChanged)
_G.IsNurfed2Loaded = true


function debug(...)
	if not AceLibrary and not Rock and not LibStub then return end
	local frame = ChatFrame3 or ChatFrame2
	if AceLibrary and AceLibrary:HasInstance("AceConsole-2.0") then
		AceLibrary("AceConsole-2.0"):CustomPrint(nil, nil, nil, frame, nil, true, ...)
	elseif Rock and Rock:HasLibrary("LibRockConsole-1.0") then
		Rock("LibRockConsole-1.0"):CustomPrint(nil, nil, nil, frame, nil, true, ...)
	else
		LibStub("AceConsole-3.0"):Print(frame, ...)
	end
end

function shitfuck()
Nurfed2DB = {
    ["Core"] = {
        ["MinimapLoc"] = {
            "CENTER", -- [1]
        },
        ["AutoSell"] = true,
        ["AutoInvite"] = {
            ["GuildRank"] = false,
            ["GuildOnly"] = true,
            ["GuildRankList"] = {
            },
            ["Enable"] = true,
            ["Keyword"] = "invite",
        },
        ["RaidMode"] = {
            ["NoInviteOfficerNote"] = "",
            ["InviteOfficerNote"] = "",
            ["GuildRankList"] = {
            },
        },
        ["AutoRepair"] = true,
        ["RepairLimit"] = 100,
        ["DoNotSell"] = {
        },
    },
    ["MultiSpecSettings"] = {
        {
            ["Bindings"] = {
                ["Macro"] = {
                },
                ["Spell"] = {
                    ["Guardian Spirit"] = "SHIFT-G",
                },
                ["Item"] = {
                },
                ["Click"] = {
                },
            },
        }, -- [1]
        {
            ["Bindings"] = {
                ["Macro"] = {
                },
                ["Spell"] = {
                    ["Divine Hymn"] = "ALT-X",
                    ["Pain Suppression"] = "SHIFT-G",
                    ["Penance"] = "E",
                    ["Abolish Disease"] = "SHIFT-Q",
                },
                ["Item"] = {
                },
                ["Click"] = {
                    ["Nurfed2_Button9"] = "ALT-T",
                    ["Nurfed2_Button2"] = "2",
                    ["Nurfed2_Button8"] = "SHIFT-V",
                    ["Nurfed2_Button5"] = "1",
                },
            },
        }, -- [2]
    },
    ["Bindings"] = {
        ["Macro"] = {
        },
        ["Spell"] = {
            ["Guardian Spirit"] = "SHIFT-G",
        },
        ["Item"] = {
        },
        ["Click"] = {
        },
    },
    ["MultiSpec"] = {
        ["Core"] = false,
        ["SpellSettings"] = false,
        ["Bindings"] = true,
        ["BarConfig"] = false,
        ["OtherMods"] = {
        },
    },
}
end