local AddonName, ns = ...

--exp&rep bar
local MoveExpBar = CreateFrame("Frame","MoveExpBarFrame",UIParent)
MoveExpBar:SetPoint("BOTTOM",UIParent,"BOTTOM",-0.5,2)
MoveExpBar:SetSize(578,10)
MoveExpBar:EnableMouse(false)

local MoveRepBar = CreateFrame("Frame","MoveRepBarFrame",UIParent)
MoveRepBar:SetPoint("BOTTOM",UIParent,"BOTTOM",-0.5,14.5)
MoveRepBar:SetSize(578,10)
MoveRepBar:EnableMouse(false)


ns.event("PLAYER_LOGIN", function()

	-- if C_AddOns.IsAddOnLoaded("ElvUI") == true then return end
	-- if C_AddOns.IsAddOnLoaded("NDui") == true then return end
	if C_AddOns.IsAddOnLoaded("Dominos") == true then return end
	if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end

	if DToolsDB.acu  ~= true then return end

	if DToolsDB.acp == false then

	--动作条调整
		local Classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass("player"))]
		local ntcolor
		if DToolsDB.acc == true then
			ntcolor = { r=0, g=0, b=0, a=0.95 }	--边框颜色
		else
			ntcolor = { r=1, g=1, b=1, a=1 }--边框颜色
		end
		--图标距离染色

		-- Range by Tuller
		if (ActionButton_UpdateRangeIndicator) then
			hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self)

				local ID = self.action
				local Icon = self.icon
				local HotKey = self.HotKey
				-- local NormalTexture = self:GetNormalTexture()

				if not ID then return end

				local isUsable, notEnoughMana = IsUsableAction(ID)
				local HasRange = ActionHasRange(ID)
				local InRange = IsActionInRange(ID)

				if (HasRange and InRange == false) then -- Out of range
					Icon:SetVertexColor(1.0, 0.2, 0.2)
					-- HotKey:SetVertexColor(0.8, 0.8, 0.8, 1)
					-- if NormalTexture then
					-- 	NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
					-- end
				elseif isUsable ~= true and notEnoughMana == true then
					Icon:SetVertexColor(0.4, 0.4, 1)
					-- HotKey:SetVertexColor(0.8, 0.8, 0.8, 1)
				elseif isUsable ~= true then
					Icon:SetVertexColor(0.4, 0.4, 0.4)
					-- HotKey:SetVertexColor(0.8, 0.8, 0.8, 1)
				else -- In range
					Icon:SetVertexColor(1.0, 1.0, 1.0)
					-- HotKey:SetVertexColor(0.8, 0.8, 0.8, 1)
					-- if NormalTexture then
					-- 	NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
					-- end
				end
			end)
		end

		local frame = CreateFrame("Frame")
		frame:RegisterEvent("UPDATE_BINDINGS")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		-- frame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
		frame:SetScript("OnEvent", function()
			local r = { "Action", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarLeft", "MultiBarRight",}
			for b = 1, #r do
				for i = 1, 12 do
					-- --文字保持在图标最上层
					-- local button = _G[r[b].."Button"..i]
					-- local hotkey = button.HotKey
					-- local name = button.Name
					-- local count = button.Count
					-- local overlay = CreateFrame("Frame", nil, button)
					-- overlay:SetAllPoints()
					-- if hotkey then hotkey:SetParent(overlay) end
					-- if name then name:SetParent(overlay) end
					-- if count then count:SetParent(overlay) end
					--
					_G[r[b].."Button"..i.."Icon"]:SetTexCoord(0.04, 0.93, 0.07, 0.96)
					_G[r[b].."Button"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
					_G[r[b].."Button"..i.."HotKey"]:SetJustifyH("RIGHT")
					_G[r[b].."Button"..i.."HotKey"]:SetPoint("TOPRIGHT", 3, 1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					_G[r[b].."Button"..i.."Name"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					_G[r[b].."Button"..i.."Name"]:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
					_G[r[b].."Button"..i.."Name"]:SetJustifyH("LEFT")
					_G[r[b].."Button"..i.."Name"]:SetPoint("BOTTOMLEFT", -2, 1)

					-- _G[r[b].."Button"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)

					_G[r[b].."Button"..i.."Count"]:SetVertexColor(0, 0.8, 0.8)
					_G[r[b].."Button"..i.."Count"]:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
					_G[r[b].."Button"..i.."Count"]:SetJustifyH("RIGHT")
					_G[r[b].."Button"..i.."Count"]:SetPoint("BOTTOMRIGHT", 2.5, 0)
					-- _G[r[b].."Button"..i.."Cooldown"]:SetPoint("TOPLEFT", 0, -1)
					-- _G[r[b].."Button"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", 0, 1)
				end
			end

			local r={ "PetAction", "Stance" }
			for b=1, #r do
				for i=1, 10 do
					-- --文字保持在图标最上层
					-- local button = _G[r[b].."Button"..i]
					-- local hotkey = button.HotKey
					-- local overlay = CreateFrame("Frame", nil, button)
					-- overlay:SetAllPoints()
					-- if hotkey then hotkey:SetParent(overlay) end
					-- --
					_G[r[b].."Button"..i.."Icon"]:SetTexCoord(0.01, 0.96, 0.04, 0.99)
					_G[r[b].."Button"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
					_G[r[b].."Button"..i.."HotKey"]:SetJustifyH("RIGHT")
					_G[r[b].."Button"..i.."HotKey"]:SetPoint("TOPRIGHT", 2, -1)
					_G[r[b].."Button"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					-- _G[r[b].."Button"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)
					-- _G[r[b].."Button"..i.."Cooldown"]:SetPoint("TOPLEFT", 0, -1)
					-- _G[r[b].."Button"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", 0, 1)
				end
			end

			local r={ "OverrideActionBar" }
			for b=1, #r do
				for i=1, 6 do
					-- --文字保持在图标最上层
					-- local button = _G[r[b].."Button"..i]
					-- local hotkey = button.HotKey
					-- local overlay = CreateFrame("Frame", nil, button)
					-- overlay:SetAllPoints()
					-- if hotkey then hotkey:SetParent(overlay) end
					-- --
					_G[r[b].."Button"..i.."Icon"]:SetTexCoord(0.01, 0.96, 0.03, 0.98)
					_G[r[b].."Button"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
					_G[r[b].."Button"..i.."HotKey"]:SetPoint("TOPRIGHT", 3, -1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
					-- _G[r[b].."Button"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
					-- _G[r[b].."Button"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)
					_G[r[b].."Button"..i.."Cooldown"]:SetPoint("TOPLEFT", 3, -2)
					_G[r[b].."Button"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", -2, 3)
				end
			end
			
			for i=1, 2 do
				_G["PossessButton"..i.."Icon"]:SetTexCoord(0.01, 0.94, 0.03, 0.96)
				_G["PossessButton"..i.."HotKey"]:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
				-- _G["PossessButton"..i.."HotKey"]:SetJustifyH("RIGHT")
				-- _G["PossessButton"..i.."HotKey"]:SetPoint("TOPRIGHT", 2, -1)
				-- _G["PossessButton"..i.."HotKey"]:SetVertexColor(0.8, 0.8, 0.8, 1)
				-- --_G["PossessButton"..i.."HotKey"]:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
				-- _G["PossessButton"..i.."NormalTexture"]:SetVertexColor(ntcolor.r, ntcolor.g, ntcolor.b, ntcolor.a)
				-- _G["PossessButton"..i.."Cooldown"]:SetPoint("TOPLEFT", 2, -1)
				-- _G["PossessButton"..i.."Cooldown"]:SetPoint("BOTTOMRIGHT", -1, 1)
			end

			if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
				-- ExtraActionButton1Icon:SetTexCoord(0.01, 0.96, 0.04, 0.99)
				ExtraActionButton1HotKey:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
				ExtraActionButton1HotKey:SetPoint("TOPRIGHT", 0, -6)
				ExtraActionButton1HotKey:SetVertexColor(0.8, 0.8, 0.8, 1)
				ExtraActionButton1Count:SetVertexColor(0, 0.8, 0.8)
				ExtraActionButton1Count:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
				ExtraActionButton1Count:SetPoint("BOTTOMRIGHT", 2.5, 2)
				ExtraActionButton1Cooldown:SetPoint("TOPLEFT", 2, -1)
				ExtraActionButton1Cooldown:SetPoint("BOTTOMRIGHT", -2, 3)
			end	

		end)

		--动作条快捷键简化
		local gsub = string.gsub
		local function UpdateHotkey(self)
			local hotkey = _G[self:GetName().."HotKey"]
			local text = hotkey:GetText()
			if not text then
				return
			end

			text = gsub(text, "(s%-)", "S")
			text = gsub(text, "(a%-)", "A")
			text = gsub(text, "(а%-)", "A")--fix ruRU
			text = gsub(text, "(c%-)", "C")
			text = gsub(text, "(Mouse Button)", "M")
			text = gsub(text, KEY_BUTTON3, "M3")
			text = gsub(text, KEY_BUTTON4, "M4")
			text = gsub(text, KEY_BUTTON5, "M5")
			text = gsub(text, KEY_MOUSEWHEELDOWN, "MD")
			text = gsub(text, KEY_MOUSEWHEELUP, "MU")

			text = gsub(text, KEY_PAGEUP, "PU")
			text = gsub(text, KEY_PAGEDOWN, "PD")
			text = gsub(text, KEY_SPACE, "SpB")
			text = gsub(text, KEY_INSERT, "Ins")
			text = gsub(text, KEY_HOME, "Hm")
			text = gsub(text, KEY_DELETE, "Del")



			text = gsub(text, KEY_NUMLOCK, "NuL")				--小键盘键
			text = gsub(text, KEY_NUMPAD0, "N0")
			text = gsub(text, KEY_NUMPAD1, "N1")
			text = gsub(text, KEY_NUMPAD2, "N2")
			text = gsub(text, KEY_NUMPAD3, "N3")
			text = gsub(text, KEY_NUMPAD4, "N4")
			text = gsub(text, KEY_NUMPAD5, "N5")
			text = gsub(text, KEY_NUMPAD6, "N6")
			text = gsub(text, KEY_NUMPAD7, "N7")
			text = gsub(text, KEY_NUMPAD8, "N8")
			text = gsub(text, KEY_NUMPAD9, "N9")

			--text = gsub(text, KEY_NUMPADDIVIDE, "N/")
			--text = gsub(text, KEY_NUMPADMINUS, "N-")
			--text = gsub(text, KEY_NUMPADMULTIPLY, "N*")
			--text = gsub(text, KEY_NUMPADPLUS, "N+")
			--text = gsub(text, KEY_NUMPADDECIMAL, "N.")



			if hotkey:GetText() == _G["RANGE_INDICATOR"] then
				hotkey:SetText("")
			else
				hotkey:SetText(text)
			end
		-- hotkey:SetVertexColor(0.8, 0.8, 0.8, 1)
		--hotkey:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)

		end
		local frame = CreateFrame("Frame")
		frame:RegisterEvent("UPDATE_BINDINGS")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:SetScript("OnEvent", function()
			for i = 1, 12 do
				UpdateHotkey(_G["ActionButton"..i])
				UpdateHotkey(_G["MultiBarBottomLeftButton"..i])
				UpdateHotkey(_G["MultiBarBottomRightButton"..i])
				UpdateHotkey(_G["MultiBarLeftButton"..i])
				UpdateHotkey(_G["MultiBarRightButton"..i])
				UpdateHotkey(_G["MultiBarRightButton"..i])
				UpdateHotkey(_G["MultiBar6Button"..i])
				UpdateHotkey(_G["MultiBar7Button"..i])
			end
			for i = 1, 10 do
				UpdateHotkey(_G["StanceButton"..i])
				UpdateHotkey(_G["PetActionButton"..i])
			end
			UpdateHotkey(ExtraActionButton1)
		end)

	end
end)


local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(...)

	if DToolsDB.daml == true then
		--隐藏动作条皮肤
		MainMenuBarArtFrame:Hide() 
		MainMenuMaxLevelBar0:Hide() 
		MainMenuMaxLevelBar1:Hide() 
		MainMenuMaxLevelBar2:Hide()
		MainMenuMaxLevelBar3:Hide() 

		MainMenuBarTexture0:Hide()
		MainMenuBarTexture1:Hide()
		MainMenuBarTexture2:Hide()
		MainMenuBarTexture3:Hide()
		MainMenuBarTextureExtender:Hide()
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
		MainMenuBarPerformanceBarFrame:Hide()

		StanceBar.BackgroundArtLeft:SetAlpha(0.01)
		StanceBar.BackgroundArtMiddle:SetAlpha(0.01)
		StanceBar.BackgroundArtRight:SetAlpha(0.01)
		PetActionBar.BackgroundArt1:SetAlpha(0.01)
		PetActionBar.BackgroundArt2:SetAlpha(0.01)
		PossessActionBar.BackgroundArt1:SetAlpha(0.01)
		PossessActionBar.BackgroundArt2:SetAlpha(0.01)
		

		--主动作条翻页
		MainActionBar.ActionBarPageNumber:SetAlpha(0)
		-- -- MainActionBar.ActionBarPageNumber.UpButton:SetAlpha(0)
		-- -- MainActionBar.ActionBarPageNumber.DownButton:SetAlpha(0)

		MainActionBar.ActionBarPageNumber:SetAlpha(0.2);--主动作条翻页数字 位置在背景上
		-- MainActionBar.ActionBarPageNumber.UpButton:SetAlpha(0.2); --主动作条翻页箭头上
		-- MainActionBar.ActionBarPageNumber.DownButton:SetAlpha(0.2); --主动作条翻页箭头下
		MainActionBar.ActionBarPageNumber:ClearAllPoints()
		MainActionBar.ActionBarPageNumber:SetPoint("BOTTOMRIGHT",ActionButton1,"BOTTOMLEFT",-2,-11)
		MainActionBar.ActionBarPageNumber.DownButton:ClearAllPoints()
		MainActionBar.ActionBarPageNumber.DownButton:SetPoint("BOTTOMLEFT",ActionButton12,"BOTTOMRIGHT",3,-2)
		MainActionBar.ActionBarPageNumber.UpButton:ClearAllPoints()
		MainActionBar.ActionBarPageNumber.UpButton:SetPoint("BOTTOM",MainActionBar.ActionBarPageNumber.DownButton,"TOP",0,0)

		--载具动作条
		if OverrideActionBar then OverrideActionBar:SetScale(1.05) end	--载具动作条
		--装备耐久框体

		DurabilityFrame:ClearAllPoints()
		DurabilityFrame:SetPoint("BOTTOM",UIParent,"BOTTOM",-255,240)

		-- --离开载具条
		-- MainMenuBarVehicleLeaveButton:SetParent(frame)
		-- MainMenuBarVehicleLeaveButton:SetScale(0.65)
		-- MainMenuBarVehicleLeaveButton:SetScript("OnEvent", function(self, event)
		-- 	if (CanExitVehicle() and ActionBarController_GetCurrentActionBarState() == LE_ACTIONBAR_STATE_MAIN) then
		-- 		MainMenuBarVehicleLeaveButton:Show()
		-- 		MainMenuBarVehicleLeaveButton:Enable()
		-- 	else
		-- 		MainMenuBarVehicleLeaveButton:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]], "ADD")
		-- 		MainMenuBarVehicleLeaveButton:UnlockHighlight()
		-- 		MainMenuBarVehicleLeaveButton:Hide()
		-- 	end
		-- end)

		----经验声望
		----经验
		local ExpBar = CreateFrame("Frame","DiabloExpBar",UIParent)
		ExpBar:SetPoint("CENTER",MoveExpBarFrame,"CENTER",0,0)
		ExpBar:SetSize(578,10)
		ExpBar:SetFrameLevel(3)

		local exp = CreateFrame("StatusBar",nil,ExpBar)
		exp:SetAllPoints(ExpBar)
		exp:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		exp:SetFrameLevel(2)

		local expo = exp:CreateTexture(nil,"OVERLAY")
		expo:SetPoint("TOP",0,2)
		expo:SetPoint("LEFT",-3,0)
		expo:SetPoint("RIGHT",473,0)
		expo:SetPoint("BOTTOM",0,-4)
		expo:SetTexture("Interface\\AddOns\\" .. AddonName .. "\\media\\exp_Overlay")

		local rexp = CreateFrame("StatusBar",nil,ExpBar)
		rexp:SetAllPoints(ExpBar)
		rexp:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		rexp:SetFrameLevel(1)
		rexp:SetAlpha(0.5)

		local expb = exp:CreateTexture(nil, "BACKGROUND")
		expb:SetAllPoints()
		expb:SetColorTexture(0.2, 0.2, 0.2, 0.5)

		local text = ExpBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:SetPoint("CENTER", ExpBar, "CENTER", 0, 0.5)
		text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
		text:Show()
		ExpBar.text = text
		----声望
		local RepBar = CreateFrame("Frame","DiabloRepBar",UIParent)
		RepBar:SetPoint("CENTER",MoveExpBarFrame,"CENTER",0,0)
		RepBar:SetSize(578,10)
		RepBar:SetFrameLevel(3)

		local rep = CreateFrame("StatusBar",nil,RepBar)
		rep:SetAllPoints(RepBar)
		rep:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		rep:SetFrameLevel(2)

		local repo = rep:CreateTexture(nil,"OVERLAY")
		repo:SetPoint("TOP",0,2)
		repo:SetPoint("LEFT",-3,0)
		repo:SetPoint("RIGHT",473,0)
		repo:SetPoint("BOTTOM",0,-4)
		repo:SetTexture("Interface\\AddOns\\" .. AddonName .. "\\media\\exp_Overlay")

		local repb = rep:CreateTexture(nil, "BACKGROUND")
		repb:SetAllPoints()
		repb:SetColorTexture(0.2, 0.2, 0.2, 0.5)

		local text = RepBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:SetPoint("CENTER", RepBar, "CENTER", 0, 0)
		text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
		text:SetShadowOffset(1, -1)
    	text:SetShadowColor(0, 0, 0, 1)
		text:Show()
		RepBar.text = text

		local FACTION_STANDING = {
			[1] = {name = "仇恨", r = 0.8, g = 0.1, b = 0.1},
			[2] = {name = "敌对", r = 0.9, g = 0.2, b = 0.2},
			[3] = {name = "冷淡", r = 0.9, g = 0.5, b = 0.1},
			[4] = {name = "中立", r = 1.0, g = 0.8, b = 0.1},
			[5] = {name = "友善", r = 0.2, g = 0.8, b = 0.2},
			[6] = {name = "尊敬", r = 0.1, g = 0.7, b = 0.1},
			[7] = {name = "崇敬", r = 0.1, g = 0.7, b = 0.1},
			[8] = {name = "崇拜", r = 0.1, g = 0.7, b = 0.1},
		}

		local function GetWatchedFactionInfo_Vanilla()
			local i = 1
			local maxFactions = GetNumFactions() or 0
			
			for i = 1, maxFactions do
				local name, desc, standID, min, max, curr, _, _, isHeader, _, _, isWatched = GetFactionInfo(i)
				if name and isWatched then
					return name, standID, min, max, curr
				end
			end
			return nil
		end

		local function UpdateBars()
			MainStatusTrackingBarContainer:SetScale(0.01)
			SecondaryStatusTrackingBarContainer:SetScale(0.01)
			MainStatusTrackingBarContainer:Hide()
			SecondaryStatusTrackingBarContainer:Hide()

			local lvl = UnitLevel("player")
			local maxLvl = GetMaxPlayerLevel()
			local currXP, maxXP = UnitXP("player"), UnitXPMax("player")
			local restXP = GetXPExhaustion() or 0
			local percent = math.floor(currXP / maxXP * 1000) / 10
			local restPercent = restXP > 0 and math.floor(restXP/maxXP*1000)/10 or 0
			exp:SetMinMaxValues(0, maxXP)
			exp:SetValue(currXP)
			rexp:SetMinMaxValues(0, maxXP)
			rexp:SetValue(math.min(currXP + restXP, maxXP))

			local exptext
			local lvls
			if (GetLocale() == "zhCN") then
				lvls = "等级:"..lvl
			else
				lvls = "L.:"..lvl
			end

			if lvl >= maxLvl then
				ExpBar:Hide()
			else
				ExpBar:Show()
				if restXP > 0 then
				exptext = lvls.." - "..currXP.."/"..maxXP.." ("..percent.."%) - "..restXP.." ("..restPercent.."%)"
					exp:SetStatusBarColor(0.0, 0.4, 0.8)
					rexp:SetStatusBarColor(0.2, 0.6, 1.0)
					rexp:Show()
				else
				exptext = lvls.." - "..currXP.."/"..maxXP.." ("..percent.."%)"
					exp:SetStatusBarColor(0.6, 0.0, 0.8)
					rexp:Hide()
				end
			end

	
			if ExpBar:IsShown() then 
				ExpBar.text:SetText(exptext)
				if DToolsDB.expbt then
					ExpBar.text:Show()
				else
					ExpBar.text:Hide()
				end
				MoveExpBar:SetScript("OnMouseDown", function(self)
					if ExpBar.text:IsShown() then 
						ExpBar.text:Hide() 
						DToolsDB.expbt = false
					else 
						ExpBar.text:Show() 
						DToolsDB.expbt = true
					end
				end)
			end


			local name, standID, min, max, curr = GetWatchedFactionInfo_Vanilla()
			if not name then
				RepBar:Hide()
				return
			end

			RepBar:Show()
			local c = FACTION_STANDING[standID] or FACTION_STANDING[4]
			local progress = max - min
			local current = curr - min
			local pct = math.floor((current / progress) * 1000) / 10

			rep:SetStatusBarColor(c.r, c.g, c.b)
			rep:SetMinMaxValues(0, progress)
			rep:SetValue(current)

			local reptext
			if (GetLocale() == "zhCN") then
				reptext = name.." - "..c.name.." "..current.."/"..progress.." ("..pct.."%)"
			else
				reptext = name.."".." "..current.."/"..progress.." ("..pct.."%)"
			end


			if ExpBar:IsShown() and RepBar:IsShown() then
				MoveRepBar:EnableMouse(true) 
				RepBar:SetPoint("CENTER",MoveRepBarFrame,"CENTER",0,0)
				RepBar.text:SetText(reptext)
				if DToolsDB.repbt then
					RepBar.text:Show()
				else
					RepBar.text:Hide()
				end
				MoveRepBar:SetScript("OnMouseDown", function(self)
					if RepBar.text:IsShown() then 
						RepBar.text:Hide() 
						DToolsDB.repbt = false
					else 
						RepBar.text:Show() 
						DToolsDB.repbt = true
					end
				end)
			elseif not ExpBar:IsShown() and RepBar:IsShown() then
				MoveExpBar:EnableMouse(true) 
				RepBar:SetPoint("CENTER",MoveExpBarFrame,"CENTER",0,0)
				RepBar.text:SetText(reptext)
				if DToolsDB.repbt then
					RepBar.text:Show()
				else
					RepBar.text:Hide()
				end
				MoveExpBar:SetScript("OnMouseDown", function(self)
					if RepBar.text:IsShown() then 
						RepBar.text:Hide() 
						DToolsDB.repbt = false
					else 
						RepBar.text:Show() 
						DToolsDB.repbt = true
					end
				end)
			end

		end

		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_XP_UPDATE")
		f:RegisterEvent("UPDATE_EXHAUSTION")
		f:RegisterEvent("PLAYER_LEVEL_UP")
		f:RegisterEvent("UPDATE_FACTION")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", UpdateBars)

		UpdateBars()


		function DToolActionBar_Layout()
			local function Update_MultiBar()
				if InCombatLockdown() then return end
				local bspace = 6

				local r = {"Action","MultiBarBottomLeft", "MultiBarBottomRight"}
				for b=1,#r do 
					for i=2,12 do 
					_G[r[b].."Button"..i]:ClearAllPoints();
					_G[r[b].."Button"..i]:SetPoint("LEFT",_G[r[b].."Button"..(i - 1)],"RIGHT",bspace,0)
					end 
				end

				local r = {"MultiBarRight","MultiBarLeft"}
				for b=1,#r do 
					for i=2,12 do 
					_G[r[b].."Button"..i]:ClearAllPoints();
					_G[r[b].."Button"..i]:SetPoint("TOP", _G[r[b].."Button"..(i - 1)], "BOTTOM", 0, -1*bspace);
					end 
				end

				--Stancbar
				for i=2, 10 do
					_G["StanceButton"..i]:ClearAllPoints();
					_G["StanceButton"..i]:SetPoint("LEFT", _G["StanceButton"..i-1], "RIGHT", bspace, 0);
				end

				--petbar
				for i=2, NUM_PET_ACTION_SLOTS do
					_G["PetActionButton"..i]:ClearAllPoints();
					_G["PetActionButton"..i]:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", bspace, 0);
				end

				--possessbar
				for i=2, NUM_POSSESS_SLOTS do
					_G["PossessButton"..i]:ClearAllPoints();
					_G["PossessButton"..i]:SetPoint("LEFT", _G["PossessButton"..i-1], "RIGHT", bspace, 0);
				end

				MainMenuBarVehicleLeaveButton:HookScript("OnUpdate",function()
					MainMenuBarVehicleLeaveButton:ClearAllPoints()
					-- MainMenuBarVehicleLeaveButton:SetParent(UIParent)
					if DToolsDB.acm == 3 then
						MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", MultiBarBottomRightButton12, "TOPLEFT", -3, 7)
					else
						MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", MultiBarBottomLeftButton12, "TOPLEFT", -3, 7)
					end
				end)

				-- SetCVar("xpBarText", 0)
				-- -- MainStatusTrackingBarContainer:HookScript("OnUpdate",function()
				-- 	MainStatusTrackingBarContainer:SetScale(0.58)
				-- 	MainStatusTrackingBarContainer:SetClampedToScreen(false)
				-- 	MainStatusTrackingBarContainer:ClearAllPoints()
				-- 	MainStatusTrackingBarContainer:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 2)

				-- 	-- MainStatusTrackingBarContainer:SetScale(1.03)
				-- 	-- MainStatusTrackingBarContainer:SetClampedToScreen(false)
				-- 	-- MainStatusTrackingBarContainer:ClearAllPoints()
				-- 	-- MainStatusTrackingBarContainer:SetPoint("TOP", UIParent, "TOP", -2, 0)

				-- -- end)
				-- -- SecondaryStatusTrackingBarContainer:HookScript("OnUpdate",function()
				-- 	SecondaryStatusTrackingBarContainer:SetScale(0.58)
				-- 	SecondaryStatusTrackingBarContainer:SetClampedToScreen(false)
				-- 	SecondaryStatusTrackingBarContainer:ClearAllPoints()
				-- 	SecondaryStatusTrackingBarContainer:SetPoint("BOTTOM", MainStatusTrackingBarContainer, "TOP", 0, -3)

				-- 	-- SecondaryStatusTrackingBarContainer:SetScale(1.03)
				-- 	-- SecondaryStatusTrackingBarContainer:SetClampedToScreen(false)
				-- 	-- SecondaryStatusTrackingBarContainer:ClearAllPoints()
				-- 	-- SecondaryStatusTrackingBarContainer:SetPoint("TOP", MainStatusTrackingBarContainer, "BOTTOM", 0, 2)

				-- -- end)


				local r={"Action","MultiBarBottomLeft"}
				for b=1,#r do for i=1,12 do _G[r[b].."Button"..i]:SetScale(1.15) end end

				ActionButton1:ClearAllPoints()
				if ExpBar:IsShown() and RepBar:IsShown() then
					ActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-231.5,25)
				elseif ExpBar:IsShown() or RepBar:IsShown() then
					ActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-231.5,14)
				else
					ActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-231.5,14)
				end

				for i = 2, 12 do
					_G["ActionButton"..i]:ClearAllPoints();
					_G["ActionButton"..i]:SetPoint("LEFT",_G["ActionButton"..(i - 1)],"RIGHT",bspace,0)
				end 

				MultiBarBottomLeftButton1:ClearAllPoints()
				MultiBarBottomLeftButton1:SetPoint("BOTTOM",ActionButton1,"TOP",0,bspace)

				MultiBarRightButton1:ClearAllPoints()
				MultiBarRightButton1:SetPoint("TOPRIGHT", UIParent, "RIGHT", -4, 100+17*bspace)

				MultiBarLeftButton1:ClearAllPoints()
				MultiBarLeftButton1:SetPoint("RIGHT", MultiBarRightButton1, "LEFT", -1*bspace, 0)

				PossessButton1:ClearAllPoints()
				PossessButton1:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOPRIGHT", 3, 7)

				-- MainMenuBarVehicleLeaveButton:ClearAllPoints()
				-- MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", MultiBarBottomLeftButton12, "TOPLEFT", -3, 7)
				
				local r = {"MultiBarRight", "MultiBarLeft"}
				for b=1,#r do for i=1,12 do _G[r[b].."Button"..i]:SetScale(1) end end

				for i=1, NUM_POSSESS_SLOTS do _G["PossessButton"..i]:SetScale(1.1) end

				-- if DToolsDB.acm == 1 then 

				-- 	for i=1,12 do _G["MultiBarBottomRightButton"..i]:SetScale(1) end

				-- 	MultiBarBottomRightButton1:ClearAllPoints()
				-- 	MultiBarBottomRightButton1:SetPoint("TOPLEFT", UIParent, "CENTER", 310, -125)
				-- 	MultiBarBottomRightButton3:ClearAllPoints()
				-- 	MultiBarBottomRightButton3:SetPoint("TOP",MultiBarBottomRightButton1,"BOTTOM", 0, -1*bspace)

				-- 	MultiBarBottomRightButton5:ClearAllPoints()
				-- 	MultiBarBottomRightButton5:SetPoint("TOPLEFT", UIParent, "BOTTOM", 310, 250)

				-- 	MultiBarBottomRightButton7:ClearAllPoints()
				-- 	MultiBarBottomRightButton7:SetPoint("TOPRIGHT",MultiBarRightButton12,"BOTTOMLEFT",-1*bspace,-1*bspace)
				-- 	MultiBarBottomRightButton9:ClearAllPoints()
				-- 	MultiBarBottomRightButton9:SetPoint("TOP", MultiBarBottomRightButton7, "BOTTOM", 0, -1*bspace)
				-- 	MultiBarBottomRightButton11:ClearAllPoints()
				-- 	MultiBarBottomRightButton11:SetPoint("TOP", MultiBarBottomRightButton9, "BOTTOM", 0, -1*bspace)

				-- elseif DToolsDB.acm == 2 then

				-- 	for i=1,12 do _G["MultiBarBottomRightButton"..i]:SetScale(0.91) end

				-- 	MultiBarBottomRightButton1:ClearAllPoints()
				-- 	MultiBarBottomRightButton1:SetPoint("TOPLEFT", UIParent, "CENTER", 344, -125)

				-- 	MultiBarBottomRightButton3:ClearAllPoints()
				-- 	MultiBarBottomRightButton3:SetPoint("TOP",MultiBarBottomRightButton1,"BOTTOMLEFT",-1*bspace/2,-1*bspace)
				-- 	MultiBarBottomRightButton6:ClearAllPoints()
				-- 	MultiBarBottomRightButton6:SetPoint("TOPLEFT",MultiBarBottomRightButton3,"BOTTOM",bspace/2,-1*bspace)

				-- 	MultiBarBottomRightButton8:ClearAllPoints()
				-- 	MultiBarBottomRightButton8:SetPoint("TOPLEFT",UIParent,"BOTTOM",323,310)
				-- 	MultiBarBottomRightButton11:ClearAllPoints()
				-- 	MultiBarBottomRightButton11:SetPoint("TOPLEFT",MultiBarBottomRightButton8,"BOTTOM",bspace/2,-1*bspace)

				-- else
					if DToolsDB.acm == 3 then

					local r={"Action","MultiBarBottomLeft","MultiBarBottomRight"}
					for b=1,#r do for i=1,12 do _G[r[b].."Button"..i]:SetScale(1.13) end end

					ActionButton1:ClearAllPoints()
					if ExpBar:IsShown() and RepBar:IsShown() then
						ActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-231.5,25)
					elseif ExpBar:IsShown() or RepBar:IsShown() then
						ActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-231.5,14)
					else
						ActionButton1:SetPoint("BOTTOM",UIParent,"BOTTOM",-231.5,6)
					end

					MultiBarBottomRightButton1:ClearAllPoints()
					MultiBarBottomRightButton1:SetPoint("BOTTOM",MultiBarBottomLeftButton1,"TOP",0,bspace)

					PossessButton1:ClearAllPoints()
					PossessButton1:SetPoint("BOTTOM", MultiBarBottomRightButton1, "TOPRIGHT", 3, 7)

					-- MainMenuBarVehicleLeaveButton:ClearAllPoints()
					-- MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", MultiBarBottomRightButton12, "TOPLEFT", -3, 7)

				else

					local r = {"MultiBarBottomRight","MultiBarRight", "MultiBarLeft"}
					for b=1,#r do for i=1,12 do _G[r[b].."Button"..i]:SetScale(0.91) end end

					MultiBarBottomRightButton1:ClearAllPoints()
					MultiBarBottomRightButton1:SetPoint("TOPRIGHT",MultiBarRightButton12,"BOTTOMLEFT",-1*bspace,-1*bspace)
					local ab={1, 3, 5, 7, 9, 11}
					for b = 2,#ab do
						_G["MultiBarBottomRightButton"..ab[b]]:ClearAllPoints()
						_G["MultiBarBottomRightButton"..ab[b]]:SetPoint("TOP",_G["MultiBarBottomRightButton"..ab[b-1]],"BOTTOM",0,-1*bspace)
					end
				end
			end
			Update_MultiBar()

			local function Update_BarPoint(BarUI)

				BarUI:ClearAllPoints();
				if BarUI == MultiCastActionBarFrame then
					if select(2, UnitClass('player')) == "SHAMAN" then
						MultiCastActionBarFrame:SetScale(1.12)
						if DToolsDB.acm == 3 then
							if PossessActionBar:IsShown() then
								MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton3, "TOP", 4, 4)
							else
								MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOP", 4, 4)
							end
						else
							if PossessActionBar:IsShown() then
								MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton3, "TOP", 4, 4)
							else
								MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOP", 4, 4)
							end
						end
						-- MultiCastActionBarFrame_OnEvent(MultiCastActionBarFrame, "UPDATE_MULTI_CAST_ACTIONBAR")
					end
				end

				if BarUI==StanceButton1 then
					for i=1, 10 do _G["StanceButton"..i]:SetScale(1.1) end
					if DToolsDB.acm == 3 then
						StanceButton1:SetPoint("BOTTOM", MultiBarBottomRightButton1, "TOPRIGHT", 3, 6)
					else
						StanceButton1:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOPRIGHT", 3, 6)
					end
				end

				if BarUI==PetActionButton1 then
					for i=1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetScale(1) end
					if DToolsDB.acm == 3 then
						if StanceBar:IsVisible() then
							if StanceButton4:IsShown() then
								for i=1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetScale(0.9) end
								PetActionButton1:SetPoint("BOTTOMLEFT", StanceButton1, "TOPLEFT", 0, 7)
							else
								PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton4, "TOPRIGHT", -7, 7)
							end
						elseif select(2, UnitClass('player')) == "SHAMAN" and MultiCastActionBarFrame then
							PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton3, "TOP", -11, 46)
						else
							PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton3, "TOP", -11, 7)
						end
					else
						if StanceBar:IsVisible() then
							if StanceButton4:IsShown() then
								for i=1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetScale(0.9) end
								PetActionButton1:SetPoint("BOTTOMLEFT", StanceButton1, "TOPLEFT", 0, 7)
							else
								PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton4, "TOPRIGHT", -3, 7)
							end
						elseif select(2, UnitClass('player')) == "SHAMAN" and MultiCastActionBarFrame then
							PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton3, "TOP", -7, 46)
						else
							PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton3, "TOP", -7, 7)
						end
					end
				end

			end

			---图腾条
			local function Update_MultiCastBar()
				if InCombatLockdown() then
					MultiCastActionBarFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
				else
					MultiCastActionBarFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
					Update_BarPoint(MultiCastActionBarFrame)
				end
			end

			--时光服图腾条
			if MultiCastActionBarFrame then
				Update_MultiCastBar()

				hooksecurefunc("UIParent_ManageFramePositions",function()
				-- hooksecurefunc("MultiCastActionBarFrame_OnUpdate",function()
					if select(2, UnitClass('player')) == "SHAMAN" then
						Update_MultiCastBar()
					end
				end)
				
				-- MultiCastActionBarFrame:HookScript("OnEvent", function (self,event)
				-- 	if event=="PLAYER_ENTERING_WORLD" then
				-- 		Update_MultiCastBar()
				-- 	elseif event=="PLAYER_REGEN_ENABLED" then
				-- 		Update_MultiCastBar()
				-- 	end
				-- end);
				-- UIParent:HookScript("OnShow", function(self)
				-- 	Update_MultiCastBar()
				-- end)
			end

			--姿态条
			local function Update_StanceBar()
				if InCombatLockdown() then
					StanceBar:RegisterEvent("PLAYER_REGEN_ENABLED");
				else
					StanceBar:UnregisterEvent("PLAYER_REGEN_ENABLED");
					Update_BarPoint(StanceButton1)
				end
			end
			Update_StanceBar()
			StanceBar:HookScript("OnEvent", function (self,event)
				if event=="PLAYER_REGEN_ENABLED" then
					Update_StanceBar()
				end
			end);
			--宠物动作条
			local function Update_PetBar()
				if InCombatLockdown() then
					PetActionBar:RegisterEvent("PLAYER_REGEN_ENABLED");
				else
					PetActionBar:UnregisterEvent("PLAYER_REGEN_ENABLED");
					Update_BarPoint(PetActionButton1)
				end
			end
			Update_PetBar()
			if PetActionBar.UpdatePositionValues then
				hooksecurefunc(PetActionBar, "UpdatePositionValues", function()
					Update_PetBar()
				end)
			elseif ShowPetActionBar then
				hooksecurefunc("ShowPetActionBar", function()
					Update_PetBar()
				end)
			end
			PetActionBar:HookScript("OnEvent", function (self,event)
				if event=="PLAYER_REGEN_ENABLED" or event == "UNIT_PET" then
					Update_PetBar()
				end
			end);

			-- hooksecurefunc("MultiActionBar_Update",function()	
			-- 	Update_MultiBar()
			-- 	Update_StanceBar()
			-- 	Update_PetBar()
			-- end);

			-- local function TrackStatusBarContainerShowHide()
			-- 	local mstbc = _G.MainStatusTrackingBarContainer
			-- 	if not mstbc or mstbc.HookedShowHide then return end
			-- 	mstbc:HookScript("OnHide", function()
			-- 		Update_MultiBar()
			-- 	end)
			-- 	mstbc:HookScript("OnShow", function()
			-- 		Update_MultiBar()
			-- 	end)
			-- 	mstbc.HookedShowHide = true

			-- 	local sstbc = _G.SecondaryStatusTrackingBarContainer
			-- 	if not sstbc or sstbc.HookedShowHide then return end
			-- 	sstbc:HookScript("OnHide", function()
			-- 		Update_MultiBar()
			-- 	end)
			-- 	sstbc:HookScript("OnShow", function()
			-- 		Update_MultiBar()
			-- 	end)
			-- 	sstbc.HookedShowHide = true
			-- end
			-- TrackStatusBarContainerShowHide()

			local function ExpandRepBarShowHide()
				if not ExpBar or ExpBar.HookedShowHide then return end
				ExpBar:HookScript("OnHide", function()
					Update_MultiBar()
				end)
				ExpBar:HookScript("OnShow", function()
					Update_MultiBar()
				end)
				ExpBar.HookedShowHide = true

				if not RepBar or RepBar.HookedShowHide then return end
				RepBar:HookScript("OnHide", function()
					Update_MultiBar()
				end)
				RepBar:HookScript("OnShow", function()
					Update_MultiBar()
				end)
				RepBar.HookedShowHide = true
			end
			ExpandRepBarShowHide()
		

			--背包和系统菜单
			local MicroButtons = {
				WorldMapMicroButton,
				GarrisonLandingPageMinimapButton,
				CompanionsMicroButton,
				EJMicroButton,
				StoreMicroButton,
				GuildMicroButton,

				MainMenuMicroButton,
				HelpMicroButton,
				LFGMicroButton,
				PVPMicroButton,
				CollectionsMicroButton,
				SocialsMicroButton,
				QuestLogMicroButton,
				AchievementMicroButton,
				TalentMicroButton,
				SpellbookMicroButton,
				CharacterMicroButton,

				}

			local BagButtons = {
				MainMenuBarBackpackButton,
				CharacterBag0Slot,
				CharacterBag1Slot,
				CharacterBag2Slot,
				CharacterBag3Slot,
				--KeyRingButton --怀旧钥匙包
				}


			--背包菜单位置
			-- hooksecurefunc("UIParent_ManageFramePositions", function()
			-- 	if InCombatLockdown() then return end
				--背包&系统菜单位置
				if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
					MainMenuBarBackpackButton:HookScript("OnUpdate",function()
						if OverrideActionBar:IsShown() then
							for i, button in next, BagButtons do button:SetScale(1) end
						else
							for i, button in next, BagButtons do button:SetScale(1.2) end
								CharacterBag0Slot:ClearAllPoints()
								CharacterBag0Slot:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -2, 0)
								CharacterBag1Slot:ClearAllPoints()
								CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot,"LEFT",  -2, 0)
								CharacterBag2Slot:ClearAllPoints()
								CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot,"LEFT",  -2, 0)
								CharacterBag3Slot:ClearAllPoints()
								CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot,"LEFT",  -2, 0)
								MainMenuBarBackpackButton:ClearAllPoints()
								MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 30)
						end
					end)
					MicroMenu:HookScript("OnUpdate",function()
						if OverrideActionBar:IsShown() then
							for i, button in next, MicroButtons do button:SetScale(1) end
						else
							for i, button in next, MicroButtons do button:SetScale(0.9) end
							MicroMenu:ClearAllPoints()
							MicroMenu:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT", 29, -3)
						end
					end)
				elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
					MainMenuBarBackpackButton:HookScript("OnUpdate",function()
						if OverrideActionBar:IsShown() then
							for i, button in next, BagButtons do button:SetScale(1) end
						else
							for i, button in next, BagButtons do button:SetScale(1.08) end
							CharacterBag0Slot:ClearAllPoints()
							CharacterBag0Slot:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -17, 0.5)
							CharacterBag1Slot:ClearAllPoints()
							CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot,"LEFT",  -3, 0)
							CharacterBag2Slot:ClearAllPoints()
							CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot,"LEFT",  -3, 0)
							CharacterBag3Slot:ClearAllPoints()
							CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot,"LEFT",  -3, 0)
							MainMenuBarBackpackButton:ClearAllPoints()
							MainMenuBarBackpackButton:SetScale(1)
							MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -3, 36)
							KeyRingButton:ClearAllPoints()
							KeyRingButton:SetScale(0.82)
							KeyRingButton:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -2, -1)
						end
					end)
				MicroMenu:HookScript("OnUpdate",function()
					if OverrideActionBar:IsShown() then
						for i, button in next, MicroButtons do button:SetScale(1) end
					else
						for i, button in next, MicroButtons do button:SetScale(0.95) end
						MicroMenu:ClearAllPoints()
						MicroMenu:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT", 13, -2)
					end
				end)
			elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
				MainMenuBarBackpackButton:HookScript("OnUpdate",function()
					if OverrideActionBar:IsShown() then
						-- for i, button in next, BagButtons do button:SetScale(1) end
					else
						-- for i, button in next, BagButtons do button:SetScale(1) end
						CharacterBag0Slot:ClearAllPoints()
						CharacterBag0Slot:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -21, 0)
						CharacterBag1Slot:ClearAllPoints()
						CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot,"LEFT",  -2, 0)
						CharacterBag2Slot:ClearAllPoints()
						CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot,"LEFT",  -2, 0)
						CharacterBag3Slot:ClearAllPoints()
						CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot,"LEFT",  -2, 0)
						MainMenuBarBackpackButton:ClearAllPoints()
						MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 3)
						KeyRingButton:ClearAllPoints()
						KeyRingButton:SetScale(0.98)
						KeyRingButton:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -2, -1)
					end
				end)
				MicroMenu:HookScript("OnUpdate",function()
					if OverrideActionBar:IsShown() then
						for i, button in next, MicroButtons do button:SetScale(1) end
					else
						for i, button in next, MicroButtons do button:SetScale(0.95) end
						MicroMenu:ClearAllPoints()
						MicroMenu:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT", 8, 38)
					end
				end)
			elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
				MainMenuBarBackpackButton:HookScript("OnUpdate",function()
					if OverrideActionBar:IsShown() then
						-- for i, button in next, BagButtons do button:SetScale(1) end
					else
						-- for i, button in next, BagButtons do button:SetScale(1) end
						CharacterBag0Slot:ClearAllPoints()
						CharacterBag0Slot:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -21, 0)
						CharacterBag1Slot:ClearAllPoints()
						CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot,"LEFT",  -2, 0)
						CharacterBag2Slot:ClearAllPoints()
						CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot,"LEFT",  -2, 0)
						CharacterBag3Slot:ClearAllPoints()
						CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot,"LEFT",  -2, 0)
						MainMenuBarBackpackButton:ClearAllPoints()
						MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 3)
						KeyRingButton:ClearAllPoints()
						KeyRingButton:SetScale(0.98)
						KeyRingButton:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton,"BOTTOMLEFT",  -2, -1)
					end
				end)
				MicroMenu:HookScript("OnUpdate",function()
					if OverrideActionBar:IsShown() then
						for i, button in next, MicroButtons do button:SetScale(1) end
					else
						for i, button in next, MicroButtons do button:SetScale(0.95) end
						MicroMenu:ClearAllPoints()
						MicroMenu:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT", 10, 38)
					end
				end)
			end
			-- end)

			----3
			-- MicroMenuContainer:ClearAllPoints()
			-- MicroMenuContainer:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT", 12, -2)
			-- BagsBar:ClearAllPoints()
			-- BagsBar:SetPoint("BOTTOMRIGHT", UIParent,"BOTTOMRIGHT", -2, 38)
			
		end
		DToolActionBar_Layout()

		--防止空白区域不可点击, 以便使其他插件正常工作
		for _, bar in next, {
			MainActionBar,
			MultiBarBottomLeft,
			MultiBarBottomRight,
			MultiBarLeft,
			MultiBarRight,
			PetActionBar,
			PossessActionBar,
			StanceBar
			} do
			bar:EnableMouse(false);
		end

	end
	
end)