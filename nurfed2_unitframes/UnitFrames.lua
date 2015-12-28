--N2
--[[
	The point of these files are to create a module version of Nurfed, to enable people to plugin easily, while
	keeping the small size of the UI Package.  This also allows for users to pick and choose how they want to configure
	and use Nurfed.
]]
assert(Nurfed2, "Nurfed2 is required to be installed and enabled for Nurfed2 UnitFrames to work")
local defaultSettings = {
	Target = {
		bigDebuffs = true,
		bigDebuffScale = 1.25,
		oldStyleAuras = true,
		oneLineAuras = true,
		Frame = {
			hideModel = false,
		},
		Health = {
			colorBackground = true,
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
		Power = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
	},
	Player = {
		Frame = {
			visibilityMode = "Always",
			visibilityState = "[combat]show;hide",
		},
		XP = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			restMiss = false,
			restThreshold = 0,
			animation = "None",
			fadeTime = 1.5,
		},
		Health = {
			colorBackground = true,
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
		Power = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
	},
	Pet = {
		Frame = { },
		Health = {
			colorBackground = true,
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
		Power = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
	},
	Focus = {
		Frame = { },
		Health = {
			colorBackground = true,
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
		Power = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
	},
	Party = {
		Frame = { },
		Health = {
			colorBackground = true,
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
		Power = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
			colorType = "Pitbull",
			colorSet = { 1, 0, 0 },
			animation = "None",
			fadeTime = 1.5,
		},
	},
	General = {
		RaidSize = 40,
		Frame = { },
		Health = {
			colorBackground = true,
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
		},
		Power = {
			shortCur = false,
			curThreshold = 0,
			shortMax = false,
			maxThreshold = 0,
			shortMiss = false,
			missThreshold = 0,
		},
	},
	Layouts = {
		FrameName = "Default",
		HudName = "None",
	},
}

local defaultConfig = {
	desc = "Default Nurfed 2 Layout",
	author = "Apoco",
	website = "http://www.nurfed.com",
	Templates = {
		Nurfed2_UnitFont = {
			type = "Font",
			Font = { NRF2_FONT.."PerspectiveSans.ttf", 10, "NONE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed2_UnitFontSmall = {
			type = "Font",
			Font = { NRF2_FONT.."PerspectiveSans.ttf", 8, "NONE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed2_UnitFontSmallOutline = {
			type = "Font",
			Font = { NRF2_FONT.."PerspectiveSans.ttf", 8, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed2_UnitFontOutline = {
			type = "Font",
			Font = { NRF2_FONT.."PerspectiveSans.ttf", 10, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		unit_hp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			StatusBarTexture = NRF2_IMG.."statusbar5",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF2_IMG.."statusbar5",
					VertexColor = { 1, 0, 0, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFont",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur ($max)", nocolor = true, },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFontOutline",
					JustifyH = "RIGHT",
					TextColor = { 1, 0.25, 0 },
					Anchor = "all",
					vars = { format = "$miss" },
				},
			},
			vars = { ani = "fade" },
		},
		unit_hptarget = {
			type = "StatusBar",
			FrameStrata = "LOW",
			StatusBarTexture = NRF2_IMG.."statusbar5",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF2_IMG.."statusbar5",
					VertexColor = { 1, 0, 0, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFont",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur/$max", nocolor = true, },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFont",
					JustifyH = "RIGHT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$perc", nocolor = true, },
				},
			},
			vars = { ani = "glide" },
		},
		player_xp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			StatusBarTexture = NRF2_IMG.."statusbar5",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF2_IMG.."statusbar5",
					VertexColor = { 1, 0, 0, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					size = { 154, 9 },
					FontObject = "Nurfed2_UnitFont",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					vars = { format = "$cur/$max ($rest)" },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFont",
					JustifyH = "RIGHT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$perc" },
				},
			},
		},
		unit_model = {
			type = "PlayerModel",
			size = { 40, 40 },
			FrameStrata = "LOW",
			ModelScale = 1.9,
			FrameLevel = 1,
		},
		unit_cast = {
			type = "StatusBar",
			FrameStrata = "LOW",
			StatusBarTexture = NRF2_IMG.."statusbar5",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF2_IMG.."statusbar5",
					VertexColor = { 1, 0, 0, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFontOutline",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$spell ($rank)", nocolor = true },
				},
				time = {
					type = "FontString",
					layer = "ARTWORK",
					JustifyH = "LEFT",
					FontObject = "Nurfed2_UnitFontOutline",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = { "BOTTOM", "$parent", "TOP", 0, 3 },
				},
				icon = {
					type = "Texture",
					layer = "OVERLAY",
					size = { 10, 10 },
					Anchor = { "RIGHT", "$parent", "RIGHT", 0, 0 },
				},
			},
			vars = { ani = "glide" },
		},
		party_template = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 180, 59 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 5, right = 5, top = 5, bottom = 5 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				border = {
					type = "Frame",
					SetAllPoints = true,
					FrameStrata = "MEDIUM",
					Backdrop = {
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 16,
						insets = { left = 5, right = 5, top = 5, bottom = 5 },
					},
				},
				hp = {
					template = "unit_hp",
					size = { 172, 20 },
					SetFrameLevel = 1,
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 4, -4 },
				},
				power = {
					template = "unit_hp",
					size = { 172, 20 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 4, 4 },
				},
				castbar = {
					template = "unit_cast",
					size = { 172, 9 },
					Anchor = { "LEFT", "$parent", "LEFT", 4, 0 },
					vars = { hideFrame = "nameFrame", },
					Hide = true,
				},
				leader = {
					type = "Texture",
					size = { 14, 14 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOP", "$parent", "TOP", 12, -4 },
					Hide = true,
				},
				master = {
					type = "Texture",
					size = { 14, 14 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOP", "$parent", "TOP", 24, -4 },
					Hide = true,
				},
				buffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16, 
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "BOTTOMLEFT", "$prevaura", "BOTTOMRIGHT", 0, 0 },
						auraReverse = false,
					},
					children = { },
				},
				debuffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parentbuffFrame", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16,
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "LEFT", "$prevaura", "RIGHT", 0, 0 }, 
						auraReverse = false,
					},
					children = { },
				},

				nameFrame = {
					type = "Frame",
					size = { 172, 9 },
					Anchor = { "LEFT", "$parent", "LEFT", 4, 0 },
					vars = { hideFrame = "castbar", },
					children = {
						name = {
							type = "FontString",
							size = { 150, 9 },
							layer = "OVERLAY",
							FontObject = "Nurfed2_UnitFontOutline",
							JustifyH = "LEFT",
							Anchor = { "LEFT", "$parent", "LEFT", 3, 1 },
							vars = { format = "$name $guild" },
						},
						raidtarget = {
							type = "Texture",
							Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
							size = { 10, 10 },
							layer = "OVERLAY",
							Anchor = { "CENTER", "$parent", "CENTER", 0, 0 },
							Hide = true,
						},
						level = {
							type = "FontString",
							size = { 50, 9 },
							layer = "OVERLAY",
							FontObject = "Nurfed2_UnitFontOutline",
							JustifyH = "RIGHT",
							Anchor = { "RIGHT", "$parent", "RIGHT", -3, 1 },
							vars = { format = "$level" },
						},
					},
				},
			},
		},
	},
	Frames = {
		player = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 180, 59 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 5, right = 5, top = 5, bottom = 5 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				border = {
					type = "Frame",
					SetAllPoints = true,
					FrameStrata = "MEDIUM",
					Backdrop = {
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 16,
						insets = { left = 5, right = 5, top = 5, bottom = 5 },
					},
				},
				hp = {
					template = "unit_hp",
					size = { 172, 20 },
					SetFrameLevel = 1,
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 4, -4 },
				},
				power = {
					template = "unit_hp",
					size = { 172, 20 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 4, 4 },
				},
				castbar = {
					template = "unit_cast",
					size = { 172, 9 },
					Anchor = { "LEFT", "$parent", "LEFT", 4, 0 },
					vars = { hideFrame = "xp", },
					Hide = true,
				},
				xp = {
					template = "player_xp",
					size = { 172, 9 },
					Anchor = { "LEFT", "$parent", "LEFT", 4, 0 },
					vars = { hideFrame = "castbar" },
					Hide = true,
				},
				pvp = {
					type = "Texture",
					size = { 14, 14 },
					layer = "OVERLAY",
					Anchor = { "TOP", "$parent", "TOP", 0, -4 },
					Hide = true,
				},
				leader = {
					type = "Texture",
					size = { 14, 14 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOP", "$parent", "TOP", 12, -4 },
					Hide = true,
				},
				master = {
					type = "Texture",
					size = { 14, 14 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOP", "$parent", "TOP", 24, -4 },
					Hide = true,
				},
				group = {
					type = "FontString",
					size = { 50, 8 },
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFont",
					JustifyH = "CENTER",
					Anchor = { "BOTTOM", "$parent", "TOP", 0, 4 },
				},
			},
			vars = { unit = "player", },
		},
		target = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 220, 59 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 3, right = 3, top = 3, bottom = 3 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				border = {
					type = "Frame",
					SetAllPoints = true,
					FrameStrata = "MEDIUM",
					Backdrop = {
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 16,
						insets = { left = 5, right = 5, top = 5, bottom = 5 },
					},
				},
				model = {
					template = "unit_model",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 4, -4 },
				},
				hp = {
					template = "unit_hptarget",
					size = { 172, 20 },
					SetFrameLevel = 1,
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -4, -4 },
				},
				power = {
					template = "unit_hp",
					size = { 172, 20 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -4, 4 },
				},
				combo = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFontOutline",
					TextHeight = 22,
					JustifyH = "RIGHT",
					Anchor = { "RIGHT", "$parent", "LEFT", 2, 3 },
				},
				castbar = {
					template = "unit_cast",
					size = { 172, 9 },
					Anchor = { "RIGHT", "$parent", "RIGHT", -4, 0 },
					vars = { hideFrame = "nameFrame", },
					Hide = true,
				},
				leader = {
					type = "Texture",
					size = { 12, 12 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 3, 3 },
					Hide = true,
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 12, 12 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parentleader", "TOPRIGHT", 1, 0 },
					Hide = true,
				},
				master = {
					type = "Texture",
					size = { 12, 12 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOPLEFT", "$parentraidtarget", "TOPRIGHT", 1, 0 },
					Hide = true,
				},
				nameFrame = {
					type = "Frame",
					size = { 180, 12 },
					Anchor = { "RIGHT", "$parent", "RIGHT", 0, 0 },
					vars = { hideFrame = "castbar", },
					children = {
						name = {
							type = "FontString",
							size = { 150, 9 },
							layer = "OVERLAY",
							FontObject = "Nurfed2_UnitFontOutline",
							JustifyH = "LEFT",
							Anchor = { "LEFT", "$parent", "LEFT", 3, 1 },
							vars = { format = "$name $guild" },
						},
						raidtarget = {
							type = "Texture",
							Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
							size = { 10, 10 },
							layer = "OVERLAY",
							Anchor = { "CENTER", "$parent", "CENTER", 0, 0 },
							Hide = true,
						},
						level = {
							type = "FontString",
							size = { 50, 9 },
							layer = "OVERLAY",
							FontObject = "Nurfed2_UnitFontOutline",
							JustifyH = "RIGHT",
							Anchor = { "RIGHT", "$parent", "RIGHT", -3, 1 },
							vars = { format = "$level" },
						},
					},
				},
				buffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16, 
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "BOTTOMLEFT", "$prevaura", "BOTTOMRIGHT", 0, 0 },
						auraReverse = false,
					},
					children = { },
				},
				debuffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parentbuffFrame", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16,
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "LEFT", "$prevaura", "RIGHT", 0, 0 }, 
						auraReverse = false,
					},
					children = { },
				},
				target = {
					type = "Button",
					uitemp = "SecureUnitButtonTemplate",
					size = { 80, 24 },
					FrameStrata = "LOW",
					Backdrop = {
						bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 8,
						insets = { left = 2, right = 2, top = 2, bottom = 2 }
					},
					Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 0, 0 },
					BackdropColor = { 0, 0, 0, 0.75 },
					children = {
						hp = {
							type = "StatusBar",
							size = { 74, 9 },
							FrameStrata = "LOW",
							StatusBarTexture = NRF2_IMG.."statusbar5",
							Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 3, 4 },
							children = {
								bg = {
									type = "Texture",
									layer = "BACKGROUND",
									Texture = NRF2_IMG.."statusbar5",
									VertexColor = { 1, 0, 0, 0.25 },
									Anchor = "all",
								},
								text = {
									type = "FontString",
									layer = "OVERLAY",
									FontObject = "Nurfed2_UnitFontSmallOutline",
									JustifyH = "RIGHT",
									TextColor = { 1, 0.25, 0 },
									Anchor = "all",
									vars = { format = "$perc", nocolor = true, },
								},
							},
						},
						name = {
							type = "FontString",
							size = { 74, 9 },
							layer = "OVERLAY",
							FontObject = "Nurfed2_UnitFontSmallOutline",
							JustifyH = "LEFT",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = { "BOTTOMLEFT", "$parenthp", "TOPLEFT", 0, 0 },
							vars = { format = "$name" },
						},
					},
					Hide = true,
				},
				targettarget = {
					type = "Button",
					uitemp = "SecureUnitButtonTemplate",
					size = { 80, 24 },
					FrameStrata = "LOW",
					Backdrop = {
						bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 8,
						insets = { left = 2, right = 2, top = 2, bottom = 2 }
					},
					Anchor = { "BOTTOMRIGHT", "$parent", "TOPRIGHT", 0, 0 },
					BackdropColor = { 0, 0, 0, 0.75 },
					children = {
						hp = {
							type = "StatusBar",
							size = { 74, 9 },
							FrameStrata = "LOW",
							StatusBarTexture = NRF2_IMG.."statusbar5",
							Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 3, 4 },
							children = {
								bg = {
									type = "Texture",
									layer = "BACKGROUND",
									Texture = NRF2_IMG.."statusbar5",
									VertexColor = { 1, 0, 0, 0.25 },
									Anchor = "all",
								},
								text = {
									type = "FontString",
									layer = "OVERLAY",
									FontObject = "Nurfed2_UnitFontSmallOutline",
									JustifyH = "RIGHT",
									TextColor = { 1, 0.25, 0 },
									Anchor = "all",
									vars = { format = "$perc", nocolor = true, },
								},
							},
						},
						name = {
							type = "FontString",
							size = { 74, 9 },
							layer = "OVERLAY",
							FontObject = "Nurfed2_UnitFontSmallOutline",
							JustifyH = "LEFT",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = { "BOTTOMLEFT", "$parenthp", "TOPLEFT", 0, 0 },
							vars = { format = "$name" },
						},
					},
					Hide = true,
				},
			},
			vars = { unit = "target", },
		},
		focus = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 160, 39 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 3, right = 3, top = 3, bottom = 3 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				border = {
					type = "Frame",
					SetAllPoints = true,
					FrameStrata = "MEDIUM",
					Backdrop = {
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 16,
						insets = { left = 5, right = 5, top = 5, bottom = 5 },
					},
				},
				model = {
					template = "unit_model",
					size = { 32, 32 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 4, -4 },
				},
				hp = {
					template = "unit_hptarget",
					size = { 120, 12 },
					SetFrameLevel = 1,
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -4, -4 },
				},
				power = {
					template = "unit_hp",
					size = { 120, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -4, 4 },
				},
				name = {
					type = "FontString",
					size = { 120, 6 },
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFontOutline",
					JustifyH = "CENTER",
					Anchor = { "BOTTOM", "$parent", "TOP", 0, 1 },
					vars = { format = "$name $guild" },
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 12, 12 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parentleader", "TOPRIGHT", 1, 0 },
					Hide = true,
				},
				castbar = {
					template = "unit_cast",
					size = { 120, 9 },
					Anchor = { "RIGHT", "$parent", "RIGHT", -4, 0 },
					vars = { hideFrame = "nameFrame", },
					Hide = true,
				}, 
				debuffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16, 
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "BOTTOMLEFT", "$prevaura", "BOTTOMRIGHT", 0, 0 },
						auraReverse = false,
					},
					children = { },
				},
			},
			vars = { unit = "focus", },
		},
		pet = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 160, 39 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 3, right = 3, top = 3, bottom = 3 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				border = {
					type = "Frame",
					SetAllPoints = true,
					FrameStrata = "MEDIUM",
					Backdrop = {
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true,
						tileSize = 16,
						edgeSize = 16,
						insets = { left = 5, right = 5, top = 5, bottom = 5 },
					},
				},
				model = {
					template = "unit_model",
					size = { 32, 32 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 4, -4 },
				},
				hp = {
					template = "unit_hptarget",
					size = { 120, 12 },
					SetFrameLevel = 1,
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -4, -4 },
				},
				power = {
					template = "unit_hp",
					size = { 120, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -4, 4 },
				},
				name = {
					type = "FontString",
					size = { 120, 6 },
					layer = "OVERLAY",
					FontObject = "Nurfed2_UnitFontOutline",
					JustifyH = "CENTER",
					Anchor = { "BOTTOM", "$parent", "TOP", 0, 1 },
					vars = { format = "$name $guild" },
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 12, 12 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parentleader", "TOPRIGHT", 1, 0 },
					Hide = true,
				},
				happiness = {
					type = "Texture",
					Texture = "Interface\\PetPaperDollFrame\\UI-PetHappiness",
					size = { 14, 14 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -40, -4 },
					Hide = true,
				},
				castbar = {
					template = "unit_cast",
					size = { 120, 9 },
					Anchor = { "RIGHT", "$parent", "RIGHT", -4, 0 },
					vars = { hideFrame = "nameFrame", },
					Hide = true,
				},
				debuffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16, 
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "BOTTOMLEFT", "$prevaura", "BOTTOMRIGHT", 0, 0 },
						auraReverse = false,
					},
					children = { },
				},
				--[[
				debuffFrame = {
					type = "Frame",
					size = { 180, 22 },
					Anchor = { "TOPLEFT", "$parentbuffFrame", "BOTTOMLEFT", 0, 0 },
					vars = { 
						numAuras = 16,
						auraStart = { "TOPLEFT", "$parent", "TOPLEFT", 4, 0 }, 
						auraAnchor = { "LEFT", "$prevaura", "RIGHT", 0, 0 }, 
						auraReverse = false,
					},
					children = { },
				},]]
			},
			vars = { unit = "pet", },
		},
		party1 = {	template = "party_template", vars = { unit = "party1" }, },
		party2 = {	template = "party_template", vars = { unit = "party2" }, },
		party3 = {	template = "party_template", vars = { unit = "party3" }, },
		party4 = {	template = "party_template", vars = { unit = "party4" }, },
	},
}
local tots, playerClass
local predictStats = {}
local units = {}
local partyframes = {}
local lhc
-- All: Status Bar Color Function
---------------------------------------------------
	-- Color List
local colorList = {
	HUNTER		= { 0.6392, 1, 0.5098 },
	WARRIOR		= { 0.8274, 0.7529,	0.5882 },
	PALADIN		= { 0.9607, 0.5490, 0.7294 },
	DRUID		= { 0, 0.4901, 0.0392 },
	PRIEST		= { 0.7607, 0.74, 0.9960 },
	SHAMAN		= { 0, 1, 0.9960 },
	ROGUE		= { 0, 0.9607, 0.4117 },
	MAGE		= { 0.4823, 0, 1 },
	WARLOCK		= { 0.7333, 0.6431, 1 },
	DEATHKNIGHT	= { 0.77, 0.12, 0.23 },
	
	rage		= { 0.886, 0.176, 0.295 },
	energy		= { 1, 0.863, .098 },
	focus		= { 1, 0.825, 0 },
	mana		= { 0.188, 0.522, .749 },
	happiness	= { 0.8, 0.8, 0.8 },
	runicpower	= { 0, 0.897, 1 },
	
	unknown = { 0.8, 0.8, 0.8 },

	hostile = { 226/255, 45/255, 75/255 },
	neutral = { 1, 1, 34/255 },
	friendly = { 0.2, 0.8, 0.15 },
	civilian = { 48/255, 113/255, 191/255 },
	
	dead = { 0.6, 0.6, 0.6 },
	disconnected = { 0.7, 0.7, 0.7 },
	inCombat = { 1, 0, 0 },
	resting = { 1, 1, 0 },
	tapped = { 0.5, 0.5, 0.5 }
}
local class = {
	["WARRIOR"]		= {0, 0.25, 0, 0.25},
	["MAGE"]		= {0.25, 0.49609375, 0, 0.25},
	["ROGUE"]		= {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"]		= {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"]		= {0, 0.25, 0.25, 0.5},
	["SHAMAN"]	 	= {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"]		= {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"]		= {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"]		= {0, 0.25, 0.5, 0.75},
	["DEATHKNIGHT"]	= {0.25, .5, 0.5, .75},
	["PETS"]	= { 0, 1, 0, 1 },
}

-- StatusBar: Get Color
------------------------------------------------------
local getColorOpt = ""
local sbgc = { }
local function StatusBar_GetColor(frame, type, perc)
	local class = select(2, UnitClass(frame.unit))
	table.wipe(sbgc)
	getColorOpt = frame["Settings"].colorType
	if getColorOpt == "Custom" and frame["Settings"].colorFunc and _G.type(frame["Settings"].colorFunc) == "function" then
		sbgc[1], sbgc[2], sbgc[3] = frame["Settings"].colorFunc(type, perc)
	elseif getColorOpt == "Set" then
		sbgc[1], sbgc[2], sbgc[3] = unpack(frame["Settings"].colorSet)
	else

		if type == "hp" then
			--getColorOpt = Nurfed2DB.UnitFrameSettings.General.HPType
			if getColorOpt == "Pitbull" then
				if not UnitIsConnected(frame.unit) then 
					sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.disconnected)

				elseif UnitIsDeadOrGhost(frame.unit) then 
					sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.dead)

				elseif UnitIsTapped(frame.unit) and not UnitIsTappedByPlayer(frame.unit) then 
					sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.tapped)

				elseif UnitIsPlayer(frame.unit) then
					if UnitIsFriend("player", frame.unit) then 
						sbgc[1], sbgc[2], sbgc[3] = unpack(colorList[class or "WARRIOR"])

					elseif UnitCanAttack(frame.unit, "player") then
						if UnitCanAttack("player", frame.unit) then 
							sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.hostile)
						else
							sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.civilian)
						end
					
					elseif UnitCanAttack("player", frame.unit) then 
						sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.neutral)

					elseif UnitIsFriend("player", frame.unit) then
						sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.friendly)
					else
						sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.civilian)
					end
				else
					local reaction = UnitReaction(frame.unit, "player")
					if reaction then
						if reaction >= 5 then
							sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.friendly)
						elseif reaction == 4 then
							sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.neutral)
						else
							sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.hostile)
						end
					else
						sbgc[1], sbgc[2], sbgc[3] = 1, 1, 1
					end
				end

				if not sbgc[1] then
					local r1, g1, b1
					local r2, g2, b2
					if perc <= 0.5 then
						perc = perc * 2
						r1, g1, b1 = unpack(colorList.minHP)
						r2, g2, b2 = unpack(colorList.midHP)
					else
						perc = perc * 2 - 1
						r1, g1, b1 = unpack(colorList.midHP)
						r2, g2, b2 = unpack(colorList.maxHP)
					end
					if r1 and r2 and g1 and g2 and b1 and b2 then
						 sbgc[1], sbgc[2], sbgc[3] = r1 + (r2-r1)*perc, g1 + (g2-g1)*perc, b1 + (b2-b1)*perc
					else
						sbgc[1], sbgc[2], sbgc[3] = 1, .5, .8
					end
				end
			elseif getColorOpt == "Class" then
				local class = select(2, UnitClass(frame.unit))
				if class then
					sbgc[1] = RAID_CLASS_COLORS[class].r
					sbgc[2] = RAID_CLASS_COLORS[class].g
					sbgc[3] = RAID_CLASS_COLORS[class].b
				else
					sbgc[1], sbgc[2], sbgc[3] = 0, 1, 0
				end

			elseif getColorOpt == "Fade" then
				if perc > 0.5 then
					sbgc[1] = (1.0 - perc) * 2
					sbgc[2] = 1.0
				else
					sbgc[1] = 1.0
					sbgc[2] = perc * 2
				end
				sbgc[3] = 0.0

			end
			--[[
			-- frame.unit is a player, hostile/friendly, doesnt matter
			if UnitIsPlayer(frame.unit) then
				if UnitIsFriend("player", frame.unit) then	-- unit is friendly
					sbgc[1], sbgc[2], sbgc[3] = unpack(colorList[class or "WARRIOR"])
				end
			end
			]]		
		elseif type == "power" then
			if getColorOpt == "Pitbull" then
				local powertype = UnitPowerType(frame.unit)
				if powertype == 0 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.mana)
				elseif powertype == 1 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.rage)
				elseif powertype == 2 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.focus)
				elseif powertype == 3 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.energy)
				elseif powertype == 4 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.happiness)
				elseif powertype == 5 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.unknown)
				elseif powertype == 6 then sbgc[1], sbgc[2], sbgc[3] = unpack(colorList.runicpower)
				end

			elseif getColorOpt == "Class" then
				local class = select(2, UnitClass(frame.unit))
				if class then
					sbgc[1] = RAID_CLASS_COLORS[class].r
					sbgc[2] = RAID_CLASS_COLORS[class].g
					sbgc[3] = RAID_CLASS_COLORS[class].b
				else
					sbgc[1], sbgc[2], sbgc[3] = 0, 1, 0
				end
		
			elseif getColorOpt == "Fade" then
				if perc > 0.5 then
					sbgc[1] = (1.0 - perc) * 2
					sbgc[2] = 1.0
				else
					sbgc[1] = 1.0
					sbgc[2] = perc * 2
				end
				sbgc[3] = 0.0
			end

		end
	end
	return sbgc
end
--//

-- Text: Convert To Short Numbers
------------------------------------------------------
-- Threshold determines how low the numbers are converted. 3 = millions(1.2mil and 12mil), 2 = hundred thousands(12k), 1 = thousands (1.2k)
local function Text_ConvertNumbers(value, threshold)
	if (value >= 10000000 or value <= -10000000) and threshold <= 3 then
		return ("%.1fm"):format(value / 1000000)
	elseif (value >= 1000000 or value <= -1000000) and threshold <= 3 then
		return ("%.2fm"):format(value / 1000000)
	elseif (value >= 100000 or value <= -100000) and threshold <= 2 then
		return ("%.0fk"):format(value / 1000)
	elseif (value >= 10000 or value <= -10000) and threshold <= 1 then
		return ("%.1fk"):format(value / 1000)
	else
		return math.floor(value+0.5)..''
	end
end
--//

-- Texture: Cut
------------------------------------------------------
local function CutTexture(texture, size, fill, value)
	if fill == "top" then
		texture:SetHeight(size)
		texture:SetTexCoord(0, 1, value, 1)
	elseif fill == "bottom" then
		texture:SetHeight(size)
		texture:SetTexCoord(0, 1, 1, value)
	elseif fill == "left" then
		texture:SetWidth(size)
		texture:SetTexCoord(value, 1, 0, 1)
	elseif fill == "right" then
		texture:SetWidth(size)
		texture:SetTexCoord(1, value, 0, 1)
	elseif fill == "vertical" then
		texture:SetHeight(size)
		texture:SetTexCoord(0, 1, 0 + (value / 2), 1 - (value / 2))
	elseif fill == "horizontal" then
		texture:SetWidth(size)
		texture:SetTexCoord(0 + (value / 2), 1 - (value / 2), 0, 1)
	end
end

--//
-- Frame: Health Update
------------------------------------------------------
local curhp, maxhp, perchp, misshp, hpr, hpg, hpb
local function Frame_UpdateHealth(frame, unit, ...)
	if UnitIsUnit(frame.unit, unit) and UnitExists(unit) then
		curhp = UnitHealth(frame.unit)
		maxhp = UnitHealthMax(frame.unit)
		perchp = curhp / maxhp
		misshp = maxhp - curhp
		local objtype
		for _, child in ipairs(frame.Health) do
			objtype = child:GetObjectType()
			if objtype == "StatusBar" then
				child:SetMinMaxValues(0, maxhp)
				if child["Settings"].animation == "Glide" then
					child.endvalue = curhp
					child.fade = 0.35
				else
					child.value = curhp
					child:SetValue(curhp)
				end
				hpr, hpg, hpb = unpack(StatusBar_GetColor(child, "hp", perchp))
				child:SetStatusBarColor(hpr, hpg, hpb)
				child:Show()
			
			elseif objtype == "Texture" then
				if child.fill then
					local size = child.bar * (perchp / 100)
					local p_h1, p_h2
					if size < 1 then
						size = 1
					end

					if child.fill == "top" or child.fill == "bottom" or child.fill == "vertical" then
						p_h1 = child.bar / child.height
					else
						p_h1 = child.bar / child.width
					end

					p_h2 = 1 - p_h1
					CutTexture(child, size, child.fill, (1 - (perchp / 100)) * p_h1 + p_h2)
					hpr, hpg, hpb = unpack(StatusBar_GetColor(child, "hp", perchp))
					if hpr and hpg and hpb then
						child:SetVertexColor(hpr, hpg, hpb)
					end
				else
					if child["Settings"].colorBackground then
						hpr, hpg, hpb = unpack(StatusBar_GetColor(child, "hp", perchp))
						if hpr and hpg and hpb then
							child:SetVertexColor((hpr + 0.2)/3, (hpg + 0.2)/3, (hpb + 0.2)/3)
						end
					end
				end
				
			elseif objtype == "FontString" then
				local text, misstext
				if not UnitIsConnected(frame.unit) then
					text = PLAYER_OFFLINE
				elseif UnitIsGhost(frame.unit) then
					text = "Ghost"
				elseif UnitIsDead(frame.unit) or UnitIsCorpse(frame.unit) then
					text = DEAD
				else
					text = child.format
					text = text:gsub("$cur", child["Settings"].shortCur and Text_ConvertNumbers(curhp, child["Settings"].curThreshold) or curhp)
					text = text:gsub("$max", child["Settings"].shortMax and Text_ConvertNumbers(maxhp, child["Settings"].maxThreshold) or maxhp)
					text = text:gsub("$perc", string.format("%.0f", floor(perchp * 100)).."%%")
					misstext = child["Settings"].shortMiss and Text_ConvertNumbers(misshp, child["Settings"].missThreshold) or misshp
					if misstext and misstext ~= 0 then
						text = text:gsub("$miss", "|cffcc1111"..misstext.."|r")
					else
						text = text:gsub("$miss", "")
					end
				end
				child:SetText(text)
				if not child.nocolor then
					hpr, hpg, hpb = unpack(StatusBar_GetColor(child, "hp", perchp))
					child:SetTextColor(hpr, hpg, hpb)
				end
			end
		end
	end
end
--//

-- Frame: Power Update
--------------------------------------------------------
local curpower, maxpower, percpower, misspower, powerr, powerg, powerb
function Frame_UpdatePower(frame, arg1, ...)
	if UnitIsUnit(frame.unit, arg1) then
		curpower = UnitPower(frame.unit)
		maxpower = UnitPowerMax(frame.unit)
		percpower = curpower / maxpower
		misspower = maxpower - curpower
		local objtype
--		powerr, powerg, powerb = unpack(StatusBar_GetColor(child, "power", percpower))
		for _, child in ipairs(frame.Power) do
			objtype = child:GetObjectType()
			if objtype == "StatusBar" then
				child:SetMinMaxValues(0, maxpower)
				if child["Settings"].animation == "Glide" then
					child.endvalue = curpower
					child.fade = 0.35
				else
					child.value = curvalue
					child:SetValue(curpower)
				end

				child:SetStatusBarColor(unpack(StatusBar_GetColor(child, "power", percpower)))
				child:Show()

			elseif objtype == "Texture" then
				if child.fill then
					local size = child.bar * (percpower / 100)
					local p_h1, p_h2
					if size < 1 then
						size = 1
					end

					if child.fill == "top" or child.fill == "bottom" or child.fill == "vertical" then
						p_h1 = child.bar / child.height
					else
						p_h1 = child.bar / child.width
					end

					p_h2 = 1 - p_h1
					CutTexture(child, size, child.fill, (1 - (percpower / 100)) * p_h1 + p_h2)
					powerr, powerg, powerb = unpack(StatusBar_GetColor(child, "power", percpower))
					if powerr and powerg and powerb then
						child:SetVertexColor(powerr, powerg, powerb)
					end
				else
					if child["Settings"].colorBackground then
						powerr, powerg, powerb = unpack(StatusBar_GetColor(child, "power", percpower))
						child:SetVertexColor((powerr + 0.2)/3, (powerg + 0.2)/3, (powerb + 0.2)/3)
					end
				end
			
			elseif objtype == "FontString" then
				local text, misstext
				if not UnitIsConnected(frame.unit) then
					text = PLAYER_OFFLINE
				elseif UnitIsGhost(frame.unit) then
					text = "Ghost"
				elseif UnitIsDead(frame.unit) or UnitIsCorpse(frame.unit) then
					text = DEAD
				else
					text = child.format
					text = text:gsub("$cur", child["Settings"].shortCur and Text_ConvertNumbers(curpower, child["Settings"].curThreshold) or curpower)
					text = text:gsub("$max", child["Settings"].shortMax and Text_ConvertNumbers(maxpower, child["Settings"].maxThreshold) or maxpower)
					text = text:gsub("$perc", string.format("%.0f", floor(percpower * 100)).."%%")
					misstext = child["Settings"].shortMiss and Text_ConvertNumbers(misspower, child["Settings"].missThreshold) or misspower
					if misstext and misstext ~= 0 then
						text = text:gsub("$miss", "|cffcc1111"..misstext.."|r")
					else
						text = text:gsub("$miss", "")
					end
				end
				child:SetText(text)
				if not child.nocolor then
					child:SetTextColor(unpack(StatusBar_GetColor(child, "power", percpower)))
				end
			end
		end
	end
end
--//


-- Status Bar Animations
-----------------------------------------------
	-- Fading Function
local usedBits = {}
local i = 0

local function GetBit()
	local r
	if #usedBits > 0 then
		r = table.remove(usedBits)
	else
		i = i + 1
		r = UIParent:CreateTexture("nrf2_fade"..i, "BACKGROUND")
	end
	return r
end

local function KillBit(item)
	table.insert(usedBits, item)
	item:Hide()
	item:SetParent(UIParent)
end

local fadeChunk
local function StatusBar_Fading(self, value, flag)
	if self.value then
		local lower, upper = self.value, self.old
		if lower < upper then
			local min, max = self:GetMinMaxValues()
			if self.old > max then 
				self.old = lower 
				return 
			end
			
			fadeChunk = GetBit()
			fadeChunk:SetTexture(self.texture)
			fadeChunk:SetVertexColor(self:GetStatusBarColor())
			fadeChunk:SetParent(self)
			
			local size = self:GetWidth()
			fadeChunk:SetPoint("TOP", self, 0, 0)
			fadeChunk:SetPoint("BOTTOM", self, 0, 0)
			fadeChunk:SetPoint("RIGHT", self, (size * -(max - upper) / max), 0)
			fadeChunk:SetPoint("LEFT", self, "RIGHT", (size * -(max - lower) / max), 0)
			
			fadeChunk:Show()
			local fadeinfo = {}
			fadeinfo.timeToFade = self["Settings"].fadeTime
			fadeinfo.mode = "OUT"
			fadeinfo.finishedFunc = KillBit
			fadeinfo.finishedArg1 = fadeChunk
			UIFrameFade(fadeChunk, fadeinfo)
		end
		self.old = lower
		self.value = nil
	end
end

local function Nurfed2_Fade(self)
	local texture = self:GetStatusBarTexture()
	local name = texture:GetTexture()
	self.texture = name
	self.old = 0
	hooksecurefunc(self, "SetValue", StatusBar_Fading)
	--self:HookScript("SetValue", StatusBar_Fading)
	--self:HookScript("OnUpdate", StatusBar_Fading)
end
	-- Glide Function
local function StatusBar_Glide(self, e)
	if self.fade < 1 then
		self.fade = self.fade + e
		if self.fade > 1 then self.fade = 1 end
		local delta = self.endvalue - self.startvalue
		local diff = delta * (self.fade / 1)
		self.startvalue = self.startvalue + diff
		self:SetValue(self.startvalue)
	end
end

--//


-- Casting Functions
------------------------------------------------
	--Casting Event
--local lbsendTime
--[[
local castSpell, castRank, castName, castIcon, castStart, castEnd, castTrade, castID, castInterrupt
local function Frame_Cast_OnUpdate(self)
	local status = GetTime()
	for _, subself in ipairs(self.Cast) do
		if subself.iscasting and subself:IsShown() then
			if status > subself.maxValue then
				status = subself.maxValue
			end
			if status == subself.maxValue then
				subself.iscasting = nil
				subself.flash = 1
				subself.fadeOut = 1
			else
				subself.flash = nil
				subself.fadeOut = nil
			end
			if subself:GetObjectType() == "StatusBar" then
				if status == subself.maxValue then
					subself:SetValue(subself.maxValue)
					subself:SetStatusBarColor(0.0, 1.0, 0.0)
					return
				end
				subself:SetValue(status)
				
			elseif subself:GetObjectType() == "FontString" then
				if subself.format then
					if not subself.format:find("$spell") then
						local text = subself.format
						local cur = subself.maxValue - status
						local max = subself.maxValue - subself.startTime
						text = text:gsub("$cur", string.format("%.1f", cur))
						text = text:gsub("$max", string.format("%.1f", max))
						text = text:gsub("$perc", string.format("%.0f", 100 - ((cur / max) * 100)))
						subself:SetText(text)
						text, cur, max = nil, nil, nil
					end
				else
					subself:SetText(string.format("(%.1fs)", subself.maxValue - status))
				end
			end
			
		elseif subself.fadeOut then
			local alpha = subself:GetAlpha() - CASTING_BAR_ALPHA_STEP
			if alpha > 0 then
				subself:SetAlpha(alpha)
			else
				subself.fadeOut = nil
				subself:Hide()
			end
		end
	end
	for _, subself in ipairs(self.Cast) do
		if subself:IsShown() then
			return
		end
		self:SetScript("OnUpdate", nil)
	end
end

local function Frame_Cast_CastFailStop(self)
	castSpell = UnitCastingInfo(self.unit)
	if not castSpell then
		for _, subself in ipairs(self.Cast) do
			if not subself.iscasting then return end
			if subself:IsShown() then
				if subself:GetObjectType() == "StatusBar" then
					subself:SetValue(subself.maxValue)
					subself:SetStatusBarColor(0.0, 1.0, 0.0)
					
				elseif subself:GetObjectType() == "FontString" then
					subself:SetText(FAILED)
				end
				subself.iscasting = nil
				subself.ischanneling = nil
				subself.fadeOut = 1
				subself.holdTime = 0
			end
		end
	end
	if not self:GetScript("OnUpdate") then
		self:SetScript("OnUpdate", Frame_Cast_OnUpdate)
	end
end
	-- UNIT_CAST_START
local function Frame_Cast_CastStart(self, event, unit, spell)
	castSpell, castRank, castName, castIcon, castStart, castEnd = UnitCastingInfo(self.unit)
	if not castSpell then 
		for _, subself in ipairs(self.Cast) do
			subself:Hide()
		end
		return 
	end
	if icon == "Interface\\Icons\\Temp" then
		icon = nil
	end
	castStart = castStart * .001
	castEnd = castEnd * .001
	for _, subself in ipairs(self.Cast) do
		subself.iscasting = true
		
		subself.startTime = castStart
		subself.endTime = castEnd
		subself.maxValue = castEnd
		
		if subself:GetObjectType() == "StatusBar" then
			subself:SetStatusBarColor(1.0, 0.7, 0.0)
			subself:SetMinMaxValues(subself.startTime, subself.maxValue)
			subself:SetValue(subself.startTime)

		elseif subself:GetObjectType() == "FontString" then
			local out = subself.format
			if out then
				out = out:gsub("$spell", castName)
				out = out:gsub("$rank", castRank)
			else
				out = string.format("(%.1fs)", castStart - castEnd)
			end
			if nameSubtext == "" then
				out = out:gsub("%(", ""):gsub("%)", "")
			end
			
			if subself.hi == "VERTICAL" or subself.short then
				local vtext = ""
				out = string.gsub(out, "[^A-Z:0-9.]", "") --fridg
				out = string.gsub(out, "R(%d+)", function(s) return " R"..s end)
				for i = 1, string.len(out) do
					vtext = vtext..string.sub(out, i, i).."\n"
				end
				out = vtext
			end
			subself:SetText(out)
			
		elseif subself:GetObjectType() == "Texture" then
			if subself.icon then
				subself:SetTexture(castIcon)
			end
		end
		subself:Show()
			("showing subself")
		if not subself.bg then
			UIFrameFadeIn(subself, 0.15)
		end
	end
	if not self:GetScript("OnUpdate") then
		self:SetScript("OnUpdate", Frame_Cast_OnUpdate)
	end
end
]]

local function Frame_CastingOnUpdate(self)
	if self.casting and self:IsShown() then
		local status = GetTime()
		if status > self.maxValue then
			status = self.maxValue
		end
		if status == self.maxValue then
			self:SetValue(self.maxValue)
			self:SetStatusBarColor(0.0, 1.0, 0.0)
			self.casting = nil
			self.flash = 1
			self.fadeOut = 1
			return
		end
		self:SetValue(status)
		local cast = _G[self:GetName().."time"]
		if cast then
			if cast.format then
				local text = cast.format
				local cur = self.maxValue - status
				local max = self.maxValue - self.startTime
				text = text:gsub("$cur", string.format("%.1f", cur))
				text = text:gsub("$max", string.format("%.1f", max))
				text = text:gsub("$perc", string.format("%.0f", 100 - ((cur / max) * 100)))
				cast:SetText(text)
				text, cur, max = nil, nil, nil
			else
				cast:SetText(string.format("(%.1fs)", self.maxValue - status))
			end
		end
	elseif self.channeling then
		local time = GetTime()
		if time > self.endTime then
			time = self.endTime
		end
		if time == self.endTime then
			self:SetStatusBarColor(0.0, 1.0, 0.0)
			self.channeling = nil
			self.flash = 1
			self.fadeOut = 1
			return
		end
		local barValue = self.startTime + (self.endTime - time)
		self:SetValue(barValue)
		local cast = _G[self:GetName().."time"]
		if cast then
			if cast.format then
				local text = cast.format
				local cur = self.endTime - time
				local max = self.endTime - self.startTime
				text = text:gsub("$cur", string.format("%.1f", cur))
				text = text:gsub("$max", string.format("%.1f", max))
				text = text:gsub("$perc", string.format("%.0f", 100 - ((cur / max) * 100)))
				cast:SetText(text)
			else
				cast:SetText(string.format("(%.1fs)", self.endTime - time))
			end
		end
	elseif GetTime() < self.holdTime then
		return

	elseif self.fadeOut then
		local parent = self.parent
		local alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP
		if alpha > 0 then
			self:SetAlpha(alpha)
			if parent then parent:SetAlpha(alpha) end
		else
			self.fadeOut = nil
			self:Hide()
			if parent then parent:Hide() end
		end
	end
end

local function Frame_CastingOnEvent(self, event, unit, spell)
	if unit ~= self.unit then return end
	local parent = self.parent
	if event == "PLAYER_ENTERING_WORLD" 
	or event == "PLAYER_TARGET_CHANGED" 
	or event == "PARTY_MEMBERS_CHANGED" 
	or event == "PLAYER_FOCUS_CHANGED" then
		local nameChannel  = UnitChannelInfo(self.unit)
		local nameSpell  = UnitCastingInfo(self.unit)
		if nameChannel then
			event = "UNIT_SPELLCAST_CHANNEL_START"
			unit = self.unit
		elseif nameSpell then
			event = "UNIT_SPELLCAST_START"
			unit = self.unit
		else
			self:Hide()
			if parent then 
				parent:Hide()
			end
			return
		end
	end

	local barText = _G[self:GetName().."text"]
	local barIcon = _G[self:GetName().."icon"]
	local orient = self:GetOrientation()

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SENT" then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(self.unit)
		if not name then
			self:Hide()
			if parent then parent:Hide() end
			return
		end

		self:SetStatusBarColor(1.0, 0.7, 0.0)
		self.startTime = startTime / 1000
		self.endTime = endTime / 1000
		self.maxValue = endTime / 1000
		
		self:SetMinMaxValues(self.startTime, self.maxValue)
		self:SetValue(self.startTime)
		self:SetAlpha(1.0)
		self.holdTime = 0
		self.casting = 1
		self.channeling = nil
		self.fadeOut = nil
		self:Show()
		if barText and barText.format then
			local out = barText.format
			out = out:gsub("$spell", name)
			out = out:gsub("$rank", nameSubtext)
			if nameSubtext == "" then
				out = out:gsub("%(", ""):gsub("%)", "")
			end
			if orient == "VERTICAL" or barText.short then
				local vtext = ""
				out = string.gsub(out, "[^A-Z:0-9.]", "") --fridg
				out = string.gsub(out, "R(%d+)", function(s) return " R"..s end)
				for i = 1, string.len(out) do
					vtext = vtext..string.sub(out, i, i).."\n"
				end
				out = vtext
			end
			barText:SetText(out)
		end
		if barIcon then 
			barIcon:SetTexture(texture) 
		end
		if parent then
			parent:Show()
			parent:SetAlpha(1.0)
		end

	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if not self:IsVisible() then self:Hide() end
		if self:IsShown() then
			self:SetValue(self.maxValue)
			if event == "UNIT_SPELLCAST_STOP" then
				self:SetStatusBarColor(0.0, 1.0, 0.0)
				self.casting = nil
			else
				self.channeling = nil
			end
			self.fadeOut = 1
			self.holdTime = 0
		end

	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_CHANNEL_INTERRUPTED" then
		if event == "UNIT_SPELLCAST_FAILED" and (self.casting or self.channeling) then
			return
		end
		if self:IsShown() and not self.channeling then
			if self.maxValue then
				self:SetValue(self.maxValue)
			end
			self:SetStatusBarColor(1.0, 0.0, 0.0)
			self.casting = nil
			self.channeling = nil
			self.fadeOut = 1
			self.holdTime = GetTime() + 0.15 --CASTING_BAR_HOLD_TIME
			if barText then
				local text = INTERRUPTED
				if event == "UNIT_SPELLCAST_FAILED" then
					text = FAILED
				end
				if orient == "VERTICAL" then
					local vtext = ""
					for i=1, string.len(text) do
						vtext = vtext..string.sub(text, i, i).."\n"
					end
					text = vtext
				end
				barText:SetText(text)
			end
		end

	elseif event == "UNIT_SPELLCAST_DELAYED" then
		if self:IsShown() then
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(self.unit)
			if not name then
				self:Hide()
				if parent then parent:Hide() end
				return
			end
			self.startTime = startTime / 1000
			self.maxValue = endTime / 1000
			self:SetMinMaxValues(self.startTime, self.maxValue)
		end

	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(self.unit)
		if not name then
			self:Hide()
			if parent then parent:Hide() end
			return
		end

		self:SetStatusBarColor(0.0, 1.0, 0.0)
		self.startTime = startTime / 1000
		self.endTime = endTime / 1000
		self.duration = self.endTime - self.startTime
		self.maxValue = self.startTime

		self:SetMinMaxValues(self.startTime, self.endTime)
		self:SetValue(self.endTime)
		self:SetAlpha(1.0)
		self.holdTime = 0
		self.casting = nil
		self.channeling = 1
		self.fadeOut = nil
		self:Show()
		if barText and barText.format then
			local out = barText.format
			out = string.gsub(out, "$spell", name)
			out = string.gsub(out, "$rank", nameSubtext)
			if nameSubtext == "" then
				out = out:gsub("%(", ""):gsub("%)", "")
			end
			if orient == "VERTICAL" or barText.short then
				local vtext = ""
				out = string.gsub(out, "[^A-Z:0-9.]", "") --fridg
				out = string.gsub(out, "R(%d+)", function(s) return " R"..s end)
				for i = 1, string.len(out) do
					vtext = vtext..string.sub(out, i, i).."\n"
				end
				out = vtext
			end
			barText:SetText(out)
		end
		if barIcon then barIcon:SetTexture(texture) end
		if parent then
			parent:Show()
			parent:SetAlpha(1.0)
		end
	
	elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		if self:IsShown() then
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(self.unit)
			if not name then
				self:Hide()
				if parent then parent:Hide() end
				return
			end
			self.startTime = startTime / 1000
			self.endTime = endTime / 1000
			self.maxValue = self.startTime
			self:SetMinMaxValues(self.startTime, self.endTime)
		end
	end
end

--//


-- .hideFrame functions
----------------------------------------------------------------
-- if the .hideFrame has a ',' in it, meaning it affects more than one frame,
-- split the strings out into a table and do shit to them, otherwise dont bother and just do shit

			-- TODO:  Hook SetAlpha to this shit so when alpha == 0 or 100 it does stuff.
	--OnHide
local function Frame_HideUpdate_OnHide(self)
	for _, frame in ipairs(self.hideList) do
		frame:Show()
		--UIFrameFadeIn(frame, 0.15)
	end
end
	--OnShow
local function Frame_HideUpdate_OnShow(self)
	for _, frame in ipairs(self.hideList) do
		--UIFrameFadeOut(frame, 0.15)
		frame:Hide()
	end
end
--//

-- Frame: Model Functions
----------------------------------------------------
	-- Update Model
local function Frame_ModelUpdate(self, event)
	if event == "DISPLAY_SIZE_CHANGED" then
		self:RefreshUnit() 
	else 
		self:SetUnit(self.unit)
	end 
end
	-- OnUpdate (makes the 3d models move)
local function Frame_ModelOnUpdate(self)
	self:SetCamera(0) 
end
--//

-- Frame: Experience Update
----------------------------------------------------
	-- Update Func
local xpcurr, xpmax, xprest, xpr, xpg, xpb
local function Frame_UpdateExperience(self, unit, ...)
	if self.XP then
		xpr, xpg, xpb = 0.58, 0.0, 0.55
		if unit == "pet" then
			xpcurr, xpmax = GetPetExperience()
		else
			local name, reaction, minval, maxval, value = GetWatchedFactionInfo()
			if name then
				xpcurr = value - minval
				xpmax = maxval - minval
				xpr = FACTION_BAR_COLORS[reaction].r
				xpg = FACTION_BAR_COLORS[reaction].g
				xpb = FACTION_BAR_COLORS[reaction].b
			else
				if GetRestState() == 1 then
					xpr, xpg, xpb = 0.0, 0.39, 0.88
				end
				xpcurr, xpmax = UnitXP(self.unit), UnitXPMax(self.unit)
			end
		end
		
		xprest = GetWatchedFactionInfo() or GetXPExhaustion() or ""
		for _, child in ipairs(self.XP) do
			local objtype = child:GetObjectType()
			if xpmax == 0 then
				child:Hide()
			else
				if not child:IsShown() then
					child:Show()
				end
				if objtype == "StatusBar" then
					child:SetMinMaxValues(0, xpmax)
					--[[
					if child.ani and child.ani == "glide" then
						child.endvalue = xpcurr
						child.fade = 0.35
					else
						child:SetValue(xpcurr)
					end
					]]
					if child["Settings"].animation == "Glide" then
						child.endvalue = xpcurr
						child.fade = 0.35
					else
						child.value = xpcurr
						child:SetValue(xpcurr)
					end

					if xpr and xpg and xpb then
						child:SetStatusBarColor(xpr, xpg, xpb)
					end
					
				elseif objtype == "FontString" then
					local text, curtext, maxtext
					text = child.format
					if child["Settings"].shortCur then
						currtext = Text_ConvertNumbers(xpcurr, child["Settings"].curThreshold)
					end
					if child["Settings"].shortMax then
						maxtext = Text_ConvertNumbers(xpmax, child["Settings"].maxThreshold)
					end
					if child["Settings"].shortRest then
						xprest = Text_ConvertNumbers(xprest, child["Settings"].restThreshold)
					end
					text = text:gsub("$cur", currtext or xpcurr)
					text = text:gsub("$max", maxtext or xpmax)
					text = text:gsub("$perc", string.format("%.0f", floor(((xpcurr/xpmax)*100))).."%%")
					text = text:gsub("$rest", xprest)

					child:SetText(text)
					if xpr and xpg and xpb and child.color then
						child:SetTextColor(xpr, xpg, xpb)
					end
				end
			end
		end
	end
end

--//
-- Frame: PVP Status Update
-----------------------------------------
local pvpgroup, pvpname
local function Frame_UpdatePVP(self, unit, ...)
	if UnitIsUnit(self.unit, unit) and self.pvp then
		local objtype = self.pvp:GetObjectType()
		pvpgroup, pvpname = UnitFactionGroup(unit)
		if UnitIsPVPFreeForAll(unit) then
			if objtype == "Texture" then
				self.pvp:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
			else
				self.pvp:SetText(PVP_ENABLED)
			end
			if unit == "player" and not self.pvpenabled then
				self.pvpenabled = true
				PlaySound("igPVPUpdate")
			end
			icon:Show()
		
		elseif pvpgroup and UnitIsPVP(unit) then
			if objtype == "Texture" then
				self.pvp:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..pvpgroup)
			else
				self.pvp:SetText(PVP_ENABLED)
			end
			if unit == "player" and not self.pvpenabled then
				self.pvpenabled = true
				PlaySound("igPVPUpdate")
			end
			self.pvp:Show()
		else
			if unit == "player" and self.pvpenabled then
				self.pvpenabled = nil
			end
			self.pvp:Hide()
		end
	end
end
--//
-- Frame: Predict Stats
------------------------------------------------------
local predcurr
local function Frame_PredictStats()
	for _, frame in ipairs(predictStats) do
		if frame:IsShown() and UnitExists(frame.unit) then
			if frame.Health then
				predcurr = UnitHealth(frame.unit)
				if not frame.curr or predcurr ~= frame.curr then
					Frame_UpdateHealth(frame:GetParent(), frame.unit)
					frame.curr = predcurr
				end	
			
			elseif frame.Power then
				predcurr = UnitPower(frame.unit)
				if not frame.curr or predcurr ~= frame.curr then
					Frame_UpdatePower(frame:GetParent(), frame.unit)
					frame.curr = predcurr
				end
			end
		end
	end
end

--//
-- Frame: Text Replace
------------------------------------------------
-- TODO: CLEAN THIS SHIT UP
-- TODO(x2):  Allow custom functions to return color values
local classification = {
	["rareelite"] = ITEM_QUALITY3_DESC.."-"..ELITE,
	["rare"] = ITEM_QUALITY3_DESC,
	["elite"] = ELITE,
}

local replaceList = {
	["$name"] = function(self)
		local color
		local name = UnitName(self.unit)
		if UnitIsPlayer(self.unit) then
			local eclass = select(2, UnitClass(self.unit))
			if eclass then
				color = Nurfed2:RGBHex(RAID_CLASS_COLORS[eclass])
			end
		else
			if not UnitPlayerControlled(self.unit) and UnitIsTapped(self.unit) and not UnitIsTappedByPlayer(self.unit) then
				color = "|cff7f7f7f"
			else
				if UnitPlayerControlled(self.unit) and UnitCreatureType(self.unit) == "Beast" then
					-- unit is a pet
					color = "|cff005500"	-- TODO:  UPDATE TO SUPPORT ALL PETS!
				else
					color = Nurfed2:RGBHex(UnitSelectionColor(self.unit))
				end
			end
		end
		return (color or "|cffffffff")..(name or "").."|r"
	end,
	["$guild"] = function(self)
		local guild = GetGuildInfo(self.unit)
		if guild then
			local color = "|cff00bfff"
			if UnitIsInMyGuild(self.unit) then
				color = "|cffff00ff"
			end
			guild = color..guild.."|r"
		end
		return guild or ""
	end,
	["$level"] = function(self)
		local level = UnitLevel(self.unit)
		local classification = UnitClassification(self.unit)
		local r, g, b
		if level > 0 then
			local color = GetQuestDifficultyColor(level)
			r = color.r
			g = color.g
			b = color.b
		end
		if classification == "rareelite" or classification == "elite" or classification == "rare" then
			level = level.."+"
		elseif level == 0 then
			level = ""
		elseif level < 0 then
			level = "??"
			r, g, b = 1, 0, 0
		end
		if classification == "worldboss" then
			level = BOSS
			r, g, b = 1, 0, 0
		end
		return Nurfed2:RGBHex(r, g, b)..level.."|r"
	end,
	["$key"] = function(self)
		local id, found = self.unit:gsub("party([1-4])", "%1")
		if found == 1 then
			local binding = GetBindingText(GetBindingKey("TARGETPARTYMEMBER"..id), "KEY_")
			binding = Nurfed2:Binding(binding)
			return binding or ""
		end
	end,
	["$class"] = function(self)
		local class, eclass = UnitClass(self.unit)
		if UnitIsPlayer(self.unit) then
			if RAID_CLASS_COLORS[eclass] then
				color = Nurfed2:RGBHex(RAID_CLASS_COLORS[eclass]) or "|cffffffff"
				class = color..class.."|r"
			end
		else
			local unitclass = UnitClassification(self.unit)
			if UnitCreatureType(self.unit) == "Humanoid" and UnitIsFriend("player", self.unit) then
				class = "NPC"
			elseif UnitCreatureType(self.unit) == "Beast" and UnitCreatureFamily(self.unit) then
				class = UnitCreatureFamily(self.unit)
			else
				class = UnitCreatureType(self.unit)
			end
			if classification[unitclass] then
				class = classification[unitclass].." "..class
			end
		end
		return class or ""
	end,
	["$loot"] = function(self)
		if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
			return ITEM_QUALITY_COLORS[GetLootThreshold()].hex..UnitLootMethod[GetLootMethod()].text.."|r"
		end
		return ""
	end,
	["$threat"] = function(self, t)
		local isTanking, state, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(self.threatUnit, self.unit)
		local string = ""
		if threatValue then
			if isTanking then
				string = "|cffff0000"
			else
				string = "|cff00ff00"
			end
			threatValue = threatValue / 100 -- get the real number....	
			threatValue = Text_ConvertNumbers(threatValue)
			string = string..threatValue.."|r"
		end
		return string
	end,
	["$realm"] = function(self) return select(2, UnitName(self.unit)) or "" end,
	["$faction"] = function(self) return UnitFactionGroup(self.unit) or "" end,
	["$rname"] = function(self) return GetPVPRankInfo(UnitPVPRank(self.unit)) or "" end,
	["$rnum"] = function(self) return select(2, GetPVPRankInfo(UnitPVPRank(self.unit))) or "" end,
	["$race"] = function(self) return UnitRace(self.unit) or "" end,
}
	-- Format Text (replaces "$shit" with actual values)
local function Frame_FormatText(self, format)
	if type(format) ~= "string" then return "NO FORMAT" end
	for string, func in pairs(replaceList) do
		if format:match(string) then
			format = format:gsub(string, func(self))
		end
	end

	return format
	--[[
	if not format then return end
	local pretext = format:find("%$%a")
	string.gsub(format, "%$%a+", function(s)
		if replaceList[s] then
			format = format:gsub(s, replaceList[s](self))
		end
	end)
	if pretext == 1 then
		local post = format:find("[%a^%|cff]")
		if post and post > pretext then
			format = format:gsub("[^%a]", "", 1)
		end
	end
	return format
	]]
end
	-- Update The Text Fields
local function Frame_UpdateText(self)
	if self and self.format then
		self:SetText(Frame_FormatText(self, self.format))
	end
end
--//

-- Frame: Update All Text
--------------------------------------------------
local function Frame_UpdateAllText(self)
	for _, frame in ipairs(self.text) do
		Frame_UpdateText(frame)
	end
end	
-- Frame: Update Level
---------------------------------------------------
local function Frame_UpdateLevel(self, unit)
	if unit == self.unit then
		if self.XP then
			Frame_UpdateExperience(self, unit)
		end
		if self.level then
			Frame_UpdateText(self.level)
		end		
	end
end
--//

-- Frame: Get Class Icon
------------------------------------------------
local function Frame_GetClassIcon(self, unit, isclass, ...)
	local coords
	local texture = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
	if isclass then
		coords = class[unit]
	else
		if UnitIsPlayer(unit) or UnitCreatureType(unit) == "Humanoid" then
			coords = class[select(2, UnitClass(unit))]
		else
			coords = class["PETS"]
			texture = "Interface\\RaidFrame\\UI-RaidFrame-Pets"
		end
	end
	return texture, coords
end

-- Frame: Name Update
------------------------------------------------
local function Frame_UpdateName(self, ...)
	if self.name then
		Frame_UpdateText(self.name)
	end
	if self.class then
		local texture, coords = Frame_GetClassIcon(self, self.unit)
		if coords then
			self.class:SetTexture(texture)
			self.class:SetTexCoord(unpack(coords))
		end
	end
	if self.race then
		local coords = Frame_GetRaceIcon(self.unit)
		if coords then
			self.race:SetTexCoord(unpack(coords))
		end
	end
end
--//
local cureList = {
	["Magic"] = {
		["PRIEST"] = true,
		["PALADIN"] = true,
		["WARLOCK"] = true,
	},
	["Curse"] = {
		["DRUID"] = true,
		["MAGE"] = true,
	},
	["Disease"] = {
		["PRIEST"] = true,
		["PALADIN"] = true,
		["SHAMAN"] = true,
	},
	["Poison"] = {
		["DRUID"] = true,
		["SHAMAN"] = true,
		["PALADIN"] = true,
	},
}
-- Frame: Update Auras
-------------------------------------------------------------	
local olPos, nomove, debuffBase
local function Frame_UpdateOneLineAuras(self)
	if self.buff or self.debuff then
		olPos, nomove, debuffBase = nil, nil, nil;
		if self.buff then
			for _, bframe in ipairs(self.buff) do
				if bframe.buffs[1]:IsShown() then
					nomove = true;
					break
				end
			end
		end
			
		if self.debuff and self.debuff[1].basePosition then
			nomove, debuffBase = nil, true;
			for _, bframe in ipairs(self.debuff) do
				if bframe.debuffs[1]:IsShown() then
					nomove = true;
					break
				end
			end
		end
		for i, bframe in ipairs(debuffBase and self.buff or self.debuff) do
			if (debuffBase and bframe.buffs[i]:IsShown()) or (not debuffBase and bframe.debuffs[i]:IsShown()) then
				bframe:ClearAllPoints()
				if nomove or not self.buff then
					bframe:SetPoint(unpack(bframe.origpos))
				else
					if debuffBase then
						olPos = { self.debuff[1]:GetPoint() }
					else
						olPos = { self.buff[1]:GetPoint() }
					end
					bframe:SetPoint(unpack(olPos))
					--bframe:SetPoint(debuffBase and self.debuff[i]:GetPoint() or self.buff[i]:GetPoint())
					--debug(debuffBase, self.buff[i]:GetPoint(), self.buff[i]:GetPoint() == bframe:GetPoint(), bframe:GetName())
				end
			end
		end
			
	end
	do return end	-- old code, works with buffs being baseline, not the otherway around.
	if (self.buff or self.debuff) and self:IsShown() then
		local nomove
		if self.buff then
			for _, bframe in ipairs(self.buff) do
				if bframe.buffs[1]:IsShown() then
					nomove = true
				end
			end
		end
		if self.debuff then
			for i, bframe in ipairs(self.debuff) do
				if bframe.debuffs[i]:IsShown() then
					bframe:ClearAllPoints()
					if nomove or not self.buff then
						bframe:SetPoint(unpack(bframe.origpos))
					else
						bframe:SetPoint(self.buff[i]:GetPoint())
					end
				end
			end
		end
	end
end

local aurabtn, auratotal, auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable
local auraList = { }
local function Frame_UpdateAuras(self)
	if self.buff or self.debuff and self:IsShown() then
		if self.buff then
			for _, bframe in ipairs(self.buff) do
				Frame_UpdateAuras(bframe)
			end
		end
		if self.debuff then
			for _, bframe in ipairs(self.debuff) do
				Frame_UpdateAuras(bframe)
			end
		end
		return
	end
	table.wipe(auraList)
	if self.IsBuff then
		local filterList = { } -- Opt: Buff Filter List
		--/p1/ What I am doing here is creating a table of all the aura information
		--/p2/ the reason behind this is because it will allow for a lot easier filtering
		--/p3/ and other manipulation of what auras are and are not shown
		--/p4/ eventually allowing you to actually choose the order in which auras are shown possibly
		local i = 1
		auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable = UnitBuff(self.unit, i, self.castable)
		while auraname do
			if not filterList[auraname] then	-- only put in auras that are not in the filter list
				table.insert(auraList, { auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable })
			end
			i = i + 1
			auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable = UnitBuff(self.unit, i, self.castable)
		end
		--[[[1] = name;		[2] = rank;		[3] = texture;	[4] = count
			[5] = type;		[6] = duration;	[7] = timeleft; [8] = owner;	[9] = stealable]]
		
		for i=1, self.numAuras do
			--aurabtn = _G[self:GetName().."buff"..i]
			aurabtn = self.buffs[i]
			if not aurabtn then break end
			if auraList[i] then
				aurabtn.icon:SetTexture(auraList[i][3])
				
				-- add the count text
				if auraList[i][4] > 1 then
					aurabtn.count:SetText(auraList[i][4])
					aurabtn.count:Show()
				else
					aurabtn.count:Hide()
				end
				
				aurabtn.isself = auraList[i][8] == "player"
				if auraList[i][6] and auraList[i][6] > 0 then
					if not Nurfed2DB.UnitFrameSettings.Target.oldStyleAuras or Nurfed2DB.UnitFrameSettings.Target.oldStyleAuras and aurabtn.isself then -- possible pet check here?
						CooldownFrame_SetTimer(aurabtn.cd, auraList[i][7] - auraList[i][6], auraList[i][6], 1)
						aurabtn:SetScript("OnUpdate", Nurfed2.CooldownText)
					else
						aurabtn.cd:Hide()
					end
				else
					aurabtn.cd:Hide()
				end
				
				aurabtn:SetAlpha(1)
				aurabtn:Show()
			else
				aurabtn:SetScript("OnUpdate", nil)
				aurabtn:Hide()
			end
		end
		local scale = 1
		if self.buffWidth then
			scale = self.buffWidth / ((#self.buffs > #auraList and #self.buffs or #auraList) * self.buffs[1]:GetWidth())
		end
		if scale > 1 then scale = 1 end
		for _, btn in ipairs(self.buffs) do
			if btn:IsShown() then
				btn:SetScale(scale)
			end
		end
	end
	
	if self.IsDebuff then
		local filterList = { } -- Opt: debuff Filter List
		local i = 1
		auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable = UnitDebuff(self.unit, i, self.dispelable)
		while auraname do
			if not filterList[auraname] then	-- only put in auras that are not in the filter list
				table.insert(auraList, { auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable })
			end
			i = i + 1
			auraname, aurarank, auratexture, auraapp, auratype, auradur, auraleft, auraowner, auraisStealable = UnitDebuff(self.unit, i, self.dispelable)
		end
		--[[[1] = name;		[2] = rank;		[3] = texture;	[4] = count
			[5] = type;		[6] = duration;	[7] = timeleft; [8] = owner;	[9] = stealable]]
		local isFriend = UnitIsFriend(self.unit, "player")
		for i=1, self.numAuras do
			--aurabtn = _G[self:GetName().."debuff"..i]
			aurabtn = self.debuffs[i]
			if not aurabtn then break end
			if auraList[i] then
				aurabtn.icon:SetTexture(auraList[i][3])
				
				-- add the count text
				if auraList[i][4] > 1 then
					aurabtn.count:SetText(auraList[i][4])
					aurabtn.count:Show()
				else
					aurabtn.count:Hide()
				end
				
				aurabtn.isself = auraList[i][8] == "player"
								
				aurabtn.border:SetVertexColor(DebuffTypeColor[auraList[i][5] or "none"].r, DebuffTypeColor[auraList[i][5] or "none"].g, DebuffTypeColor[auraList[i][5] or "none"].b)
				if auraList[i][6] and auraList[i][6] > 0 then
					if not Nurfed2DB.UnitFrameSettings.Target.oldStyleAuras or Nurfed2DB.UnitFrameSettings.Target.oldStyleAuras and aurabtn.isself then -- possible pet check here?
						CooldownFrame_SetTimer(aurabtn.cd, auraList[i][7] - auraList[i][6], auraList[i][6], 1)
						aurabtn:SetScript("OnUpdate", Nurfed2.CooldownText)
					else
						aurabtn.cd:Hide()
					end
				else
					aurabtn.cd:Hide()
				end
				if isFriend and auraList[i][5] and cureList[auraList[i][5]] and cureList[auraList[i][5]][playerClass] then
					if not aurabtn:GetScript("OnUpdate") then
						aurabtn.flashtime = GetTime()
						aurabtn.update = 0
						aurabtn.flashdct = 1
						aurabtn:SetScript("OnUpdate", aurafade)
					end
				else
					aurabtn:SetScript("OnUpdate", Nurfed2.CooldownText)
				end
				
				aurabtn:SetAlpha(1)
				aurabtn:Show()
			else
				aurabtn:SetScript("OnUpdate", nil)
				aurabtn:Hide()
			end
		end
		local scale = 1
		if self.debuffWidth then
			scale = self.debuffWidth / ((#self.debuffs > #auraList and #self.debuffs or #auraList) * self.debuffs[1]:GetWidth())
		end
		if scale > 1 then scale = 1 end
		for _, btn in ipairs(self.debuffs) do
			local tscale
			if btn:IsShown() then
				if btn.isself and Nurfed2DB.UnitFrameSettings.Target.bigDebuffs then 
					tscale = scale * Nurfed2DB.UnitFrameSettings.Target.bigDebuffScale
				end
				btn:SetScale(tscale or scale)
			end
		end
		Frame_UpdateOneLineAuras(self:GetParent())
		--[[
		local width, fwidth, scale
		if self.debuffWidth then
			width = aurabtn:GetWidth()
			fwidth = total * width
			scale = self.debuffWidth / fwidth
			if scale > 1 then scale = 1 end
			for i = 1, self.numAuras do
				_G[self:GetName().."debuff"..i]:SetScale(scale)
			end
		end
		]]
	end
end
--//

-- Frame: Update Raid Icon
------------------------------------------------------------
local function Frame_UpdateRaidIcon(self, unit)
	unit = unit or self.unit
	local index = GetRaidTargetIndex(unit)
	if index then
		SetRaidTargetIconTexture(self.raidtarget, index)
		self.raidtarget:Show()
	else
		self.raidtarget:Hide()
	end
end
--//

-- Frame: Update Leader Status
-------------------------------------------------------------
local function Frame_UpdateLeader(self)
	local id, found = self.unit:gsub("party([1-4])", "%1")
	if self.unit == "player" then
		if IsPartyLeader() then
			self.leader:Show()
		else
			self.leader:Hide()
		end
		
	elseif self.unit == "target" then
		if UnitIsPartyLeader(self.unit) then
			self.leader:Show()
		else
			self.leader:Hide()
		end
		
	elseif found == 1 then
		if GetPartyLeaderIndex() == tonumber(id) then
			self.leader:Show()
		else
			self.leader:Hide()
		end
	end
end
--//

-- Frame: Update Master Loot Status
-------------------------------------------------------------
local function Frame_UpdateMaster(self)
	local id, found = self.unit:gsub("party([1-4])", "%1")
	local lootMethod, lootMaster = GetLootMethod()
	if unit == "player" then
		if lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) then
			self.master:Show()
		else
			self.master:Hide()
		end

	elseif found == 1 then
		if lootMaster == tonumber(id) then
			self.master:Show()
		else
			self.master:Hide()
		end
	end
end
--//

-- Frame: Update Combo Points
------------------------------------------------------
local comboPoints
local function Frame_UpdateComboPoints(self)
	comboPoints = GetComboPoints("player", "target")
	for _, child in ipairs(self.combo) do
		if comboPoints > 0 then
			local objtype = child:GetObjectType()
			if objtype == "FontString" then
				child:SetText(comboPoints)
				if comboPoints < 5 then
					child:SetTextColor(1, 1, 0)
				else
					child:SetTextColor(1, 0, 0)
				end
				child:Show()
				
			elseif objtype == "StatusBar" then
				child:SetMinMaxValues(0, 5)
				child:SetValue(comboPoints)
				child:Show()
				
			else
				if comboPoints >= child.id then
					child:Show()
				else
					child:Hide()
				end
			end
		else
			child:Hide()
		end
	end
end
--//

-- Frame: Update Combat Status
local function Frame_UpdateStatus(self, unit)
	local icon = self.Status
	local objtype = icon:GetObjectType()
	if UnitAffectingCombat(self.unit) then
		if objtype == "Texture" then
			icon:SetTexCoord(0.5, 1.0, 0, 0.5)
		else
			icon:SetText("Combat")
			icon:SetTextColor(1, 0, 0)
		end
		icon:Show()
		
	elseif IsResting() then
		if objtype == "Texture" then
			icon:SetTexCoord(0, 0.5, 0, 0.5)
		else
			icon:SetText(TUTORIAL_TITLE30)
			icon:SetTextColor(1, 1, 0)
		end
		icon:Show()
	else
		icon:Hide()
	end
end
--// End Update Combat Status

-- LibHealComm: locals
-------------------------------------------------------------
local playerEndTime, playerGUID;
local lhcFrames = {};
local INCOMING_SECONDS = 3;
-- end locals
-- LibHealComm: Update HealBar
-------------------------------------------------------------
local curheal, maxheal, percheal, missheal
local function LHC_UpdateHealBar(self, int)
	-- This makes sure that when a heal like Tranquility is cast, it won't show the entire cast but cap it at 4 seconds into the future
	local time = GetTime()
	local timeBand = playerEndTime and math.min(playerEndTime - time, INCOMING_SECONDS) or INCOMING_SECONDS
	local healed = (lhc:GetHealAmount(UnitGUID(self.unit), lhc.ALL_HEALS, time + timeBand) or 0) * lhc:GetHealModifier(UnitGUID(self.unit))

	curheal = UnitHealth(self.unit) + healed
	maxheal = UnitHealthMax(self.unit)
	percheal = curheal / maxheal
	missheal = maxheal - curheal
	local objtype
	for _, child in ipairs(self.Heal) do
		objtype = child:GetObjectType()
		if objtype == "StatusBar" then
			if healed > 0 then
				child:SetMinMaxValues(0, maxheal)
				--[[
				if child.ani and child.ani == "glide" then
					child.endvalue = curheal
					child.fade = 0.35
				else
					child:SetValue(curheal)
				end
				]]
				if child["Settings"].animation == "Glide" then
					child.endvalue = curheal
					child.fade = 0.35
				else
					child.value = curheal
					child:SetValue(curheal)
				end

				local hpr, hpg, hpb = unpack(StatusBar_GetColor(child, "hp", percheal))
				child:SetStatusBarColor(hpr, hpg, hpb)
				child:Show()
				
				--TODO: FINISH THIS WITH EVERYTHING ELSE LIKE TEXT AND SHIT
			else
				child:Hide()
			end
		end
	end
end

-- LibHealComm: Update Incoming Heals
-------------------------------------------------------------
local function LHC_UpdateIncomming(int, ...)
	for _, frame in ipairs(lhcFrames) do
		for i=1, select("#", ...) do
			if select(i, ...) == UnitGUID(frame.unit) then
				LHC_UpdateHealBar(frame, int)
			end
		end
	end
end
-- end update of incoming

-- LibHealComm: Update Heals
-------------------------------------------------------------
local function LHC_HealUpdated(event, casterGUID, spellID, healType, endTime, ...)
	if (casterGUID == playerGUID and bit.band(healType, lhc.CASTED_HEALS) > 0) then 
		playerEndTime = endTime 
	end
	LHC_UpdateIncomming(nil, ...)
end
-- End Update Heals

-- LibHealComm: Interrupt Heals
local function LHC_HealInterrupted(event, casterGUID, spellID, healType, interrupt, ...)
	if (casterGUID == playerGUID and bit.band(healType, lhc.CASTED_HEALS) > 0 ) then playerEndTime = nil end
	LHC_UpdateIncomming(interrupt, ...)
end
-- end interrupt

-- LibHealComm: Modifier Changed
-------------------------------------------------------------
local function LHC_ModifierChanged(event, guid)
	LHC_UpdateIncomming(nil, guid)
end
-- end modifier changed

-- LibHealComm: GUID goes poof
-------------------------------------------------------------
local function LHC_GUIDGone(event, guid)
	LHC_UpdateIncomming(true, guid)
end
--// end guid going poof

-- Frame: Update All Settings/Variables
-------------------------------------------------------------
function Frame_UpdateAll(self, force)
	if self.Health then Frame_UpdateHealth(self, self.unit) end
	if self.Heal then LHC_UpdateHealBar(self) end
	if self.Power then Frame_UpdatePower(self, self.unit) end
	if self.XP then Frame_UpdateExperience(self, self.unit) end
	if self.Status then Frame_UpdateStatus(self, self.unit) end
	if self.pvp then Frame_UpdatePVP(self, self.unit) end
	if self.name then Frame_UpdateName(self, self.unit) end
	if self.level then Frame_UpdateLevel(self, self.unit) end
	if self.model then if self.model["Settings"].hideModel then self.model:Hide() else self.model:SetUnit(self.unit) end end
	if self.buff or self.debuff then Frame_UpdateAuras(self) end
	if self.raidtarget then Frame_UpdateRaidIcon(self, self.unit) end
	if self.leader then Frame_UpdateLeader(self) end
	if self.master then Frame_UpdateMaster(self) end
	if self.combo then Frame_UpdateComboPoints(self) end
	if self.text then Frame_UpdateAllText(self) end
	if force then
		if self.Health then
			for _, child in ipairs(self.Health) do
				if child:GetObjectType() == "StatusBar" then
					if child["Settings"].animation == "Glide" then
						child.endvalue = 1
						child.fade = 1
						child.startvalue = 0
						child:SetScript("OnUpdate", StatusBar_Glide)
					elseif child["Settings"].animation == "Fade" then
						Nurfed2_Fade(child)
					elseif child["Settings"].animation == "None" then
						child:SetScript("OnUpdate", nil)
					end
				end
			end
		end
		if self.Power then
			for _, child in ipairs(self.Power) do
				if child:GetObjectType() == "StatusBar" then
					if child["Settings"].animation == "Glide" then
						child.endvalue = 1
						child.fade = 1
						child.startvalue = 0
						child:SetScript("OnUpdate", StatusBar_Glide)
					elseif child["Settings"].animation == "Fade" then
						Nurfed2_Fade(child)
					elseif child["Settings"].animation == "None" then
						child:SetScript("OnUpdate", nil)
					end
				end
			end
		end
	end
	if self == Nurfed2_Player and not InCombatLockdown() then
		local visMode = Nurfed2DB.UnitFrameSettings.Player.Frame.visibilityMode;
		UnregisterStateDriver(Nurfed2_Player, "visibility", "show")
		UnregisterStateDriver(Nurfed2_Player, "visibility", "hide")
		if visMode == "State" then
			RegisterStateDriver(Nurfed2_Player, "visibility", Nurfed2DB.UnitFrameSettings.Player.Frame.visibilityState)
		elseif visMode == "Combat" then
			RegisterStateDriver(Nurfed2_Player, "visibility", "[combat]show;hide")
		elseif visMode == "Target" then
			RegisterStateDriver(Nurfed2_Player, "visibility", "[@target,exists]show;hide")
		elseif visMode == "Focus" then
			RegisterStateDriver(Nurfed2_Player, "visibility", "[@focus,exists]show;hide")
		elseif visMode == "None" then
			RegisterStateDriver(Nurfed2_Player, "visibility", "show")
		end
	end
	-- new code
	--if self.Cast then Frame_Cast_CastStart(self) end
end
--//
-- Frame: Show All Frames
-----------------------------------------------------------
--[[
local showAll;
local oldPet
local function Frame_ShowAll(show)
	if show then
		if Nurfed2_Player then Nurfed2_Player:Show() end
		if Nurfed2_Target then Nurfed2_Target:Show() end
		if Nurfed2_Pet then 
			oldPet = Nurfed2_Pet.Hide
			Nurfed2_Pet.Hide = function() end
			Nurfed2_Pet:Show()
			for i,v in pairs(Nurfed2_Pet.text) do
				v:SetText(v:GetName():gsub("Nurfed2_Pet", ""))
			end
		end
		for i=1,4 do
			if _G["Nurfed2_Party"..i] then _G["Nurfed2_Party"..i]:Show() end
		end
	end
end
]]
--- end show all
-- Get Roster Info Based On Name
local function GetGroup(name)
	if UnitExists(name) then
		local rname, rank, group
		for i = 1, GetNumRaidMembers() do
			rname, rank, group = GetRaidRosterInfo(i)
			if rname and name == rname then
				return group, rank
			end
		end
	end
	return nil, nil
end

-- Event List And Functions
local partysched
function Frame_UpdateParty()
	if InCombatLockdown() then
		if not partysched then
			partysched = true
			Nurfed2:Schedule("combat", Frame_UpdateParty)
		end
	else
		if HIDE_PARTY_INTERFACE == "1" and (GetNumRaidMembers() > Nurfed2DB.UnitFrameSettings.General.RaidSize) then
			for _, frame in ipairs(partyframes) do
				frame:Hide()
			end
		else
			for _, frame in ipairs(partyframes) do
				if frame:GetAttribute("state-unitexists") then
					frame:Show()
				else
					frame:Hide()
				end
			end
		end
		partysched = nil
	end
end

hooksecurefunc("RaidOptionsFrame_UpdatePartyFrames", Frame_UpdateParty)

local function Frame_ShowParty(self)
	if InCombatLockdown() then
		if not partysched then
			partysched = true
			Nurfed2:Schedule("combat", Frame_UpdateParty)
		end
	else
		if not UnitExists(self.unit) or (HIDE_PARTY_INTERFACE == "1" and (GetNumRaidMembers() > Nurfed2DB.UnitFrameSettings.General.RaidSize)) then
			self:Hide()
		else
			self:Show()
		end
	end
end

local function Frame_UpdateGroupNumber(self)
	local group = GetGroup(UnitName(self.unit))
	if group then
		self.group:SetText(GROUP..": |cffffff00"..group.."|r")
	else
		self.group:SetText(nil)
	end
end

local function Frame_UpdateGroup(self)
	if self.unit == "player" then
		if self.leader then Frame_UpdateLeader(self) end
		if self.master then Frame_UpdateMaster(self) end
		if self.group then Frame_UpdateGroupNumber(self) end
		if self.loot then Frame_UpdateText(self.loot) end
	else
		Frame_UpdateAll(self)
	end
end
-- Frame: Target of Target(s) Update
------------------------------------------------------
local ToT_LastName = "StupidFoolFromIllidian"
local function Frame_TOTUpdate()
	for _, self in ipairs(tots) do
		if UnitExists(self.unit) then
			ToT_LastName = UnitName(self.unit)
			-- only update when the unit changes, let predict stats take care of the rest.
			if self.lastname ~= ToT_LastName then
				self.lastname = ToT_LastName
				Frame_UpdateAll(self)
			end
		end
	end
end
--//
-- pet happiness shit
local function Frame_UpdateHappiness(self)
	local happiness, damagePercentage = GetPetHappiness()
	local hasPetUI, isHunterPet = HasPetUI()
	if happiness or isHunterPet then
		local display
		local text = self.name
		local icon = self.happiness
		if icon then 
			icon:Show() 
		end
		if happiness == 1 then
			if text then text:SetTextColor(1, 0.5, 0) end
			if icon then icon:SetTexCoord(0.375, 0.5625, 0, 0.359375) end
		elseif happiness == 2 then
			if text then text:SetTextColor(1, 1, 0) end
			if icon then icon:SetTexCoord(0.1875, 0.375, 0, 0.359375) end
		elseif happiness == 3 then
			if text then text:SetTextColor(0, 1, 0) end
			if icon then icon:SetTexCoord(0, 0.1875, 0, 0.359375) end
		end
		if text then
			text:SetText(Frame_UpdateText(self.name))
		end
	end
end
--//
-- Frame: Events List
------------------------------------------------------
local events = { 
	UNIT_HEALTH = Frame_UpdateHealth,
	UNIT_MAXHEALTH = Frame_UpdateHealth,
	
	UNIT_DISPLAYPOWER = Frame_UpdatePower,
	
	PLAYER_XP_UPDATE = Frame_UpdateExperience,
	PLAYER_LEVEL_UP = Frame_UpdateExperience,
	UPDATE_EXHAUSTION = Frame_UpdateExperience,
	UPDATE_FACTION = Frame_UpdateExperience,
	UNIT_LEVEL = Frame_UpdateExperience,
	
	UNIT_FACTION = Frame_UpdatePVP,
	
	UNIT_NAME_UPDATE = Frame_UpdateName,
	UNIT_DYNAMIC_FLAGS = Frame_UpdateName,
--	PLAYER_TARGET_CHANGED = Frame_UpdateAll, -- GO BACK TO USING THIS; TEMP FIX FOR CASTING BAR (using old, non-new code)
	PLAYER_TARGET_CHANGED = function(self, ...)
		Frame_UpdateAll(self)
		if self.Cast then
			Frame_CastingOnEvent(self.Cast, "PLAYER_TARGET_CHANGED", self.unit, ...)
		end
	end,
	
	PARTY_LEADER_CHANGED = Frame_UpdateAll,
	PLAYER_ENTERING_WORLD = Frame_UpdateAll,
	
	RAID_TARGET_UPDATE = Frame_UpdateRaidIcon,
	
	PLAYER_FOCUS_CHANGED = Frame_UpdateAll,
	
	RAID_ROSTER_UPDATE = Frame_UpdateGroup,
	PARTY_MEMBERS_CHANGED = Frame_UpdateGroup,
	
	UNIT_AURA = Frame_UpdateAuras,
	
	UNIT_COMBO_POINTS = Frame_UpdateComboPoints,
	
	UPDATE_SHAPESHIFT_FORM = Frame_UpdateAll,
	
	PLAYER_REGEN_ENABLED = Frame_UpdateStatus,
	PLAYER_REGEN_DISABLED = Frame_UpdateStatus,
	PLAYER_UPDATE_RESTING = Frame_UpdateStatus,
	UNIT_HAPPINESS = Frame_UpdateHappiness,
}
--//

-- OnEvent
local goevent
local function Frame_OnEvent(event, ...)
	for _, frame in ipairs(units[event]) do
		if UnitExists(frame.unit) then
			if event == "UNIT_PET" and ((arg1 == "player" and unit == "pet") or (arg1 == unit:gsub("pet", ""))) then
				goevent = true
			
			elseif event:find("^UNIT_") then
				if arg1 == frame.unit then
					goevent = true;
				elseif event == "UNIT_COMBO_POINTS" and arg1 == "player" and frame.unit == "target" then
					goevent = true;
				end
			else
				goevent = true;
			end
		end
		if goevent then
			if not events[event] then 
				goevent = nil;
				--if UnitName("player") == "Apoco" or UnitName("player") == "Adkpoco" or UnitName("player") == "Chetvipoco" then
				--	print("NO EVENT FUNC!>", event) 
				--end
				return
			end
			events[event](frame, ...)
			goevent = nil
		end
	end
end

local disable = {
	player = function()
		_G["PlayerFrame"]:UnregisterAllEvents()
		_G["PlayerFrame"]:Hide()
		UnregisterUnitWatch(_G["PlayerFrame"])
	end,
	target = function()
		_G["TargetFrame"]:UnregisterAllEvents()
		_G["TargetFrame"]:Hide()
		UnregisterUnitWatch(_G["TargetFrame"])
	end,
	party1 = function()
		for i = 1, 4 do
			local party = _G["PartyMemberFrame"..i]
			party:UnregisterAllEvents()
			party:Hide()
			UnregisterUnitWatch(party)
		end
		_G["ShowPartyFrame"] = function() end
	end,
	focus = function()
		_G["FocusFrame"]:UnregisterAllEvents()
		_G["FocusFrame"]:Hide()
		UnregisterUnitWatch(_G["FocusFrame"])
		if _G["ShowFocusFrame"] then
			_G["ShowFocusFrame"] = function() end
		end
	end,
}
local function Frame_ImbueSettings(frame)
	local id, found = frame.unit:gsub("party([1-4])", "%1")
	if found == 1 and string.len(frame.unit) > 6 then
		id = nil; found = nil
	end
	
	local events = { "PLAYER_ENTERING_WORLD", "UNIT_NAME_UPDATE" }
	local frames = {}
	Nurfed2:GetFrames(frame, frames, true)
	-- disable blizzards frames
	if disable[frame.unit] then disable[frame.unit]() end
	
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnEnter", UnitFrame_OnEnter)
	frame:SetScript("OnLeave", UnitFrame_OnLeave)
	local function Frame_OnDragStart(self)
		if Nurfed2:IsLocked() or InCombatLockdown() then return end
		self:StartMoving()
	end
	local function Frame_OnDragStop(self)
		self:StopMovingOrSizing()
		self:SetUserPlaced(true)
	end
	local function Frame_OnMouseWheel(self)
		if Nurfed2:IsLocked() or InCombatLockdown() then return end
		local scale = self:GetScale()
		if arg1 > 0 and scale < 3 then
			self:SetScale(scale + 0.1)
		elseif arg1 < 0 and scale > 0.25 then
			self:SetScale(scale - 0.1)
		end
		if IsShiftKeyDown() and IsControlKeyDown() then
			self:SetScale(1)
		end
		if not Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName] then
			Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName] = { }
		end
		if not Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][self:GetName():gsub("^Nurfed2_", ""):lower()] then
			Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][self:GetName():gsub("^Nurfed2_", ""):lower()] = { }
		end
		Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][self:GetName():gsub("^Nurfed2_", ""):lower()].Scale = self:GetScale()
	end
	local function Frame_SavePointPosition(self)
		self:StartMoving()
		self:StopMovingOrSizing()
	end
	local function Frame_SavePosition(self)
		local p1, p2, p3, p4, p5 = self:GetPoint()
		if (p1 and p3 and p4 and p5) then
			p2 = p2 or UIParent
			if type(p2) == "table" then
				p2 = p2:GetName()
			end
			if not Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName] then
				Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName] = { }
			end
			if not Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][self:GetName():gsub("^Nurfed2_", ""):lower()] then
				Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][self:GetName():gsub("^Nurfed2_", ""):lower()] = { }
			end
			Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][self:GetName():gsub("^Nurfed2_", ""):lower()].Position = { p1, p2, p3, p4, p5 }
		end
	end
	if frame:GetParent() == UIParent then
		-- setting a var of 'noscroll = true' will disable the scrolling for scale.
		-- setting a var of 'nomove = true' will disable moving the frame all together.
		if not frame.noscroll then
			frame:EnableMouseWheel(true)
			frame:SetScript("OnMouseWheel", Frame_OnMouseWheel)
		end
		if not frame.nomove then
			frame:RegisterForDrag("LeftButton")
			frame:SetMovable(true)
			frame:SetScript("OnDragStart", Frame_OnDragStart)
			frame:SetScript("OnDragStop", Frame_OnDragStop)
			hooksecurefunc(frame, "StopMovingOrSizing", Frame_SavePosition)
			hooksecurefunc(frame, "SetPoint", Frame_SavePointPosition)
		end
	end
	if frame.unit == "player" then
		Nurfed2:insert(events, "PLAYER_COMBAT")
		Nurfed2:insert(events, "UPDATE_SHAPESHIFT_FORM")
		Nurfed2:insert(events, "UNIT_EXITED_VEHICLE")
		Nurfed2:insert(events, "UNIT_ENTERED_VEHICLE")
		RuneFrame:UnregisterAllEvents()
		RuneFrame:Hide()
	end
	if frame.unit == "target" then
		Nurfed2:insert(events, "PLAYER_TARGET_CHANGED")
		Nurfed2:insert(events, "UNIT_DYNAMIC_FLAGS")
		Nurfed2:insert(events, "UNIT_CLASSIFICATION_CHANGED")
	end
	--// Fixes Focus Update Problems
	if frame.unit == "focus" then
		Nurfed2:insert(events, "PLAYER_FOCUS_CHANGED")
	end
	if frame.unit ~= "player" then
		RegisterUnitWatch(frame)
	end

	local dropdown, menufunc
	if found == 1 then
		frame.isParty = true
		frame:SetID(tonumber(id))
		if not frame.noEvents then
			frame:SetScript("OnAttributeChanged", Frame_ShowParty)
			Nurfed2:insert(events, "UNIT_COMBAT")
			Nurfed2:insert(events, "PARTY_MEMBERS_CHANGED")
		end
		dropdown = _G["PartyMemberFrame"..id.."DropDown"]
		Nurfed2:insert(partyframes, frame)
		RegisterUnitWatch(frame, true)
		if not UnitExists(frame.unit) then
			frame:Hide()
		end
	else
		dropdown = _G[frame.unit:gsub("^%l", string.upper).."FrameDropDown"]
	end
	if dropdown then
		menufunc = function() securecall("ToggleDropDownMenu", 1, nil, dropdown, "cursor") end
	end
	
	-- Load the Unit
	SecureUnitButton_OnLoad(frame, frame.unit, menufunc)
	
	-- Enable Click Casting
	if not ClickCastFrames then ClickCastFrames = { }; end
	ClickCastFrames[frame] = true
	
	local name = frame:GetName()
	local function RegisterStatus(pre, child)
		if not frame[pre] then
			frame[pre] = {}
			if not frame.unit then
				local k = frame:GetParent()
				while not k.unit do
					k = k:GetParent()
				end
				frame.unit = k.unit
			end
			
			if pre == "Health" then
				Nurfed2:insert(predictStats, child)
				child.Health = true
			
			elseif pre == "Heal" then
				if IsAddOnLoaded("LibHealComm-4.0") then
					lhc = LibStub("LibHealComm-4.0", true)
					lhc.RegisterCallback("N2UF", "HealComm_HealStarted", LHC_HealUpdated)
					lhc.RegisterCallback("N2UF", "HealComm_HealStopped", LHC_HealInterrupted)
					lhc.RegisterCallback("N2UF", "HealComm_HealDelayed", LHC_HealUpdated)
					lhc.RegisterCallback("N2UF", "HealComm_HealUpdated", LHC_HealUpdated)
					lhc.RegisterCallback("N2UF", "HealComm_ModifierChanged", LHC_ModifierChanged)
					lhc.RegisterCallback("N2UF", "HealComm_GUIDDisappeared", LHC_GUIDGone)
					child.Heal = true
					playerGUID = UnitGUID("player")
					Nurfed2:insert(lhcFrames, frame)
				end

			elseif pre == "Threat" then
				Nurfed2:insert(events, "UNIT_THREAT_LIST_UPDATE")
				Nurfed2:insert(events, "UNIT_THREAT_SITUATION_UPDATE")
			
			elseif pre == "Power" then
				Nurfed2:insert(predictStats, child)
				Nurfed2:insert(events, "UNIT_DISPLAY_POWER")
				child.Power = true
	
			elseif pre == "XP" then
				if frame.unit == "player" then
					Nurfed2:insert(events, "PLAYER_XP_UPDATE");
					Nurfed2:insert(events, "PLAYER_LEVEL_UP");
					Nurfed2:insert(events, "UPDATE_EXHAUSTION");
					Nurfed2:insert(events, "UPDATE_FACTION");
					
				elseif frame.unit == "pet" then
					Nurfed2:insert(events, "UNIT_PET_EXPERIENCE");
				end
				
			elseif pre == "combo" then
				Nurfed2:insert(events, "UNIT_COMBO_POINTS");
				_G["ComboFrame"]:UnregisterAllEvents()
				_G["ComboFrame"]:Hide()
				
			elseif pre == "feedback" then
				Nurfed2:insert(events, "UNIT_COMBAT");
				
			elseif pre == "buff" or pre == "debuff" then
				if not string.find(frame.unit, "target", 2, true) then
					Nurfed2:insert(events, "UNIT_AURA");
				end
			
			elseif pre == "rune" then
				Nurfed2:insert(events, "RUNE_POWER_UPDATE");
				Nurfed2:insert(events, "RUNE_TYPE_UPDATE");
			
			elseif pre == "buff" then
				Nurfed2:insert(events, "UNIT_AURA")
			end
		end
		if frame.unit:find("^party") then
			child.Settings = Nurfed2DB["UnitFrameSettings"].Party[pre]
		elseif frame.unit:find("^raid") then
			child.Settings = Nurfed2DB["UnitFrameSettings"].Raid[pre]
		else
			if Nurfed2DB["UnitFrameSettings"][string.capital(frame.unit):gsub("%d", ""):gsub("target", "", 2)] then
				if Nurfed2DB["UnitFrameSettings"][string.capital(frame.unit):gsub("%d", ""):gsub("target", "", 2)][pre] then
					child.Settings = Nurfed2DB["UnitFrameSettings"][string.capital(frame.unit):gsub("%d", ""):gsub("target", "", 2)][pre]
				else
					child.Settings = Nurfed2DB["UnitFrameSettings"].General
				end
			end
		end
		if child.hideFrame and child.GetScript then
			if not child.hideList then child.hideList = { } end
			if child.hideFrame:find(",") then
				for _, hframe in ipairs({ child.hideFrame:split(",") }) do
					Nurfed2:insert(child.hideList, _G[child:GetParent():GetName()..hframe])
				end
			else
				Nurfed2:insert(child.hideList, _G[child:GetParent():GetName()..child.hideFrame])
			end
			
			if child:GetScript("OnHide") then
				child:HookScript("OnHide", Frame_HideUpdate_OnHide)
			else
				child:SetScript("OnHide", Frame_HideUpdate_OnHide)
			end
			if child:GetScript("OnShow") then
				child:HookScript("OnShow", Frame_HideUpdate_OnShow)
			else
				child:SetScript("OnShow", Frame_HideUpdate_OnShow)
			end
		end
		
		table.insert(frame[pre], child)
		table.sort(frame[pre], function(a,b) 
			local ma, mb = a:GetName():match("%d"), b:GetName():match("%d")
			if ma and mb then
				return ma < mb
			end
		end)
	end
	
	-- Update the children
	local function UpdateChildren(child)
		local objtype = child:GetObjectType()
		local childname = child:GetName():gsub(name, "")
		if not child.unit then
			local k = child:GetParent()
			while not k.unit do
				k = k:GetParent()
			end
			child.unit = k.unit
		end
		if not childname:find("^target") and not childname:find("^pet") then
			local pre = childname:sub(1, 2)
			-- pre check
			if pre == "hp" or pre == "po" or pre == "xp" or pre == "he" then
				if pre == "hp" then pre = "Health" end
				if pre == "po" then pre = "Power" end
				if pre == "xp" then pre = "XP" end
				if pre == "he" then pre = "Heal" end
				RegisterStatus(pre, child)
				--[[
				if child.ani then
					if child.ani == "glide" then
						child.endvalue = 1
						child.fade = 1
						child.startvalue = 0
						child:SetScript("OnUpdate", StatusBar_Glide)
						
					elseif child.ani == "fade" then
						child.endvalue = 1
						child.fade = 1
						child.startvalue = 0
						child:SetScript("OnUpdate", StatusBar_Glide)
						Nurfed2_Fade(child)
					end
				end
				]]
				
			elseif objtype == "StatusBar" then
				if childname:find("^cast") then
					if child:GetParent() ~= frame then
						child.parent = child:GetParent()
					end
					frame.Cast = child;
					child.unit = frame.unit
					child.casting = nil
					child.channeling = nil
					child.holdTime = 0
					child:RegisterEvent("UNIT_SPELLCAST_SENT")
					child:RegisterEvent("UNIT_SPELLCAST_START")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
					child:RegisterEvent("UNIT_SPELLCAST_STOP")
					child:RegisterEvent("UNIT_SPELLCAST_FAILED")
					child:RegisterEvent("UNIT_SPELLCAST_DELAYED")
					child:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
					child:RegisterEvent("PLAYER_ENTERING_WORLD")

					if frame.unit == "target" then child:RegisterEvent("PLAYER_TARGET_CHANGED")
					elseif frame.unit == "focus" then child:RegisterEvent("PLAYER_FOCUS_CHANGED")
					elseif found == 1 then child:RegisterEvent("PARTY_MEMBERS_CHANGED")
					end
					child:SetScript("OnEvent", Frame_CastingOnEvent)
					child:SetScript("OnUpdate", Frame_CastingOnUpdate)
				end
				if child.hideFrame and child.GetScript then
					if not child.hideList then child.hideList = { } end
					if child.hideFrame:find(",") then
						for _, hframe in ipairs({ child.hideFrame:split(",") }) do
							Nurfed2:insert(child.hideList, _G[child:GetParent():GetName()..hframe])
						end
					else	Nurfed2:insert(child.hideList, _G[child:GetParent():GetName()..child.hideFrame])
					end
					
					if child:GetScript("OnHide") then	child:HookScript("OnHide", Frame_HideUpdate_OnHide)
					else								child:SetScript("OnHide", Frame_HideUpdate_OnHide)
					end
					if child:GetScript("OnShow") then	child:HookScript("OnShow", Frame_HideUpdate_OnShow)
					else								child:SetScript("OnShow", Frame_HideUpdate_OnShow)
					end
					
				end
			elseif childname:find("^pvp") then
				Nurfed2:insert(events, "UNIT_FACTION")
				frame.pvp = child
				
			elseif childname:find("^status") or childname:find("^Status") then
				Nurfed2:insert(events, "PLAYER_REGEN_DISABLED")
				Nurfed2:insert(events, "PLAYER_REGEN_ENABLED")
				Nurfed2:insert(events, "PLAYER_UPDATE_RESTING")
				frame.Status = child
		
			elseif childname:find("^combo") then
				RegisterStatus("combo", child)
			
			elseif objtype == "Texture" then
				local texture = child:GetTexture()
				if texture then
					if texture == "Interface\\GroupFrame\\UI-Group-LeaderIcon" then
						Nurfed2:insert(events, "PARTY_LEADER_CHANGED")
						frame.leader = child
						
					elseif texture == "Interface\\GroupFrame\\UI-Group-MasterLooter" then
						Nurfed2:insert(events, "PARTY_LOOT_METHOD_CHANGED")
						frame.master = child
						
					elseif texture == "Interface\\QuestFrame\\UI-QuestTitleHighlight" then
						Nurfed2:insert(events, "PLAYER_TARGET_CHANGED")
						if (not frame:GetHighlightTexture()) then
							frame:SetHighlightTexture(child)
							frame.highlight = child
						end
						
					elseif texture == "Interface\\TargetingFrame\\UI-RaidTargetingIcons" then
						Nurfed2:insert(events, "RAID_TARGET_UPDATE")
						frame.raidtarget = child
						
					elseif texture == "Interface\\PetPaperDollFrame\\UI-PetHappiness" then
						Nurfed2:insert(events, "UNIT_HAPPINESS")
						frame.happiness = child
						
					elseif texture == "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes" then
						frame.class = child
						
					elseif texture == "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races" then
						frame.race = child
					end
					
					if child.isHighlight then
						Nurfed2:insert(events, "PLAYER_TARGET_CHANGED")
						if (not frame:GetHighlightTexture()) then
							frame:SetHighlightTexture(child)
							frame.highlight = child
						end
					end
					
					if childname:find("lag") and not childname:find("lagtext") then
						frame.lag = child
					end
					
				elseif childname:find("^portrait") or child.isportrait then
					Nurfed2:insert(events, "UNIT_PORTRAIT_UPDATE")
					frame.portrait = child
					
				elseif childname:find("^rank") then
					frame.rank = child
					
				elseif childname:find("lag") and not childname:find("lagtext")then
					frame.lag = child
				end
				
			elseif objtype == "PlayerModel" then
				child:RegisterEvent("PLAYER_ENTERING_WORLD")
				child:RegisterEvent("DISPLAY_SIZE_CHANGED")
				child:RegisterEvent("UNIT_MODEL_CHANGED")
				
				if frame.unit == "target" or frame.unit:find("^target", 2) then
					child:RegisterEvent("PLAYER_TARGET_CHANGED")
				
				elseif frame.unit == "pet" then
					child:RegisterEvent("UNIT_PET")
					
				elseif frame.unit == "focus" then
					child:RegisterEvent("PLAYER_FOCUS_CHANGED")
					
				elseif found == 1 then
					child:RegisterEvent("PARTY_MEMBERS_CHANGED")
				end
				
				frame.model = child
				child.Settings = Nurfed2DB["UnitFrameSettings"][string.capital(frame.unit):gsub("%d", ""):gsub("target", "", 2)].Frame
				child:SetScript("OnEvent", Frame_ModelUpdate)
				
				if not child.full then
					child:SetScript("OnUpdate", Frame_ModelOnUpdate)
				end
				
			elseif objtype == "FontString" then
				if child.format then
					string.gsub(child.format, "%$%a+",
						function(s)
							if s == "$guild" then
								frame.guild = child
								
							elseif s == "$level" then
								Nurfed2:insert(events, "UNIT_LEVEL")
								frame.level = child
								
							elseif s == "$key" then
								Nurfed2:insert(events, "UPDATE_BINDINGS")
								frame.key = child
								
							elseif s == "$name" then
								frame.name = child
								
							elseif s == "$loot" then
								Nurfed2:insert(events, "PARTY_MEMBERS_CHANGED")
								Nurfed2:insert(events, "PARTY_LOOT_METHOD_CHANGED")
								frame.loot = child
							end
						end
					)
					RegisterStatus("text", child)
					
				elseif childname == "group" then
					Nurfed2:insert(events, "RAID_ROSTER_UPDATE")
					Nurfed2:insert(events, "PARTY_MEMBERS_CHANGED")
					frame.group = child
				end

			elseif objtype == "Frame" then
				if childname:find("^buff") then	-- its a buff frame
					child.IsBuff = true
					-- Create the buff template
					child.buffs = {}
					for i=1, child.numAuras do
						local buff = CreateFrame("Button", name..childname.."buff"..i, child, "TargetBuffFrameTemplate")
						child.buffs[i] = buff
						buff:SetID(i)
						buff.unit = frame.unit
						buff:ClearAllPoints()
						if i == 1 then
							local p1, p2, p3, p4, p5 = unpack(child.auraStart)
							local parent = child
							while p2:find("$parent") do
								p2 = p2:gsub("^$parent", parent:GetName(), 1)
								parent = parent:GetParent()
							end
							child.origpos = { child:GetPoint() }
							buff:SetPoint(p1, p2, p3, p4, p5)
						else
							local p1, p2, p3, p4, p5 = unpack(child.auraAnchor)
							if p2:find("$prevaura") then
								p2 = p2:gsub("^$prevaura", child:GetName().."buff"..i-1, 1)
							end
							buff:SetPoint(p1, p2, p3, p4, p5)
						end
						
						local cd = _G[buff:GetName().."Cooldown"]
						if not cd then
							cd = CreateFrame("Cooldown", buff:GetName().."Cooldown", buff, "CooldownFrameTemplate")
							cd:Hide()
						end
						if type(child.auraReverse) == "boolean" then -- GUI: Opt for reverse of auras
							cd:SetReverse(child.auraReverse)
						end

						buff.cd = cd

						cd.scalesize = .65
						
						cd.text = cd:CreateFontString(nil, "OVERLAY")
						--cd.text.font = Nurfed2_UnitFontOutline
						--cd.text:SetFontObject(Nurfed2_UnitFontOutline)
						cd.text:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE")
						cd.text:SetPoint("CENTER")

						buff.count = _G[buff:GetName().."Count"]
						buff.count:SetFontObject(Nurfed2_UnitFontOutline)
						
						buff.icon = _G[buff:GetName().."Icon"]
						
						buff.border = _G[buff:GetName().."Border"]
						if child.auraSize then
							buff:SetHeight(child.auraSize[2])
							buff:SetWidth(child.auraSize[1])
						end
						--buff.dwidth = buff:GetWidth()
						--buff.dheight = buff:GetHeight()
						--buff.dscale = buff:GetScale()
					end
					RegisterStatus("buff", child)
				end
				
				if childname:find("^debuff") then	-- its a debuff frame
					child.IsDebuff = true
					child.debuffs = {}
					-- Create the debuff template
					for i=1, child.numAuras do
						local debuff = CreateFrame("Button", name..childname.."debuff"..i, child, "TargetDebuffFrameTemplate")
						child.debuffs[i] = debuff
						debuff:SetID(i)
						debuff.unit = frame.unit
						debuff:ClearAllPoints()
						if i == 1 then
							local p1, p2, p3, p4, p5 = unpack(child.auraStart)
							local parent = child
							while p2:find("$parent") do
								p2 = p2:gsub("^$parent", parent:GetName(), 1)
								parent = parent:GetParent()
							end
							child.origpos = { child:GetPoint() }
							debuff:SetPoint(p1, p2, p3, p4, p5)
						else
							local p1, p2, p3, p4, p5 = unpack(child.auraAnchor)
							if p2:find("$prevaura") then
								p2 = p2:gsub("^$prevaura", child:GetName().."debuff"..i-1, 1)
							end
							debuff:SetPoint(p1, p2, p3, p4, p5)
						end
						
						local cd = _G[debuff:GetName().."Cooldown"]
						if not cd then
							cd = CreateFrame("Cooldown", debuff:GetName().."Cooldown", debuff, "CooldownFrameTemplate")
							cd:Hide()
						end
						debuff.cd = cd

						cd.scalesize = .65

						if type(child.auraReverse) == "boolean" then
							cd:SetReverse(child.auraReverse)
						end

						cd.text = cd:CreateFontString(nil, "OVERLAY")
						cd.text:SetFont("Fonts\\FRIZQT__.TTF", 6, "OUTLINE")
						cd.text:SetPoint("CENTER")

						debuff.count = _G[debuff:GetName().."Count"]
						debuff.count:SetFontObject(Nurfed2_UnitFontOutline)
						
						debuff.icon = _G[debuff:GetName().."Icon"]
						
						debuff.border = _G[debuff:GetName().."Border"]
						if child.auraSize then
							debuff:SetHeight(child.auraSize[1])
							debuff:SetWidth(child.auraSize[2])
						end
					end
					RegisterStatus("debuff", child)
				end
			end
			
		elseif objtype == "Button" then
			if childname:find("^target") then
				child.unit = frame.unit..childname
				if child:GetParent() == frame then
					Frame_ImbueSettings(child)
				end
				
			elseif childname:find("^pet") then
				child.punit = frame.unit
				child.unit = gsub(frame.unit.."pet", "^([^%d]+)([%d]+)[pP][eE][tT]$", "%1pet%2")
				Frame_ImbueSettings(child)
			end
		end
	end
	for i, child in ipairs(frames) do
		if not child.hidewhencapped or (child.hidewhencapped and UnitLevel("player") ~= 80) then
			UpdateChildren(_G[child])
		end
	end

	if frame.unit:find("target", 2) then
		if not tots then
			tots = {}
			Nurfed2:Schedule(0.15, Frame_TOTUpdate, true)
		end
		frame.lastname = "none"
		Nurfed2:insert(tots, frame)
	else
		for _, event in ipairs(events) do
			if not units[event] then
				units[event] = {}
				Nurfed2:RegEvent(event, Frame_OnEvent)
			end
			Nurfed2:insert(units[event], frame)
		end
	end
	Frame_UpdateAll(frame, true)
end

local options
local n2framecache = {}
local n2hudcache = {}
local function OptionsLoaded()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Nurfed 2 Unit Frames", options)
	Nurfed2.optionsFrames.UnitFrames = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Nurfed 2 Unit Frames", "Unit Frames", "Nurfed 2", "UnitFrames")
end

-- Load Function 
local function OnLoad()
   	Nurfed2:FeedDefaultSettings("UnitFrameSettings", defaultSettings)
	Nurfed2:SendEvent("N2_UNITFRAMES_LOADED")
	if not Nurfed2DB.UnitFrames then
		Nurfed2:Print("N2_UF:> Layout has been disabled, or is now broken.  Using default layout.")
		Nurfed2:FeedDefaultSettings("UnitFrames", defaultConfig)
	else
		if Nurfed2DB.UnitFrameSettings.Layouts.FrameName == "Default" then
			Nurfed2DB.UnitFrames = nil;
			Nurfed2:FeedDefaultSettings("UnitFrames", defaultConfig)
		else
			Nurfed2DB.UnitFrames = n2framecache[Nurfed2DB.UnitFrameSettings.Layouts.FrameName]
		end
	end
	-- HUD SUPPORT NOT IN YET!
	
	playerClass = select(2, UnitClass("player"))
	-- Load the templates
	for k, v in pairs(Nurfed2DB.UnitFrames.Templates) do
		Nurfed2:CreateTemp(k, v)
	end

	for k,v in pairs(Nurfed2DB.UnitFrames.Frames) do
		local frame = Nurfed2:Create("Nurfed2_"..k:capital(), v)
		frame:ClearAllPoints()
		if Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName] and Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][frame:GetName():gsub("^Nurfed2_", ""):lower()] then
			frame:SetPoint(unpack(v.Anchor or Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][frame:GetName():gsub("^Nurfed2_", ""):lower()].Position or { "CENTER" }))
			if Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][frame:GetName():gsub("^Nurfed2_", ""):lower()].Scale then
				frame:SetScale(Nurfed2DB.UnitFrameSettings.Layouts[Nurfed2DB.UnitFrameSettings.Layouts.FrameName][frame:GetName():gsub("^Nurfed2_", ""):lower()].Scale)
			end
		else
			frame:SetPoint(unpack(v.Anchor or { "CENTER" }))
		end

		Frame_ImbueSettings(frame)
	end
	Nurfed2:Schedule(0.1, Frame_PredictStats, true)
	Nurfed2:RegEvent("N2_OPTIONS_LOADED", OptionsLoaded)
end

-- Settings
-------------------------------------------------------
function Nurfed2:AddLayout(name, tbl, layouttype)
	if type(name) ~= "string" or type(tbl) ~= "table" or (layouttype ~= "frame" and layouttype ~= "hud") then
		assert(Nurfed2UnitFramesLayouts, "Invalid Layout Name or Table")
		return "Missing Name, Table, or Layout Type"
	end
	if layouttype == "hud" then
		n2hudcache[name] = tbl
	end
	if layouttype == "frame" then
		n2framecache[name] = tbl
	end
	return true
end

local function GetLayoutOptions()
	local tbl = options.args.UnitFrames.args.Layouts.args.HudList.args
	local descname = ""
	for name, layout in pairs(n2hudcache) do
		if not tbl[name] then
			descname = layout.desc or "Unknown Description"
			descname = descname.."\r Author: "..(layout.author or "Unknown Author")
			descname = descname.."\r Website: "..(layout.website or "Unknown Website")
			tbl[name] = {
				type = "toggle",
				name = name,
				desc = descname,
				order = -1,
			}
		end
	end
	tbl = options.args.UnitFrames.args.Layouts.args.FrameList.args
	for name, layout in pairs(n2framecache) do
		if not tbl[name] then
			descname = layout.desc or "Unknown Description"
			descname = descname.."\r Author: "..(layout.author or "Unknown Author")
			descname = descname.."\r Website: "..(layout.website or "Unknown Website")
			tbl[name] = {
				type = "toggle",
				name = name,
				desc = descname,
				order = -1,
			}
		end
	end	
	LibStub("AceConfigRegistry-3.0"):NotifyChange("Nurfed 2")
end

options = {
	type = "group",
	order = -1,
	args = {
		["UnitFrames"] = {
			type = "group",
			name = "Unit Frames",
			childGroups = "tab",
			order = 2,
			args = {
				text = {
					type = "description",
					name = function() 
						return "Unit Frame Settings"; 
					end,
					order = 0,
				},
				General = {
					type = "group",
					name = "General",
					order = 0,
					args = {
						showAll = {
							type = "toggle",
							name = "Show All",
							desc = "Show all frames.",
							get = function() return showAll; end,
							set = function()
								showAll = not showAll
								Frame_ShowAll(showAll)
							end,
							disabled = true,
						},	
					},
				},
				Player = {
					type = "group",
					name = "Player",
					order = 1,
					get = function(info)
						return Nurfed2DB.UnitFrameSettings.Player[info[#info-1]][info[#info]]
					end,
					set = function(info, val)
						Nurfed2DB.UnitFrameSettings.Player[info[#info-1]][info[#info]] = val
						Frame_UpdateAll(Nurfed2_Player, true)
					end,
					childGroups = "tree",
					args = {
						text = {
							type = "description",
							name = "Player Options",
							order = 0,
						},
						Frame = {
							type = "group",
							name = "Frame Options",
							order = 10,
							args = {
								visibilityMode = {
									type = "select",
									name = "Visibility Mode",
									order = 0,
									values = function()
										return { ["None"] = "None", ["State"] = "State", ["Combat"] = "Combat", ["Target"] = "Target", ["Focus"] = "Focus", ["Party"] = "Party", ["Raid"] = "Raid" }
									end,
									confirm = function(info, state)
										if state == "State" then return "Caution:\rYou break it, you buy it.  No refunds" end
										return false
									end,
								},
								visibilityState = {
									type = "input",
									name = "Visibility State",
									order = 1,
									hidden = function() return Nurfed2DB.UnitFrameSettings.Player.Frame.visibilityMode ~= "State" end,
									width = "double",
								},
							},
						},
						Health = {
							type = "group",
							name = "Health Options",
							order = 20,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current hp numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Player.Health.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max hp numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Player.Health.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing hp numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Player.Health.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Player.Health.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Player)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Player.Health.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Player.Health.colorType ~= "Set" end,
								},
								animation = {
									type = "select",
									name = "Animation",
									desc = "Select your statusbar animation.",
									values = function() return { ["Glide"] = "Glide", ["None"] = "None", ["Fade"] = "Fade" } end,
									order = 80,
								},
								fadeTime = {
									type = "range",
									name = "Fade Time",
									desc = "Select how long you want it to take for the bar to fade out",
									min = 0,
									max = 5,
									step = 0.1,
									bigStep = 0.1,
									hidden = function() return Nurfed2DB.UnitFrameSettings.Player.Health.animation ~= "Fade" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									desc = "Enable the ticker!",
									disabled = true,
								},
							},
						},
						Power = {
							type = "group",
							name = "Power Options",
							order = 30,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current power numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Player.Power.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max power numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Player.Power.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing power numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Player.Power.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Player.Power.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Player)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Player.Power.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Player.Power.colorType ~= "Set" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									disabled = true,
								},
							},
						},
					},
				},
				Target = {
					type = "group",
					name = "Target",
					order = 1,
					get = function(info)
						return Nurfed2DB.UnitFrameSettings.Target[info[#info-1]][info[#info]]
					end,
					set = function(info, val)
						Nurfed2DB.UnitFrameSettings.Target[info[#info-1]][info[#info]] = val
						Frame_UpdateAll(Nurfed2_Target, true)
					end,
					childGroups = "tree",
					args = {
						text = {
							type = "description",
							name = "Target Options",
							order = 0,
						},
						Frame = {
							type = "group",
							name = "Frame Options",
							order = 0.5,
							args = {
								hideModel = {
									name = "Hide Model",
									type = "toggle",
									desc = "Hide the model on the target frame",
									hidden = function() return not Nurfed2_Target.model end,
								},
							},	
						},
						Health = {
							type = "group",
							name = "Health Options",
							order = 1,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current hp numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Target.Health.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max hp numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Target.Health.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing hp numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Target.Health.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Target.Health.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Target)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Target.Health.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Target.Health.colorType ~= "Set" end,
								},
								animation = {
									type = "select",
									name = "Animation",
									desc = "Select your statusbar animation.",
									values = function() return { ["Glide"] = "Glide", ["None"] = "None", ["Fade"] = "Fade" } end,
									order = 80,
								},
								fadeTime = {
									type = "range",
									name = "Fade Time",
									desc = "Select how long you want it to take for the bar to fade out",
									min = 0,
									max = 5,
									step = 0.1,
									bigStep = 0.1,
									hidden = function() return Nurfed2DB.UnitFrameSettings.Target.Health.animation ~= "Fade" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									desc = "Enable the ticker!",
									disabled = true,
								},
							},
						},
						Power = {
							type = "group",
							name = "Power Options",
							order = 1,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current power numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Target.Power.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max power numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Target.Power.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing power numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Target.Power.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Target.Power.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Target)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Target.Power.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Target.Power.colorType ~= "Set" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									disabled = true,
								},
							},
						},
					},
				},
				Focus = {
					type = "group",
					name = "Focus",
					order = 3,
					get = function(info)
						return Nurfed2DB.UnitFrameSettings.Focus[info[#info-1]][info[#info]]
					end,
					set = function(info, val)
						Nurfed2DB.UnitFrameSettings.Focus[info[#info-1]][info[#info]] = val
						Frame_UpdateAll(Nurfed2_Focus, true)
					end,
					childGroups = "tree",
					args = {
						text = {
							type = "description",
							name = "Focus Options",
							order = 0,
						},
						Health = {
							type = "group",
							name = "Health Options",
							order = 1,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current hp numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Focus.Health.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max hp numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Focus.Health.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing hp numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Focus.Health.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Focus.Health.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Focus)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Focus.Health.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Focus.Health.colorType ~= "Set" end,
								},
								animation = {
									type = "select",
									name = "Animation",
									desc = "Select your statusbar animation.",
									values = function() return { ["Glide"] = "Glide", ["None"] = "None", ["Fade"] = "Fade" } end,
									order = 80,
								},
								fadeTime = {
									type = "range",
									name = "Fade Time",
									desc = "Select how long you want it to take for the bar to fade out",
									min = 0,
									max = 5,
									step = 0.1,
									bigStep = 0.1,
									hidden = function() return Nurfed2DB.UnitFrameSettings.Focus.Health.animation ~= "Fade" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									desc = "Enable the ticker!",
									disabled = true,
								},
							},
						},
						Power = {
							type = "group",
							name = "Power Options",
							order = 1,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current power numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Focus.Power.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max power numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Focus.Power.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing power numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Focus.Power.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Focus.Power.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Focus)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Focus.Power.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Focus.Power.colorType ~= "Set" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									disabled = true,
								},
							},
						},
					},
				},
				Party = {
					type = "group",
					name = "Party",
					order = 3,
					get = function(info)
						return Nurfed2DB.UnitFrameSettings.Party[info[#info-1]][info[#info]]
					end,
					set = function(info, val)
						Nurfed2DB.UnitFrameSettings.Party[info[#info-1]][info[#info]] = val
						Frame_UpdateAll(Nurfed2_Party1, true)
						Frame_UpdateAll(Nurfed2_Party2, true)
						Frame_UpdateAll(Nurfed2_Party3, true)
						Frame_UpdateAll(Nurfed2_Party4, true)
					end,
					childGroups = "tree",
					args = {
						text = {
							type = "description",
							name = "Party Options",
							order = 0,
						},
						Health = {
							type = "group",
							name = "Health Options",
							order = 1,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current hp numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Party.Health.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max hp numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Party.Health.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing hp numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing hp shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Party.Health.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return "Warning:  This is for ADVANCED USERS ONLY, using this improperly, WILL break your unit frames!"
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Party.Health.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Party1, true)
										Frame_UpdateAll(Nurfed2_Party2, true)
										Frame_UpdateAll(Nurfed2_Party3, true)
										Frame_UpdateAll(Nurfed2_Party4, true)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Party.Health.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Party.Health.colorType ~= "Set" end,
								},
								animation = {
									type = "select",
									name = "Animation",
									desc = "Select your statusbar animation.",
									values = function() return { ["Glide"] = "Glide", ["None"] = "None", ["Fade"] = "Fade" } end,
									order = 80,
								},
								fadeTime = {
									type = "range",
									name = "Fade Time",
									desc = "Select how long you want it to take for the bar to fade out",
									min = 0,
									max = 5,
									step = 0.1,
									bigStep = 0.1,
									hidden = function() return Nurfed2DB.UnitFrameSettings.Party.Health.animation ~= "Fade" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									desc = "Enable the ticker!",
									disabled = true,
								},
							},
						},
						Power = {
							type = "group",
							name = "Power Options",
							order = 1,
							args = {
								Override = {
									type = "toggle",
									name = "Override Layout Settings",
									desc = "Enable this to prevent layouts from overriding your settings.\rLayouts must support this!",
									descStyle = "inline",
									order = 1,
									width = "full",
								},
								txtheader = {
									type = "header",
									name = "Text Settings",
									order = 9,
								},
								shortCur = {
									type = "toggle",
									name = "Short Current",
									desc = "Shorten current power numbers.",
									order = 10,
								},
								curThreshold = {
									type = "range",
									name = "Current Threshold",
									desc = "Current power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 11,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Party.Power.shortCur
									end,
								},
								shortMax = {
									type = "toggle",
									name = "Short Max",
									desc = "Shorten max power numbers.",
									order = 20,
								},
								maxThreshold = {
									type = "range",
									name = "Max Threshold",
									desc = "Max power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 21,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Party.Power.shortMax
									end,
								},
								shortMiss = {
									type = "toggle",
									name = "Short Miss",
									desc = "Shorten missing power numbers.",
									order = 30,
								},
								missThreshold = {
									type = "range",
									name = "Miss Threshold",
									desc = "Missing power shorten threshold, the lower the better.",
									min = 0,
									max = 4,
									step = 1,
									bigStep = 1,
									order = 31,
									disabled = function()
										return not Nurfed2DB.UnitFrameSettings.Party.Power.shortMiss
									end,
								},
								barheader = {
									type = "header",
									name = "Statusbar Settings",
									order = 40,
								},
								colorBackground = {
									type = "toggle",
									name = "Color Background",
									desc = "Toggle coloring of the background of statusbars.",
									order = 50,
								},
								colorType = {
									type = "select",
									name = "Color Mode",
									desc = "Select how you want your bars to be colored here.",
									values = function() return { ["Pitbull"] = "Pitbull", ["Fade"] = "Fade", ["Class"] = "Class", ["Set"] = "Set", ["Custom"] = "Custom", } end,
									confirm = function(info, val)
										if val == "Custom" then
											return true
										end
										return false
									end,
									order = 60,
								},
								colorSet = {
									type = "color",
									name = "Set Color",
									desc = "Set the color of your statusbar!",
									order = 61,
									set = function(info, r, g, b)
										Nurfed2DB.UnitFrameSettings.Party.Power.colorSet = { r, g, b }
										Frame_UpdateAll(Nurfed2_Party1, true)
										Frame_UpdateAll(Nurfed2_Party2, true)
										Frame_UpdateAll(Nurfed2_Party3, true)
										Frame_UpdateAll(Nurfed2_Party4, true)
									end,
									get = function()
										return unpack(Nurfed2DB.UnitFrameSettings.Party.Power.colorSet)
									end,
									disabled = function() return Nurfed2DB.UnitFrameSettings.Party.Power.colorType ~= "Set" end,
								},
								ticker = {
									type = "toggle",
									name = "Ticker",
									disabled = true,
								},
							},
						},
					},
				},
				Layouts = {
					type = "group",
					name = "Layouts",
					order = -1,
					get = function(info)
						local type = info[#info-1]
						if type == "FrameList" then
							return Nurfed2DB.UnitFrameSettings.Layouts.FrameName == info[#info]
						elseif type == "HudList" then
							return Nurfed2DB.UnitFrameSettings.Layouts.HudName == info[#info]
						end
					end,
					set = function(info, val)
						local type = info[#info-1]
						if val then
							if type == "FrameList" then
								Nurfed2DB.UnitFrameSettings.Layouts.FrameName = info[#info]
							elseif type == "HudList" then
								Nurfed2DB.UnitFrameSettings.Layouts.HudName = info[#info]
							end
						else
							if type == "FrameList" then
								Nurfed2DB.UnitFrameSettings.Layouts.FrameName = "Default"
							elseif type == "HudList" then
								Nurfed2DB.UnitFrameSettings.Layouts.HudName = "Default"
							end
						end	
						Nurfed2:Print("Layout Changed!  RELOAD UI! (/rl)")
					end,				
					args = {
						text = {
							type = "description",
							name = function()
								GetLayoutOptions()
								return "Layout Controls"
							end,
							order = 0,
						},
						FrameList = {
							type = "group",
							name = "Frame's",
							order = 1,
							args = {
								Default = {
									type = "toggle",
									name = "Default",
									desc = "Default Nurfed 2 Layout\rAuthor: Apoco\rWebsite: http://www.nurfed.com",
								},		
							},
						},	
						HudList = {
							type = "group",
							name = "HUD's",
							order = 2,
							args = { },
						},
					},
				},
			},
		},
	},
}
-------------------------------------------------------
--On Load
OnLoad()
Nurfed2_UnitFramesver = "r20100412013329"

-- I HATE GIT x2
-- GIT CAN SUCKA NUTA