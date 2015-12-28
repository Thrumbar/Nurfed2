--[[
	The point of these files are to create a module version of Nurfed, to enable people to plugin easily, while
	keeping the small size of the UI Package.  This also allows for users to pick and choose how they want to configure
	and use Nurfed.
]]
assert(Nurfed2, "Nurfed2 is required to be installed and enabled for Nurfed 2 Chat to work")
local updateChatSettings
local defaultSettings = {
	["TimeStamps"] = true,
	["TimeStampFormat"] = "[%I:%M:%S]",
	["HideChatButtons"] = true,
	["EnableChatFading"] = false,
	["ChatFadeTime"] = 100,
}
local function getOpt(info)
	return Nurfed2DB["Chat"][info[#info]]
end

local function setOpt(info, val)
	Nurfed2DB["Chat"][info[#info]] = val
	updateChatSettings()
end

local options = {
	type = "group",
	order = 2,
	get = getOpt,
	set = setOpt,
	args = {
		["Chat"] = {
			type = "group",
			name = "Chat",
			args = {
				text = {
					type = "description",
					name = "Alter the way the chat frame shows and works.\rIn order for Nurfed 2 to stay small, quick, and compact, we do not give you a lot of options here.  If you want more chat features, we recommend trying Chatter at: \r|cffaaaaaahttp://wow.curse.com/downloads/wow-addons/details/chatter.aspx|r",
					order = 0,
				},
				TimeStamps = {
					type = "toggle",
					name = "Time Stamps",
					desc = "Toggle Showing of Timestamps.",
				},
				TimeStampFormat = {
					type = "input",
					name = "Time Stamp Format",
					desc = "Change the way your timestamps show up.",
					usage = "This is in LUA.  Use the defaults if you don't know what your doing!",
					validate = function(info, val)
						if val == "" or val == " " or val:match("^%s%s+") then
							return "You must have actual code in this box, not just space(s)."
						end
						return true
					end,
					hidden = function(info)
						return not Nurfed2DB.Chat.TimeStamps
					end,
				},
				HideChatButtons = {
					type = "toggle",
					name = "Hide Chat Buttons",
					desc = "Toggle hiding the ugly chat buttons.",
				},
				EnableChatFadeIn = {
					type = "toggle",
					name = "Chat Fading",
					desc = "Toggle allowing the chat windows to fade in or not.",
				},
				ChatFadeTime = {
					type = "range",
					name = "Fade Time",
					desc = "Change the amount of time the chat windows will keep text before fading it away.",
					min = 0,
					max = 360,
					step = 1,
					hidden = function()
						return not Nurfed2DB.Chat.EnableChatFadeIn
					end,
				},
				ChannelNames = {
					type = "group",
					name = "Channel Names",
					order = -1,
					inline = true,
					set = function(info, val)
						if val == "" then val = nil; end
						
						Nurfed2DB["Chat"][info[#info]] = val or nil
						updateChatSettings()
					end,
					args = {
						text = {
							type = "description",
							name = "If you want them to be default, leave the setting blank.  If you want them to disappear, put a space.",
							order = 0,
						},
						["chat-general"] = {
							type = "input",
							name = "General",
							desc = "General Chat Prefix",
							usage = "Example: [Gen]",
						},
						["chat-trade"] = {
							type = "input",
							name = "Trade",
							desc = "Trade Chat Prefix",
							usage = "Example: [Trd]",
						},
						["chat-guild"] = {
							type = "input",
							name = "Guild",
							desc = "Guild Chat Prefix",
							usage = "Example: [Gld]",
						},
						["chat-party"] = {
							type = "input",
							name = "Party",
							desc = "Party Chat Prefix",
							usage = "Example: [Pty]",
						},
						["chat-localdefense"] = {
							type = "input",
							name = "Local Defense",
							desc = "Local Defense Prefix",
							usage = "Example: [Ldf]",
						},
						["chat-rw"] = {
							type = "input",
							name = "Raid Warning",
							desc = "Raid Warning Prefix",
							usage = "Example: [Rlw]",
						},
						["chat-whisper"] = {
							type = "input",
							name = "Whispers",
							desc = "Whispers Prefix",
							usage = "Example: [Whs]",
						},
						["chat-whisperto"] = {
							type = "input",
							name = "Whisper To",
							desc = "Whisper To Prefix",
							usage = "Example: [Whs-to]",
						}, 
					},
				},
			},
		},
	},
}

-- Modify chat frames
ChatTypeInfo["CHANNEL"].sticky = 1
ChatTypeInfo["OFFICER"].sticky = 1

local function OnMouseWheel(self, arg1)
	if IsShiftKeyDown() then
		if arg1 > 0 then self:PageUp()
		elseif arg1 < 0 then self:PageDown()
		end
	elseif IsControlKeyDown() then
		if arg1 > 0 then self:ScrollToTop()
		elseif arg1 < 0 then self:ScrollToBottom()
		end
	else
		if arg1 > 0 then self:ScrollUp()
		elseif arg1 < 0 then self:ScrollDown()
		end
	end
end

local messageText = {}
local function replaceChannel(oChan, msg, num, chan)
	local newChan = Nurfed2DB.Chat["chat-"..chan:lower()]
	return newChan and ("|Hchannel:%s|h%s|h%s"):format(oChan, newChan, "") or nil
end

local function replaceWhisper(chan)
	local newChan = Nurfed2DB.Chat["chat-whisperto"]
	return newChan and newChan.."" or nil
end

local function replaceWhispers(msg)
	local newChan = Nurfed2DB.Chat["chat-whisper"]
	return newChan and (newChan.."%S+:"):format(msg) or nil
end


local function message(self, msg, ...)
	if not msg then return self:O_AddMessage(msg, ...) end
	table.wipe(messageText)

	if Nurfed2DB.Chat.TimeStamps then
		table.insert(messageText, date(Nurfed2DB.Chat.TimeStampFormat))
	end
	if self ~= COMBATLOG then-- dont do this for the combat log
		msg = msg:gsub("^|Hchannel:(%S-)|h(%[([%d. ]*)([^%]]+)%])|h ", replaceChannel)
		msg = msg:gsub("^(%[(".."Raid Warning"..")%]) ", Nurfed2DB.Chat["chat-rw"] or "%1")
		msg = msg:gsub("^To ", replaceWhisper)
		--msg = msg:gsub("^(.-|h) whispers:", replaceWhispers)
	end
	table.insert(messageText, msg)
	return self:O_AddMessage(table.concat(messageText, " "), ...)
end

local function chatFrameOnShow(self) SetChatWindowShown(self:GetID(), 1); end

updateChatSettings = function()
	local buttons = Nurfed2DB.Chat.HideChatButtons
	local fade = Nurfed2DB.Chat.EnableChatFade
	local fadeTime = Nurfed2DB.Chat.ChatFadeTime
	local chatframe, up, down, bottom
	for i=1,7 do
		chatframe = _G["ChatFrame"..i]
		up = _G["ChatFrame"..i.."UpButton"]
		down = _G["ChatFrame"..i.."DownButton"]
		bottom = _G["ChatFrame"..i.."BottomButton"]
		if buttons then
			up:Hide()
			down:Hide()
			bottom:Hide()
			if i==1 then ChatFrameMenuButton:Hide() end
			chatframe:SetScript("OnShow", chatFrameOnShow)
		else
			up:Show()
			down:Show()
			bottom:Show()
			if i==1 then ChatFrameMenuButton:Show() end
			chatframe:SetScript("OnShow", chatframe.O_OnShow)
		end
		chatframe:SetFading(fade or false)
		chatframe:SetTimeVisible(fadeTime)
	end
end

local function ChatOptionsLoaded()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Nurfed 2 Chat", options)
	Nurfed2.optionsFrames.Chat = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Nurfed 2 Chat", "Chat", "Nurfed 2", "Chat")
end

local function OnLoad()
	for i=1,7 do
		local chatFrame = _G["ChatFrame"..i]
		chatFrame:EnableMouseWheel(true)
		chatFrame:SetScript("OnMouseWheel", OnMouseWheel)
		if not chatFrame.O_AddMessage then
			chatFrame.O_AddMessage = chatFrame.AddMessage
			chatFrame.AddMessage = message;
		end
		if not chatFrame.O_OnShow then
			chatFrame.O_OnShow = chatFrame:GetScript("OnShow")
		end
	end
	Nurfed2:FeedDefaultSettings("Chat", defaultSettings)
	updateChatSettings()
	Nurfed2:RegEvent("N2_OPTIONS_LOADED", ChatOptionsLoaded)
	Nurfed2:RegEvent("N2_SETTINGS_UPDATE", updateChatSettings)
end
OnLoad()
Nurfed2_Chatver = "r20100220165254"