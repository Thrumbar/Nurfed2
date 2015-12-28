local AceGUI = LibStub("AceGUI-3.0")

--------------------------
-- Keybinding  		    --
--------------------------
-- macro box

do
	local Type = "Macro_EditBox"
	local Version = 2
	local PREDICTION_ROWS = 10
	local totalSpellsLoaded, spellLoader = 0
	local spells, indexedSpells, visiblePredicters = {}, {}, {}
	
	-- Defined blew
	local searchSpells
	
	-- Spells have to gradually be loaded in to prevent the client from lagging, this starts as soon as one widget is shown
	-- as of 3.1 the spellID goes up to ~66,000 which means it'll take around 5 - 10 seconds for it to load them all
	-- Given users have to actually move the mouse, type what they want etc
	-- it should result in them not noticing it does not have all the spell data yet
	local function startLoading()
		if( spellLoader ) then return end

		spellLoader = CreateFrame("Frame")
		spellLoader.timeElapsed = 0
		spellLoader.totalInvalid = 0
		spellLoader.index = 0
		spellLoader:SetScript("OnUpdate", function(self, elapsed)
			self.timeElapsed = self.timeElapsed + elapsed
			if( self.timeElapsed < 0.10 ) then return end
			self.timeElapsed = self.timeElapsed - 0.10

			-- Too many invalid spells found will assume we found all there is that we can
			if( self.totalInvalid >= 5000 ) then
				self:Hide()
				return
			end

			-- Load as many spells in
			
			local spellsLoaded = totalSpellsLoaded
--			for i=spellLoader.index + 1, spellLoader.index + 500 do
				--[[
				for tab = 1, GetNumSpellTabs() do
					local _, _, offset, numSpells = GetSpellTabInfo(tab)
					for k = 1, numSpells do
						spell = offset + k
						if not IsPassiveSpell(spell, BOOKTYPE_SPELL) then
							local spellName, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
							local spellID = GetSpellLink(spell, BOOKTYPE_SPELL):match("spell:(%d+)")
							spellName = string.lower(spellName)
							
							if( not spells[spellName] ) then
								spells[spellName] = spellID
								table.insert(indexedSpells, spellName)
								
								totalSpellsLoaded = totalSpellsLoaded + 1
							end
						end
					end
				end
				]]
				local all, char, name, texture
				all, char = GetNumMacros()
				for i = 1, all do
					name, texture = GetMacroInfo(i)
					name = string.lower(name)
					if not spells[name] then
						spells[name] = i
						table.insert(indexedSpells, name)
						
						totalSpellsLoaded = totalSpellsLoaded + 1
					end
				end
				
				name, texture = nil, nil
				for i = 37, char + 36 do
					name, texture = GetMacroInfo(i)
					name = string.lower(name)
					if not spells[name] then
						spells[name] = i
						table.insert(indexedSpells, name)
						
						totalSpellsLoaded = totalSpellsLoaded + 1
					end
				end
--			end
			--[[
			for i=spellLoader.index + 1, spellLoader.index + 500 do
				local name, _, icon = GetSpellInfo(i)
				
				-- The majority of spells that use the engineer gear icon are actually invalid spells that we can easily ignore
				-- since there are ~12000 not counting duplicate names that use this icon it's worthwhile to filter out these spells
				self.totalInvalid = self.totalInvalid + 1
				if( name and icon ~= "Interface\\Icons\\Trade_Engineering" ) then
					name = string.lower(name)
					
					if( not spells[name] ) then
						spells[string.lower(name)] = i
						table.insert(indexedSpells, name)
						
						totalSpellsLoaded = totalSpellsLoaded + 1
						self.totalInvalid = 0
					end
				end
			end
			]]
			-- Every ~1 second it will update any visible predicters to make up for the fact that the data is delay loaded
			if( spellLoader.index % 5000 == 0 ) then
				for predicter in pairs(visiblePredicters) do
					searchSpells(predicter, predicter.lastQuery)
				end
			end
						
			-- Increment and do it all over!
			spellLoader.index = spellLoader.index + 500
		end)
	end

	-- Search for spells quickly
	searchSpells = function(self, query)
		for _, button in pairs(self.buttons) do button:Hide() end

		local usedButtons = 0
		for i=1, totalSpellsLoaded do
			local name = indexedSpells[i]
			if( string.match(name, query) ) then
				usedButtons = usedButtons + 1

				local spellName, spellIcon = GetMacroInfo(spells[name])
				local button = self.buttons[usedButtons]
				button.spellID = spells[name]
				button:SetFormattedText("|T%s:20:20:2:11|t %s", spellIcon, spellName)
				button:Show()
				
				if( usedButtons ~= self.selectedButton ) then
					button:UnlockHighlight()

					if( GameTooltip:IsOwned(button) ) then
						GameTooltip:Hide()
					end
				end
				
				-- Ran out of text to suggest :<
				if( usedButtons >= PREDICTION_ROWS ) then break end
			end
		end
		
		if( usedButtons > 0 ) then
			self:SetHeight(15 + usedButtons * 17)
			self:Show()
		else
			self:Hide()
		end
		
		self.lastQuery = query
		self.usedButtons = usedButtons
	end
	
	local function OnAcquire(self)
		self:SetHeight(26)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetLabel()
		self.showbutton = true
	end
	
	local function OnRelease(self)
		self.frame:ClearAllPoints()
		self.frame:Hide()
		self.predictFrame:Hide()

		self:SetDisabled(false)
	end
			
	local function Control_OnEnter(this)
		this.obj:Fire("OnEnter")
	end
	
	local function Control_OnLeave(this)
		this.obj:Fire("OnLeave")
	end
		
	local function EditBox_OnEscapePressed(this)
		this:ClearFocus()
	end
		
	local function ShowButton(self)
		if( self.lasttext ~= "" ) then
			self.editbox.predictFrame.selectedButton = nil
			searchSpells(self.editbox.predictFrame, "^" .. string.lower(self.lasttext))
		else
			self.editbox.predictFrame:Hide()
		end
			
		if( self.showbutton ) then
			self.button:Show()
			self.editbox:SetTextInsets(0,20,3,3)
		end
	end
	
	local function HideButton(self)
		self.button:Hide()
		self.editbox:SetTextInsets(0,0,3,3)
		self.editbox.predictFrame:Hide()
	end
	
	local function EditBox_OnEnterPressed(this)
		if( this.predictFrame.selectedButton ) then
			this.predictFrame.buttons[this.predictFrame.selectedButton]:Click()
			this.predictFrame.selectedButton = nil
			return
		end
	
		local self = this.obj
		local value = this:GetText()
		local cancel = self:Fire("OnEnterPressed", value)
		if( not cancel ) then
			HideButton(self)
		end

		-- Reactivate the cursor, odds are if you're adding auras you're adding multiple auras
		self.editbox:SetFocus()
	end
	
	local function Button_OnClick(this)
		local editbox = this.obj.editbox
		
		editbox:ClearFocus()
		EditBox_OnEnterPressed(editbox)
	end

	local function Predicter_OnHide(self)
		-- Allow users to use arrows to go back and forth again without the fix
		self.editbox:SetAltArrowKeyMode(false)

		visiblePredicters[self] = nil
		
		ClearOverrideBindings(self)
	end

	local function Predicter_OnShow(self)
		-- I'm pretty sure this is completely against what you are supposed to actually do :>
		visiblePredicters[self] = true
		
		-- User doesn't need arrow keys, and by doing this the override binding for up/down arrows will work properly
		self.editbox:SetAltArrowKeyMode(true)
		
		SetOverrideBindingClick(self, true, "DOWN", self:GetName(), 1)
		SetOverrideBindingClick(self, true, "UP", self:GetName(), -1)
		SetOverrideBindingClick(self, true, "LEFT", self:GetName(), "LEFT")
		SetOverrideBindingClick(self, true, "RIGHT", self:GetName(), "RIGHT")
	end

	-- When using SetAltArrowKeyMode the ability to move the cursor with left and right is disabled, this reenables that
	-- since the cursor position automatically can't go below 0, this is a quick and easy fix
	local function EditBox_FixCursorPosition(self, direction)
		self:SetCursorPosition(self:GetCursorPosition() + (direction == "RIGHT" and 1 or -1))
	end
	
	local function EditBox_OnReceiveDrag(this)
		local self = this.obj
		local type, id, info = GetCursorInfo()
		if( type == "spell" ) then
			local name = GetSpellName(id, info)
			self:SetText(name)
			self:Fire("OnEnterPressed" ,name)
			ClearCursor()
		end
		HideButton(self)
		AceGUI:ClearFocus()
	end
	
	local function EditBox_OnTextChanged(this)
		local self = this.obj
		local value = this:GetText()
		if( value ~= self.lasttext ) then
			self:Fire("OnTextChanged", value)
			self.lasttext = value
			ShowButton(self)
		end
	end

	local function EditBox_OnEditFocusLost(self)
		Predicter_OnHide(self.predictFrame)
	end
	
	local function EditBox_OnEditFocusGained(self)
		if( self.predictFrame:IsVisible() ) then
			Predicter_OnShow(self.predictFrame)
		end
	end
	
	local function SetDisabled(self, disabled)
		self.disabled = disabled
		if( disabled ) then
			self.editbox:EnableMouse(false)
			self.editbox:ClearFocus()
			self.editbox:SetTextColor(0.5, 0.5, 0.5)
			self.label:SetTextColor(0.5, 0.5, 0.5)
		else
			self.editbox:EnableMouse(true)
			self.editbox:SetTextColor(1, 1, 1)
			self.label:SetTextColor(1, 0.82, 0)
		end
	end
	
	local function SetText(self, text, cursor)
		self.lasttext = text or ""
		self.editbox:SetText(self.lasttext)
		self.editbox:SetCursorPosition(cursor or 0)

		HideButton(self)
	end
	
	local function SetLabel(self, text)
		if( text and text ~= "" ) then
			self.label:SetText(text)
			self.label:Show()
			self.editbox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, -18)
			self:SetHeight(44)
			self.alignoffset = 30
		else
			self.label:SetText("")
			self.label:Hide()
			self.editbox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, 0)
			self:SetHeight(26)
			self.alignoffset = 12
		end
	end
	
	local function Predicter_OnMouseDown(self, direction)
		if( direction == "LEFT" or direction == "RIGHT" ) then
			EditBox_FixCursorPosition(self.editbox, direction)
			return
		end
		
		self.selectedButton = (self.selectedButton or 0) + direction
		if( self.selectedButton > self.usedButtons ) then
			self.selectedButton = 1
		elseif( self.selectedButton <= 0 ) then
			self.selectedButton = self.usedButtons
		end
		
		for i=1, self.usedButtons do
			local button = self.buttons[i]
			if( i == self.selectedButton ) then
				button:LockHighlight()
				
				GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT")
				GameTooltip:SetHyperlink("spell:" .. button.spellID)
			else
				button:UnlockHighlight()
				
				if( GameTooltip:IsOwned(button) ) then
					GameTooltip:Hide()
				end
			end
		end
	end
				
	local function Spell_OnClick(self)
		local name = GetMacroInfo(self.spellID)
		
		SetText(self.parent.obj, name, string.len(name))
		self.parent.obj:Fire("OnEnterPressed", name)
	end
	
	local function Spell_OnEnter(self)
		self.parent.selectedButton = nil
		self:LockHighlight()
		
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetHyperlink("spell:" .. self.spellID)
	end
	
	local function Spell_OnLeave(self)
		self:UnlockHighlight()
		GameTooltip:Hide()
	end

	local predicterBackdrop = {
	  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	  edgeSize = 26,
	  insets = {left = 9, right = 9, top = 9, bottom = 9},
	}

	local function Constructor()
		local num  = AceGUI:GetNextWidgetNum(Type)
		local frame = CreateFrame("Frame", nil, UIParent)
		local editbox = CreateFrame("EditBox", "AceGUI30MacroEditBox" .. num, frame, "InputBoxTemplate")
	
		-- Don't feel like looking up the specific callbacks for when a widget resizes, so going to be creative with SetPoint instead!
		local predictFrame = CreateFrame("Frame", "AceGUI30MacroEditBox" .. num .. "Predicter", UIParent)
		predictFrame:SetBackdrop(predicterBackdrop)
		predictFrame:SetBackdropColor(0, 0, 0, 0.85)
		predictFrame:SetWidth(1)
		predictFrame:SetHeight(150)
		predictFrame:SetPoint("TOPLEFT", editbox, "BOTTOMLEFT", -6, 0)
		predictFrame:SetPoint("TOPRIGHT", editbox, "BOTTOMRIGHT", 0, 0)
		predictFrame:SetFrameStrata("TOOLTIP")
		predictFrame:Hide()
		
		predictFrame.buttons = {}

		for i=1, PREDICTION_ROWS do
			local button = CreateFrame("Button", nil, predictFrame)
			button:SetHeight(17)
			button:SetWidth(1)
			button:SetPushedTextOffset(-2, 0)
			button:SetScript("OnClick", Spell_OnClick)
			button:SetScript("OnEnter", Spell_OnEnter)
			button:SetScript("OnLeave", Spell_OnLeave)
			button.parent = predictFrame
			button.editbox = editbox
			button:Hide()
			
			if( i > 1 ) then
				button:SetPoint("TOPLEFT", predictFrame.buttons[i - 1], "BOTTOMLEFT", 0, 0)
				button:SetPoint("TOPRIGHT", predictFrame.buttons[i - 1], "BOTTOMRIGHT", 0, 0)
			else
				button:SetPoint("TOPLEFT", predictFrame, 8, -8)
				button:SetPoint("TOPRIGHT", predictFrame, -7, 0)
			end

			-- Create the actual text
			local text = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text:SetHeight(1)
			text:SetWidth(1)
			text:SetJustifyH("LEFT")
			text:SetAllPoints(button)
			button:SetFontString(text)

			-- Setup the highlighting
			local texture = button:CreateTexture(nil, "ARTWORK")
			texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			texture:ClearAllPoints()
			texture:SetPoint("TOPLEFT", button, 0, -2)
			texture:SetPoint("BOTTOMRIGHT", button, 5, 2)
			texture:SetAlpha(0.70)

			button:SetHighlightTexture(texture)
			button:SetHighlightFontObject(GameFontHighlight)
			button:SetNormalFontObject(GameFontNormal)
			
			table.insert(predictFrame.buttons, button)
		end		

		local self = {}
		self.type = Type
		self.num = num

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire

		self.SetDisabled = SetDisabled
		self.SetText = SetText
		self.SetLabel = SetLabel
		
		frame.obj = self
		self.frame = frame

		editbox.obj = self
		editbox.predictFrame = predictFrame
		self.editbox = editbox

		self.predictFrame = predictFrame
		predictFrame.editbox = editbox
		predictFrame.obj = self
		
		self.alignoffset = 30
		
		frame:SetHeight(44)
		frame:SetWidth(200)

		-- Despite the fact that wowprogramming/wowwiki say EditBoxes have OnKeyUp/OnKeyDown thats not actually true
		-- so doing some trickery with bindings and such to make navigation work
		predictFrame:SetScript("OnMouseDown", Predicter_OnMouseDown)
		predictFrame:SetScript("OnHide", Predicter_OnHide)
		predictFrame:SetScript("OnShow", Predicter_OnShow)
		
		editbox:SetScript("OnShow", startLoading)
		editbox:SetScript("OnEnter", Control_OnEnter)
		editbox:SetScript("OnLeave", Control_OnLeave)
		
		editbox:SetAutoFocus(false)
		editbox:SetFontObject(ChatFontNormal)
		editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
		editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
		editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
		editbox:SetScript("OnReceiveDrag", EditBox_OnReceiveDrag)
		editbox:SetScript("OnMouseDown", EditBox_OnReceiveDrag)
		editbox:SetScript("OnEditFocusGained", EditBox_OnEditFocusGained)
		editbox:SetScript("OnEditFocusLost", EditBox_OnEditFocusLost)

		editbox:SetTextInsets(0, 0, 3, 3)
		editbox:SetMaxLetters(256)
		
		editbox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 0)
		editbox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		editbox:SetHeight(19)
		
		local label = frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
		label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		label:SetJustifyH("LEFT")
		label:SetHeight(18)
		self.label = label
		
		local button = CreateFrame("Button",nil,editbox,"UIPanelButtonTemplate")
		button:SetWidth(40)
		button:SetHeight(20)
		button:SetPoint("RIGHT", editbox, "RIGHT", -2, 0)
		button:SetText(OKAY)
		button:SetScript("OnClick", Button_OnClick)
		button:Hide()
		
		self.button = button
		button.obj = self

		AceGUI:RegisterAsWidget(self)
		return self
	end
	
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
--

local options
local unpack = unpack
local pairs = pairs
local select = select
local next = next
local Nurfed2 = Nurfed2

local function GetOpt(info)
	if info.arg then
		if info.arg.usepname then
			return Nurfed2DB[info.arg.mod or "Core"][info[#info-1]][info[#info]]
		end
		return Nurfed2DB[info.arg.mod or "Core"][info[#info]]
	end
	return Nurfed2DB["Core"][info[#info]]
end

local function SetOpt(info, val, ...)
	if info.arg then
		if info.arg.usepname then
			Nurfed2DB[info.arg.mod or "Core"][info[#info-1]][info[#info]] = val
		else
			Nurfed2DB[info.arg.mod or "Core"][info[#info]] = val
		end
	else
		Nurfed2DB["Core"][info[#info]] = val
	end
end
	-- strip addon names
local function StripName(name)
	return name:gsub("[%c \127]", "_")
end
	-- update the registry
local function UpdateAceConfigReg()
	LibStub("AceConfigRegistry-3.0"):NotifyChange("Nurfed 2") 
end
-- addons menu functions
----------------------------------------------------
	-- get addon status
local function GetAddons(info)
	if info.option.ranChecked then
		return true
	else
		if type(info.option.ranChecked) == "boolean" then
			return false
		end
	end
	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(info.option.ranval)
	if enabled or loadable then
		info.option.ranChecked = true
		return true
	else
		info.option.ranChecked = false
		return false
	end
end
	-- set addon status
local function SetAddons(info, val)
	if info.option.ranChecked then
		DisableAddOn(info.option.ranval)
		info.option.ranChecked = false
	else
		EnableAddOn(info.option.ranval)
		info.option.ranChecked = true
	end
	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(info.option.ranval)
	if val then
		EnableAddOn(name)
	else
		DisableAddOn(name)
	end
	info.option.name = title.."      |cffff3333(ReloadUI)|r"
end
	-- create addon list
local addonList = {
	SomeOtherGreatAddon = true,
	DXE = true,
	Nurfed = true,
	Nurfed2 = "Nurfed 2",
	Nurfed3 = true,
	ButtonFacade = true,
	Quartz = true,
	FuBar = "FuBar",
	LushGearSwap = true,
	kgPanels = true,
	BigWigs = true,
	DBM = "Deadly Boss Mods",
	Combuctor = true,
	Acherus = true,
	Gatherer = true,
	Auctioneer = true,
	Overachiever = true,
	Grid = true,
	BulkMail = "Bulk Mail",
	Bagnon = "Combuctor",
	Lib = "Libraries",
	Ace3 = "Libraries",
	Ace2 = "Libraries",
	AceGUI = "Libraries",
}

local function createAddonsList()
	local order = 10
	local i = 1
	local maxnum = GetNumAddOns()
	local name, title, notes, enabled, loadable, reason, security, loadedName, strippename, isLoaded, trueOrder, frame
	while i <= maxnum do
		frame = options.args.Addons.args.GeneralGroup.args
	    name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
	    isLoaded = IsAddOnLoaded(i)
	    strippedname = StripName(name)
	    loadedName, trueOrder = nil, nil
	    local isDisabled = false
	    if name:find("^Nurfed2", 1) then
			if name == "Nurfed2_Options" or name == "Nurfed2" then
				isDisabled = true
			end
			frame = options.args.Addons.args.Nurfed2Group.args
		else
			for tname, group in pairs(addonList) do
				if name:find("^"..tname, 1) then
					if type(group) == "boolean" then
						if not options.args.Addons.args[tname.."Group"] then
							options.args.Addons.args[tname.."Group"] = {
								type = "group",
								name = name,
								order = -1,
								args = { },
							}
						end
						frame = options.args.Addons.args[tname.."Group"].args
					else
						if not options.args.Addons.args[group.."Group"] then
							options.args.Addons.args[group.."Group"] = {
								type = "group",
								name = group,
								order = -1,
								args = { },
							}
						end
						frame = options.args.Addons.args[group.."Group"].args
					end
					break
				end
			end
		end
		name = title;

	    if isLoaded then
			name = name.." |cff22ff22(Loaded)|r"
		elseif loadable then
			name = name.." |cffff4444(On Demand)|r"
		else
			name = name.." |cffff2222(".._G["ADDON_"..reason]..")|r"
		end

		if not frame[strippedname] then
			frame[strippedname] = {
				type = "toggle",
				name = name,
				desc = notes,
				width = "double",
				disabled = isDisabled,
				ranval = i,
				order = trueOrder or order,
			}
			order = order + 5
		end
		i = i + 1
	end
	UpdateAceConfigReg()
end
-- Bindings Functions
-----------------------------------------------------
-- new binding code

--------------------------
-- Keybinding  		    --
--------------------------

local function setNurfedBinding(info, key, type)
	SetBinding(key)
	for type, tbl in pairs(Nurfed2DB.Bindings) do
		for name, tkey in pairs(tbl) do
			if tkey == key then
				Nurfed2DB.Bindings[type][name] = nil
			end
		end
	end
	local spell = info.option.args.spellName
	if spell then
		getglobal("SetBinding"..type)(key, spell)
		if key == "" then
			Nurfed2DB.Bindings[type][spell] = nil
		else
			Nurfed2DB.Bindings[type][spell] = key
		end
		if type == "Click" then
			spell = spell..":LeftButton"
		end
		local old = { GetBindingKey(type.." "..spell) }
		for _, v in ipairs(old) do
			if v ~= key then
				SetBinding(v)
			end
		end
	end
	SaveBindings(GetCurrentBindingSet())
	Nurfed2:SendEvent("N2_BINDINGS_UPDATE")
end

local function createMacroBinding(info, spell)
	local frame = options.args.KeyBindings.args
	local stripName = StripName(spell)
	if not frame["macro"..stripName] then
		local name, texture = GetMacroInfo(spell)
		local tname = string.format("%s |T%s:26:26:5:0|t ", name, texture)--string.format("|T%s:20:20:2:0|t %s", texture, name)
		frame["macro"..stripName] = {
			type = "keybinding",
			name = tname,
			get = function(info, key)
				return GetBindingKey("MACRO "..info.option.args.spellName) or nil
			end,
			set = function(info, key)
				setNurfedBinding(info, key, "Macro")
			end,
			args = { spellName = name, },
			order = 202,
		}
	end
	UpdateAceConfigReg()
end

-- spell bindings
local function createSpellBinding(info, spell)
	local frame = options.args.KeyBindings.args
	local stripName = StripName(spell)
	if not frame[stripName] then
		local name, _, texture = GetSpellInfo(spell)
		local tname = string.format("%s |T%s:26:26:5:0|t ", name, texture)--string.format("|T%s:20:20:2:0|t %s", texture, name)
		frame[stripName] = {
			type = "keybinding",
			dialogControl = "Nurfed2_Keybinding",
			name = tname,
			get = function(info, key)
				return GetBindingKey("SPELL "..info.option.args.spellName) or nil
			end,
			set = function(info, key)
				setNurfedBinding(info, key, "Spell")
			end,
			args = { spellName = name, },
			order = 102,
		}
	end
	UpdateAceConfigReg()
end
local function showHideBindings()

end
local function createCurrentBindings()
	local frame = options.args.KeyBindings.args
	-- create currently bound spells;
	for tab = 1, GetNumSpellTabs() do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		for k = 1, numSpells do
			spell = offset + k
			if not IsPassiveSpell(spell, BOOKTYPE_SPELL) then
				local spellName, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
				local bind = GetBindingKey("SPELL "..spellName)
				if bind then
					local stripName = StripName(spellName)
					if not frame[stripName] then
						local name, _, texture = GetSpellInfo(spellName)
						local tname = string.format("%s |T%s:26:26:5:0|t ", name, texture)--string.format("|T%s:20:20:2:0|t %s", texture, name)
						frame[stripName] = {
							type = "keybinding",
							dialogControl = "Nurfed2_Keybinding",
							name = tname,
							get = function(info, key)
								return GetBindingKey("SPELL "..info.option.args.spellName) or nil
							end,
							set = function(info, key)
								setNurfedBinding(info, key, "Spell")
							end,
							args = {
								spellName = spellName,
							},
							order = 102,
						}
					end
				end
			end
		end
	end
	if Nurfed2DB.BarSettings and IsAddOnLoaded("Nurfed2_ActionBars") then
		for name, vals in pairs(Nurfed2DB.BarSettings) do
			if _G[name] then
				local stripName = StripName(name)
				if not frame["bar"..stripName] then
					frame["bar"..stripName] = {
						type = "group",
						inline = true,
						name = name,
						args = {},
						order = 401,
					}
				end
				
				local childlst = { _G[name]:GetChildren() }
				for i, btn in pairs(childlst) do
					if not btn:GetName():find("drag") then
						if not frame["bar"..stripName].args[btn:GetName()] then
							frame["bar"..stripName].args[btn:GetName()] = {
								type = "keybinding",
								name = "Button "..btn:GetName():match("%d+$"),
								get = function(info, key)
									return GetBindingKey("CLICK "..info.option.args.spellName..":LeftButton") or nil
								end,
								set = function(info, key)
									setNurfedBinding(info, key, "Click")
								end,
								args = {
									spellName = btn:GetName(),
								},
								order = btn:GetID(),
							}
						end
					end
				end
			end
		end
	end
			
		
	--LibStub("AceConfigRegistry-3.0"):NotifyChange("Nurfed 2")
	-- end create spells
	UpdateAceConfigReg()
end

local function createMultiSpecSettingsN2()
	local frame = options.args.MultiSpec.args.Nurfed2.args
	for name, val in pairs(Nurfed2DB["MultiSpec"]) do
		if name and name ~= "OtherMods" then
			local stripName = StripName(name)
			if not frame[stripName] then
				frame[stripName] = {
					type = "toggle",
					name = name,
					get = function(info, key)
						return Nurfed2DB["MultiSpec"][info[#info]]
					end,
					set = function(info, val)
						if val then
							Nurfed2DB["MultiSpecSettings"][1][info[#info]] = Nurfed2:copytable(Nurfed2DB[info[#info]])
							Nurfed2DB["MultiSpecSettings"][2][info[#info]] = Nurfed2:copytable(Nurfed2DB[info[#info]])
						else
							Nurfed2DB["MultiSpecSettings"][1][info[#info]] = nil
							Nurfed2DB["MultiSpecSettings"][2][info[#info]] = nil
						end
						Nurfed2DB["MultiSpec"][info[#info]] = val
					end,
					order = 100,
				}
			end
		end
	end
	UpdateAceConfigReg()
end
local function createMultiSpecSettingsOtherMods()
	local frame = options.args.MultiSpec.args.OtherMods.args
	for name, val in pairs(Nurfed2DB["MultiSpec"]["OtherMods"]) do
		if name then
			local stripName = StripName(name)
			local tname = name
			if not frame[stripName.."group"] then
				frame[stripName.."group"] = {
					type = "group",
					name = tname,
					order = 100,
					args = {
						desc = {
							type = "description",
							name = tname,
							order = 1,
						},
					},
				}
				print(frame[stripName.."group"])
			end
			tframe = options.args.MultiSpec.args.OtherMods.args[stripName.."group"]["args"]
			if not tframe[stripName] then
				tframe[stripName] = {
					type = "input",
					name = tname,
					disabled = true,
					get = function(info, key)
						return info[#info]
					end,
					set = function()	end,
					order = 100,
				}
			end
			if not tframe[stripName.."primarySpec"] then
				tframe[stripName.."primarySpec"] = {
					type = "input",
					name = "Primary Spec",
					desc = "Type the name of the profile for your Primary Spec\rTHIS IS CASE SENSITIVE!",
					width = "half",
					get = function(info, key)
						return Nurfed2DB["MultiSpec"]["OtherMods"][name][1]
					end,
					set = function(info, val)
						Nurfed2DB["MultiSpec"]["OtherMods"][name][1] = val
					end,
					order = 101,
				}
			end
			if not tframe[stripName.."secondarySpec"] then
				tframe[stripName.."secondarySpec"] = {
					type = "input",
					name = "Secondary Spec",
					desc = "Type the name of the profile for your Secondary Spec\rTHIS IS CASE SENSITIVE!",
					width = "half",
					get = function(info, key)
						return Nurfed2DB["MultiSpec"]["OtherMods"][name][2]
					end,
					set = function(info, val)
						Nurfed2DB["MultiSpec"]["OtherMods"][name][2] = val
					end,
					order = 102,
				}
			end
			if not tframe[stripName.."type"] then
				tframe[stripName.."type"] = {
					type = "select",
					name = "Type",
					values = { ["Ace3"] = "Ace3" },
					width = "half",
					get = function(info, key)
						return Nurfed2DB["MultiSpec"]["OtherMods"][name]["type"]
					end,
					set = function(info, val)
						Nurfed2DB["MultiSpec"]["OtherMods"][name]["type"] = val
					end,
					order = 104,
				}
			end
			if not tframe[stripName.."remove"] then
				tframe[stripName.."remove"] = {
					type = "execute",
					name = "Remove",
					width = "half",
					func = function()
						frame[stripName.."group"] = nil;
						Nurfed2DB["MultiSpec"]["OtherMods"][name] = nil;
					end,
					confirm = true,
					order = 105,
				}
			end
		end
	end
	UpdateAceConfigReg()
end

options = {
	type = "group",
	get = GetOpt,
	set = SetOpt,
	args = {
		indexPage = {
			type = "group",
			name = "Nurfed 2",
			order = 0,
			args = { 
				desc = { 
					type = "description",
					order = 0,
					name = function()
						-- load all the other shit here keke!
						createMultiSpecSettingsN2()
						createMultiSpecSettingsOtherMods()
						createCurrentBindings()
						return "Welcome to Nurfed 2.  \rIf you have any questions please feel free to visit us at |cffff00ffwww.nurfed.com|r"
					end,
				},
				aboutGroup = {
					type = "group",
					order = 1,
					name = "Credits",
					inline = true,
					args = {
						people1 = {
							type = "description",
							name = "|cffff00ffNurfed - Blackrock US|r\r|cffff4444Blood Legion - Illidan US|r\rTivoli - Blackrock US\rUnbalanced - Blackrock US\rCindered - Illidan US\rSlafsinator - Shattered Hand EU\rNyhm - Nessingwary US\rAll of the IRC Crew, and All of the Layout Authors.",
							order = 1,
						},
					},
				},
			},
		},
		General = {
			type = "group",
			name = "General",
			order = 1,
			args = {
				text = {
					type = "description",
					name = "General options for Nurfed that affect default UI elements and appearance.",
					order = 0,
				},
				SquareMinimap = {
					type = "toggle",
					name = "Square Minimap",
					desc = "Fixes the minimap icon positioning so that it can be used properly on square minimaps",
					order = 1,
				},
				AutoRepair = {
					type = "toggle",
					name = "Auto Repair",
					desc = "Toggle auto repairing when at a repair vendor.",
					order = 20,
				},
				RepairLimit = {
					type = "range",
					name = "Repair Limit",
					desc = "Change the number of gold you must have to auto repair.",
					min = 1,
					max = 1000,
					step = 25,
					order = 21,
					hidden = function()
						return not Nurfed2DB.Core.AutoRepair
					end,
				},
				HideCastBar = {
					type = "toggle",
					name = "Hide Cast Bar",
					desc = "Toggle the casting bar",
					order = -1,
					set = function(info, val)
						Nurfed2DB.Core.HideCastBar = not Nurfed2DB.Core.HideCastBar
						Nurfed2_ToggleCastBar()
					end,
				},
				AutoSellGroup = {
					type = "group",
					name = "Auto Sell",
					inline = true,
					args = {
						AutoSell = {
							type = "toggle",
							name = "Enable",
							desc = "Auto sell trash and vendor loot to vendors.",
							order = 30,
						},
						DoNotSell = {
							type = "input",
							name = "Do Not Sell Items",
							desc = "Add item names that you do not want to be automatically sold to vendors.",
							order = 31,
							hidden = function()
								return not Nurfed2DB.Core.AutoSell
							end,
							get = function()
								return ""
							end,
							set = function(_, name)
								if type(name) == "string" then
									name = tonumber(select(2, GetItemInfo(name)):match("Hitem:(%d+)"))
								end
								Nurfed2DB.Core.DoNotSell[name] = true
							end,	
						},
						DoNotSellList = {
							type = "select",
							name = "Do Not Sell List",
							desc = "Click an item name to remove it from the selling list.",
							hidden = function()
								return not Nurfed2DB.Core.AutoSell
							end,
							get = function() return false end,
							order = 32,
							values = function()
								local t = {}
								for itemid in pairs(Nurfed2DB.Core.DoNotSell) do
									if type(itemid) == "number" then
										t[itemid] = GetItemInfo(itemid)
									else
										t[itemid] = itemid
									end
								end
								return t
							end,
							set = function(_, name)
								Nurfed2DB.Core.DoNotSell[name] = nil;
							end,
						},
					},
				},
				AutoInvite = {
					type = "group",
					name = "Auto Invite Settings",
					desc = "Change auto invite settings!",
					inline = true,
					order = -1,
					hidden = function(info)
						local key = info[#info]
						if key == "Enable" or key == "AutoInvite" then
							return false
						end
						if key == "GuildOnly" or key == "Keyword" then
							if Nurfed2DB["Core"].AutoInvite.Enable then
								return false
							end
						end
						if key == "GuildRank" then
							if Nurfed2DB["Core"].AutoInvite.Enable and Nurfed2DB["Core"].AutoInvite.GuildOnly then
								return false
							end
						end
						if key == "GuildRankList" then
							if Nurfed2DB["Core"].AutoInvite.Enable and Nurfed2DB["Core"].AutoInvite.GuildOnly and Nurfed2DB["Core"].AutoInvite.GuildRank then
								return false
							end
						end
						return true
					end,
					args = {
						Enable = {
							type = "toggle",
							name = "Enable",
							desc = "Toggle auto inviting based by keyword and other settings.",
							arg = { usepname = true, },
						},
						InviteReply = {
							type = "toggle",
							name = "Invite Reply",
							desc = "Toggle replying when group is full or the player is in a group.",
							arg = { usepname = true, },
						},
						GuildOnly = {
							type = "toggle",
							name = "Guild Only",
							desc = "Toggle auto inviting guild members only.",
							arg = { usepname = true, },
						},
						GuildRank = {
							type = "toggle",
							name = "Guild Rank",
							desc = "Toggle auto inviting based on guild ranks.",
							arg = { usepname = true, },
						},
						Keyword = {
							type = "input",
							name = "Keyword",
							desc = "Change the keyword that a player must send you to get invited.",
							validate = function(_, msg)
								print(msg)
								if msg == "" then
									return "Error: The keyword must exist!"
								elseif msg == " " then
									return "Error: The keyword must contain more than a space!"
								elseif msg:match("^%s%s+") then
									return "Error: The keyword must not start with multiple spaces (or be all spaces)!"
								end
								return true
							end,
							pattern = "^%S+",
							arg = { usepname = true, },
						},
						GuildRankList = {
							type = "multiselect",
							name = "Rank List",
							desc = "Select the guild ranks you wish to be able to be auto invited.",
							values = function()
								local tbl = {}
								for i=1, GuildControlGetNumRanks() do
									tbl[GuildControlGetRankName(i)] = GuildControlGetRankName(i)
								end
								return tbl
							end,
							get = function(info, val)
								for name in pairs(Nurfed2DB.Core.AutoInvite.GuildRankList) do
									if val == name then return true end
								end
								return false
							end,
							set = function(info, name, val)
								Nurfed2DB.Core.AutoInvite.GuildRankList[name] = val or nil
							end,
							arg = { usepname = true, },
						},
					},
				},
				AutoAccept = {
					type = "group",
					name = "Auto Accept",
					desc = "Auto Accept Settings",
					inline = true,
					order = -1,
					args = {
						AutoAcceptFriendInvite = {
							type = "toggle",
							name = "Auto Friend",
							desc = "Automatically accept group invites from friends.",
							order = -1,
						},
						AutoAcceptGuildInvite = {
							type = "toggle",
							name = "Auto Guild",
							desc = "Automatically accept group invites from guild members.",
							order = -1,
						},
					},
				},
			},
		},
		Addons = {
			type = "group",
			name = "AddOns",
			get = GetAddons,
			set = SetAddons,
			childGroups = "tree",
			hidden = function(info)
				local key = info[#info]
				local hide = true
				local frame = options.args.Addons.args[key]
				if frame and frame.args then
					for i,v in pairs(frame.args) do
						hide = false
					end
				else
					hide = false
				end
				return hide
			end,
			args = {
				desc = {
					type = "description",
					name = "Enable and Disable Installed Addons",
					hidden = function() return false, createAddonsList() end,
					order = 0,
				},
				GeneralGroup = {
					type = "group",
					name = "General",
					order = 1,
					args = { },
				},
				NurfedGroup = {
					type = "group",
					name = "Nurfed",
					order = 2,
					args = { },
				},
				Nurfed2Group = {
					type = "group",
					name = "|cffaaaaffNurfed 2|r",
					order = 3,
					args = { },
				},
				--[[
				QuartzGroup = {
					type = "group",
					name = "Quartz",
					order = -1,
					args = { },
				},
				FuBarGroup = {
					type = "group",
					name = "FuBar",
					order = -1,
					args = { },
				},
				ButtonFacadeGroup = {
					type = "group",
					name = "ButtonFacade",
					order = -1,
					args = { },
				},
				BigWigsGroup = {
					type = "group",
					name = "BigWigs",
					order = -1,
					args = { },
				},
				DXEGroup = {
					type = "group",
					name = "DXE",
					order = -1,
					args = { },
				},
				LibrariesGroup = {
					type = "group",
					name = "Libraries",
					order = -1,
					args = { },
				},
				OverachieverGroup = {
					type = "group",
					name = "Under Achiever",
					order = -1,
					args = { },
				},
				DBMGroup = {
					type = "group",
					name = "DBM",
					order = -1,
					args = { },
				},
				CombuctorGroup = {
					type = "group",
					name = "Combuctor",
					order = -1,
					args = { },
				},
				AcherusGroup = {
					type = "group",
					name = "Acherus",
					order = -1,
					args = { },
				},
				GridGroup = {
					type = "group",
					name = "Grid",
					order = -1,
					args = { },
				},
				GathererGroup = {
					type = "group",
					name = "Gatherer",
					order = -1,
					args = { },
				},
				]]
			},
		},
		KeyBindings = {
			type = "group",
			name = "Bindings",
			desc = "Key Bindings!",
			--hidden = true,
			args = {
				desc = {
					type = "description",
					name = function() 
						createCurrentBindings()
						if not IsAddOnLoaded("AceGUI-3.0-Spell-EditBox") then
							return "AceGUI-3.0-Spell-EditBox NOT LOADED!"
						end
						return "Type a spell name below." 
					end,
					order = 0,
				},
				spellsHeader = {
					type = "header",
					name = "Spells/Abilities",
					desc = function()
						showHideBindings()
						return "Spells and Abilities"
					end,
					order = 100,
				},
				spellDropdown = {
					name = "Spells",
					type = "input",
					dialogControl = "Player_EditBox",
					get = function() end,
					set = createSpellBinding,
					validate = function(info, spell)
						if GetSpellInfo(spell) then
							return true
						end
						return false
					end,
					width = "full",
					order = 101,
				},
				macroHeader = {
					type = "header",
					name = "Macros",
					desc = "Macros",
					order = 200,
				},
				macrosDropdown = {
					name = "Macros",
					type = "input",
					dialogControl = "Macro_EditBox",
					get = function() end,
					set = createMacroBinding,
					validate = function(info, macro)
						return true
					end,
					width = "full",
					order = 201,
				},
				itemsHeader = {
					type = "header",
					name = "Items",
					desc = "Items",
					order = 300,
				},
				itemsDropdown = {
					name = "Items",
					type = "input",
					get = function() end,
					set = function() end,
					validate = function(info, item)
						return true
					end,
					width = "full",
					order = 301,
				},
				actionbarHeader = {
					name = "Action Bars",
					desc = "Action Bars",
					type = "header",
					order = 400,
				},
			},
			--[[
			args = {
				testdesc = {
					type = "description",
					name = "~",
					image = function() SetupBindings(); return "Interface\\Icons\\Temp.blp", 12, 21 end,
					order = 105,
				},
				test = {
					type = "keybinding",
					name = 'key',
					desc = 'Test Keybind',
					icon = function() return "Interface\\Icons\\Temp.blp", 12, 21 end,
					set = function(info, value) keyval = value print(keyval, info[#info]) end,
					get = function(info) return keyval end,
					
					order = 106,
				},
				
			},]]
		},
		RaidMode = {
			type = "group",
			name = "Raid Mode",
			desc = "Raid set up mode.\r This feature helps you create raids quickly and efficiently",
			args = {
				StartRaid = {
					type = "execute",
					name = "Start Raid",
					desc = "Starts the raid\r you should already be in a party",
					func = Nurfed2_StartRaidMode,
				},
				GuildRankList = {
					type = "multiselect",
					name = "Rank List",
					desc = "Select the guild ranks you wish to be able to be auto invited.",
					values = function()
						local tbl = {}
						for i=1, GuildControlGetNumRanks() do
							tbl[GuildControlGetRankName(i)] = GuildControlGetRankName(i)
						end
						return tbl
					end,
					get = function(info, val)
						for name in pairs(Nurfed2DB.Core.RaidMode.GuildRankList) do
							if val == name then return true end
						end
						return false
					end,
					set = function(info, name, val)
						Nurfed2DB.Core.RaidMode.GuildRankList[name] = val or nil
					end,
					arg = { usepname = true, },
				},
				NoInviteOfficerNote = {
					type = "input",
					name = "No Invite Note",
					desc = "When an officer note has this in it, they are not auto-invited, regardless of rank",
				},
				InviteOfficerNote = {
					type = "input",
					name = "Invite Note",
					desc = "When an officer note has this in it, they are always auto-invited, regardless of rank.",
				},
			},
		},
		MultiSpec = {
			type = "group",
			name = "MultiSpec",
			desc = "Many options dealing with the Multiple Spec Support Nurfed2 Gives.  Be careful!",
			childGroups = "tab",
			args = {
				Nurfed2 = {
					type = "group",
					name = "Nurfed 2",
					args = {
						desc = {
							type = "description",
							name = function() createMultiSpecSettingsN2(); return "Enable Mutli-Spec Support For The Following Mods" end,
							order = 0,
						},
					},
				},
				OtherMods = {
					type = "group",
					name = "Other Mods",
					childGroups = "inline",
					args = {
						desc = {
							type = "description",
							name = function() 
								createMultiSpecSettingsOtherMods();
								return "Enable multispec support for mods that are not Nurfed 2 Based.\r What this means is that you can make any mod with profile support change profiles when you change specs.\r BE AWARE!  IF YOU MESS THIS UP YOU CAN BREAK STUFF!"
							end,
							order = 0,
						},
						AddGroup = {
							type = "group",
							name = "Add New Mod",
							order = 1,
							args = {
								name = {
									type = "input",
									name = "Name",
									desc = "Type the name of the mod you wish to give support for.  MAKE SURE THIS IS TYPED EXACTLY CORRECT!",
									validate = function(info, val)
										if not _G[val] then return false end
										return true
									end,
									get = function()
										return addModName or ""
									end,
									set = function(info, val)
										addModName = val;
									end,
									order = 1,
								},
								type = {
									type = "select",
									name = "Mod Type",
									desc = "Select what time of mod this is.",
									values = { ["Ace3"] = "Ace3" },	-- atm just Ace3 Support
									get = function() 
										return addModType or ""
									end,
									set = function(info, val)
										addModType = val;
									end,
									order = 2,
								},
								primarySpec = {
									type = "input",
									name = "Primary Spec",
									desc = "Type the name of the profile for your primary spec.  THIS IS CASE SENSITIVE!",
									get = function()
										return addModPrimarySpec or ""
									end,
									set = function(info, val)
										addModPrimarySpec = val;
									end,
									order = 3,
								},
								secondarySpec = {
									type = "input",
									name = "Secondary Spec",
									desc = "Type the name of the profile for your secondary spec.  THIS IS CASE SENSITIVE!",
									get = function()
										return addModSecondarySpec or ""
									end,
									set = function(info, val)
										addModSecondarySpec = val;
									end,
									order = 4,
								},
								add = {
									type = "execute",
									name = "Add",
									desc = "Click this when the other 4 settings have been set!",
									confirm = function() return "Are you sure you wish to add this set?" end,
									validate = function()
										if addModName and addModType and addModSecondarySpec and addModPrimarySpec then
											return true
										end
										return "You must set all 4 values!"
									end,
									func = function()
										if addModName and addModType and addModSecondarySpec and addModPrimarySpec then
											Nurfed2DB["MultiSpec"]["OtherMods"][addModName] = {
												[1] = addModPrimarySpec,
												[2] = addModSecondarySpec,
												["type"] = addModType,
											}
											addModName, addModType, addModSecondarySpec, addModPrimarySpec = nil, nil, nil, nil;
										else
											return Nurfed2:Print("ERROR:  YOU MUST SET ALL 4 VALUES!!")
										end
									end,
								},
							},
						},
					},
				},
			},
		},
	},
}

 

local optionsSlash = {
	name = "Nurfed 2",
	type = "group",
}
function OnLoad(self)
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("Nurfed 2", optionsSlash)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Nurfed 2", options)
	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	local parentName = "Nurfed 2"
	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.IndexPage = ACD3:AddToBlizOptions("Nurfed 2", parentName, nil, "indexPage")
	self.optionsFrames.General = ACD3:AddToBlizOptions("Nurfed 2", "General", parentName, "General")
	self.optionsFrames.AddOns = ACD3:AddToBlizOptions("Nurfed 2", "Addons", parentName, "Addons")
	self.optionsFrames.Bindings = ACD3:AddToBlizOptions("Nurfed 2", "Bindings", parentName, "KeyBindings")
	self.optionsFrames.RaidMode = ACD3:AddToBlizOptions("Nurfed 2", "Raid Mode", parentName, "RaidMode")
	self.optionsFrames.MultiSpec = ACD3:AddToBlizOptions("Nurfed 2", "Multi Spec", parentName, "MultiSpec")
end
OnLoad(Nurfed2)
Nurfed2_Optionssver = "r20100228010321"