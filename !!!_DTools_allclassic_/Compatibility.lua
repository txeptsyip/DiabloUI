local AddonName, ns =...

local hptexture1 = "Interface\\AddOns\\"..AddonName.."\\media\\Raid-Bar-Hp-ad"
local hptexture2 = "Interface\\AddOns\\"..AddonName.."\\media\\Raid-Bar-Hp-Fill"
local hptexture3 = "Interface\\AddOns\\"..AddonName.."\\media\\statusbar5"
local hptexture4 = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status"

ns.event("PLAYER_LOGIN", function()

if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then

--战网提示窗口
		local function SecureMoveBNToast()
				BNToastAnchor = CreateFrame("Frame", "BNToastAnchor", UIParent)
				BNToastAnchor:SetSize(1, 1)
				BNToastAnchor:SetPoint("BOTTOMLEFT", SELECTED_DOCK_FRAME, "TOPLEFT", -32, 50)

			hooksecurefunc(BNToastFrame, "SetPoint", function(self, point, relativeTo, relativePoint, x, y)
				if relativeTo ~= BNToastAnchor then
					self:ClearAllPoints()
					self:SetPoint("BOTTOMLEFT", BNToastAnchor, "BOTTOMLEFT")
				end
			end)
			-- 初始定位
			BNToastFrame:ClearAllPoints()
			BNToastFrame:SetPoint("BOTTOMLEFT", BNToastAnchor, "BOTTOMLEFT")
		end
		-- 延迟执行以确保框架已加载
		C_Timer.After(1, SecureMoveBNToast)
--]]



--动作条----------
		local Classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass("player"))]
		local ntcolor
		if DToolsDB.acc ~= nil and DToolsDB.acc == true then
			ntcolor = { r=0, g=0, b=0, a=0.8 }	--边框颜色
		else
			ntcolor = { r=1, g=1, b=1, a=1 }--边框颜色
		end
		local frame = CreateFrame("Frame")
		-- frame:RegisterEvent("UPDATE_BINDINGS")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")

		frame:SetScript("OnEvent", function()
			local r = { "Action", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarLeft", "MultiBarRight",}
			for b = 1, #r do
				for i = 1, 12 do
					--文字保持在图标最上层
					local button = _G[r[b].."Button"..i]
					local hotkey = button.HotKey
					local name = button.Name
					local count = button.Count
					local overlay = CreateFrame("Frame", nil, button)
					overlay:SetAllPoints()
					if hotkey then hotkey:SetParent(overlay) end
					if name then
						name:SetParent(overlay)
						name:SetFontObject("GameFontHighlightLeft");
						end
					if count then count:SetParent(overlay) end
					--
					-- _G[r[b].."Button"..i.."Icon"]:SetTexCoord(0.04, 0.93, 0.07, 0.96)
					_G[r[b].."Button"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
					_G[r[b].."Button"..i.."HotKey"]:SetPoint("TOPRIGHT", 4, 1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
					--_G[r[b].."Button"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					_G[r[b].."Button"..i.."Name"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					_G[r[b].."Button"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
					_G[r[b].."Button"..i.."Name"]:SetPoint("BOTTOMLEFT", 0, 3.5)

					-- _G[r[b].."Button"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)

					_G[r[b].."Button"..i.."Count"]:SetVertexColor(0, 0.8, 0.8)
					_G[r[b].."Button"..i.."Count"]:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
					_G[r[b].."Button"..i.."Count"]:SetPoint("BOTTOMRIGHT", 2.5, 2)
					_G[r[b].."Button"..i.."Cooldown"]:SetPoint("TOPLEFT", 0, 0)
					_G[r[b].."Button"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", 0, -1)
				end
			end

			local r={ "PetAction", "Stance" }
			for b=1, #r do
				for i=1, 10 do
					--文字保持在图标最上层
					local button = _G[r[b].."Button"..i]
					local hotkey = button.HotKey
					local overlay = CreateFrame("Frame", nil, button)
					overlay:SetAllPoints()
					if hotkey then hotkey:SetParent(overlay) end
					--
					-- _G[r[b].."Button"..i.."Icon"]:SetTexCoord(0.01, 0.96, 0.04, 0.99)
					_G[r[b].."Button"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
					_G[r[b].."Button"..i.."HotKey"]:SetPoint("TOPRIGHT", 2.5, 0)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
					--_G[r[b].."Button"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					-- _G[r[b].."Button"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)
					-- _G[r[b].."Button"..i.."Cooldown"]:SetPoint("TOPLEFT", 0, -1)
					-- _G[r[b].."Button"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", 0, 1)
				end
			end

			local r={ "OverrideActionBar" }
			for b=1, #r do
				for i=1, 6 do
					--文字保持在图标最上层
					local button = _G[r[b].."Button"..i]
					local hotkey = button.HotKey
					local overlay = CreateFrame("Frame", nil, button)
					overlay:SetAllPoints()
					if hotkey then hotkey:SetParent(overlay) end
					--
					-- _G[r[b].."Button"..i.."Icon"]:SetTexCoord(0.01, 0.96, 0.03, 0.98)
					_G[r[b].."Button"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
					_G[r[b].."Button"..i.."HotKey"]:SetPoint("TOPRIGHT", 3, -1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					-- _G[r[b].."Button"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)
					_G[r[b].."Button"..i.."Cooldown"]:SetPoint("TOPLEFT", 3, -2)
					_G[r[b].."Button"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", -2, 3)
				end
			end
		end)

--]]



--[[style player BuffFrame buff buttons
	local buffButtonIndex = 1
	local function UpdateBuffButtons()
		if buffButtonIndex > BUFF_MAX_DISPLAY then
			return
		end

		for i = buffButtonIndex, BUFF_MAX_DISPLAY do
			local button = _G["BuffButton" .. i]
			if not button then break end
		local overlay = CreateFrame("Frame", nil, button)
		overlay:SetAllPoints()
			button.duration:SetParent(overlay)
			button.duration:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")	--时间文字大小
			button.duration:SetPoint("BOTTOMLEFT", -2, -4)
			button.duration:SetPoint("BOTTOMRIGHT", 4, -4)
			button.count:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
			button.count:SetPoint("BOTTOMRIGHT", 0, 2)

			-- if button.__styled then
			-- 	buffButtonIndex = i + 1
			-- end
		end
		for i = 1,3 do
			local TempEnchant = _G["TempEnchant" .. i]
			if not TempEnchant then break end
			local overlay = CreateFrame("Frame", nil, TempEnchant)
			overlay:SetAllPoints()
			TempEnchant.duration:SetParent(overlay)
			TempEnchant.duration:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")	--时间文字大小
			TempEnchant.duration:SetPoint("BOTTOMLEFT", -2, -4)
			TempEnchant.duration:SetPoint("BOTTOMRIGHT", 4, -4)
		end
	end
	hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffButtons)

	-- style player BuffFrame debuff buttons
	local function UpdateDebuffButton(buttonName, i)
		local button = _G["DebuffButton" .. i]
		local overlay = CreateFrame("Frame", nil, button)
		overlay:SetAllPoints()
		button.duration:SetParent(overlay)
		button.duration:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")	--时间文字大小
		button.duration:SetPoint("BOTTOMLEFT", -2, -4)
		button.duration:SetPoint("BOTTOMRIGHT", 4, -4)
		button.count:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
		button.count:SetPoint("BOTTOMRIGHT", 0, 2)

	end
	hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffButton)
--]]



--单位框架----------

	--目标仇恨位置
	TargetFrameNumericalThreat:ClearAllPoints()
	TargetFrameNumericalThreat:SetScale(0.51)
	TargetFrameNumericalThreat:SetFrameStrata"HIGH"
	TargetFrameNumericalThreat:SetPoint("BOTTOM", TargetFrameHealthBar, "BOTTOM", 0, 2)
	FocusFrameNumericalThreat:ClearAllPoints()
	FocusFrameNumericalThreat:SetScale(0.51)
	FocusFrameNumericalThreat:SetFrameStrata"HIGH"
	FocusFrameNumericalThreat:SetPoint("BOTTOM", FocusFrameHealthBar, "BOTTOM", 0, 2)
	Boss1TargetFrameNumericalThreat:ClearAllPoints()
	Boss1TargetFrameNumericalThreat:SetScale(0.51)
	Boss1TargetFrameNumericalThreat:SetFrameStrata"HIGH"
	Boss1TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss1TargetFrameHealthBar, "BOTTOM", 0, 2)
	Boss2TargetFrameNumericalThreat:ClearAllPoints()
	Boss2TargetFrameNumericalThreat:SetScale(0.51)
	Boss2TargetFrameNumericalThreat:SetFrameStrata"HIGH"
	Boss2TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss2TargetFrameHealthBar, "BOTTOM", 0, 2)
	Boss3TargetFrameNumericalThreat:ClearAllPoints()
	Boss3TargetFrameNumericalThreat:SetScale(0.51)
	Boss3TargetFrameNumericalThreat:SetFrameStrata"HIGH"
	Boss3TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss3TargetFrameHealthBar, "BOTTOM", 0, 2)
	Boss4TargetFrameNumericalThreat:ClearAllPoints()
	Boss4TargetFrameNumericalThreat:SetScale(0.51)
	Boss4TargetFrameNumericalThreat:SetFrameStrata"HIGH"
	Boss4TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss4TargetFrameHealthBar, "BOTTOM", 0, 2)
	Boss5TargetFrameNumericalThreat:ClearAllPoints()
	Boss5TargetFrameNumericalThreat:SetScale(0.51)
	Boss5TargetFrameNumericalThreat:SetFrameStrata"HIGH"
	Boss5TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss5TargetFrameHealthBar, "BOTTOM", 0, 2)


	-- --目标框架: 显示debuff倒计时
	-- hooksecurefunc("TargetFrame_UpdateAuras", function(self)
	-- local selfName = self:GetName()
	-- local maxDebuffs = self.maxDebuffs or MAX_TARGET_DEBUFFS
	-- local _, frame, debuffName, duration
	-- for i = 1, maxDebuffs do
	-- frame = _G[selfName.."Debuff"..i.."Cooldown"]
	-- if (frame) then
	-- debuffName, _, _, _, duration = UnitDebuff(self.unit, i, "PLAYER") --只顯示自己PLAYER, 全部顯示 INCLUDE_NAME_PLATE_ONLY
	-- if (debuffName and duration and duration <= 60) then
	-- frame:SetHideCountdownNumbers(false)
	-- else
	-- frame:SetHideCountdownNumbers(true)
	-- end
	-- end
	-- end
	-- end)
	--


	-- --显示目标可驱散buff高亮
	-- hooksecurefunc("TargetFrame_UpdateAuras", function(self)
	-- local frame, frameName
	-- local selfName = self:GetName()
	-- local name, icon, count, debuffType, duration, expirationTime, caster, isStealable
	-- local frameStealable
	-- local playerIsTarget = UnitIsUnit(PlayerFrame.unit, self.unit)
	-- local _, class = UnitClass("player")
	-- for index = 1, MAX_TARGET_BUFFS do
	-- name, icon, count, debuffType, duration, expirationTime, caster, canStealOrPurge = UnitBuff(self.unit, index, filter)
	-- frameName = selfName.."Buff"..index
	-- frame = _G[frameName]
	-- if (frame and frame:IsShown()) then
	-- frameStealable = _G[frameName.."Stealable"]
	-- if ( not playerIsTarget and debuffType == "Magic" ) then
	-- frameStealable:Show()
	-- else
	-- frameStealable:Hide()
	-- end
	-- end
	-- end
	-- end)
	--

	-- 头像材质

	local function UnitFramesImproved_Style_PlayerFrame(PlayerFrame)

		if not UnitHasVehicleUI"player" then

			-- PlayerFrameGroupIndicator:SetFrameStrata("HIGH")
			-- PlayerFrameGroupIndicator:SetAlpha(1)
			-- PlayerFrameGroupIndicator:ClearAllPoints()
			-- PlayerFrameGroupIndicator:SetPoint("BOTTOM", PlayerFrameHealthBar, "TOP", 0, 100)
			-- PlayerFrameGroupIndicatorText:SetTextColor(1, 1, 1, 1) -- 小队编号文字颜色
			-- PlayerFrameGroupIndicatorText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE") -- 小队编号字体、大小
			-- PlayerFrameGroupIndicatorText:SetScale(1)
			-- PlayerFrameGroupIndicatorText:ClearAllPoints()
			-- PlayerFrameGroupIndicatorText:SetPoint("BOTTOM", PlayerFrame, "TOP", -40, -10)
			PlayerName:SetJustifyH("LEFT")
			PlayerName:SetPoint("TOPLEFT", 106, -20)
			PlayerName:SetPoint("TOPRIGHT", -3, -20)
			PlayerName:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
			if DToolsDB.unfn == true then
				PlayerName:SetAlpha(0)	--名字透明度
			else
				PlayerName:SetAlpha(1)	--名字透明度
			end
			PlayerLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
			-- PlayerLevelText:SetPoint("TOPLEFT", -80, -16)
			-- PlayerLevelText:SetPoint("BOTTOMRIGHT", -45, -16)

			-- PlayerFrameHealthBar:ClearAllPoints()
			-- PlayerFrameHealthBar:SetPoint("TOPLEFT", 107, -24)
			-- PlayerFrameHealthBar:SetHeight(29)

			-- PlayerFrameHealthBar:SetStatusBarTexture(hptexture2)

			PlayerFrameHealthBarText:ClearAllPoints()
			PlayerFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
			PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 1)
			PlayerFrameHealthBarTextLeft:ClearAllPoints()
			PlayerFrameHealthBarTextLeft:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
			PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 3, 1)
			PlayerFrameHealthBarTextRight:ClearAllPoints()
			PlayerFrameHealthBarTextRight:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
			PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -3, 1)
		else
			-- PlayerFrameHealthBar:SetHeight(12)
		end
	end


	local function UnitFramesImproved_Style_PetFrame(self)
		-- self.name:ClearAllPoints()
		-- self.name:SetPoint("CENTER", 75, 12)
		-- self.name:SetJustifyH("LEFT")
		self.name:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
		-- self.healthbar:SetStatusBarTexture(hptexture2)
	end

	TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	TargetFrameTextureFrameLevelText:SetPoint("TOPLEFT", 47, -16)
	TargetFrameTextureFrameLevelText:SetPoint("BOTTOMRIGHT", 80, -16)
	FocusFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	FocusFrameTextureFrameLevelText:SetPoint("TOPLEFT", 49, -16)
	FocusFrameTextureFrameLevelText:SetPoint("BOTTOMRIGHT", 80, -16)
	Boss1TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	Boss1TargetFrameTextureFrameLevelText:SetPoint("BOTTOMRIGHT", -44, 28)
	Boss2TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	Boss2TargetFrameTextureFrameLevelText:SetPoint("BOTTOMRIGHT", -44, 28)
	Boss3TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	Boss3TargetFrameTextureFrameLevelText:SetPoint("BOTTOMRIGHT", -44, 28)
	Boss4TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	Boss4TargetFrameTextureFrameLevelText:SetPoint("BOTTOMRIGHT", -44, 28)

	-- --统一大小版
	local function UnitFramesImproved_Style_TargetFrame(self)
		-- self.nameBackground:Hide()
		-- self.healthbar:SetHeight(29)
		-- self.healthbar:SetPoint("TOPLEFT", 5, -24)
		-- self.Background:SetPoint("TOPLEFT", 7, -22)
		-- self.healthbar:SetStatusBarTexture(hptexture2)
		self.name:SetJustifyH("LEFT")
		self.name:ClearAllPoints()
		self.name:SetPoint("TOPLEFT", 22, -20)
		self.name:SetPoint("TOPRIGHT", -104, -20)
		self.name:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
		self.deadText:SetPoint("CENTER", -5, 12)
		self.deadText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
		self.healthbar.TextString:ClearAllPoints()
		self.healthbar.TextString:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
		self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 1)
		self.healthbar.LeftText:ClearAllPoints()
		self.healthbar.LeftText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
		self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 3, 1)
		self.healthbar.RightText:ClearAllPoints()
		self.healthbar.RightText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
		self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -3, 1)
		-- self.TextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 120, "OUTLINE")
		-- self.TextureFrameLevelText:SetPoint("TOPLEFT", 25, -26.5)
		self.deadText:SetPoint("CENTER",self.healthbar,"CENTER", 0, 0)
		self.deadText:SetFont(STANDARD_TEXT_FONT,14, "OUTLINE")

	end



	local function UnitFramesImproved_Style_TargetOfTargetFrame(self)
		-- self.name:ClearAllPoints()
		-- self.name:SetPoint("TOP", self, "BOTTOM", 10, 5)
		-- self.healthbar:SetStatusBarTexture(hptexture2)
		self.name:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
		self.deadText:ClearAllPoints()
		self.deadText:SetPoint("CENTER", 10, 0)
		self.deadText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	end

	local function UnitFramesImproved_BossTargetFrame_Style(self) UnitFramesImproved_Style_TargetFrame(self) end

	local function EnableUnitFramesImproved()
		-- Set up some stylings
		UnitFramesImproved_Style_PlayerFrame(PlayerFrame)
		UnitFramesImproved_Style_PetFrame(PetFrame)
		UnitFramesImproved_Style_TargetFrame(TargetFrame)
		UnitFramesImproved_Style_TargetFrame(FocusFrame)
		-- UnitFramesImproved_Style_TargetOfTargetFrame();
		UnitFramesImproved_Style_TargetOfTargetFrame(TargetFrameToT)
		UnitFramesImproved_Style_TargetOfTargetFrame(FocusFrameToT)
		UnitFramesImproved_BossTargetFrame_Style(Boss1TargetFrame)
		UnitFramesImproved_BossTargetFrame_Style(Boss2TargetFrame)
		UnitFramesImproved_BossTargetFrame_Style(Boss3TargetFrame)
		UnitFramesImproved_BossTargetFrame_Style(Boss4TargetFrame)
		UnitFramesImproved_BossTargetFrame_Style(Boss5TargetFrame)



		-- local color = {r = 0., g = 0.5, b = 0.5}
		-- local tcolor = {r = 0., g = 0.5, b = 0.5}
		-- local ttcolor = {r = 0., g = 0.5, b = 0.5}
		-- local fcolor = {r = 0., g = 0.5, b = 0.5}
		-- local ftcolor = {r = 0., g = 0.5, b = 0.5}
		-- if UnitIsPlayer("player") then
		-- local _, class = UnitClass("player")
		-- 	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		-- 	PlayerFrame.healthbar:SetStatusBarColor(color.r, color.g, color.b)
		-- end


		-- if UnitIsPlayer("target") then
		-- 	local _, class = UnitClass("target")
		-- 	tcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		-- elseif UnitReaction("target", "player") then
		-- 	tcolor = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction("target", "player")]
		-- end
		-- TargetFrame.healthbar:SetStatusBarColor(tcolor.r, tcolor.g, tcolor.b)

		-- if UnitIsPlayer("targettarget") then
		-- 	local _, class = UnitClass("targettarget")
		-- 	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		-- elseif UnitReaction("targettarget", "player") then
		-- 	color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction("targettarget", "player")]
		-- end
		-- TargetFrameToT.healthbar:SetStatusBarColor(color.r, color.g, color.b)

		-- if UnitIsPlayer("focus") then
		-- 	local _, class = UnitClass("focus")
		-- 	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		-- elseif UnitReaction("focus", "player") then
		-- 	color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction("focus", "player")]
		-- end
		-- FocusFrame.healthbar:SetStatusBarColor(color.r, color.g, color.b)

		-- if UnitIsPlayer("focustarget") then
		-- 	local _, class = UnitClass("focustarget")
		-- 	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		-- elseif UnitReaction("focustarget", "player") then
		-- 	color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction("focustarget", "player")]
		-- end
		-- FocusFrameToT.healthbar:SetStatusBarColor(color.r, color.g, color.b)


	end



	local UnitFramesImproved = CreateFrame("Frame", "UnitFramesImproved")
	UnitFramesImproved:SetScript("OnEvent", function(self, event, ...) EnableUnitFramesImproved() end)

	UnitFramesImproved:RegisterEvent("UNIT_TARGETABLE_CHANGED");
	UnitFramesImproved:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");

	-- --PlayerFrame_Update();
	UnitFramesImproved:RegisterEvent("PLAYER_LEVEL_CHANGED");
	UnitFramesImproved:RegisterEvent("UNIT_FACTION");
	UnitFramesImproved:RegisterEvent("PLAYER_ENTERING_WORLD");
	UnitFramesImproved:RegisterEvent("PLAYER_ENTER_COMBAT");
	UnitFramesImproved:RegisterEvent("PLAYER_LEAVE_COMBAT");
	UnitFramesImproved:RegisterEvent("PLAYER_REGEN_DISABLED");
	UnitFramesImproved:RegisterEvent("PLAYER_REGEN_ENABLED");
	UnitFramesImproved:RegisterEvent("PLAYER_UPDATE_RESTING");
	UnitFramesImproved:RegisterEvent("PARTY_LEADER_CHANGED");
	UnitFramesImproved:RegisterEvent("GROUP_ROSTER_UPDATE");
	UnitFramesImproved:RegisterEvent("READY_CHECK");
	UnitFramesImproved:RegisterEvent("READY_CHECK_CONFIRM");
	UnitFramesImproved:RegisterEvent("READY_CHECK_FINISHED");
	UnitFramesImproved:RegisterEvent("UNIT_ENTERED_VEHICLE");
	UnitFramesImproved:RegisterEvent("UNIT_ENTERING_VEHICLE");
	UnitFramesImproved:RegisterEvent("UNIT_EXITING_VEHICLE");
	UnitFramesImproved:RegisterEvent("UNIT_EXITED_VEHICLE");
	UnitFramesImproved:RegisterEvent("PVP_TIMER_UPDATE");
	UnitFramesImproved:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	UnitFramesImproved:RegisterEvent("VARIABLES_LOADED");
	-- UnitFramesImproved:RegisterEvent("HONOR_LEVEL_UPDATE");
	UnitFramesImproved:RegisterEvent("QUEST_SESSION_JOINED");
	UnitFramesImproved:RegisterEvent("QUEST_SESSION_LEFT");
	UnitFramesImproved:RegisterUnitEvent("UNIT_COMBAT", "player", "vehicle");
	UnitFramesImproved:RegisterUnitEvent("UNIT_MAXPOWER", "player", "vehicle");
	UnitFramesImproved:RegisterEvent("PLAYTIME_CHANGED");
	UnitFramesImproved:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	UnitFramesImproved:RegisterEvent("PLAYER_TARGET_CHANGED")
	UnitFramesImproved:RegisterEvent("PLAYER_DEAD")
	UnitFramesImproved:RegisterEvent("PLAYER_UNGHOST")
	UnitFramesImproved:RegisterEvent("PLAYER_ALIVE")
	UnitFramesImproved:RegisterEvent("PLAYER_FOCUS_CHANGED")
	UnitFramesImproved:RegisterEvent("QUEST_WATCH_UPDATE")


	UnitFramesImproved:RegisterEvent("RAID_TARGET_UPDATE");
	UnitFramesImproved:RegisterUnitEvent("UNIT_AURA", unit);
	UnitFramesImproved:RegisterEvent("PLAYER_FLAGS_CHANGED");
	UnitFramesImproved:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	UnitFramesImproved:RegisterEvent("UNIT_LEVEL");
	UnitFramesImproved:RegisterEvent("UNIT_HEALTH");



	----
	TargetFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	TargetFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	TargetFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
	TargetFrame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	TargetFrame:RegisterEvent("UNIT_EXITING_VEHICLE")
	TargetFrame:RegisterEvent("UNIT_TARGETABLE_CHANGED");

	--TargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	TargetFrame:RegisterEvent("PLAYER_DEAD")
	TargetFrame:RegisterEvent("PLAYER_UNGHOST")
	TargetFrame:RegisterEvent("PLAYER_ALIVE")
	TargetFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")

	--TargetFrame:RegisterEvent("QUEST_WATCH_UPDATE")
	TargetFrame:RegisterEvent("PLAYER_ENTER_COMBAT");
	TargetFrame:RegisterEvent("PLAYER_LEAVE_COMBAT");


	--TargetFrame:RegisterUnitEvent("UNIT_AURA", unit);
	--TargetFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");

	FocusFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")

	----

	-- 隐藏头像伤害数字
	-- PlayerHitIndicator:SetText(nil)
	-- PlayerHitIndicator.SetText = function() end
	-- PetHitIndicator:SetText(nil)
	-- PetHitIndicator.SetText = function() end
	-- PetName:SetFont(STANDARD_TEXT_FONT, 12)
	-- 隐藏宠物生命值显示
	-- PetFrameHealthBar.cvar = nil;
	-- PetFrameManaBar.cvar = nil;

	-- 	-- 职业染色
	-- local color = true

	-- local function colors(self, unit)
	-- 	if unit and unit == self.unit then
	-- 		if UnitIsPlayer(unit) then
	-- 			local _, class = UnitClass(unit)
	-- 			color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
	-- 		elseif UnitReaction(unit, "player") then
	-- 			color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction(unit, "player")]
	-- 		end
	-- 		if not UnitIsConnected(unit) then self:SetStatusBarColor(0.5, 0.5, 0.5)
	-- 		else
	-- 			if color then self:SetStatusBarColor(color.r, color.g, color.b) end
	-- 		end
	-- 	end
	-- end
	-- hooksecurefunc("UnitFrameHealthBar_Update", colors)
	-- hooksecurefunc("HealthBar_OnValueChanged", function(self) colors(self, self.unit) end)
	-- C_Timer.After(1, colors)

	hooksecurefunc("UnitFrame_Update", function(self)
		if UnitClass(self.unit) then
			local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(self.unit))]
			self.name:SetTextColor(c.r, c.g, c.b, 1)
		end
	end)


	-- --各个框体移动及缩放
	-- PlayerFrame:SetScript("OnMouseDown", function()
	-- 	-- 按shift移动玩家框体
	-- 	if IsShiftKeyDown() then
	-- 		-- PlayerFrame:ClearAllPoints()
	-- 		PlayerFrame:StartMoving()
	-- 	end
	-- end)
	-- PlayerFrame:SetScript("OnMouseUp", function() PlayerFrame:StopMovingOrSizing() end)
	-- -- PlayerFrame:SetScale(1) --玩家框体大小缩放可以改括号内数值
	-- TargetFrame:SetMovable(true)
	-- -- 按shift移动目标框体
	-- TargetFrame:SetScript("OnMouseDown", function()
	-- 	if IsShiftKeyDown() then
	-- 		-- TargetFrame:ClearAllPoints()
	-- 		TargetFrame:StartMoving()
	-- 	end
	-- end)
	-- TargetFrame:SetScript("OnMouseUp", function() TargetFrame:StopMovingOrSizing() end)
	-- -- TargetFrame:SetScale(1) --目标框体大小缩放
	-- FocusFrame:SetScript("OnMouseDown", function()
	-- 	-- 按shift移动焦点框体
	-- 	if IsShiftKeyDown() then
	-- 		-- FocusFrame:ClearAllPoints()
	-- 		FocusFrame:StartMoving()
	-- 	end
	-- end)
	-- FocusFrame:SetScript("OnMouseUp", function() FocusFrame:StopMovingOrSizing() end)
	-- -- FocusFrame:SetScale(0.8) ----焦点框体大小缩放
	-- PartyMemberFrame1:SetScript("OnMouseDown", function()
	-- 	-- 按shift移动小队
	-- 	if IsShiftKeyDown() then
	-- 		-- PartyMemberFrame1:ClearAllPoints()
	-- 		PartyMemberFrame1:StartMoving()
	-- 	end
	-- end)
	-- PartyMemberFrame1:SetScript("OnMouseUp", function() PartyMemberFrame1:StopMovingOrSizing() end)
	-- TargetFrameToT:SetScript("OnMouseDown", function()
	-- 	-- 按shift移动目标的目标
	-- 	if IsShiftKeyDown() then
	-- 		-- TargetFrameToT:ClearAllPoints()
	-- 		TargetFrameToT:StartMoving()
	-- 	end
	-- end)
	-- TargetFrameToT:SetScript("OnMouseUp", function() TargetFrameToT:StopMovingOrSizing() end)
	-- -- TargetFrameToT:SetScale(1) --目标的目标框体大小缩放

	--移动模块
	local Frame = { PlayerFrame, TargetFrame, FocusFrame }
	for i, f in next, Frame do
		f:SetScript("OnMouseDown", function()
			if IsShiftKeyDown() then
			f:StartMoving()
			end
		end)
		f:SetScript("OnMouseUp", function()
			f:StopMovingOrSizing()
		end)
		-- f.ClearAllPoints = function() end
		-- f.SetPoint = function() end
	end

	-- 目标头像添加职业小图标辅助功能
	local targeticon = CreateFrame("Button", "TargetClass", TargetFrame)
	local y = GetHight
	targeticon:Hide()
	targeticon:SetFrameStrata"HIGH"
	targeticon:SetWidth(32)
	targeticon:SetHeight(32)
	targeticon:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 110, -5)
	targeticon:SetHighlightTexture"Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
	local bg = targeticon:CreateTexture("TargetClassBackground", "BACKGROUND")
	bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	bg:SetWidth(20)
	bg:SetHeight(20)
	bg:SetPoint("CENTER")
	bg:SetVertexColor(0, 0, 0, 1)
	local icon = targeticon:CreateTexture("TargetClassIcon", "ARTWORK")
	icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	icon:SetWidth(16)
	icon:SetHeight(16)
	icon:SetPoint"CENTER"
	local lay = targeticon:CreateTexture("TargetClassBorder", "OVERLAY")
	lay:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\minimap-trackingborder")
	lay:SetWidth(41)
	lay:SetHeight(41)
	lay:SetPoint("CENTER", 8, -8)
	RaiseFrameLevel(targeticon)
	targeticon:SetScript("OnUpdate", function(self)
		if not UnitCanAttack("player", "target") and UnitIsPlayer"target" then
			targeticon:Enable()
			SetDesaturation(TargetClassIcon, false)
		else
			targeticon:Disable()
			SetDesaturation(TargetClassIcon, true)
		end
	end)
	local havedown = false

	local function TargetClassIconDown()
		local point, relativeTo, relativePoint, offsetX, offsetY = TargetClassIcon:GetPoint()
		TargetClassIcon:SetPoint(point, relativeTo, relativePoint, offsetX + 1, offsetY - 1)
		return true
	end

	targeticon:SetScript("OnMouseDown", function(self, button)
		-- 鼠标点击辅助功能
		if not UnitCanAttack("player", "target") and UnitIsPlayer"target" then
			if button == "LeftButton" then
				-- 鼠标左键
				havedown = TargetClassIconDown()
				InspectUnit"target"
			elseif button == "RightButton" then
				-- 鼠标右键
				if CheckInteractDistance("target", 2) then
					havedown = TargetClassIconDown()
					InitiateTrade"target"
				end
			elseif button == "MiddleButton" then
				-- 鼠标中键
				havedown = TargetClassIconDown()
				local server = nil
				local name, server = UnitName"target"
				local fullname = name
				if server and (not "target" or UnitRealmRelationship"target" ~= LE_REALM_RELATION_SAME) then fullname = name .. "-" .. server end
				ChatFrame_SendTell(fullname)
				-- 密语
				-- StartDuel("target") --决斗
			elseif button == "Button4" then
				-- 鼠标侧键4
				if CheckInteractDistance("target", 4) then
					havedown = TargetClassIconDown()
					FollowUnit"target"
					-- 跟随
				end
			else
				if CheckInteractDistance("target", 1) then
					havedown = TargetClassIconDown()
					InspectAchievements"target"
				end
			end
		end
	end)

	local function TargetClassIconUp()
		local point, relativeTo, relativePoint, offsetX, offsetY = TargetClassIcon:GetPoint()
		TargetClassIcon:SetPoint(point, relativeTo, relativePoint, offsetX - 1, offsetY + 1)
		return false
	end

	targeticon:SetScript("OnMouseUp", function(self) if havedown then havedown = TargetClassIconUp() end end)

	-- hooksecurefunc("UnitFrame_Update", function(self)
	-- 	local _,_class = UnitClass(self.unit);
	-- 	local coords
	-- 	if (_class and UnitIsPlayer(self.unit)) then
	-- 		coords = CLASS_ICON_TCOORDS[_class]
	-- 		TargetClassIcon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
	-- 		targeticon:Show()
	-- 	else
	-- 		targeticon:Hide()
	-- 	end
	-- end)

	hooksecurefunc("UnitFrame_Update", function()
		--if InCombatLockdown() then return end
		if UnitIsPlayer"target" then
			local coord = CLASS_ICON_TCOORDS[select(2, UnitClass"target")]
			TargetClassIcon:SetTexCoord(unpack(coord))
			targeticon:Show()
		else targeticon:Hide() end
	end)
	--TargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	--]]



--团队框架美化
	if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
		-- if InCombatLockdown() then return end

		--姓名文本美化--
		hooksecurefunc('CompactUnitFrame_UpdateName', function (f)
			-- if InCombatLockdown() then return end
			if f.UpdateNameOverride and f:UpdateNameOverride() then
				return;
			end
			if f:IsForbidden() then return end
			local fname = f.name and f:GetName()
			local namematch = (fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactRaidGroup%d"))
			if not namematch then return end


			-- if (not ShouldShowName(f)) then
				-- f.name:Hide()

			if ShouldShowName(f) then
				-- local uname = UnitFullName(f.unit, true) or GetUnitName(f.unit, true)
				local uname = UnitFullName(f.unit)
				-- if (C_Commentator.IsSpectating() and uname) then
				-- 	local overrideName = C_Commentator.GetPlayerOverrideName(uname)
				-- 	if overrideName then
				-- 		uname = overrideName
				-- 	end
				-- end
				if uname then
					f.name:SetText(uname);
					local fontName, fontSize, fontFlags = f.name:GetFont()
					f.name:SetFont(fontName, 13, "OUTLINE")
				end
				-- if (CompactUnitFrame_IsTapDenied(f)) then
				-- 	--Use grey if not a player and can't get tap on unit
				-- 	f.name:SetVertexColor(0.5, 0.5, 0.5);
				-- elseif (f.optionTable.colorNameBySelection) then
				-- 	if (f.optionTable.considerSelectionInCombatAsHostile and CompactUnitFrame_IsOnThreatListWithPlayer(f.displayedUnit)) then
				-- 		f.name:SetVertexColor(1.0, 0.0, 0.0);
				-- 	else
				-- 		f.name:SetVertexColor(UnitSelectionColor(f.unit, f.optionTable.colorNameWithExtendedColors));
				-- 	end
				-- end

				-- 	f.name:Show()
			end
		end)


		-- --备用
		-- --姓名文本美化--
		-- hooksecurefunc('CompactUnitFrame_UpdateName', function (f)
		-- 	if InCombatLockdown() then return end
		-- 	if f.UpdateNameOverride and f:UpdateNameOverride() then
		-- 		return;
		-- 	end
		-- 	if not f.name then return end	--not f.name or not f.name:IsShown()

		-- 	if (not ShouldShowName(f)) then
		-- 		f.name:Hide();
		-- 	elseif ShouldShowName(f) then
		-- 		local name = UnitFullName(f.unit, true) or GetUnitName(f.unit, true);
		-- 		if (C_Commentator.IsSpectating() and name) then
		-- 			local overrideName = C_Commentator.GetPlayerOverrideName(name);
		-- 			if overrideName then
		-- 				name = overrideName;
		-- 			end
		-- 		end

		-- 		f.name:SetText(name);
		-- 		local fontName, fontSize, fontFlags = f.name:GetFont()
		-- 		f.name:SetFont(fontName, 13, "OUTLINE")

		-- 		if (CompactUnitFrame_IsTapDenied(f)) then
		-- 			--Use grey if not a player and can't get tap on unit
		-- 			f.name:SetVertexColor(0.5, 0.5, 0.5);
		-- 		elseif (f.optionTable.colorNameBySelection) then
		-- 			if (f.optionTable.considerSelectionInCombatAsHostile and CompactUnitFrame_IsOnThreatListWithPlayer(f.displayedUnit)) then
		-- 				f.name:SetVertexColor(1.0, 0.0, 0.0);
		-- 			else
		-- 				f.name:SetVertexColor(UnitSelectionColor(f.unit, f.optionTable.colorNameWithExtendedColors));
		-- 			end
		-- 		end

		-- 		f.name:Show();
		-- 	end
		-- end)


		-- ---1
		-- hooksecurefunc('CompactUnitFrame_UpdateName', function (f)
		-- if not f.name or not f.unit then return end
		-- local fname = f.name and f:GetName()
		-- if not fname then return end
		-- local namematch = (frame_name and frame_name:match("^CompactRaidGroup%dMember%d")) or (frame_name and frame_name:match("^CompactRaidFrame%d"))
		-- --local name = GetUnitName(f.unit, true) or UnitFullName(f.unit)
		-- if ShouldShowName(f) then
		-- local name = UnitFullName(f.unit)
		-- -- if (C_Commentator.IsSpectating() and name) then
		-- -- local overrideName = C_Commentator.GetPlayerOverrideName(name)
		-- -- if overrideName then name = overrideName end
		-- -- end
		-- f.name:SetText(name)--将name改为""隐藏名字
		-- local fontName, fontSize, fontFlags = f.name:GetFont()
		-- f.name:SetFont(fontName, 13, "OUTLINE")
		-- end
		-- end)


		-----2
		-- hooksecurefunc("CompactUnitFrame_UpdateName", function(f)
		-- if f and not f:IsForbidden() then
		-- local frame_name = f:GetName()
		-- if frame_name and frame_name:match("^CompactRaidFrame%d") and f.unit and f.name then
		-- local unit_name = GetUnitName(f.unit, true)
		-- if unit_name then
		-- f.name:SetText(unit_name:match("[^-]+"))
		-- local fontName, fontSize, fontFlags = f.name:GetFont()
		-- f.name:SetFont(fontName, 13, "OUTLINE")
		-- end
		-- end
		-- end
		-- end)
		----

		--不显示输出职责图标--
		hooksecurefunc('CompactUnitFrame_UpdateRoleIcon', function (f)
			-- if InCombatLockdown() then return end
			if not f or not f.roleIcon then return end
			local role = UnitGroupRolesAssigned(f.unit)

			if role == "TANK" then
				f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\ROLE-N",true)
				f.roleIcon:SetTexCoord(0.03,.28,.35,.64)
			elseif role == "HEALER" then
				f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\ROLE-N",true)
				f.roleIcon:SetTexCoord(.33,.59,.03,.3)
			elseif role == "DAMAGER" then
				f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\ROLE-TDPS",true)
				f.roleIcon:SetTexCoord(.33,.62,.35,.68)
			end

			f.roleIcon.shouldShowRole = (f.roleIcon.shouldShowRole == nil and f.roleIcon:IsShown()) or f.roleIcon.shouldShowRole
			if f.roleIcon.shouldShowRole then
			f.roleIcon:SetScale(1.15)
			if role == "DAMAGER" then
				f.roleIcon:Hide()
				-- f.roleIcon:SetAlpha(0)
				-- f.roleIcon:SetScale(0.0001)
				f.roleIcon:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -2)
			elseif role == "TANK" or "HEALER" then
				-- f.roleIcon:Hide()
				-- f.roleIcon:SetAlpha(0)
				-- f.roleIcon:SetScale(0.0001)
				f.roleIcon:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -2)
			else
				-- f.roleIcon:Hide()
				-- f.roleIcon:SetAlpha(0)
				-- f.roleIcon:SetScale(0.0001)
				f.roleIcon:SetPoint("TOPLEFT", f, "TOPLEFT", -8, -2)
				end
			end

			if f and f.name then
				if f.roleIcon:IsShown() then
					f.name :SetPoint("TOPLEFT", f, "TOPLEFT", 14, -2)
				else
					f.name :SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
				end
			end
		end)

		-- --隐藏队伍显示--
		-- hooksecurefunc('CompactRaidGroup_UpdateLayout', function (f)
		-- 	-- if InCombatLockdown() then return end
		-- 	f.title:SetAlpha(0);
		-- end)
		-- --

		--超距渐隐--
		hooksecurefunc('CompactUnitFrame_UpdateInRange', function (f)
			-- if InCombatLockdown() then return end
			if (not f.optionTable.fadeOutOfRange) then
				return;
			end

			local inRange, checkedRange = UnitInRange(f.displayedUnit);
			if (checkedRange and not inRange) then
				f:SetAlpha(0.35);
			else
				f:SetAlpha(1);
			end
		end)
		--

		--法力条
		hooksecurefunc('CompactUnitFrame_UpdatePower', function (f)
			if not f or not f.powerBar then return end
			local role = UnitGroupRolesAssigned(f.unit);
			f.horizDivider:SetAlpha(0);
			--f.horizDivider:Hide();
			if role == "HEALER" then
			f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 6);
			--f.powerBar:Show();
			f.powerBar:SetAlpha(1);
			else
			f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 6);
			---f.powerBar:Hide();
			-- f.powerBar:SetAlpha(0);	--只显示治疗的法力值
			f.powerBar:SetAlpha(1);
			end
		end)
		--

		--美化 buffs and debuffs--
		local function CompactUnitFrame_UpdateAurasInternal(f)
			if not f or not f.buffFrames then return end
			local role = UnitGroupRolesAssigned(f.unit);

			--f.buffFrames[1]:ClearAllPoints();
			if role == "HEALER" then
			f.buffFrames[1]:SetPoint("BOTTOMRIGHT", f.healthBar, "BOTTOMRIGHT", -1.5, 1);
			else
			f.buffFrames[1]:SetPoint("BOTTOMRIGHT", f.healthBar, "BOTTOMRIGHT", -1.5, 1);
			end

			for i=1, #f.buffFrames do
			if (i > 1) then
			--f.buffFrames[i]:ClearAllPoints();
			f.buffFrames[i]:SetPoint("BOTTOMRIGHT", f.buffFrames[i-1], "BOTTOMLEFT", 0, 0);
			end
			f.buffFrames[i]:SetScale(1.22);
			f.buffFrames[i].icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
			end

			--f.debuffFrames[1]:ClearAllPoints();
			if role == "HEALER" then
				f.debuffFrames[1]:SetPoint("BOTTOMLEFT", f.healthBar, "BOTTOMLEFT", 1, 2);
				else
				f.debuffFrames[1]:SetPoint("BOTTOMLEFT", f.healthBar, "BOTTOMLEFT", 1, 2);
				end			for i=1, #f.debuffFrames do
			if (i > 1) then
			f.debuffFrames[i]:ClearAllPoints();
			f.debuffFrames[i]:SetPoint("BOTTOMLEFT", f.debuffFrames[i-1], "BOTTOMRIGHT", 0, 0);
			end
			f.debuffFrames[i]:SetScale(1.2);
			f.debuffFrames[i].icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);

			end
		end
		hooksecurefunc('CompactUnitFrame_UpdateAuras', CompactUnitFrame_UpdateAurasInternal)

	end
--]]



--任务物品
	local function moveQuestObjectiveItems(self)
		--if InCombatLockdown() then return end
		local a = { self:GetPoint() }

		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", a[2], "TOPLEFT", -16, 1)
		self:SetScale(1.4)
		--self:SetFrameStrata("MEDIUM")
		--self:SetFrameLevel(25)
	end

	local qitime = 0
	local qiinterval = 1

	hooksecurefunc("WatchFrameItem_OnUpdate", function(self, elapsed)
		--if InCombatLockdown() then return end
		qitime = qitime + elapsed
		moveQuestObjectiveItems(self)
		qitime = 0
	end)

--]]


--小地图
	DragonflightUIMinimapInfoPanel:SetScale(0.95)
	DragonflightUICalendarButton:SetScale(1.4)

	MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetJustifyH("LEFT")
	MinimapZoneText:SetPoint("LEFT", MinimapZoneTextButton, "LEFT", -2, -1)
	MinimapZoneText:SetPoint("RIGHT", MinimapZoneTextButton, "RIGHT", 15, -1)

	--小地图时间
	C_AddOns.LoadAddOn("Blizzard_TimeManager")
	--select(1, TimeManagerClockButton:GetRegions()):Hide()
	TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	TimeManagerClockTicker:SetJustifyH("RIGHT") --文本对齐方向
	-- TimeManagerClockTicker:SetTextColor(0, 0.95, 0.1)--时间字体颜色
	TimeManagerClockTicker:ClearAllPoints()
	TimeManagerClockTicker:SetPoint("RIGHT", MinimapZoneTextButton, "RIGHT", 43, 0)--时间位置
	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint("RIGHT", MinimapZoneTextButton, "RIGHT", 43, 0)


	hooksecurefunc("UIParent_ManageFramePositions",function()
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("CENTER", UIParent, "CENTER", 350, -50)
	end)
--]]


	end
end)