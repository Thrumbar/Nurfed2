--[[
	The point of these files are to create a module version of Nurfed, to enable people to plugin easily, while
	keeping the small size of the UI Package.  This also allows for users to pick and choose how they want to configure
	and use Nurfed.
	
	Nurfed Spell Alert is a replacement for Nurfed_CombatLog.
	Nurfed_CombatLog has been discontinued as of Nurfed2 Release.
]]
assert(Nurfed2, "Nurfed2 is required to be installed and enabled for Nurfed2 SpellAlert to work")

local _G = getfenv(0)
-- upvalue commonly used functionsw
local bitband = _G.bit.band
local SPELLCASTGOOTHER = "%s casts %s."
local AURAADDEDOTHERHELPFUL = "%s gains %s."
local COMBATLOG_OBJECT_REACTION_HOSTILE = _G.COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER
local UnitExists = _G.UnitExists
local UnitIsPlayer = _G.UnitIsPlayer
local UnitCanAttack = _G.UnitCanAttack
local UnitName = _G.UnitName
local options, UpdateSettings, msg, frame, spFrame, bFrame
local classLst, eventLst = {}, {}
local eventLst = { ["SPELL_CAST_SUCCESS"] = true, ["SPELL_CAST_START"] = true, ["SPELL_AURA_APPLIED"] = true, }

-- Default Settings!
local defaultSettings = {
	["ShowIcons"] = true,
	["ShowText"] = true,
	["ColorSpells"] = true,
	["ClassColor"] = true,
	["FilterSpells"] = { },
	["FilterApplied"] = { },
	["ZoneFilter"] = { },
	["SpellFrame"] = {
		Enabled = true,
		Height = 90,
		Width = UIParent:GetWidth(),
		InsertMode = "TOP",
		VisibleTime = 1,
		Font = "Fonts\\ARIALN.TTF",
		FadeDuration = 0.5,
		FontHeight = 18,
		FontStyle = "OUTLINE",
		FontJustifyH = "CENTER",
		Position = { "CENTER" },
	},
	["BuffFrame"] = {
		Enabled = true,
		Height = 90,
		Width = UIParent:GetWidth(),
		InsertMode = "TOP",
		VisibleTime = 1,
		Font = "Fonts\\ARIALN.TTF",
		FadeDuration = 0.5,
		FontHeight = 18,
		FontStyle = "OUTLINE",
		FontJustifyH = "CENTER",
		Position = { "CENTER" },
	},
}
local function getOpt(info)
	return Nurfed2DB["SpellAlert"][info[#info-1]][info[#info]]
end

local function setOpt(info, val)
	--Nurfed2DB["SpellAlert"][info[#info]] = val or nil
	Nurfed2DB["SpellAlert"][info[#info-1]][info[#info]] = val or false
	UpdateSettings()
end

options = {
	type = "group",
	order = 2,
	get = getOpt,
	set = setOpt,
	args = {
		["SpellAlert"] = {
			type = "group",
			name = "Spell Alert",
			childGroups = "tab",
			args = {
				text = {
					type = "description",
					name = "Spell Alert Settings",
					order = 0,
				},
				General = {
					type = "group",
					name = "General",
					order = 1,
					get = function(info)
						return Nurfed2DB.SpellAlert[info[#info]]
					end,
					set = function(info, val)
						Nurfed2DB.SpellAlert[info[#info]] = val
						UpdateSettings()
					end,
					args = {
						ShowIcons = {
							type = "toggle",
							name = "Show Icons",
							desc = "Show spell icons.",
						},
						ShowText = {
							type = 'toggle',
							name = 'Show Text',
							desc = 'Show extra vanity text with spells.',
						},
						ColorSpells = {
							type = 'toggle',
							name = 'Color Spells',
							desc = 'Color spell names by spell class type',
						},
						ClassColor = {
							type = 'toggle',
							name = 'Class Colors',
							desc = 'Color players names by class color',
						},
					},
				},
				SpellFrame = {
					type = "group",
					name = "Cast",
					disabled = function(info)
						if info[#info] ~= "Enabled" and info[#info] ~= "SpellFrame" then
							return not Nurfed2DB.SpellAlert.SpellFrame["Enabled"]
						end
						return false
					end,
					args = {
						Enabled = {
							type = "toggle",
							name = "Enable",
							desc = "Enable the cast frame.",
							order = 0,
						},
						Test = {
							type = "execute",
							name = "Test",
							desc = "Test the frame!",
							order = 1,
							func = function()
								spFrame:AddMessage("HI! Welcome to Nurfed2! - Tivoli, Apoco")
							end,
						},
						Height = {
							type = "range",
							name = "Height",
							desc = "Height of the cast frame.",
							min = 10,
							max = 250,
						},
						Width = {
							type = "range",
							name = "Width",
							desc = "Width of the cast frame.",
							min = 125,
							max = 3000,
							step = 50,
						},
						InsertMode = {
							type = "select",
							name = "Insert Mode",
							desc = "Where do you want the text to be inserted when shown?",
							values = {
								["TOP"] = "Top",
								["BOTTOM"] = "Bottom",
							},
						},
						VisibleTime = {
							type = "range",
							name = "Visible Time",
							desc = "How long do you want the text to be shown before it fades away?",
							min = 0,
							max = 25,
						},
						Font = {
							type = "select",
							name = "Font",
							desc = "What font do you want to use?",
							values = {
							},
							disabled = true,
						},
						FontHeight = {
							type = "range",
							name = "Font Height",
							desc = "How big do you want your text to be?",
							min = 6,
							max = 36,
						},
						FontStyle = {
							type = "select",
							name = "Font Style",
							desc = "Do you want the text to have any extra added effects?",
							values = {
								["OUTLINE"] = "Outline",
							},
						},
						FontJustifyH = {
							type = "select",
							name = "Font Justification",
							desc = "What side of the frame do you want the text to be aligned too?",
							values = {
								["LEFT"] = "Left",
								["RIGHT"] = "Right",
								["CENTER"] = "Center",
							},
						},
						FadeDuration = {
							type = "range",
							name = "Fade Duration",
							desc = "How long do you want the text to fade before disappearing?",
							min = 0,
							max = 50,
						},
						FilterInput = {
							type = "input",
							name = "Filter Spells",
							desc = "Type a spell name to filter it",
							get = function() return "" end,
							set = function(info, val)
								Nurfed2DB.SpellAlert.FilterSpells[val] = true
							end,
							width = "double",
							order = 1000,
						},
						FilterList = {
							type = "select",
							name = "Filter List",
							desc = "Click a name to remove it.",
							values = function()
								local t = {}
								for name in pairs(Nurfed2DB.SpellAlert.FilterSpells) do
									t[name] = name;
								end
								return t
							end,
							get = function() return true end,
							set = function(info, val)
								Nurfed2DB.SpellAlert.FilterSpells[val] = nil
							end,
							order = -1,
							width = "double",
						},
					},
				},
				BuffFrame = {
					type = "group",
					name = "Buffs",
					disabled = function(info)
						if info[#info] ~= "Enabled" and info[#info] ~= "BuffFrame" then
							return not Nurfed2DB.SpellAlert.BuffFrame["Enabled"]
						end
						return false
					end,
					args = {
						Enabled = {
							type = "toggle",
							name = "Enable",
							desc = "Enable the cast frame.",
							order = 0,
						},
						Test = {
							type = "execute",
							name = "Test",
							desc = "Test the frame!",
							order = 1,
							func = function()
								bFrame:AddMessage("HI! Welcome to Nurfed2! - Tivoli, Apoco")
							end,
						},
						Height = {
							type = "range",
							name = "Height",
							desc = "Height of the cast frame.",
							min = 10,
							max = 250,
						},
						Width = {
							type = "range",
							name = "Width",
							desc = "Width of the cast frame.",
							min = 125,
							max = 3000,
							step = 50,
						},
						InsertMode = {
							type = "select",
							name = "Insert Mode",
							desc = "Where do you want the text to be inserted when shown?",
							values = {
								["TOP"] = "Top",
								["BOTTOM"] = "Bottom",
							},
						},
						VisibleTime = {
							type = "range",
							name = "Visible Time",
							desc = "How long do you want the text to be shown before it fades away?",
							min = 0,
							max = 25,
						},
						Font = {
							type = "select",
							name = "Font",
							desc = "What font do you want to use?",
							values = {
							},
							disabled = true,
						},
						FontHeight = {
							type = "range",
							name = "Font Height",
							desc = "How big do you want your text to be?",
							min = 6,
							max = 36,
						},
						FontStyle = {
							type = "select",
							name = "Font Style",
							desc = "Do you want the text to have any extra added effects?",
							values = {
								["OUTLINE"] = "Outline",
							},
						},
						FontJustifyH = {
							type = "select",
							name = "Font Justification",
							desc = "What side of the frame do you want the text to be aligned too?",
							values = {
								["LEFT"] = "Left",
								["RIGHT"] = "Right",
								["CENTER"] = "Center",
							},
						},
						FadeDuration = {
							type = "range",
							name = "Fade Duration",
							desc = "How long do you want the text to fade before disappearing?",
							min = 0,
							max = 50,
						},
						FilterInput = {
							type = "input",
							name = "Filter Buffs",
							desc = "Type a spell name to filter it",
							get = function() return "" end,
							set = function(info, val)
								Nurfed2DB.SpellAlert.FilterApplied[val] = true
							end,
							width = "double",
							order = 1000,
						},
						FilterList = {
							type = "select",
							name = "Filter List",
							desc = "Click a name to remove it.",
							values = function()
								local t = {}
								for name in pairs(Nurfed2DB.SpellAlert.FilterApplied) do
									t[name] = name;
								end
								return t
							end,
							get = function() return true end,
							set = function(info, val)
								Nurfed2DB.SpellAlert.FilterApplied[val] = nil
							end,
							order = -1,
							width = "double",
						},
					},
				},
			},
		},
	},
}

-- OnEvent Function
--------------------------------------------------
local msg = ""
local function SpellAlert_OnEvent(_, _, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, id, spellName, spellSchool, spellType, spellName2)
	-- do not run for non-wanted sub events.\/
	if not eventLst[event] then return end
	
	if event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_START" then	-- both use source
		if bitband(COMBATLOG_OBJECT_REACTION_HOSTILE, srcFlags) == 0 or bitband(COMBATLOG_OBJECT_CONTROL_PLAYER, srcFlags) == 0 then return end

		if Nurfed2DB.SpellAlert.FilterSpells[spellName] then return end
		if Nurfed2DB.SpellAlert.ClassColor and classLst[srcName] then
			srcName = classLst[srcName]..srcName.."|r"
		end
		if Nurfed2DB.SpellAlert.ColorSpells then
			spellName = "|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r"
		end
		if Nurfed2DB.SpellAlert.ShowIcons then
			msg = "|T"..select(3, GetSpellInfo(id))..":24:24:-5|t"
		end
		if Nurfed2DB.SpellAlert.ShowText then
			msg = msg..(SPELLCASTGOOTHER):format(srcName, spellName)
		else
			msg = msg.." "..srcName.." - "..spellName
		end
		frame = spFrame
		
	elseif event == "SPELL_AURA_APPLIED" then
		if spellType ~= "BUFF" then	return end
		if bitband(COMBATLOG_OBJECT_REACTION_HOSTILE, dstFlags) == 0 or bitband(COMBATLOG_OBJECT_CONTROL_PLAYER, dstFlags) == 0 then return end

		if Nurfed2DB.SpellAlert.FilterApplied[spellName] then return end
		if Nurfed2DB.SpellAlert.ClassColor and classLst[dstName] then
			dstName = classLst[dstName]..dstName.."|r"
		end
		if Nurfed2DB.SpellAlert.ColorSpells then
			spellName = "|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r"
		end
		if Nurfed2DB.SpellAlert.ShowIcons then
			msg = "|T"..select(3, GetSpellInfo(id))..":24:24:-5|t"
		end
		if Nurfed2DB.SpellAlert.ShowText then
			msg = msg..(AURAADDEDOTHERHELPFUL):format(dstName, spellName)
		else
			msg = msg.." "..dstName.." - "..spellName
		end
		frame = bFrame
	end
	frame:AddMessage(msg)
	msg = ""
end

-- OnZone Change Function
--------------------------------------------------
local function ZoneChange()
	if Nurfed2DB.SpellAlert.EnableInCombatOnly then return end
	if GetZonePVPInfo() == "sanctuary" or (Nurfed2DB.SpellAlert.ZoneFilter[GetRealZoneText()] or Nurfed2DB.SpellAlert.ZoneFilter[GetMinimapZoneText()]) then
		Nurfed2:UnregEvent("COMBAT_LOG_EVENT_UNFILTERED", SpellAlert_OnEvent)
		return
	end
	Nurfed2:RegEvent("COMBAT_LOG_EVENT_UNFILTERED", SpellAlert_OnEvent)
end

-- Name Color Functions
--------------------------------------------------
local unitLst = {
	[1] = "mouseover",
	[2] = "target",
	[3] = "focus",
}

local function UpdateNameList()
	for _, unit in ipairs(unitLst) do
		if UnitExists(unit) and UnitIsPlayer(unit) and UnitCanAttack("player", unit) then
			local name = UnitName(unit)
			if name and not classLst[name] then
				classLst[name] = RAID_CLASS_COLORS[select(2, UnitClass(unit))].hex
				name = nil
				break
			end
		end
	end
end

-- Update Settings Function
--------------------------------------------------
UpdateSettings = function()
	spFrame:SetWidth(Nurfed2DB.SpellAlert.SpellFrame.Width)
	spFrame:SetHeight(Nurfed2DB.SpellAlert.SpellFrame.Height)
	spFrame:SetInsertMode(Nurfed2DB.SpellAlert.SpellFrame.InsertMode)
	spFrame:SetTimeVisible(Nurfed2DB.SpellAlert.SpellFrame.VisibleTime)
	spFrame:SetFadeDuration(Nurfed2DB.SpellAlert.SpellFrame.FadeDuration)
	spFrame:SetFont(Nurfed2DB.SpellAlert.SpellFrame.Font, Nurfed2DB.SpellAlert.SpellFrame.FontHeight, Nurfed2DB.SpellAlert.SpellFrame.FontStyle)
	spFrame:SetJustifyH(Nurfed2DB.SpellAlert.SpellFrame.FontJustifyH)
	spFrame.Anchor:SetPoint(unpack(Nurfed2DB.SpellAlert.SpellFrame.Position))
	eventLst["SPELL_CAST_SUCCESS"] = Nurfed2DB.SpellAlert.SpellFrame.Enabled
	eventLst["SPELL_CAST_START"] = Nurfed2DB.SpellAlert.SpellFrame.Enabled

	bFrame:SetWidth(Nurfed2DB.SpellAlert.BuffFrame.Width)
	bFrame:SetHeight(Nurfed2DB.SpellAlert.BuffFrame.Height)
	bFrame:SetInsertMode(Nurfed2DB.SpellAlert.BuffFrame.InsertMode)
	bFrame:SetTimeVisible(Nurfed2DB.SpellAlert.BuffFrame.VisibleTime)
	bFrame:SetFadeDuration(Nurfed2DB.SpellAlert.BuffFrame.FadeDuration)
	bFrame:SetFont(Nurfed2DB.SpellAlert.BuffFrame.Font, Nurfed2DB.SpellAlert.BuffFrame.FontHeight, Nurfed2DB.SpellAlert.BuffFrame.FontStyle)
	bFrame:SetJustifyH(Nurfed2DB.SpellAlert.BuffFrame.FontJustifyH)
	bFrame.Anchor:SetPoint(unpack(Nurfed2DB.SpellAlert.BuffFrame.Position))
	eventLst["SPELL_AURA_APPLIED"] = Nurfed2DB.SpellAlert.BuffFrame.Enabled
end
-- OnLoad Function
--------------------------------------------------
local function OptionsLoaded()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Nurfed 2 Spell Alert", options)
	Nurfed2.optionsFrames.SpellAlert = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Nurfed 2 Spell Alert", "Spell Alert", "Nurfed 2", "SpellAlert")
end

local function OnLoad()
	Nurfed2:FeedDefaultSettings("SpellAlert", defaultSettings)
	Nurfed2:RegEvent("PLAYER_LOGIN", ZoneChange)
	Nurfed2:RegEvent("ZONE_CHANGED_NEW_AREA", ZoneChange)
	Nurfed2:RegEvent("PLAYER_TARGET_CHANGED", UpdateNameList)
	Nurfed2:RegEvent("PLAYER_FOCUS_CHANGED", UpdateNameList)
	Nurfed2:RegEvent("UPDATE_MOUSEOVER_UNIT", UpdateNameList)
	
	-- Create The Frames
	-- Spell Alert Frame
	spFrame = CreateFrame("MessageFrame", "Nurfed2_SpellAlert", UIParent)
	spFrame.Anchor = Nurfed2:CreateHandle(nil, "Spell Alert")
	Nurfed2:RegisterLock(spFrame.Anchor)
	
	spFrame:SetFrameStrata("HIGH")
	spFrame:SetPoint("TOP", spFrame.Anchor, "BOTTOM", 0, -2)
	spFrame.Anchor:SetPoint(unpack(Nurfed2DB.SpellAlert.SpellFrame.Position))
	
	spFrame.Grid = CreateFrame("Frame", nil, UIParent)
	spFrame.Grid:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
	spFrame.Grid:SetBackdropColor(0, 0, 0, 0.25)
	spFrame.Grid:SetAllPoints(spFrame)
	spFrame.Grid:Hide()
	Nurfed2:RegisterLock(spFrame.Grid)
	
	-- Buff Alert Frame
	bFrame = CreateFrame("MessageFrame", "Nurfed2_BuffAlert", UIParent)
	bFrame.Anchor = Nurfed2:CreateHandle(nil, "Buff Alert")
	Nurfed2:RegisterLock(bFrame.Anchor)
	
	bFrame:SetFrameStrata("HIGH")
	bFrame:SetPoint("TOP", bFrame.Anchor, "BOTTOM", 0, -2)
	bFrame.Anchor:SetPoint(unpack(Nurfed2DB.SpellAlert.BuffFrame.Position))
	
	bFrame.Grid = CreateFrame("Frame", nil, UIParent)
	bFrame.Grid:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
	bFrame.Grid:SetBackdropColor(0, 0, 0, 0.25)
	bFrame.Grid:SetAllPoints(bFrame)
	bFrame.Grid:Hide()
	Nurfed2:RegisterLock(bFrame.Grid)
	
	UpdateSettings()
	Nurfed2:RegEvent("N2_OPTIONS_LOADED", OptionsLoaded)
	Nurfed2:RegEvent("N2_SETTINGS_UPDATE", UpdateSettings)
	Nurfed2:RegEvent("N2_LOCK_STATUS_UPDATE", function()
		if Nurfed2:IsLocked() then
			local p1, p2, p3, p4, p5 = bFrame.Anchor:GetPoint()
			if (p1 and p3 and p4 and p5) then
				p2 = p2 or UIParent
				if type(p2) == "table" then
					p2 = p2:GetName()
				end
				Nurfed2DB.SpellAlert.BuffFrame.Position = { p1, p2, p3, p4, p5 }
			end
			
			p1, p2, p3, p4, p5 = nil, nil, nil, nil, nil
			p1, p2, p3, p4, p5 = spFrame.Anchor:GetPoint()
			if (p1 and p3 and p4 and p5) then
				p2 = p2 or UIParent
				if type(p2) == "table" then
					p2 = p2:GetName()
				end
				Nurfed2DB.SpellAlert.SpellFrame.Position = { p1, p2, p3, p4, p5 }
			end
		end
	end)
end

OnLoad()