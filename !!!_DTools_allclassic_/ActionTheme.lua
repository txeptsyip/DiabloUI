local _
local AddonName, ns = ...
if InCombatLockdown() then return end

ns.event("PLAYER_LOGIN", function()

	-- if C_AddOns.IsAddOnLoaded("ElvUI") == true then return end
	-- if C_AddOns.IsAddOnLoaded("NDui") == true then return end
	if C_AddOns.IsAddOnLoaded("Dominos") == true then return end
	if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end

	-- if DToolsDB.acu == nil or DToolsDB.acu == false then return end
	if DToolsDB.acp ~= true then return end


	if InCombatLockdown() then return end
	--------------------
	-- 设置在最下面 --
	--------------------

	local cfg = ns.cfg
	local mediapath = "Interface\\AddOns\\"..AddonName.."\\media\\"
	local Classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass("player"))]
	local flatstyel


	local bbc
	local bntc
	if DToolsDB.acc == nil or DToolsDB.acc == true then
		bbc = { r=0, g=0, b=0, a=1 }--阴影颜色
		bntc = { r=0, g=0, b=0, a=0.8 }	--边框颜色
	else
		bbc = { r=Classcolor.r, g=Classcolor.g, b=Classcolor.b, a=0.5 }--阴影颜色
		bntc = { r=Classcolor.r, g=Classcolor.g, b=Classcolor.b, a=0.25 }--边框颜色
	end

	--动作条超出距离染色+快捷键颜色
	if (ActionButton_UpdateRangeIndicator) then
		hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
			if self.action == nil then
				return
			end
			local isUsable, notEnoughMana = IsUsableAction(self.action)

			-- if ( checksRange and not inRange ) then
			-- 	_G[self:GetName().."Icon"]:SetVertexColor(0.5, 0.1, 0.1)
			-- elseif isUsable ~= true or notEnoughMana == true then
			-- 	_G[self:GetName().."Icon"]:SetVertexColor(0.4, 0.4, 0.4)
			-- else
			-- 	_G[self:GetName().."Icon"]:SetVertexColor(1, 1, 1)
			-- end

			if (checksRange and not inRange) then
				self.icon:SetVertexColor(0.8, 0.1, 0.1)
				self.HotKey:SetVertexColor(1, 0, 0)
			elseif isUsable ~= true and notEnoughMana == true then
				self.icon:SetVertexColor(0.4, 0.4, 1)
				--self.HotKey:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
			elseif isUsable ~= true then
				self.icon:SetVertexColor(0.4, 0.4, 0.4)
				--self.HotKey:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
			else
				self.icon:SetVertexColor(1, 1, 1)
				--self.HotKey:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
			end
			-- for i = 1, NUM_PET_ACTION_SLOTS do
			-- 	local _, _, _, _, _, _, _, petchecksRange, petinRange = GetPetActionInfo(i)
			-- 	local petisUsable, petnotEnoughMana = GetPetActionSlotUsable(i)

			-- 	if (petchecksRange and not petinRange) then
			-- 		_G['PetActionButton' .. i].icon:SetVertexColor(0.8, 0.1, 0.1)
			-- 		--_G['PetActionButton' .. i].icon:SetVertexColor(1, 0, 0)
			-- 	elseif petisUsable ~= true and petnotEnoughMana == true then
			-- 		_G['PetActionButton' .. i].icon:SetVertexColor(0.4, 0.4, 1)
			-- 		--_G['PetActionButton' .. i].HotKey:SetVertexColor(1, 1, 1)
			-- 	elseif petisUsable ~= true then
			-- 		_G['PetActionButton' .. i].icon:SetVertexColor(0.4, 0.4, 0.4)
			-- 		--_G['PetActionButton' .. i].HotKey:SetVertexColor(1, 1, 1)
			-- 	else
			-- 		_G['PetActionButton' .. i].icon:SetVertexColor(1, 1, 1)
			-- 		--_G['PetActionButton' .. i].HotKey:SetVertexColor(1, 1, 1)
			-- 	end
			-- end
		end)
	end
	--]]

	--动作条快捷键简化
	local gsub = string.gsub
	local function UpdateHotkey(self)
		local hotkey = _G[self:GetName() .. "HotKey"]
		local text = hotkey:GetText()
		if not text then
			return
		end

		text = gsub(text, "(s%-)", "S")
		text = gsub(text, "(a%-)", "A")
		text = gsub(text, "(а%-)", "A") --fix ruRU
		text = gsub(text, "(c%-)", "C")
		text = gsub(text, "(Mouse Button )", "M")
		text = gsub(text, KEY_BUTTON3, "M3")
		text = gsub(text, KEY_BUTTON4, "M4")
		text = gsub(text, KEY_BUTTON5, "M5")
		text = gsub(text, KEY_PAGEUP, "PU")
		text = gsub(text, KEY_PAGEDOWN, "PD")
		text = gsub(text, KEY_SPACE, "SpB")
		text = gsub(text, KEY_INSERT, "Ins")
		text = gsub(text, KEY_HOME, "Hm")
		text = gsub(text, KEY_DELETE, "Del")
		text = gsub(text, KEY_NUMPADDECIMAL, "Nu.")
		text = gsub(text, KEY_NUMPADDIVIDE, "Nu/")
		text = gsub(text, KEY_NUMPADMINUS, "Nu-")
		text = gsub(text, KEY_NUMPADMULTIPLY, "Nu*")
		text = gsub(text, KEY_NUMPADPLUS, "Nu+")
		text = gsub(text, KEY_NUMLOCK, "NuL")
		text = gsub(text, KEY_MOUSEWHEELDOWN, "MD")
		text = gsub(text, KEY_MOUSEWHEELUP, "MU")

		if hotkey:GetText() == _G["RANGE_INDICATOR"] then
			hotkey:SetText("")
		else
			hotkey:SetText(text)
		end
	end
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("UPDATE_BINDINGS")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function()
		for i = 1, 12 do
			UpdateHotkey(_G["ActionButton" .. i])
			UpdateHotkey(_G["MultiBarBottomLeftButton" .. i])
			UpdateHotkey(_G["MultiBarBottomRightButton" .. i])
			UpdateHotkey(_G["MultiBarLeftButton" .. i])
			UpdateHotkey(_G["MultiBarRightButton" .. i])
		end
		for i = 1, 10 do
			UpdateHotkey(_G["StanceButton" .. i])
			UpdateHotkey(_G["PetActionButton" .. i])
		end
		--UpdateHotkey(ExtraActionButton1)
	end)
	--]]



--by:paopaojy
local createBackdrop = function(anchor, alpha, border_size, parent)
	local parent_frame = parent or anchor
	local bd_frame = CreateFrame("Frame", nil, parent_frame, "BackdropTemplate")
	local size = border_size or 6
	
	local flvl = parent_frame:GetFrameLevel()
	if flvl - 1 >= 0 then bd_frame:SetFrameLevel(flvl-1) end

	bd_frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -size, size)
	bd_frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", size, -size)
	bd_frame:SetBackdrop({
		edgeFile = mediapath.."button_backdropBorder",
		edgeSize = size+1,
		bgFile = mediapath.."button_backdrop",
		insets = {left = size, right = size, top = size, bottom = size}
	})
	
	bd_frame:SetBackdropColor(.1, .1, .1, alpha or 0)
	bd_frame:SetBackdropBorderColor(bbc.r, bbc.g, bbc.b, bbc.a)

	return bd_frame
end

-- 动作条
local function styleActionButton(bu)
	if not bu then return end
	
	if not bu.rabs_styled then

		bu.icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
		bu.icon:SetAllPoints(bu)
		bu.icon:SetPoint("TOPLEFT", 1, -1)
		bu.icon:SetPoint("BOTTOMRIGHT", -1, 1)

		if bu.HotKey then
			bu.HotKey:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
			bu.HotKey:SetVertexColor(0.8, 0.8, 0.8, 1)
			bu.HotKey:ClearAllPoints()
			bu.HotKey:SetJustifyH("RIGHT")
			bu.HotKey:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, 1)
			bu.HotKey:SetPoint("TOPRIGHT", bu, "TOPRIGHT", 4, 1)
		end

		if bu.Name then
			bu.Name:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
			bu.Name:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b)
			bu.Name:ClearAllPoints()
			bu.Name:SetJustifyH("LEFT")
			bu.Name:SetPoint("BOTTOMLEFT", bu, "BOTTOMLEFT", -1, 2)	
			bu.Name:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 2)
		end

		if bu.Count then
			bu.Count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
			bu.Count:SetVertexColor(0, 0.8, 0.8)
			bu.Count:ClearAllPoints()
			bu.Count:SetJustifyH("RIGHT")
			bu.Count:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, 0.5)
		end
						
		if bu.cooldown then
			bu.cooldown:SetAllPoints(bu)
			-- bu.cooldown:SetPoint("TOPLEFT", 2, -2)
			-- bu.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
		end
		
		-- 额外动作条的材质
		if bu.style then
			bu.style:SetAlpha(0)
		end
		
		if bu.IconMask then
			bu.IconMask:Hide()
		end
		
		-- if bu.Border then
		-- 	bu.Border:SetTexture(mediapath.."button_border")
		-- end
		
		if bu.SlotArt then -- 动作条的背景
			bu.SlotArt:SetTexture(nil)
		end
		
		if bu.SlotBackground then -- 动作条的背景
			bu.SlotBackground:SetTexture(nil)
		end
		
		bu.bg = createBackdrop(bu, .7, 5)
		if bu:GetFrameLevel() > 0 then
			bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		end
					
		-- local highlight = bu:GetHighlightTexture()
		-- if highlight then
		-- 	bu:SetHighlightTexture(mediapath.."button_highlight")
		-- 	highlight:SetAllPoints(bu)
		-- 	-- highlight:SetPoint("TOPLEFT", 2, -2)
		-- 	-- highlight:SetPoint("BOTTOMRIGHT", -2, 2)
		-- end

		-- local check = bu:GetCheckedTexture()
		-- if check then
		-- 	bu:SetCheckedTexture(mediapath.."button_border")
		-- 	check:SetVertexColor(1,1,1,0.8)
		-- 	check:SetAllPoints(bu)
		-- 	check:SetPoint("TOPLEFT", -1, 1)
		-- 	check:SetPoint("BOTTOMRIGHT", 1, -1)
		-- end
		
		-- if bu.SetShowGrid then
		-- 	hooksecurefunc(bu, "SetShowGrid", function(self, showGrid, reason)			
		-- 		if not InCombatLockdown() and self:GetShowGrid() ~= showGrid then
		-- 			local showGridAttribute = self:GetAttribute("showgrid")
		-- 			if ( showGrid ) then
		-- 				self:SetAttribute("showgrid", bit.bor(showGridAttribute or 0, reason))
		-- 			else
		-- 				self:SetAttribute("showgrid", bit.band(showGridAttribute or 0, bit.bnot(reason)))
		-- 			end
		-- 		end
		-- 	end)
		-- end
		
		bu.rabs_styled = true
	end
	
	local pushed = bu:GetPushedTexture()
	if pushed then
		bu:SetPushedTexture(mediapath.."button_pushed")
		pushed:SetVertexColor(1,1,0)
		pushed:SetAllPoints(bu)
		-- pushed:SetPoint("TOPLEFT", 2, -2)
		-- pushed:SetPoint("BOTTOMRIGHT", -2, 2)
	end		

	local normal = bu:GetNormalTexture()
	if normal then
		bu:SetNormalTexture(mediapath.."button_normal")
		normal:SetVertexColor(bntc.r, bntc.g, bntc.b, bntc.a)
		normal:SetAllPoints(bu)
		normal:SetPoint("TOPLEFT", 1, -1)
		normal:SetPoint("BOTTOMRIGHT", -1, 1)
	end
end
--====================================================--
--[[                  -- Init --                    ]]--
--====================================================--
local function UpdateActionbars()
	for i = 1, 12 do
		local bu = _G["ActionButton"..i]
		hooksecurefunc(bu, "UpdateButtonArt", function(self)
			styleActionButton(bu)
		end)
	end
	
	-- 动作条(8)1-12,OverrideActionBar1~6,ExtraActionButton1,MultiCastActionButton1-12	
	for i, bu in pairs(ActionBarButtonEventsFrame.frames) do
		styleActionButton(bu)
	end
	
	-- 宠物动作条
	for i, bu in pairs(PetActionBar.actionButtons) do
		styleActionButton(bu)
	end
	
	-- 心控动作条
	for i, bu in pairs(PossessActionBar.actionButtons) do
		styleActionButton(bu)
	end
	
	-- 姿态条
	for i, bu in pairs(StanceBar.actionButtons) do
		styleActionButton(bu)
	end

	if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
		styleActionButton(ExtraActionButton1)
	end
	-- -- 弹出的动作条按钮
	-- SpellFlyout.Background.End:SetTexture(nil)
	-- SpellFlyout.Background.HorizontalMiddle:SetTexture(nil)
	-- SpellFlyout.Background.VerticalMiddle:SetTexture(nil)
	
	-- SpellFlyout:HookScript("OnShow", function(self)
	-- 	local i = 1
	-- 	while _G["SpellFlyoutButton"..i] do
	-- 		local bu = _G["SpellFlyoutButton"..i]
	-- 		styleActionButton(bu)
	-- 		i = i + 1
	-- 	end
	-- end)
end
UpdateActionbars()


end)