--[[
	The point of these files are to create a module version of Nurfed, to enable people to plugin easily, while
	keeping the small size of the UI Package.  This also allows for users to pick and choose how they want to configure
	and use Nurfed.
]]
assert(Nurfed2, "Nurfed2 is required to be installed and enabled for Nurfed2 ActionBars to work")
local _G = getfenv(0)
local pairs = _G.pairs
local ipairs = _G.ipairs
local UnitCanAttack = _G.UnitCanAttack
local UnitCanAssist = _G.UnitCanAssist
local GetItemCount = _G.GetItemCount
local GetSpellCount = _G.GetSpellCount
local IsEquipedItem = _G.IsEquipedItem
local GetMacroItem = _G.GetMacroItem
local GetMacroSpell = _G.GetMacroSpell
local GetSpellName = _G.GetSpellName
local GetSpellCount = _G.GetSpellCount
local GetSpellTexture = _G.GetSpellTexture
local GetSpellCooldown = _G.GetSpellCooldown
local GetItemCooldown = _G.GetItemCooldown
local SecureButton_GetAttribute = _G.SecureButton_GetAttribute
local SecureButton_GetUnit = _G.SecureButton_GetUnit
local SecureButton_GetModifiedAttribute = _G.SecureButton_GetModifiedAttribute
local IsAttackSpell = _G.IsAttackSpell
local IsAutoRepeatSpell = _G.IsAutoRepeatSpell
local GetMacroInfo = _G.GetMacroInfo
local GameTooltip_SetDefaultAnchor = _G.GameTooltip_SetDefaultAnchor
local GameTooltip = _G.GameTooltip
local GetItemInfo = _G.GetItemInfo
local GetMacroBody = _G.GetMacroBody
local GetCompanionInfo = _G.GetCompanionInfo
local SecureCmdOptionParse = _G.SecureCmdOptionParse
local InCombatLockdown = _G.InCombatLockdown
local PickupSpell = _G.PickupSpell
local PickupItem = _G.PickupItem
local PickupMacro = _G.PickupMacro
local UnitExists = _G.UnitExists
local GetCursorInfo = _G.GetCursorInfo
local ClearCursor = _G.ClearCursor
local IsCurrentSpell = _G.IsCurrentSpell
local IsUsableSpell = _G.IsUsableSpell
local SpellHasRange = _G.SpellHasRange
local IsSpellInRange = _G.IsSpellInRange
local IsUsableItem = _G.IsUsableItem
local ItemHasRange = _G.ItemHasRange
local IsItemInRange = _G.IsItemInRange
local lbf = _G["LibStub"] and _G.LibStub("LibButtonFacade", true) or nil
local lbfg
local defaultBarConfig = {
	["NoMana"] = { 0.5, 0.5, 1 },
	["NotUsable"] = { 0.4, 0.4, 0.4 },
	["NoRange"] = { 1, 0, 0 },
	["BaseColor"] = { 1, 1, 1 },
	["Tooltips"] = true,
	["Totem"] = {
		Show = true,
		Vertical = true,
		Scale = 1,
		Offset = 0,
	},
	["Bags"] = {
		Show = false,
		Vertical = false,
		Scale = 1,
	},
	["Micro"] = {
		Show = false,
		Scale = 1,
	},
	["Stance"] = {
		Show = true,
		Vertical = false,
		Offset = 0,
		Scale = 1,
	},
	["Pet"] = {
		Show = false,
		Vertical = false,
		Offset = 0,
		Scale = 1,
	},
	["Possess"] = {
		Scale = 1,
		Offset = 0,
	},
	["Vehicle"] = {
		Scale = 1,
		Offset = 0,
	},
}

local defaultSpellSettings = { }
local defaultBarSettings = { }
-- item icon's meta table
local function GetCompanionIcon(compname)
	local txture
	for i=1, GetNumCompanions("MOUNT") do
		local _, name, _, texture = GetCompanionInfo("MOUNT", i)
		if name:find(compname) then
			if not txture or name == compname then
				txture = texture
			end
		end
	end
	for i=1, GetNumCompanions("CRITTER") do
		local _, name, _, texture = GetCompanionInfo("CRITTER", i)
		if name:find(compname) then
			if not txture or name == compname then
				txture = texture
			end
		end
	end
	return txture
end

local icons = setmetatable({}, {__index = function(self, key)
	self[key] = GetSpellTexture(key) or GetCompanionIcon(key) or "Interface\\Icons\\Temp"
	return self[key]
end,})
-- companions meta table
							
local function clearMetaTables()
	for name, texture in pairs(icons) do
		if texture == "Interface\\Icons\\Temp" then
			icons[name] = nil
		end
	end
end

-- convert information
local function convert(btn, value)
	local unit = SecureButton_GetAttribute(btn, "unit")
	if unit and unit ~= "none" and UnitExists(unit) then
		if UnitCanAttack("player", unit) then
			value = SecureButton_GetModifiedAttribute(btn, "harmbutton", value) or value
		elseif UnitCanAssist("player", unit) then
			value = SecureButton_GetModifiedAttribute(btn, "helpbutton", value) or value
		end
	end
	return value
end

-- Update the button cooldown
local function Button_UpdateCooldown(btn)
	local start, duration, enable = 0, 0, 0
	if btn.spell then
		if btn.type == "spell" then
			start, duration, enable = GetSpellCooldown(btn.spell)
		elseif btn.type == "item" then
			start, duration, enable = GetItemCooldown(btn.spell)
		elseif btn.type == "macro" then
			local item, link = GetMacroItem(btn.spell)
			local spell, rank = GetMacroSpell(btn.spell)
			if item then
				start, duration, enable = GetItemCooldown(item)
			elseif spell then
				start, duration, enable = GetSpellCooldown(spell)
			end
		end
	end
	if start and duration then
		CooldownFrame_SetTimer(_G[btn:GetName().."Cooldown"], start, duration, enable)
	end
end

-- Button: Update Item Colors
local function Button_UpdateItem(btn)
	if btn.spell then
		local count = _G[btn:GetName().."Count"]
		local border = _G[btn:GetName().."Border"]

		if btn.type == "spell" then
			local reg = GetSpellCount(btn.spell)
			if reg and reg > 0 then
				count:SetText(reg)
			else
				count:SetText(nil)
			end
			border:Hide()
			
		elseif btn.type == "item" then
			local num = GetItemCount(btn.spell)
			if num > 1 then
				count:SetText(num)
			else
				count:SetText(nil)
			end
			if IsEquippedItem(btn.spell) then
				border:SetVertexColor(0, 1.0, 0, 0.35)
				border:Show()
			else
				border:Hide()
			end
			
		elseif btn.type == "macro" then
			local item, link = GetMacroItem(btn.spell)
			local spell, rank = GetMacroSpell(btn.spell)
			if item then
				local num = GetItemCount(item)
				if num > 1 then
					count:SetText(num)
				else
					count:SetText(nil)
				end
				if IsEquippedItem(item) then
					border:SetVertexColor(0, 1.0, 0, 0.35)
					border:Show()
				else
					border:Hide()
				end
			elseif spell then
				local reg = GetSpellCount(spell)
				if reg and reg > 0 then
					count:SetText(reg)
				else
					count:SetText(nil)
				end
				border:Hide()
			else
				border:Hide()
				count:SetText(nil)
			end
		end
	end
end

-- Set The Button Icon
local function Button_SetIcon(btn)
	local value = btn:GetParent():GetAttribute("state")
	if value then
		value = convert(btn, value)
		local texture
		local text = _G[btn:GetName().."Name"]
		local new = SecureButton_GetModifiedAttribute(btn, "type", value)
		btn.type = new
		btn.attack = nil
		text:SetText(nil)
		if new then
			local spell = SecureButton_GetModifiedAttribute(btn, new, value)
			if spell then
				if new == "spell" then
					texture = icons[spell]

					if SecureButton_GetModifiedAttribute(btn, "companiontype", value) then
						btn.companion = SecureButton_GetModifiedAttribute(btn, "companiontype", value)
					else
						btn.companion = nil;
					end
					
					if IsAttackSpell(spell) or IsAutoRepeatSpell(spell) then
						btn.attack = true
					end
					
				elseif new == "item" then
					local itemid = SecureButton_GetModifiedAttribute(btn, "itemid", value)
					if itemid then
						texture = select(10, GetItemInfo(itemid))
					end
				
				elseif new == "macro" then
					spell, texture = GetMacroInfo(spell)
					if Nurfed2DB.BarSettings[btn:GetParent():GetName()].hideMacroText then
						text:SetText(nil)
					else	
						text:SetText(spell)
					end
				end
			end
			btn.spell = spell
		end

		local icon = _G[btn:GetName().."Icon"]
		if icon:GetTexture() ~= texture then
			icon:SetTexture(texture)
			if texture then
				btn:SetAlpha(1)
			end
			Button_UpdateItem(btn)
			Button_UpdateCooldown(btn)
		end
		
		if not texture and not btn.grid then
			btn:SetAlpha(0)
		end
	end
end

local function Button_ShowGrid(btn)
	btn.grid = true
	btn:SetAlpha(1)
end

local function Button_HideGrid(btn)
	btn.grid = nil
	if not _G[btn:GetName().."Icon"]:GetTexture() then
		btn:SetAlpha(0)
	end
end

local function Button_SpecChanged(self)
	local tbl = Nurfed2DB.SpellSettings[self:GetParent():GetName()][self:GetID()]
	local value = self:GetParent():GetAttribute("state")
	if value == "0" then
		value = nil
	end
	local unit = SecureButton_GetModifiedUnit(self, (value or "LeftButton"))
	if value then
		value = "-"..value
	else
		value = "*"
	end
	
	local useunit = self:GetParent():GetAttribute("useunit")
	if useunit and unit and unit ~= "none" and UnitExists(unit) then
		if UnitCanAttack("player", unit) then
			self:SetAttribute("*harmbutton"..value, "nuke"..value)
			value = "-nuke"..value
		elseif UnitCanAssist("player", unit) then
			self:SetAttribute("*helpbutton"..value, "heal"..value)
			value = "-heal"..value
		end
	end

	--Clear Attributes
	
	self.inspecchange = true
	
	self:SetAttribute("*type"..value, nil)
	self:SetAttribute("*spell"..value, nil)
	self:SetAttribute("*companion"..value, nil)
	self:SetAttribute("*companiontype"..value, nil)
	self:SetAttribute("*item"..value, nil)
	self:SetAttribute("*itemid"..value, nil)
	self:SetAttribute("*macro"..value, nil)
	self:SetAttribute("*macroID"..value, nil)
	
	self.inspecchange = nil
	if tbl then
		for i,v in pairs(tbl) do
			self:SetAttribute(i,v)
		end
	end
	Button_SetIcon(self)
end


-- Button Start/Stop Flashing
local function Button_FlashStart(btn) btn.flash = true; end
local function Button_FlashStop(btn) btn.flash = nil; end

-- Button On Enter Event
local function Button_OnEnter(self)
	if Nurfed2DB["BarConfig"].Tooltips and self.type then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		if self.type == "spell" then
			local id = Nurfed2:GetSpell(self.spell)
			if id and GetSpellLink(id, BOOKTYPE_SPELL) then
				local rank = select(2, GetSpellName(id, BOOKTYPE_SPELL))
				GameTooltip:SetHyperlink(GetSpellLink(id, BOOKTYPE_SPELL))
				if rank then
					GameTooltipTextRight1:SetText(rank)
					GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
					GameTooltipTextRight1:Show()
				end
			else
				-- companion tooltip
--				if not companionList then
--					updateCompanionList()
--				end
--				if companionList and companionList[self.spell] then
--					GameTooltip:SetHyperlink("spell:"..companionList[self.spell])
--				end
			end
		
		elseif self.type == "item" then
			if GetItemInfo(self.spell) then
				GameTooltip:SetHyperlink(select(2, GetItemInfo(self.spell)))
			end
		
		elseif self.type == "macro" and GetMacroBody(self.spell) then
			local bdy = GetMacroBody(self.spell)
			local action = SecureCmdOptionParse(bdy)
			if action then
				if bdy:find("/cast") then
					local taction = bdy:match("/ca%a+ [%a%s]+")
					if taction then
						taction = taction:gsub("/ca%a+ ", ""):gsub("%c", "")
						action = taction
					end
				end
				if companionList and companionList[action] then
					GameTooltip:SetHyperlink("spell:"..companionList[action])
				
				elseif GetItemInfo(action) then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(action)))
				else
					local id = Nurfed2:GetSpell(action)
					if id then
						local rank = select(2, GetSpellName(id, BOOKTYPE_SPELL))
						GameTooltip:SetHyperlink(GetSpellLink(id, BOOKTYPE_SPELL))
						if rank then
							GameTooltipTextRight1:SetText(rank)
							GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
							GameTooltipTextRight1:Show()
						end
					end
				end
			end
		end
		GameTooltip:Show()
	end
end


local live, dead = {}, {}
-- Update the button colors
local function Button_UpdateColors()
	for _, btn in ipairs(live) do
		local r, g, b = Nurfed2DB.BarConfig.BaseColor[1], Nurfed2DB.BarConfig.BaseColor[2], Nurfed2DB.BarConfig.BaseColor[3]--1, 1, 1;
		local unit = SecureButton_GetUnit(btn);
		if btn.companion then
			if InCombatLockdown() then
				r, g, b = Nurfed2DB.BarConfig.NotUsable[1], Nurfed2DB.BarConfig.NotUsable[2], Nurfed2DB.BarConfig.NotUsable[3] --0.4, 0.4, 0.4;
			end
		
		elseif btn.type == "spell" then
			if IsCurrentSpell(btn.spell) or UnitCastingInfo("player") == btn.spell then
				btn:SetChecked(true);
			else
				btn:SetChecked(nil);
			end

			local usable, nomana = IsUsableSpell(btn.spell);
			if nomana then
				r, g, b = Nurfed2DB.BarConfig.NoMana[1], Nurfed2DB.BarConfig.NoMana[2], Nurfed2DB.BarConfig.NoMana[3] --0.5, 0.5, 1;
			elseif not usable then
				r, g, b = Nurfed2DB.BarConfig.NotUsable[1], Nurfed2DB.BarConfig.NotUsable[2], Nurfed2DB.BarConfig.NotUsable[3] --0.4, 0.4, 0.4;
			elseif SpellHasRange(btn.spell) and IsSpellInRange(btn.spell, unit) == 0 then
				r, g, b = Nurfed2DB.BarConfig.NoRange[1], Nurfed2DB.BarConfig.NoRange[2], Nurfed2DB.BarConfig.NoRange[3]--1, 0, 0;
			end
	
		elseif btn.type == "item" then
			if not IsUsableItem(btn.spell) then
				r, g, b = Nurfed2DB.BarConfig.NotUsable[1], Nurfed2DB.BarConfig.NotUsable[2], Nurfed2DB.BarConfig.NotUsable[3] --0.4, 0.4, 0.4;
			elseif ItemHasRange(btn.spell) and IsItemInRange(btn.spell, unit) == 0 then
				r, g, b = Nurfed2DB.BarConfig.NoRange[1], Nurfed2DB.BarConfig.NoRange[2], Nurfed2DB.BarConfig.NoRange[3]--1, 0, 0;
			end
			
		elseif btn.type == "macro" then
			local item, link = GetMacroItem(btn.spell);
			local spell, rank = GetMacroSpell(btn.spell);
			if item then
				if not IsUsableItem(item) then
					r, g, b = Nurfed2DB.BarConfig.NotUsable[1], Nurfed2DB.BarConfig.NotUsable[2], Nurfed2DB.BarConfig.NotUsable[3] --0.4, 0.4, 0.4;
				elseif ItemHasRange(item) and IsItemInRange(item, unit) == 0 then
					r, g, b = Nurfed2DB.BarConfig.NoRange[1], Nurfed2DB.BarConfig.NoRange[2], Nurfed2DB.BarConfig.NoRange[3]--1, 0, 0;
				end
			
			elseif spell then
				if btn.companion then
					if InCombatLockdown() then
						r, g, b = Nurfed2DB.BarConfig.NotUsable[1], Nurfed2DB.BarConfig.NotUsable[2], Nurfed2DB.BarConfig.NotUsable[3] --0.4, 0.4, 0.4;
					end
				else
					local usable, nomana = IsUsableSpell(spell);
					if nomana then
						r, g, b = Nurfed2DB.BarConfig.NoMana[1], Nurfed2DB.BarConfig.NoMana[2], Nurfed2DB.BarConfig.NoMana[3] --0.5, 0.5, 1;
					elseif not usable then
						r, g, b = Nurfed2DB.BarConfig.NotUsable[1], Nurfed2DB.BarConfig.NotUsable[2], Nurfed2DB.BarConfig.NotUsable[3] --0.4, 0.4, 0.4;
					elseif SpellHasRange(spell) and IsSpellInRange(spell, unit) == 0 then
						r, g, b = Nurfed2DB.BarConfig.NoRange[1], Nurfed2DB.BarConfig.NoRange[2], Nurfed2DB.BarConfig.NoRange[3]--1, 0, 0;
					end
				end
			end

			if btn.macro then
				Button_SetIcon(btn);
				btn.macro = nil;
			end
		end
		_G[btn:GetName().."Icon"]:SetVertexColor(r, g, b);
		Nurfed2:CooldownText(btn)
	end
end

-- Update All Button Information
local function Button_UpdateAll(btn)
	local parent = btn:GetParent()
	if not parent then return end
	clearMetaTables()
	local vals = Nurfed2DB["SpellSettings"][parent:GetName()][btn:GetID()]
	if vals then
		local value = parent:GetAttribute("state")
		if value == "0" then
			value = nil
		end
		
		local unit = SecureButton_GetModifiedUnit(btn, (value or "LeftButton"))
		if value then
			value = "-"..value
		else
			value = "*"
		end
		
		-- determine if the button requires a special unit type
		local useunit = parent:GetAttribute("useunit")
		if useunit and unit and unit ~= "none" and UnitExists(unit) then
			if UnitCanAttack("player", unit) then
				btn:SetAttribute("*harmbutton"..value, "nuke"..value)
				value = "-nuke"..value
			elseif UnitCanAssist("player", unit) then
				btn:SetAttribute("*helpbutton"..value, "heal"..value)
				value = "-heal"..value
			end
		end
	
		
		-- Update Button Information
		for i, v in pairs(vals) do
			btn:SetAttribute(i, v)
		end
	end
	Button_SetIcon(btn)
	Button_UpdateColors()
end

local function Button_DragStart(self)
	if Nurfed2:IsLocked() or InCombatLockdown() then return end
	local state = self:GetParent():GetAttribute("state")
	if state == "0" then
		state = "LeftButton"
	end
	
	local value = convert(self, state)
	local new = SecureButton_GetModifiedAttribute(self, "type", value)
	if new then
		spell = SecureButton_GetModifiedAttribute(self, new, value)
		if spell then
			local state, value = state, value
			if state == "LeftButton" then
				value = "*"
			else
				value = "-"..value
			end
			if new == "spell" then
				if Nurfed2:GetSpell(spell) then
					PickupSpell(Nurfed2:GetSpell(spell), BOOKTYPE_SPELL)
				else
					self.spell = nil
				end
				if SecureButton_GetModifiedAttribute(self, "companiontype", value) then
					PickupCompanion(SecureButton_GetModifiedAttribute(self, "companiontype", value), SecureButton_GetModifiedAttribute(self, "companion", value))
				end
				
			elseif new == "item" then
				PickupItem(spell)
			elseif new == "macro" then
				PickupMacro(spell)
			end
		end

		if state == "LeftButton" then
			value = "*"
		else
			value = "-"..value
		end
		self:SetAttribute("*type"..value, nil)
		self:SetAttribute("*"..new..value, nil)

		local unit = SecureButton_GetModifiedUnit(self, state)
		local useunit = self:GetParent():GetAttribute("useunit")
		if useunit and unit and unit ~= "none" and UnitExists(unit) then
			if state == "LeftButton" then
				state = "*"
			else
				state = "-"..state
			end
			if UnitCanAttack("player", unit) then
				self:SetAttribute("*harmbutton"..state, nil)
			elseif UnitCanAssist("player", unit) then
				self:SetAttribute("*helpbutton"..state, nil)
			end
		end
		Button_UpdateAll(self)
	end
end

local function Button_ReceiveDrag(self)
	if GetCursorInfo() and not InCombatLockdown() then
		local oldtype = self.type
		local oldspell = self.spell
		local cursor, arg1, arg2 = GetCursorInfo()
		local value = self:GetParent():GetAttribute("state")
		if value == "0" then
			value = nil
		end
		local unit = SecureButton_GetModifiedUnit(self, (value or "LeftButton"))
		if value then
			value = "-"..value
		else
			value = "*"
		end
		
		local useunit = self:GetParent():GetAttribute("useunit")
		if useunit and unit and unit ~= "none" and UnitExists(unit) then
			if UnitCanAttack("player", unit) then
				self:SetAttribute("*harmbutton"..value, "nuke"..value)
				value = "-nuke"..value
			elseif UnitCanAssist("player", unit) then
				self:SetAttribute("*helpbutton"..value, "heal"..value)
				value = "-heal"..value
			end
		end
		
		self:SetAttribute("*type"..value, cursor)
		--Clear Attributes
		self:SetAttribute("*spell"..value, nil)
		self:SetAttribute("*item"..value, nil)
		self:SetAttribute("*itemid"..value, nil)
		self:SetAttribute("*macro"..value, nil)
		self:SetAttribute("*macroID"..value, nil)
		self:SetAttribute("*companion"..value, nil)
		self:SetAttribute("*companiontype"..value, nil)
		if cursor == "companion" then
			local id = select(3, GetCompanionInfo(arg2, arg1))
			spell = GetSpellInfo(id)
			self:SetAttribute("*spell"..value, spell)
			-- find a way to use the attribute id 'companion' which I imagine is in now.
			self:SetAttribute("*type"..value, "spell")
			self:SetAttribute("*companion"..value, arg1)
			self:SetAttribute("*companiontype"..value, arg2)
			
			
		elseif cursor == "spell" then
			local spell, rank = GetSpellName(arg1, arg2)
			if rank:find(RANK) then
				spell = spell.."("..rank..")"
			elseif spell:find("%(") then
				spell = spell.."()"
			end
			self:SetAttribute("*spell"..value, spell)
			
		
		elseif cursor == "item" then
			local name = GetItemInfo(arg1)
			self:SetAttribute("*item"..value, name)
			self:SetAttribute("*itemid"..value, arg1)
			
		elseif cursor == "macro" then
			self:SetAttribute("*macro"..value, arg1)
		end 
		ClearCursor()

		if oldtype and oldspell then
			if oldtype == "spell" then
				local id = Nurfed2:GetSpell(oldspell)
				if id then
					PickupSpell(id, BOOKTYPE_SPELL)
				end
			elseif oldtype == "item" then
				-- do nothing?
			elseif oldtype == "macro" then
				PickupMacro(oldspell)
			end
		end
	end
	Button_SetIcon(self)
end

-- Attribute Changed
local btnsave
local function Button_AttributeChanged(self, name, value)
	if name:find("^%*") or name:find("^shift") or name:find("^ctrl") or name:find("^alt") then
		if not self.inspecchange then
			btnsave = Nurfed2DB.SpellSettings[self:GetParent():GetName()][self:GetID()]
			if btnsave then
				Nurfed2DB.SpellSettings[self:GetParent():GetName()][self:GetID()][name] = value
			else
				Nurfed2DB.SpellSettings[self:GetParent():GetName()][self:GetID()] = { }-- temp fix
				Nurfed2DB.SpellSettings[self:GetParent():GetName()][self:GetID()][name] = value
			end
		end
	end
end

local function Bar_AttributeChanged(self, name, value)
	Nurfed2:SendEvent("N2_ATTRIBUTE_CHANGED")
end

-- Get The Button, if it exists, if not create a new one!
local function GetButton(hdr, settingsChanged)
	local btn
	if #dead > 0 then
		--btn = table.remove(dead)
		btn = table.remove(dead, 1)
		table.sort(dead, function(a, b)
			local num1 = a:GetName():gsub("Nurfed2_Button", "")
			local num2 = b:GetName():gsub("Nurfed2_Button", "")
			num1 = tonumber(num1)
			num2 = tonumber(num2)
			return num1<num2
		end)
	else
		local new = #live + 1
		btn = CreateFrame("CheckButton", "Nurfed2_Button"..new, hdr, "SecureActionButtonTemplate ActionButtonTemplate")
		
		btn.hotkey = _G[btn:GetName().."HotKey"]
		btn:SetParent(hdr)

		btn:RegisterForClicks("AnyUp")
		btn:RegisterForDrag("LeftButton")

		btn:SetAttribute("checkselfcast", true)

		btn:SetScript("OnEnter", Button_OnEnter)
		btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
		btn:SetScript("OnDragStart", Button_DragStart)
		btn:SetScript("OnReceiveDrag", Button_ReceiveDrag)
		
		btn:SetScript("PreClick", function(self)
			if GetCursorInfo() and not InCombatLockdown() then
				self.unwrapped = true
				hdr:UnwrapScript(self, "OnClick")
				hdr:WrapScript(self, "OnClick", [[ return false ]])
				Button_ReceiveDrag(self)
			end
		end)
		
		btn:SetScript("PostClick", function(self)
			self:SetChecked(nil)
			if self.unwrapped then
				hdr:UnwrapScript(self, "OnClick")
				hdr:WrapScript(self, "OnClick", [[ return state ]])
				self.unwrapped = nil
			end
		end)
		btn.hotkey:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		
		local cd = _G[btn:GetName().."Cooldown"]
		cd.text = cd:CreateFontString(nil, "OVERLAY")
		cd.text:SetPoint("CENTER")
		cd.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
		--cd.text:SetFont(NRF2_FONT.."PerspectiveSans.ttf", 12, "OUTLINE")
		
		local flash = _G[btn:GetName().."Flash"]
		flash:ClearAllPoints()
		flash:SetAllPoints(cd)
		btn.flashtime = 0
	end
	table.insert(live, btn)
	
	btn:SetScript("OnAttributeChanged", Button_AttributeChanged)
	hdr:UnwrapScript(btn, "OnClick")
	hdr:WrapScript(btn, "OnClick", [[ return state ]])
	return btn
end

local function DeleteButton(btn)
	for k, v in ipairs(live) do
		if v == btn then
			table.remove(live, k)
			table.insert(dead, btn)
			table.sort(dead, function(a, b)
				local num1 = a:GetName():gsub("Nurfed2_Button", "")
				local num2 = b:GetName():gsub("Nurfed2_Button", "")
				num1 = tonumber(num1)
				num2 = tonumber(num2)
				return num1<num2
			end)
			break
		end
	end
	
	if Nurfed2DB.BarSettings[btn:GetParent():GetName()][btn:GetID()] then
		for k in pairs(Nurfed2DB.BarSettings[btn:GetParent():GetName()][btn:GetID()]) do
			btn:SetAttribute(k, nil)
		end
	end
	
	btn:SetScript("OnAttributeChanged", nil)
	if btn:GetParent().lbf then
		btn:GetParent().lbf:RemoveButton(btn)
	end
	btn:SetParent(UIParent)
	btn:Hide()
	btn:SetID(0)
	btn.hotkey:SetText(nil)
	--_G[btn:GetName().."HotKey"]:SetText(nil)
end

-- Update The Entire Bar, Ensuring the buttons are created, and exist
local function UpdateBar(bar, settingsChanged)
	local state, visible;
	local btns, statelist, driver, unitlist, unitdriver = {}, {}, {}, {}, {}
	local vals = Nurfed2DB["BarSettings"][bar:GetName()]
	for _, child in ipairs({ bar:GetChildren() }) do
		if child:GetID() then
			table.insert(btns, child:GetID(), child);
		end
	end
	local unitLst
	if vals.statemaps then
		for k, v in pairs(vals.statemaps) do
			if k:find("%-") then
				k = k:gsub("%-", ":");
			end
	
			local add = true;
			local list = v..":"..v;
			table.insert(driver, "["..k.."] "..v);

			for _, l in ipairs(statelist) do
				if l == list then
					add = nil;
					break
				end
			end

			if add then
				table.insert(statelist, v..":"..v);
			end
		end
	end
	
	driver = table.concat(driver, ";");
	state = SecureCmdOptionParse(driver);
	statelist = table.concat(statelist, ";");
	

	if #driver == 0 then
		state = "0";
	end
	if not vals.visible or vals.visible == "" then
		vals.visible = "show";
	end

	visible = vals.visible;

	if vals.visible ~= "hide" and vals.visible ~= "show" then
		visible = "["..vals.visible.."]".." show; hide";
	end
	print(bar:GetName(), vals.visible, visible)

	bar:SetAttribute("_onstate-state", [[ -- (self, stateid, newstate)
						state = newstate;
						self:SetAttribute("state", newstate)
						control:ChildUpdate(stateid, newstate)]]
					)
	RegisterStateDriver(bar, "state", driver);
	RegisterStateDriver(bar, "visibility", visible);
	bar:SetAttribute("statebutton", statelist);
	bar:SetAttribute("state", state);
	bar:SetScale(vals.scale)
	bar:SetAlpha(vals.alpha)
	
  	bar:SetWidth(vals.cols * (36 + vals.xgap) - vals.xgap);
	bar:SetHeight(vals.rows * (36 + vals.ygap) - vals.ygap);
	
	local last, begin;
	local count = 1;
	--local btnVals = Nurfed2DB["SpellSettings"][bar:GetName()]
	for i = 1, vals.rows do
		for j = 1, vals.cols do
			local btn = table.remove(btns, 1) or GetButton(bar, settingsChanged);
			btn:SetID(count);
			btn:SetParent(bar)
			bar:SetAttribute("addchild", btn);
			btn:ClearAllPoints();
			if bar.lbf then
				bar.lbf:AddButton(btn)
			end
			if j == 1 then
				if begin then
					btn:SetPoint("BOTTOMLEFT", begin, "TOPLEFT", 0, vals.ygap);
				else
					btn:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0);
				end
				begin = btn;
			else
				btn:SetPoint("LEFT", last, "RIGHT", vals.xgap, 0);
			end
			if vals.noclick then
				btn:EnableMouse(false)
			else
				btn:EnableMouse(true)
			end
			last = btn;
			count = count + 1;
			btn:Show()
			Button_UpdateAll(btn)
		end
	end
	if not settingsChanged then
		bar:HookScript("OnAttributeChanged", Bar_AttributeChanged)
		for _, button in ipairs(btns) do
			DeleteButton(button);
		end
		Nurfed2:SendEvent("N2_BINDINGS_UPDATE")
	end
end

-- Delete The Bar
function Nurfed2:DeleteBar(frame)
	local hdr = _G[frame];
	if hdr then
		UnregisterUnitWatch(hdr);
		hdr:SetAttribute("unit", nil);
		RegisterStateDriver(hdr, "visibility", "hide");
		hdr:Hide();

		for _, child in ipairs({ hdr:GetChildren() }) do
			if child:GetID() and child:GetID() ~= 0 then
				DeleteButton(child)
			end
		end
		if hdr.lbf then
			lbf:DeleteGroup("Nurfed 2", "Virtual Bars", hdr:GetName())
		end
	end
	Nurfed2DB["BarSettings"][frame] = nil;
	Nurfed2DB["SpellSettings"][frame] = nil;
	if Nurfed2DB["MultiSpecSettings"][1]["SpellSettings"] and Nurfed2DB["MultiSpecSettings"][1]["SpellSettings"][frame] then
		Nurfed2DB["MultiSpecSettings"][1]["SpellSettings"][frame] = nil
		Nurfed2DB["MultiSpecSettings"][2]["SpellSettings"][frame] = nil
	end
	if Nurfed2DB["MultiSpecSettings"][1]["BarSettings"] and Nurfed2DB["MultiSpecSettings"][1]["BarSettings"][frame] then
		Nurfed2DB["MultiSpecSettings"][1]["BarSettings"][frame] = nil
		Nurfed2DB["MultiSpecSettings"][2]["BarSettings"][frame] = nil
	end
end

-- Secure Bar Functions to save positions, based on hooking SetPoint and StopMovingOrSizing
local function Bar_SavePosition(bar)
	local p1, p2, p3, p4, p5 = bar:GetPoint()
	if (p1 and p3 and p4 and p5) then
		p2 = p2 or UIParent
		if type(p2) == "table" then
			p2 = p2:GetName()
		end
		if bar.blizz then
			Nurfed2DB.BarConfig[bar:GetName():gsub("Nurfed2_", "", 1):gsub("Bar", "")].Position = { p1, p2, p3, p4, p5 }
		else
			Nurfed2DB["BarSettings"][bar:GetName()]["position"] = { p1, p2, p3, p4, p5 }	
		end
	end
end

local function Bar_SavePointPosition(bar)
	bar:StartMoving()
	bar:StopMovingOrSizing()
end

local function Bar_UpdateSkins(updateall, skinID, gloss, backdrop, group, bar, colors)
	if group and bar then
		if group == "Virtual Bars" then
			Nurfed2DB.BarSettings[bar].Skin = { skinID, gloss, backdrop }

		elseif group == "Blizzard Bars" then
			Nurfed2DB.BarConfig[bar:gsub("Nurfed2_", ""):gsub("Bar", "", 1)].Skin = { skinID, gloss, backdrop }
		end
	end
	if updateall then
		for name, tbl in pairs(Nurfed2DB.BarSettings) do
			if tbl.Skin and _G[name] and _G[name].lbf then
				_G[name].lbf:Skin(unpack(tbl.Skin))
			end
		end
		for name, tbl in pairs(Nurfed2DB.BarConfig) do
			if type(tbl) == "table" then
				if tbl.Skin and _G["Nurfed2_"..name.."Bar"] and _G["Nurfed2_"..name.."Bar"].lbf then
					_G["Nurfed2_"..name.."Bar"].lbf:Skin(unpack(tbl.Skin))
				end
			end
		end
	end
end

-- Create The Bar Itself
function Nurfed2:CreateBar(name, bar)
	local hdr = _G[name] or Nurfed2:Create(name, "actionbar");
	if hdr and type(hdr) == "table" then
		hdr:SetScale(bar.scale)
		hdr:SetAlpha(bar.alpha)
		hdr:ClearAllPoints()
		hdr:SetPoint(unpack(bar.position or { "CENTER" }))
		hdr:SetAttribute("unit", bar.unit)
		hdr:SetAttribute("useunit", bar.useunit)

		_G[name.."dragtext"]:SetText(name)
		_G[name.."dragtext2"]:SetText(name)
		
		hooksecurefunc(hdr, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(hdr, "SetPoint", Bar_SavePointPosition)
		if lbfg then
			hdr.lbf = lbf:Group("Nurfed 2", "Virtual Bars", hdr:GetName())
		end
		UpdateBar(hdr)
	end
end

-- Create the bars
local function CreateBars()
	for name, bar in pairs(Nurfed2DB["BarSettings"]) do
		Nurfed2:CreateBar(name, bar)
	end
	Bar_UpdateSkins(true)
end

-- Set Binding Text
local function Button_SetBindingText(self)
	local key = GetBindingKey("CLICK "..self:GetName()..":LeftButton")
	if Nurfed2DB.BarSettings[self:GetParent():GetName()].hotkeys then
		if key then
			self.hotkey:SetText(key)
			self.hotkey:Show()
		else
			self.hotkey:SetText(nil)
			self.hotkey:Hide()
		end
	end
end

-- Button Events
local buttonEvents = {
	PLAYER_ENTERING_WORLD = Button_UpdateAll,

	ACTIONBAR_UPDATE_USABLE = Button_UpdateCooldown,
	ACTIONBAR_UPDATE_COOLDOWN = Button_UpdateCooldown,

	UPDATE_INVENTORY_ALERTS = Button_UpdateCooldown,

	PLAYER_REGEN_ENABLED = Button_SetIcon,
	PLAYER_REGEN_DISABLED = Button_SetIcon,
	
	COMPANION_UPDATE = Button_SetIcon,
	
	N2_ATTRIBUTE_CHANGED = Button_SetIcon,
	
	MODIFIER_STATE_CHANGED = Button_SetIcon,

	ACTIONBAR_UPDATE_STATE = Button_SetIcon,

	UPDATE_BONUS_ACTIONBAR = Button_SetIcon,
	
	ACTIONBAR_SHOWGRID = Button_ShowGrid,
	ACTIONBAR_HIDEGRID = Button_HideGrid,
	
	N2_SETTINGS_UPDATE = Button_SpecChanged,
	N2_BINDINGS_UPDATE = Button_SetBindingText,
	
	BAG_UPDATE = Button_UpdateItem,
	
	START_AUTOREPEAT_SPELL = Button_FlashStart,
	STOP_AUTOREPEAT_SPELL = Button_FlashStop,

	PLAYER_ENTER_COMBAT = Button_FlashStart,
	PLAYER_LEAVE_COMBAT = Button_FlashStop,
}

local function Button_OnEvent(event, ...)
	for _, btn in ipairs(live) do
		buttonEvents[event](btn, ...);
	end
end

local options
local function OptionsLoaded()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Nurfed 2 Action Bars", options)
	Nurfed2.optionsFrames.ActionBars = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Nurfed 2 Action Bars", "Action Bars", "Nurfed 2", "ActionBars")
end

function N2ManageUIPositions()
	local btn
	-- Shaman Totem Bar
	if UnitClass("player") == "Shaman" then
		if Nurfed2DB.BarConfig.Totem.Show then
			N2ManageUISize(Nurfed2_TotemBar)
			Nurfed2_TotemBar:SetScale(Nurfed2DB.BarConfig.Totem.Scale)

			Nurfed2_TotemBar:ClearAllPoints()
			Nurfed2_TotemBar:SetPoint(unpack(Nurfed2DB.BarConfig.Totem.Position or { "CENTER" }))

			MultiCastActionBarFrame:SetParent(Nurfed2_TotemBar)
			MultiCastActionBarFrame:ClearAllPoints()
			MultiCastActionBarFrame:SetPoint("TOPLEFT", Nurfed2_TotemBar, "TOPLEFT", -2, 2)
		end
		for i=1, 12 do
			btn = _G["MultiCastActionButton"..i]
			if btn then
				btn:ClearAllPoints()
				if Nurfed2DB.BarConfig.Totem.Vertical then
					if i == 1 or i == 5 or i == 9 then
						btn:SetPoint("TOP", "MultiCastSummonSpellButton", "BOTTOM", 0, Nurfed2DB.BarConfig.Totem.Offset)
					else
						btn:SetPoint("TOP", "MultiCastActionButton"..(i-1), "BOTTOM", 0, Nurfed2DB.BarConfig.Totem.Offset)
					end
				else
					if i == 1 or i == 5 or i == 9 then
						btn:SetPoint("LEFT", "MultiCastSummonSpellButton", "RIGHT", Nurfed2DB.BarConfig.Totem.Offset, 0)
					else
						btn:SetPoint("LEFT", "MultiCastActionButton"..(i-1), "RIGHT", Nurfed2DB.BarConfig.Totem.Offset, 0)
					end
				end
			end
		end
		if MultiCastActionBarFrame.numActiveSlots > 0 then
			btn = _G["MultiCastRecallSpellButton"]
			btn:ClearAllPoints()
			if Nurfed2DB.BarConfig.Totem.Vertical then
				btn:SetPoint("TOP", "MultiCastActionButton"..MultiCastActionBarFrame.numActiveSlots, "BOTTOM", 0, Nurfed2DB.BarConfig.Totem.Offset)
			else
				btn:SetPoint("LEFT", "MultiCastActionButton"..MultiCastActionBarFrame.numActiveSlots, "RIGHT", Nurfed2DB.BarConfig.Totem.Offset, 0)
			end

			
			for i=1, 4 do
				local btn = _G["MultiCastSlotButton"..i]
				btn:ClearAllPoints()
				if Nurfed2DB.BarConfig.Totem.Vertical then
					if i == 1 then
						btn:SetPoint("TOP", "MultiCastSummonSpellButton", "BOTTOM", 0, Nurfed2DB.BarConfig.Totem.Offset)
					else
						btn:SetPoint("TOP", "MultiCastSlotButton"..(i-1), "BOTTOM", 0, Nurfed2DB.BarConfig.Totem.Offset)
					end
				else
					if i == 1 then
						btn:SetPoint("LEFT", "MultiCastSummonSpellButton", "RIGHT", Nurfed2DB.BarConfig.Totem.Offset, 0)
					else
						btn:SetPoint("LEFT", "MultiCastSlotButton"..(i-1), "RIGHT", Nurfed2DB.BarConfig.Totem.Offset, 0)
					end
				end
			end
			if Nurfed2DB.BarConfig.Totem.Show then
				Nurfed2_TotemBar:Show()
			else
				Nurfed2_TotemBar:Hide()
			end
		end
	end
	
	-- Bags Bar
	for i=0,3 do
		local bag = _G["CharacterBag"..i.."Slot"]
		bag:ClearAllPoints()
		if Nurfed2DB.BarConfig.Bags.Vertical then
			if i == 0 then
				bag:SetPoint("TOP", "MainMenuBarBackpackButton", "BOTTOM", 0, -3)
			else
				bag:SetPoint("TOP", "CharacterBag"..(i-1).."Slot", "BOTTOM", 0, -3)
			end
		else
			if i == 0 then
				bag:SetPoint("RIGHT", "MainMenuBarBackpackButton", "LEFT", -3, 0)
			else
				bag:SetPoint("RIGHT", "CharacterBag"..(i-1).."Slot", "LEFT", -3, 0)
			end
		end
	end
	
	Nurfed2_BagsBar:SetScale(Nurfed2DB.BarConfig.Bags.Scale)
	N2ManageUISize(Nurfed2_BagsBar)

	Nurfed2_BagsBar:ClearAllPoints()
	Nurfed2_BagsBar:SetPoint(unpack(Nurfed2DB.BarConfig.Bags.Position or { "CENTER" }))

	if not Nurfed2DB.BarConfig.Bags.Vertical then
		Nurfed2_BagsBar:SetHeight(32)
		Nurfed2_BagsBar:SetWidth(182)
	else
		Nurfed2_BagsBar:SetHeight(182)
		Nurfed2_BagsBar:SetWidth(32)
	end
	if Nurfed2DB.BarConfig.Bags.Show then
		Nurfed2_BagsBar:Show()
	else
		Nurfed2_BagsBar:Hide()
	end
	
	-- Micro Bar
	Nurfed2_MicroBar:SetScale(Nurfed2DB.BarConfig.Micro.Scale)

	Nurfed2_MicroBar:ClearAllPoints()
	Nurfed2_MicroBar:SetPoint(unpack(Nurfed2DB.BarConfig.Micro.Position or { "CENTER" }))
	
	if Nurfed2DB.BarConfig.Micro.Show then
		Nurfed2_MicroBar:Show()
	else
		Nurfed2_MicroBar:Hide()
	end
	
	-- Stance Bar
	Nurfed2_StanceBar:SetScale(Nurfed2DB.BarConfig.Stance.Scale)

	N2ManageUISize(Nurfed2_StanceBar)
	
	Nurfed2_StanceBar:ClearAllPoints()
	Nurfed2_StanceBar:SetPoint(unpack(Nurfed2DB.BarConfig.Stance.Position or { "CENTER" }))
	
	for i=2, 10 do
		btn = _G["ShapeshiftButton"..i]
		btn:ClearAllPoints()
		if Nurfed2DB.BarConfig.Stance.Vertical then
			btn:SetPoint("TOP", "ShapeshiftButton"..(i-1), "BOTTOM", 0, -(Nurfed2DB.BarConfig.Stance.Offset))
		else
			btn:SetPoint("LEFT", "ShapeshiftButton"..(i-1), "RIGHT", Nurfed2DB.BarConfig.Stance.Offset, 0)
		end
	end
	if Nurfed2DB.BarConfig.Stance.Show then
		Nurfed2_StanceBar:Show()
	else
		Nurfed2_StanceBar:Hide()
	end
end

function N2ManageUISize(bar)
	local width, height = 4, 4
	
	if bar == Nurfed2_TotemBar then
		for i=1,4 do
			if Nurfed2DB.BarConfig.Totem.Vertical then
				width = (_G["MultiCastActionButton"..i]:GetWidth())
				height = height + (_G["MultiCastActionButton"..i]:GetHeight() + -(Nurfed2DB.BarConfig.Totem.Offset))
			else
				width = width + (_G["MultiCastActionButton"..i]:GetWidth() + Nurfed2DB.BarConfig.Totem.Offset)
				height = (_G["MultiCastActionButton"..i]:GetHeight())
			end
		end
		if Nurfed2DB.BarConfig.Totem.Vertical then
			height = height + (_G["MultiCastSummonSpellButton"]:GetHeight() + -(Nurfed2DB.BarConfig.Totem.Offset))
			height = height + (_G["MultiCastRecallSpellButton"]:GetHeight() + -(Nurfed2DB.BarConfig.Totem.Offset))
		else
			width = width + (_G["MultiCastSummonSpellButton"]:GetWidth() + (Nurfed2DB.BarConfig.Totem.Offset))
			width = width + (_G["MultiCastRecallSpellButton"]:GetWidth() + (Nurfed2DB.BarConfig.Totem.Offset))
		end
	else
		local children = { bar:GetChildren() }
		for i, frame in ipairs(children) do
			if not frame:GetName():find("drag$") and frame:IsShown() then
				if Nurfed2DB.BarConfig[bar:GetName():gsub("^Nurfed2_", "", 1):gsub("Bar$", "")].Vertical then
					width = frame:GetWidth()
					height = height + frame:GetHeight() + (Nurfed2DB.BarConfig[bar:GetName():gsub("^Nurfed2_", "", 1):gsub("Bar$", "")].Offset or 0)
				else
					width = width + frame:GetWidth() + (Nurfed2DB.BarConfig[bar:GetName():gsub("^Nurfed2_", "", 1):gsub("Bar$", "")].Offset or 0)
					height = frame:GetHeight()
				end
			end
		end
	end
	bar:SetHeight(height)
	bar:SetWidth(width)
	if _G[bar:GetName().."drag"] then
		_G[bar:GetName().."drag"]:GetScript("OnShow")(_G[bar:GetName().."drag"])
	end
end

-- Blizzard Removal Settings
local function LoadBlizzardSettings()
	-- Shaman Bar
	if UnitClass("player") == "Shaman" then
		if not _G["Nurfed2_TotemBar"] then
			Nurfed2:Create("Nurfed2_TotemBar", "actionbar")

			Nurfed2_TotemBar:SetAttribute("unit", "player")
			
			hooksecurefunc(Nurfed2_TotemBar, "StopMovingOrSizing", Bar_SavePosition)
			hooksecurefunc(Nurfed2_TotemBar, "SetPoint", Bar_SavePointPosition)
			hooksecurefunc("MultiCastRecallSpellButton_Update", N2ManageUIPositions)
			hooksecurefunc("MultiCastSlotButton_OnEnter", function()
				MultiCastFlyoutFrame:SetFrameStrata("HIGH")
				MultiCastFlyoutFrameOpenButton:SetFrameStrata("HIGH")
			end)
						
			Nurfed2_TotemBar.blizz = true
			Nurfed2_TotemBardragtext:SetText("Totem Bar")
			Nurfed2_TotemBardragtext2:SetText("Totem Bar")
			Nurfed2_TotemBar:SetScale(Nurfed2DB.BarConfig.Totem.Scale)

			Nurfed2_TotemBar:ClearAllPoints()
			Nurfed2_TotemBar:SetPoint(unpack(Nurfed2DB.BarConfig.Totem.Position or { "CENTER" }))

			MultiCastActionBarFrame:SetParent(Nurfed2_TotemBar)
			MultiCastActionBarFrame:ClearAllPoints();
			MultiCastActionBarFrame:SetAllPoints(Nurfed2_TotemBar)
			if lbfg then
				Nurfed2_TotemBar.lbf = lbf:Group("Nurfed 2", "Blizzard Bars", "Nurfed2_TotemBar")
			end
		end
		if Nurfed2DB.BarConfig.Totem.Show then
			Nurfed2_TotemBar:Show()
		else
			Nurfed2_TotemBar:Hide()
		end
	end
	
	-- Bag Bar
	if not Nurfed2_BagsBar then
		Nurfed2:Create("Nurfed2_BagsBar", "actionbar")

		KeyRingButton:SetParent(Nurfed2_BagsBar)
		KeyRingButton:ClearAllPoints()
		KeyRingButton:SetPoint("TOPRIGHT", "CharacterBag3Slot", "TOPLEFT", -2, 0)
		KeyRingButton:SetHeight(CharacterBag1Slot:GetHeight())

		MainMenuBarBackpackButton:SetParent(Nurfed2_BagsBar)
		MainMenuBarBackpackButton:SetWidth(CharacterBag1Slot:GetWidth())
		MainMenuBarBackpackButton:SetHeight(CharacterBag1Slot:GetHeight())
		MainMenuBarBackpackButtonNormalTexture:SetHeight(CharacterBag1SlotNormalTexture:GetHeight())
		MainMenuBarBackpackButtonNormalTexture:SetWidth(CharacterBag1SlotNormalTexture:GetWidth())
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("TOPRIGHT", Nurfed2_BagsBar, "TOPRIGHT",0, -2)
		
		if lbfg then
			Nurfed2_BagsBar.lbf = lbf:Group("Nurfed 2", "Blizzard Bars", "Nurfed2_BagsBar")
		end
		
		for i=0,3 do
			_G["CharacterBag"..i.."Slot"]:SetParent(Nurfed2_BagsBar)
			if lbfg then
				Nurfed2_BagsBar.lbf:AddButton(_G["CharacterBag"..i.."Slot"])
			end
		end

		Nurfed2_BagsBardragtext:SetText("Bags")
		Nurfed2_BagsBardragtext2:SetText("Bags")
		hooksecurefunc(Nurfed2_BagsBar, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(Nurfed2_BagsBar, "SetPoint", Bar_SavePointPosition)
		Nurfed2_BagsBar.blizz = true
	end
		
	-- micro bar
	if not Nurfed2_MicroBar then
		Nurfed2:Create("Nurfed2_MicroBar", "actionbar")
		
		Nurfed2_MicroBardragtext:SetText("Micro Bar")	
		Nurfed2_MicroBardragtext2:SetText("Micro Bar")
		Nurfed2_MicroBar:SetWidth(254)
		Nurfed2_MicroBar:SetHeight(32)
		
		CharacterMicroButton:SetParent(Nurfed2_MicroBar)
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint("BOTTOMLEFT", Nurfed2_MicroBar, "BOTTOMLEFT", 0, -3)


		local children = { MainMenuBarArtFrame:GetChildren() }
		for _, child in ipairs(children) do
			local name = child:GetName()
			if name:find("MicroButton", 1, true) then 
				child:SetParent(Nurfed2_MicroBar)
			end
		end
		local children = { VehicleMenuBarArtFrame:GetChildren() }
		for _, child in ipairs(children) do
			local name = child:GetName()
			if name:find("MicroButton", 1, true) then 
				child:SetParent(Nurfed2_MicroBar)
			end
		end
		
		Nurfed2_MicroBar.blizz = true
		hooksecurefunc(Nurfed2_MicroBar, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(Nurfed2_MicroBar, "SetPoint", Bar_SavePointPosition)
	end
	
	
	-- Stance Bar
	if not Nurfed2_StanceBar then
		Nurfed2:Create("Nurfed2_StanceBar", "actionbar")
		Nurfed2_StanceBardragtext:SetText("Stance Bar")
		Nurfed2_StanceBardragtext2:SetText("Stance Bar")
		Nurfed2_StanceBar:SetHeight(32)
		Nurfed2_StanceBar:SetWidth(195)
		if lbfg then
			Nurfed2_StanceBar.lbf = lbf:Group("Nurfed 2", "Blizzard Bars", "Nurfed2_StanceBar")
		end
		for i = 1, 10 do
			local btn = _G["ShapeshiftButton"..i]
			local cooldown = _G["ShapeshiftButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			if lbfg then
				Nurfed2_StanceBar.lbf:AddButton(btn)
			end
			_G[btn:GetName().."NormalTexture"]:SetAlpha(0)
			btn:SetParent(Nurfed2_StanceBar)
			btn:SetScript("OnUpdate", Nurfed2.CooldownText)
			
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("TOPLEFT")
			end
		end
		Nurfed2_StanceBar.blizz = true
		hooksecurefunc(Nurfed2_StanceBar, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(Nurfed2_StanceBar, "SetPoint", Bar_SavePointPosition)

		ShapeshiftBar_Update = function() end
	end
	
	-- Pet Bar
	if not Nurfed2_PetBar then
		Nurfed2:Create("Nurfed2_PetBar", "actionbar")
		Nurfed2_PetBar:SetAttribute("unit", "pet")
		
		Nurfed2_PetBardragtext:SetText("Pet Bar")
		Nurfed2_PetBardragtext2:SetText("Pet Bar")
		
		if lbfg then
			Nurfed2_PetBar.lbf = lbf:Group("Nurfed 2", "Blizzard Bars", "Nurfed2_PetBar")
		end
		for i=1, 10 do
			local btn = _G["PetActionButton"..i]
			local cooldown = _G["PetActionButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			if lbfg then
				Nurfed2_PetBar.lbf:AddButton(btn)
			end
			btn:SetParent(Nurfed2_PetBar)
			btn:SetScript("OnUpdate", Nurfed2.CooldownText)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("BOTTOMLEFT")
			end
		end

		Nurfed2_PetBar.blizz = true
		hooksecurefunc(Nurfed2_PetBar, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(Nurfed2_PetBar, "SetPoint", Bar_SavePointPosition)
	end

	Nurfed2_PetBar:SetScale(Nurfed2DB.BarConfig.Pet.Scale)
	
	Nurfed2_PetBar:ClearAllPoints()
	Nurfed2_PetBar:SetPoint(unpack(Nurfed2DB.BarConfig.Pet.Position or { "CENTER" }))
	
	for i=2, 10 do
		local btn = _G["PetActionButton"..i]
		btn:ClearAllPoints()
		if Nurfed2DB.BarConfig.Pet.Vertical then
			btn:SetPoint("TOP", "PetActionButton"..(i-1), "BOTTOM", 0, Nurfed2DB.BarConfig.Pet.Offset)
		else
			btn:SetPoint("LEFT", "PetActionButton"..(i-1), "RIGHT", Nurfed2DB.BarConfig.Pet.Offset, 0)
		end
	end
	
	if Nurfed2DB.BarConfig.Pet.Show then
		RegisterUnitWatch(Nurfed2_PetBar)
		Nurfed2_PetBar:Show()
	else
		UnregisterUnitWatch(Nurfed2_PetBar)
		Nurfed2_PetBar:Hide()
	end
	-- New Vehicle Bar Code: Attempt #3
	if not Nurfed2_VehicleBar then
		--Nurfed2:Create("Nurfed2_VehicleBar", "actionbar", Nurfed2_StateHandler)
		Nurfed2:Create("Nurfed2_VehicleBar", "vehiclebar")
		Nurfed2_VehicleBar:Show()
		Nurfed2_VehicleBardragtext:SetText("Vehicle Bar")
		Nurfed2_VehicleBardragtext2:SetText("Vehicle Bar")
		
		Nurfed2_VehicleBar:SetPoint("LEFT")
		
		Nurfed2_VehicleBar:SetScript("OnEvent", function(self, event)
			if event == "UNIT_ENTERED_VEHICLE" and arg1 == "player" then
				self:UpdateButtonVisibility()
			end
		end)
		Nurfed2_VehicleBar:RegisterEvent('UNIT_ENTERED_VEHICLE')
		Nurfed2_VehicleBar:RegisterEvent('UNIT_ENTERING_VEHICLE')
		
		UnregisterStateDriver(Nurfed2_VehicleBar.header, "visibility", "show")
		Nurfed2_VehicleBar.header:Show()
		
		function Nurfed2_VehicleBar:UpdateButtonVisibility()
			if IsVehicleAimAngleAdjustable() then
				_G["VehicleMenuBarPitchUpButton"]:Show()
				_G["VehicleMenuBarPitchDownButton"]:Show()
				_G["VehicleMenuBarPitchSlider"]:Show()
			else
				_G["VehicleMenuBarPitchUpButton"]:Hide()
				_G["VehicleMenuBarPitchDownButton"]:Hide()
				_G["VehicleMenuBarPitchSlider"]:Hide()
			end

			if CanExitVehicle() then
				_G["VehicleMenuBarLeaveButton"]:Show()
			else
				_G["VehicleMenuBarLeaveButton"]:Hide()
			end
		end
		Nurfed2_VehicleBar:UpdateButtonVisibility()
		
		Nurfed2_VehicleBar.blizz = true
		hooksecurefunc(Nurfed2_VehicleBar, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(Nurfed2_VehicleBar, "SetPoint", Bar_SavePointPosition)
		
		-- hijack exit button
		local btn = getglobal("VehicleMenuBarLeaveButton")
		btn:SetParent(Nurfed2_VehicleBar.header)
		btn:ClearAllPoints()
		btn:SetPoint("TOPLEFT", Nurfed2_VehicleBar.header, "TOPLEFT", -6, 0)
		btn:GetNormalTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
		btn:GetNormalTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
		btn:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
		btn:GetPushedTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
		btn:SetWidth(24)
		btn:SetHeight(24)
		Nurfed2_VehicleBar.exit = btn

		-- hijack pitch slider
		btn = getglobal("VehicleMenuBarPitchSlider")
		btn:SetParent(Nurfed2_VehicleBar)
		btn:ClearAllPoints();
		btn:SetPoint("TOPRIGHT", Nurfed2_VehicleBar.exit, "TOPLEFT", 0, 2)
		Nurfed2_VehicleBar.slider = btn
		--
		-- hijack pitchup button
		btn = getglobal("VehicleMenuBarPitchUpButton")
		btn:SetParent(Nurfed2_VehicleBar)
		btn:GetNormalTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Pitch-Up")
		btn:GetNormalTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
		btn:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Pitch-Down")
		btn:GetPushedTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
		btn:SetWidth(24)
		btn:SetHeight(24)
		btn:ClearAllPoints()
		btn:SetPoint("TOPRIGHT", Nurfed2_VehicleBar.exit, "BOTTOMRIGHT", 0, -2)
		Nurfed2_VehicleBar.pitchup = btn
		--
		-- hijack pitch down
		btn = getglobal("VehicleMenuBarPitchDownButton")
		btn:SetParent(Nurfed2_VehicleBar)
		btn:GetNormalTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-PitchDown-Up")
		btn:GetNormalTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
		btn:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-PitchDown-Down")
		btn:GetPushedTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
		btn:SetWidth(24)
		btn:SetHeight(24)
		btn:ClearAllPoints()
		btn:SetPoint("TOPRIGHT", Nurfed2_VehicleBar.pitchup, "BOTTOMRIGHT", 0, -2)
		Nurfed2_VehicleBar.pitchdown = btn

		MainMenuBar_ToPlayerArt = function() end
		MainMenuBar_ToVehicleArt = function() end

		RegisterStateDriver(Nurfed2_VehicleBar.header, "visibility", "[@vehicle,exists]show;hide")

	end
	Nurfed2_VehicleBar:SetScale(Nurfed2DB.BarConfig.Vehicle.Scale)

	Nurfed2_VehicleBar:ClearAllPoints()
		-- Remove this at release
	if Nurfed2DB.BarConfig.Vehicle.Position then
		for i,v in pairs(Nurfed2DB.BarConfig.Vehicle.Position) do
			if type(v) == "string" and v:find("StateHand") then
				Nurfed2DB.BarConfig.Vehicle.Position = nil;
				break
			end
		end
	end
	Nurfed2_VehicleBar:SetPoint(unpack(Nurfed2DB.BarConfig.Vehicle.Position or { "CENTER" }))
	
	-- Posseess Bar
	if not Nurfed2_PossessBar then
		-- Create the possess bar
		Nurfed2:Create("Nurfed2_PossessBar", "vehiclebar")
		Nurfed2_PossessBardragtext:SetText("Possess Bar")
		Nurfed2_PossessBardragtext2:SetText("Possess Bar")
		Nurfed2_PossessBar:SetPoint("RIGHT")
		Nurfed2_PossessBar.header:Show()
		if lbfg then
			Nurfed2_PossessBar.lbf = lbf:Group("Nurfed 2", "Blizzard Bars", "Nurfed2_PossessBar")
		end
		for i = 1, NUM_BONUS_ACTION_SLOTS do
			local btn = _G["BonusActionButton"..i]
			local cooldown = _G["BonusActionButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			if lbfg then
				Nurfed2_PossessBar.lbf:AddButton(btn)
			end
			btn:SetParent(Nurfed2_PossessBar.header)
			btn:SetScript("OnUpdate", Nurfed2.CooldownText)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("BOTTOMLEFT")
			end
			_G["BonusActionButton"..i.."NormalTexture"]:Hide()
			_G["BonusActionButton"..i.."NormalTexture"]:SetAlpha(0)
			Nurfed2_PossessBar.header:SetFrameRef("btn"..i, btn)
			btn:Show()
		end
		
		Nurfed2_PossessBar.blizz = true
		hooksecurefunc(Nurfed2_PossessBar, "StopMovingOrSizing", Bar_SavePosition)
		hooksecurefunc(Nurfed2_PossessBar, "SetPoint", Bar_SavePointPosition)
		UnregisterStateDriver(Nurfed2_PossessBar.header, "visibility", "show")
		Nurfed2_PossessBar.header:SetAttribute("_onstate-possess", [[
			if newstate == "possess" then
				for i=1, 12 do
					local key
					if i == 10 then key = 0 elseif i == 11 then key = "-" elseif i == 12 then key = "=" else key = i end
					self:SetBindingClick(true, key, self:GetFrameRef("btn"..i))
				end
			else
				self:ClearBindings()
			end
		]])
		RegisterStateDriver(Nurfed2_PossessBar.header, "possess", "[bonusbar:5]possess;nopossess")
		RegisterStateDriver(Nurfed2_PossessBar.header, "visibility", "[bonusbar:5]show;hide")
	end
	for i=2, NUM_BONUS_ACTION_SLOTS do
		local btn = _G["BonusActionButton"..i]
		btn:ClearAllPoints();
		if Nurfed2DB.BarConfig.Possess.Vertical then
			btn:SetPoint("TOP", "BonusActionButton"..(i-1), "BOTTOM", 0, Nurfed2DB.BarConfig.Possess.Offset)
		else
			btn:SetPoint("LEFT", "BonusActionButton"..(i-1), "RIGHT", Nurfed2DB.BarConfig.Possess.Offset, 0)
		end
		btn:Show()
	end
	
	Nurfed2_PossessBar:SetScale(Nurfed2DB.BarConfig.Possess.Scale)

	Nurfed2_PossessBar:ClearAllPoints()
		-- Remove this at release
	if Nurfed2DB.BarConfig.Possess.Position then
		for i,v in pairs(Nurfed2DB.BarConfig.Possess.Position) do
			if type(v) == "string" and v:find("StateHand") then
				Nurfed2DB.BarConfig.Possess.Position = nil;
				break
			end
		end
	end
	Nurfed2_PossessBar:SetPoint(unpack(Nurfed2DB.BarConfig.Possess.Position or { "CENTER" }))
	Nurfed2_PossessBar:Show()
	
	
	
	
	-- End new vehicle bar code.
	N2ManageUIPositions()
	MainMenuBar:Hide()	
end

-- Basic Initial Onload shit
local function OnLoad()
	Nurfed2:FeedDefaultSettings("BarSettings", defaultBarSettings, true)
	Nurfed2:FeedDefaultSettings("SpellSettings", defaultSpellSettings)
	Nurfed2:FeedDefaultSettings("BarConfig", defaultBarConfig)
	local function Bar_OnLoad(self)
		self:RegisterForDrag("LeftButton")
		Nurfed2:RegisterLock(self)
		if not Nurfed2:IsLocked() then self:Show() end
	end
	local function Bar_OnAttributeChanged(self)
		if Nurfed2:IsLocked() then
			self:Hide()
		end
	end
	local function Bar_OnDragStart(self)
		self:GetParent():StartMoving()
	end
	local function Bar_OnDragStop(self)
		self:GetParent():StopMovingOrSizing()
		self:GetParent():SetUserPlaced(true)
	end
	local function Bar_OnMouseDown(self, button)
		if button ~= "LeftButton" then return end
		self:GetParent():StartMoving()	
	end
	local function Bar_OnMouseUp(self, button)
		if button ~= "LeftButton" then return end
		self:GetParent():StopMovingOrSizing()
	end
	local function Bar_OnShow(self)
		self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", -12.5, 12.5)
		self:SetWidth(self:GetParent():GetWidth()+25)
		self:SetHeight(self:GetParent():GetHeight()+25)
		if Nurfed2DB.BarSettings[self:GetParent():GetName()] and Nurfed2DB.BarSettings[self:GetParent():GetName()].noclick then
			for i, tbl in ipairs({ self:GetParent():GetChildren() }) do
				if not tbl:GetName():find("drag") then
					tbl:EnableMouse(1)
				end
			end
		end
	end
	local function Bar_OnHide(self)
		self:SetFrameStrata("LOW")
		if Nurfed2DB.BarSettings[self:GetParent():GetName()] and Nurfed2DB.BarSettings[self:GetParent():GetName()].noclick then
			for i, tbl in ipairs({ self:GetParent():GetChildren() }) do
				if not tbl:GetName():find("drag") then
					tbl:EnableMouse(0)
				end
			end
		end
	end
	Nurfed2:CreateTemp("vehiclebar", {
		type = "Frame",
		--uitemp = "SecureHandlerStateTemplate SecureHandlerClickTemplate",
		size = { 36, 36 },
		Movable = true,
		Hide = true,
		Point = { "CENTER" },
		ClampedToScreen = true,
		children = {
			header = {
				type = "Frame",
				uitemp = "SecureHandlerStateTemplate",
				SetAllPoints = true,
				OnLoad = function(self) self:GetParent().header = self; end,
			},
			drag = {
				type = "Frame",
				Mouse = true,
				size = { 110, 13 },
				Hide = true,
				Backdrop = {
					bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
					edgeFile = nil,
					tile = true,
					tileSize = 16,
					edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }
				},
				BackdropColor = { 0, 0, 0, 0.5 },
				Point = { "TOPLEFT", "$parent", "BOTTOMLEFT" },
				OnLoad = Bar_OnLoad,
				OnAttributeChanged = Bar_OnAttributeChanged,
				OnDragStart = Bar_OnDragStart,
				OnDragStop = Bar_OnDragStop,
				OnMouseUp = Bar_OnMouseUp,
				OnMouseDown = Bar_OnMouseDown,
				OnShow = Bar_OnShow,
				OnHide = Bar_OnHide,
				children = {
					text = {
						type = "FontString",
						Point = { "TOP" },
						FontObject = "GameFontNormalSmall",
						JustifyH = "TOP",
						TextColor = { 1, 1, 1 },
					},
					text2 = {
						type = "FontString",
						Point = { "BOTTOM" },
						FontObject = "GameFontNormalSmall",
						JustifyH = "BOTTOM",
						TextColor = { 1, 1, 1 },
					},
				}
			}
		}
	})
	Nurfed2:CreateTemp("actionbar", {
		type = "Frame",
		uitemp = "SecureHandlerStateTemplate SecureHandlerClickTemplate",
		size = { 36, 36 },
		Movable = true,
		Hide = true,
		Point = { "CENTER" },
		ClampedToScreen = true,
		children = {
			drag = {
				type = "Frame",
				Mouse = true,
				size = { 110, 13 },
				Hide = true,
				Backdrop = {
					bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
					edgeFile = nil,
					tile = true,
					tileSize = 16,
					edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }
				},
				BackdropColor = { 0, 0, 0, 0.5 },
				Point = { "TOPLEFT", "$parent", "BOTTOMLEFT" },
				OnLoad = Bar_OnLoad,
				OnAttributeChanged = Bar_OnAttributeChanged,
				OnDragStart = Bar_OnDragStart,
				OnDragStop = Bar_OnDragStop,
				OnMouseUp = Bar_OnMouseUp,
				OnMouseDown = Bar_OnMouseDown,
				OnShow = Bar_OnShow,
				OnHide = Bar_OnHide,
				children = {
					text = {
						type = "FontString",
						Point = { "TOP" },
						FontObject = "GameFontNormalSmall",
						JustifyH = "TOP",
						TextColor = { 1, 1, 1 },
					},
					text2 = {
						type = "FontString",
						Point = { "BOTTOM" },
						FontObject = "GameFontNormalSmall",
						JustifyH = "BOTTOM",
						TextColor = { 1, 1, 1 },
					},
				}
			}
		}
	})
	for event, _ in pairs(buttonEvents) do
		Nurfed2:RegEvent(event, Button_OnEvent)
	end
	Nurfed2:Schedule(TOOLTIP_UPDATE_TIME, Button_UpdateColors, true)
	Nurfed2:RegEvent("N2_OPTIONS_LOADED", OptionsLoaded)
	if lbf then
		if not lbfg then
			lbfg = lbf:Group("Nurfed 2")
			if lbfg then
				lbf:Group("Nurfed 2", "Virtual Bars")
				lbf:Group("Nurfed 2", "Blizzard Bars")
				lbf:RegisterSkinCallback("Nurfed 2", Bar_UpdateSkins)
			end
		
		end
	end
	LoadBlizzardSettings()
	CreateBars()
	hooksecurefunc("UIParent_ManageFramePosition", N2ManageUIPositions)
	hooksecurefunc("UIParent_ManageFramePositions", N2ManageUIPositions)
end
-------------options settings------------------------------------------------------
local testName
local function UpdateBarStuff()
	UpdateBar(_G[testName])
end

local function createActionBarGroups()
	local tbl = options.args.ActionBars.args.CurrentBars.args
	for name in pairs(Nurfed2DB.BarSettings) do
		if not tbl[name] then
			tbl[name] = {
				type = "group",
				inline = true,
				name = name,
				get = function(info)
					local val = info[#info]
					if Nurfed2DB.BarSettings[name] then
						local db = Nurfed2DB.BarSettings[name].statemaps
						if val == "stealth" then
							return db["stealth:0"] == "s1" and db["stealth:1"] == "s2"
						elseif val == "druidstealth" then
							return db["actionbar:1, stance:0"] == "s0"
							and db["actionbar:1, stance:1"] == "s1"
							and db["actionbar:1, stance:2"] == "s2"
							and db["actionbar:1, stance:3, nostealth"] == "s3"
							and db["actionbar:1, stance:3, stealth"] == "st3"
							and db["actionbar:1, stance:4"] == "s4"
							and db["actionbar:1, stance:5"] == "s5"
							and db["actionbar:2"] == "p2"
							and db["actionbar:3"] == "p3"
							
						elseif val == "druidnostealth" then
							return db["actionbar:1, stance:0"] == "s0"
							and db["actionbar:1, stance:1"] == "s1"
							and db["actionbar:1, stance:2"] == "s2"
							and db["actionbar:1, stance:3"] == "s3"
							and db["actionbar:1, stance:4"] == "s4"
							and db["actionbar:1, stance:5"] == "s5"
							and db["actionbar:2"] == "p2"
							and db["actionbar:3"] == "p3"
							
						elseif val == "warrior" then
							return db["stance:1"] == "s1" and db["stance:2"] == "s2" and db["stance:3"] == "s3"
						end
						return Nurfed2DB.BarSettings[name][val]
					end
					return nil
				end,
				hidden = function(info)
					if Nurfed2DB.BarSettings[info[#info]] or Nurfed2DB.BarSettings[info[#info-1]] then
						return false
					end
					return true
				end,
				set = function(info, val)
					-- todo: Clean this shit up
					local tinfo = info[#info]
					testName = name;
					if tinfo == "statemaps" then
						local state = string.match(val, "^%[%S+%]"); state = state:gsub("^%[", ""):gsub("%]", "");
						local value = val:match("%]%S+"); value = value:gsub("%]", "");
						
						Nurfed2DB.BarSettings[name]["statemaps"][state] = value
						
					elseif tinfo == "stealth" then
						if val then
							Nurfed2DB.BarSettings[name].statemaps = { ["stealth:0"] = "s1", ["stealth:1"] = "s2" }
						else
							Nurfed2DB.BarSettings[name].statemaps = { }
						end
					elseif tinfo == "druidstealth" then
						if val then
							Nurfed2DB.BarSettings[name].statemaps = { 
								["actionbar:1, stance:0"] = "s0", ["actionbar:1, stance:1"] = "s1",
								["actionbar:1, stance:2"] = "s2", ["actionbar:1, stance:3, nostealth"] = "s3",
								["actionbar:1, stance:3, stealth"] = "st3", ["actionbar:1, stance:4"] = "s4",
								["actionbar:1, stance:5"] = "s5", ["actionbar:2"] = "p2", ["actionbar:3"] = "p3",
							 }
						else
							Nurfed2DB.BarSettings[name].statemaps = { }
						end
					elseif tinfo == "druidnostealth" then
						if val then
							Nurfed2DB.BarSettings[name].statemaps = { 
								["actionbar:1, stance:0"] = "s0", ["actionbar:1, stance:1"] = "s1",
								["actionbar:1, stance:2"] = "s2", ["actionbar:1, stance:3"] = "s3",
								["actionbar:1, stance:4"] = "s4", ["actionbar:1, stance:5"] = "s5",
								["actionbar:2"] = "p2", ["actionbar:3"] = "p3"
							}
						else
							Nurfed2DB.BarSettings[name].statemaps = { }
						end
					
					elseif tinfo == "warrior" then
						if val then
							Nurfed2DB.BarSettings[name].statemaps = { 
								["stance:1"] = "s1",
								["stance:2"] = "s2",
								["stance:3"] = "s3",
							}
						else
							Nurfed2DB.BarSettings[name].statemaps = { }
						end
					else
						Nurfed2DB.BarSettings[name][tinfo] = val
					end
					Nurfed2:Unschedule(UpdateBarStuff)
					Nurfed2:Schedule(0.05, UpdateBarStuff)
				end,
				args = {
					rows = {
						type = "range",
						name = "Rows",
						order = 2,
						min = 1,
						max = 16,
						step = 1,
						--width = "half",
					},
					cols = {
						type = "range",
						name = "Columns",
						order = 3,
						min = 1,
						max = 16,
						step = 1,
						----width = "half",
					},
					scale = {
						type = "range",
						name = "Scale",
						order = 4,
						min = 0.1,
						max = 5,
						step = 0.01,
						bigStep = 0.25,
						--width = "half",
					},
					alpha = {
						type = "range",
						name = "Alpha",
						order = 5,
						min = 0,
						max = 1,
						step = 0.01,
						bigStep = 0.25,
						--width = "half",
					},
					xgap = {
						type = "range",
						name = "X Gap",
						order = 6,
						min = -100,
						max = 100,
						step = 0.01,
						bigStep = 1,
						--width = "half",
					},
					ygap = {
						type = "range",
						name = "Y Gap",
						order = 7,
						min = -100,
						max = 100,
						step = 0.01,
						bigStep = 1,
						--width = "half",
					},
					noclick = {
						type = "toggle",
						name = "Click Through",
						order = 8,
						desc = "Disable clicking on the bar",
					},
					statemaps = {
						type = "input",
						name = "States",
						order = 20,
						desc = "WARNING:  ADVANCED USERS ONLY!",
					},
					visible = {
						type = "input",
						name = "Visible",
						order = 21,
						desc = "WARNING: ADVANCED USERS ONLY!",
					},
					stealth = {
						type = "toggle",
						name = "Stealth",
						order = -1,
						desc = "Rogue stealth bar",
					},
					druidstealth = {
						type = "toggle",
						name = "Druid-Stealth",
						order = -1,
						desc = "Druid Stealth Bar",
					},
					druidnostealth = {
						type = "toggle",
						name = "Druid-NoStealth",
						order = -1,
						desc = "Druid non-stealth bar.",
					},
					warrior = {
						type = "toggle",
						name = "Warrior Stance",
						order = -1,
						desc = "Warrior Stance Bar",
					},
					hideMacroText = {
						type = "toggle",
						name = "Hide Macro Text",
						order = -1,
						desc = "Hides the name of macros on your bar",
					},
					remove = {
						type = "execute",
						name = "Remove",
						order = -1,
						desc = "Remove this bar",
						confirm = function(info)
							return "Are you sure you wish to remove"..info[#info-1].."?"
						end,
						func = function(info, val)
							Nurfed2:DeleteBar(info[#info-1])
						end,
					},
				},
			}
		end
	end
	LibStub("AceConfigRegistry-3.0"):NotifyChange("Nurfed 2")
end

local newName, newRows, newCols, newScale, newAlpha, newUnitShow, newXGap, newYGap, newStateMaps, newVisible = "Rename Me", 1, 1, 1, 1, nil, 1, 1, nil, "show";
options = {
	type = "group",
	order = 2,
	args = {
		["ActionBars"] = {
			type = "group",
			name = "Action Bars",
			childGroups = "tab",
			order = 2,
			args = {
				text = {
					type = "description",
					name = function() 
						createActionBarGroups(); 
						return "Action Bar Settings"; 
					end,
					order = 0,
				},
				CurrentBars = {
					type = "group",
					name = "Existing Bars",
					order = 1,
					args = {
							
					},
				},
				CreateBar = {
					type = "group",
					name = "Create",
					order = 2,
					args = {
						Name = {
							type = "input",
							name = "Name",
							order = 1,
							validate = function(info, val)
								if _G[val] then 
									return "Invalid Name"
								end
								return true
							end,
							set = function(info, val) newName = val; end,
							get = function() return newName; end,
						},
						Rows = {
							type = "range",
							name = "Rows",
							order = 2,
							min = 1,
							max = 16,
							step = 1,
							set = function(info, val) newRows = val; end,
							get = function() return newRows; end,
						},
						Cols = {
							type = "range",
							name = "Columns",
							order = 3,
							min = 1,
							max = 16,
							step = 1,
							set = function(info, val) newCols = val; end,
							get = function() return newCols; end,
						},
						Scale = {
							type = "range",
							name = "Scale",
							order = 4,
							min = 0.1,
							max = 5,
							step = 0.01,
							bigStep = 0.25,
							set = function(info, val) newScale = val; end,
							get = function() return newScale; end,
						},
						Alpha = {
							type = "range",
							name = "Alpha",
							order = 5,
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = 0.25,
							set = function(info, val) newAlpha = val; end,
							get = function() return newAlpha; end,
						},
						XGap = {
							type = "range",
							name = "X Gap",
							order = 6,
							min = -5,
							max = 5,
							step = 0.01,
							bigStep = 1,
							set = function(info, val) newXGap = val; end,
							get = function() return newXGap; end,
						},
						YGap = {
							type = "range",
							name = "Y Gap",
							order = 7,
							min = -5,
							max = 5,
							step = 0.01,
							bigStep = 1,
							set = function(info, val) newYGap = val; end,
							get = function() return newYGap; end,
						},
						Create = {
							type = "execute",
							name = "Create",
							order = -1,
							confirm = function() return "Are you sure you wish to create this bar?"; end,
							func = function()
								if not newName then return end	
								Nurfed2DB["BarSettings"][newName] = {
									rows = newRows or 1,
									cols = newCols or 12,
									scale = newScale or 1,
									alpha = newAlpha or 1,
									unitshow = newUnitShow or false,
									xgap = newXGap or 2,
									ygap = newYGap or 2,
									statemaps = newStateMaps or { },
									visible = newVisible or "show",
								}
								Nurfed2DB["SpellSettings"][newName] = { }
								if Nurfed2DB.MultiSpec.SpellSettings then
									Nurfed2DB.MultiSpecSettings[1].SpellSettings[newName] = { }
									Nurfed2DB.MultiSpecSettings[2].SpellSettings[newName] = { }
								end 
								
								Nurfed2:CreateBar(newName, Nurfed2DB["BarSettings"][newName])
								newName, newRows, newCols, newScale, newAlpha, newUnitShow, newXGap, newYGap, newStateMaps, newVisible = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
							end,
						},
					},
				},
				BarSettings = {
					type = "group",
					name = "Settings",
					order = 1000,
					childGroups = "tree",
					args = {
						Bags = {
							type = "group",
							name = "Bags",
							get = function(info)
								return Nurfed2DB.BarConfig.Bags[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Bags[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Show = {
									type = "toggle",
									name = "Show",
									order = 1,
								},
								Vertical = {
									type = "toggle",
									name = "Vertical",
									disabled = function() return not Nurfed2DB.BarConfig.Bags.Show end,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
									disabled = function() return not Nurfed2DB.BarConfig.Bags.Show end,
								},
							},
						},
						Micro = {
							type = "group",
							name = "Micro",
							get = function(info)
								return Nurfed2DB.BarConfig.Micro[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Micro[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Show = {
									type = "toggle",
									name = "Show",
									order = 1,
								},
								Vertical = {
									type = "toggle",
									name = "Vertical",
									disabled = function() return not Nurfed2DB.BarConfig.Micro.Show end,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
									disabled = function() return not Nurfed2DB.BarConfig.Micro.Show end,
								},
							},
						},
						Pet = {
							type = "group",
							name = "Pet",
							get = function(info)
								return Nurfed2DB.BarConfig.Pet[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Pet[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Show = {
									type = "toggle",
									name = "Show",
									order = 1,
								},
								Vertical = {
									type = "toggle",
									name = "Vertical",
									disabled = function() return not Nurfed2DB.BarConfig.Pet.Show end,
								},
								Offset = {
									type = "range",
									name = "Offset",
									min = -50,
									max = 50,
									disabled = function() return not Nurfed2DB.BarConfig.Pet.Show end,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
									disabled = function() return not Nurfed2DB.BarConfig.Pet.Show end,
								},
							},
						},
						Stance = {
							type = "group",
							name = "Stance",
							get = function(info)
								return Nurfed2DB.BarConfig.Stance[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Stance[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Show = {
									type = "toggle",
									name = "Show",
									order = 1,
								},
								Vertical = {
									type = "toggle",
									name = "Vertical",
									disabled = function() return not Nurfed2DB.BarConfig.Stance.Show end,
								},
								Offset = {
									type = "range",
									name = "Offset",
									min = -50,
									max = 50,
									disabled = function() return not Nurfed2DB.BarConfig.Stance.Show end,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
									disabled = function() return not Nurfed2DB.BarConfig.Stance.Show end,
								},
							},
						},
						Totem = {
							type = "group",
							name = "Totem",
							hidden = function()
								return not UnitClass("player") == "Shaman"
							end,
							get = function(info)
								return Nurfed2DB.BarConfig.Totem[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Totem[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Show = {
									type = "toggle",
									name = "Show",
									order = 1,
								},
								Vertical = {
									type = "toggle",
									name = "Vertical",
									disabled = function() return not Nurfed2DB.BarConfig.Totem.Show end,
								},
								Offset = {
									type = "range",
									name = "Offset",
									min = -50,
									max = 50,
									disabled = function() return not Nurfed2DB.BarConfig.Totem.Show end,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
									disabled = function() return not Nurfed2DB.BarConfig.Totem.Show end,
								},
							},
						},
						Vehicle = {
							type = "group",
							name = "Vehicle",
							get = function(info)
								return Nurfed2DB.BarConfig.Vehicle[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Vehicle[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Vertical = {
									type = "toggle",
									name = "Vertical",
								},
								Offset = {
									type = "range",
									name = "Offset",
									min = -50,
									max = 50,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
								},
							},
						},
						Possess = {
							type = "group",
							name = "Possess",
							get = function(info)
								return Nurfed2DB.BarConfig.Possess[info[#info]]
							end,
							set = function(info, val)
								Nurfed2DB.BarConfig.Possess[info[#info]] = val
								N2ManageUIPositions()
							end,
							args = {
								Vertical = {
									type = "toggle",
									name = "Vertical",
								},
								Offset = {
									type = "range",
									name = "Offset",
									min = -50,
									max = 50,
								},
								Scale = {
									type = "range",
									name = "Scale",
									min = 0.01,
									max = 10,
								},
							},
						},
					},
				},
			},
		},
	},
}
-----------------------------------------------------------------------------------
OnLoad()
Nurfed2_ActionBarsver = "r20100311005022"