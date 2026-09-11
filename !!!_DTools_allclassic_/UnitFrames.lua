local _
local AddonName, ns =...

--职业副资源位置
local PSRF = CreateFrame("Button","SecondaryResFrame",UIParent)
PSRF:SetFrameStrata("LOW")
PSRF:SetSize(200,80)
PSRF:SetPoint("CENTER", UIParent, "BOTTOM", 0, 270)
PSRF:EnableMouse(false)

ns.event("PLAYER_LOGIN", function()

    local hptexture
    if DToolsDB.bart == 1 then
        hptexture = "Interface\\AddOns\\"..AddonName.."\\media\\Raid-Bar-Hp-Fill"
    elseif DToolsDB.bart == 2 then
        hptexture = "Interface\\AddOns\\"..AddonName.."\\media\\Raid-Bar-Hp-ad"
    elseif DToolsDB.bart == 3 then
        hptexture = "Interface\\AddOns\\"..AddonName.."\\media\\statusbar5"
    else
        hptexture = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status"
    end
	--------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------单位框体-------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	-- 单位框体
    if DToolsDB.unu == true then
		-- if C_AddOns.IsAddOnLoaded("ElvUI") == true then return end
		-- if C_AddOns.IsAddOnLoaded("NDui") == true then return end
		-- if C_AddOns.IsAddOnLoaded("alaUnitFrame") == true then return end
		-- if C_AddOns.IsAddOnLoaded("TUnitFrame") == true then return end
		if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end

        -- 职业资源框统一锚点
        if RuneFrame and RuneFrame:IsShown() then
            PSRF:EnableMouse(true)
            -- RuneFrame:HookScript("OnUpdate",function(self)
                _G["RuneFrame"]:ClearAllPoints()
                _G["RuneFrame"]:SetParent(PSRF)
                _G["RuneFrame"]:SetPoint("CENTER", PSRF, "CENTER", -21, 0)
                _G["RuneFrame"]:SetScale(1.5)
            -- end)
        end

		-- TargetFrameToT:ClearAllPoints()
		-- TargetFrameToT:SetPoint("RIGHT", TargetFrame, "BOTTOMRIGHT", -18, 8)

		-- FocusFrameToT:ClearAllPoints()
		-- FocusFrameToT:SetPoint("RIGHT", FocusFrame, "BOTTOMRIGHT", -18, 8)

        --目标仇恨位置
        TargetFrameNumericalThreat:ClearAllPoints()
        TargetFrameNumericalThreat:SetScale(0.51)
        TargetFrameNumericalThreat:SetFrameStrata("HIGH")
        TargetFrameNumericalThreat:SetPoint("BOTTOM", TargetFrameHealthBar, "BOTTOM", 0, 2)
        FocusFrameNumericalThreat:ClearAllPoints()
        FocusFrameNumericalThreat:SetScale(0.51)
        FocusFrameNumericalThreat:SetFrameStrata("HIGH")
        FocusFrameNumericalThreat:SetPoint("BOTTOM", FocusFrameHealthBar, "BOTTOM", 0, 2)
        Boss1TargetFrameNumericalThreat:ClearAllPoints()
        Boss1TargetFrameNumericalThreat:SetScale(0.51)
        Boss1TargetFrameNumericalThreat:SetFrameStrata("HIGH")
        Boss1TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss1TargetFrameHealthBar, "BOTTOM", 0, 2)
        Boss2TargetFrameNumericalThreat:ClearAllPoints()
        Boss2TargetFrameNumericalThreat:SetScale(0.51)
        Boss2TargetFrameNumericalThreat:SetFrameStrata("HIGH")
        Boss2TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss2TargetFrameHealthBar, "BOTTOM", 0, 2)
        Boss3TargetFrameNumericalThreat:ClearAllPoints()
        Boss3TargetFrameNumericalThreat:SetScale(0.51)
        Boss3TargetFrameNumericalThreat:SetFrameStrata("HIGH")
        Boss3TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss3TargetFrameHealthBar, "BOTTOM", 0, 2)
        Boss4TargetFrameNumericalThreat:ClearAllPoints()
        Boss4TargetFrameNumericalThreat:SetScale(0.51)
        Boss4TargetFrameNumericalThreat:SetFrameStrata("HIGH")
        Boss4TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss4TargetFrameHealthBar, "BOTTOM", 0, 2)
        Boss5TargetFrameNumericalThreat:ClearAllPoints()
        Boss5TargetFrameNumericalThreat:SetScale(0.51)
        Boss5TargetFrameNumericalThreat:SetFrameStrata("HIGH")
        Boss5TargetFrameNumericalThreat:SetPoint("BOTTOM", Boss5TargetFrameHealthBar, "BOTTOM", 0, 2)

        -- 头像材质：【修复版】PlayerFrame美化函数
        local function UnitFramesImproved_Style_PlayerFrame()
            -- 修复：延迟判断载具UI，强制应用美化
            C_Timer.After(0.1, function()
                if not UnitHasVehicleUI("player") then
                    if DToolsDB.unft == true then
                        PlayerFrameTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame-Elite")
                    else
                        PlayerFrameTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame")
                    end
                    PlayerStatusTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-Player-Status")

                    PlayerFrameGroupIndicator:SetFrameStrata("HIGH")
                    PlayerFrameGroupIndicator:ClearAllPoints()
                    -- PlayerFrameGroupIndicator:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", -2, 2)
                    PlayerFrameGroupIndicatorText:SetTextColor(1, 1, 1, 1)
                    PlayerFrameGroupIndicatorText:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
                    PlayerFrameGroupIndicatorText:SetScale(1)
                    PlayerFrameGroupIndicatorText:ClearAllPoints()
                    PlayerFrameGroupIndicatorText:SetPoint("BOTTOM", PlayerFrame, "TOP", -57, -14)

                    PlayerName:SetPoint("BOTTOM", PlayerFrameHealthBar, "TOP", 0, 3)
                    PlayerName:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
                    if DToolsDB.unfn == true then
                        PlayerName:SetAlpha(0)
                    else
                        PlayerName:SetAlpha(1)
                    end
                    PlayerLevelText:SetFont(STANDARD_TEXT_FONT, 13, "THINOUTLINE")

                    -- 修复：血条强制重置，防止被覆盖
                    PlayerFrameHealthBar:ClearAllPoints()
                    PlayerFrameHealthBar:SetPoint("TOPLEFT", 90, -27)
                    PlayerFrameHealthBar:SetHeight(29)

                    PlayerFrameHealthBarText:ClearAllPoints()
                    PlayerFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
                    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", -1, 1)
                    PlayerFrameHealthBarTextLeft:ClearAllPoints()
                    PlayerFrameHealthBarTextLeft:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
                    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 3, 1)
                    PlayerFrameHealthBarTextRight:ClearAllPoints()
                    PlayerFrameHealthBarTextRight:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
                    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -3, 1)
                    
                    PlayerFrameManaBarText:ClearAllPoints()
                    PlayerFrameManaBarText:SetFont(STANDARD_TEXT_FONT,11, "OUTLINE")
                    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 1)
                    PlayerFrameManaBarTextLeft:ClearAllPoints()
                    PlayerFrameManaBarTextLeft:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 3, 1)
                    PlayerFrameManaBarTextRight:ClearAllPoints()
                    PlayerFrameManaBarTextRight:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -3, 1)

                    PlayerFrameHealthBar:SetStatusBarTexture(hptexture)
                    -- PlayerFrameManaBar:SetStatusBarTexture(hptexture)
                else
                    PlayerFrameHealthBar:SetHeight(12)
                end
            end)
        end

        -- 宠物框体（不变）
        local function UnitFramesImproved_Style_PetFrame(self)
            self.name:SetJustifyH("CENTER")
            self.name:ClearAllPoints()
            self.name:SetPoint("CENTER", 16, 11)
            self.name:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")

            self.healthbar.TextString:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
            self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0.5)
            self.healthbar.LeftText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
            self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", -1, 0.5)
            self.healthbar.RightText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
            self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", 0, 0.5)

            self.manabar.TextString:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
            self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, -1.5)
            self.manabar.LeftText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
            self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", -1, -1.5)
            self.manabar.RightText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
            self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", 0, -1.5)

            self.healthbar:SetStatusBarTexture(hptexture)
            self.manabar:SetStatusBarTexture(hptexture)
        end

        TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "THINOUTLINE")
        FocusFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 13, "THINOUTLINE")

        -- 目标框体（不变）
        local function UnitFramesImproved_Style_TargetFrame(self)
            self.nameBackground:Hide()
            self.healthbar:SetHeight(29)
            self.healthbar:SetPoint("TOPLEFT", 24, -27)
            self.Background:SetHeight(29)
            self.Background:SetPoint("TOPLEFT", 23, -27)
            self.Background:SetPoint("BOTTOMRIGHT", 24, 31)
            self.name:ClearAllPoints()
            self.name:SetPoint("BOTTOM", self.healthbar, "TOP", 0, 3)
            self.name:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
            self.deadText:SetPoint("CENTER",self.healthbar,"CENTER", 0, 1)
            self.deadText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            self.healthbar.TextString:ClearAllPoints()
            self.healthbar.TextString:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 1)
            self.healthbar.LeftText:ClearAllPoints()
            self.healthbar.LeftText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 2, 1)
            self.healthbar.RightText:ClearAllPoints()
            self.healthbar.RightText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -3, 1)
			self.manabar.TextString:ClearAllPoints()
            self.manabar.TextString:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 1)
            self.manabar.LeftText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 5, 1)
            self.manabar.RightText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -3, 1)

            self.healthbar:SetStatusBarTexture(hptexture)
            -- self.manabar:SetStatusBarTexture(hptexture)
        end

        local function UnitFramesImproved_Style_TargetOfTargetFrame(self)
            self.name:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            self.deadText:ClearAllPoints()
            self.deadText:SetPoint("CENTER", 10, 0)
            self.deadText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

            self.healthbar:SetStatusBarTexture(hptexture)
            self.manabar:SetStatusBarTexture(hptexture)
        end

        local function UnitFramesImproved_BossTargetFrame_Style(self)
            UnitFramesImproved_Style_TargetFrame(self)
        end

        local function UnitFramesImproved_TargetFrame_CheckFaction(self)
            UnitFramesImproved_Style_TargetFrame(self)
        end

		hooksecurefunc("PlayerFrame_UpdateArt", UnitFramesImproved_Style_PlayerFrame)
		hooksecurefunc("PlayerFrame_SequenceFinished", UnitFramesImproved_Style_PlayerFrame)
		hooksecurefunc("PlayerFrame_UpdateStatus", UnitFramesImproved_Style_PlayerFrame)
		hooksecurefunc("PlayerFrame_ToPlayerArt", UnitFramesImproved_Style_PlayerFrame)
		hooksecurefunc("PlayerFrame_ToVehicleArt", UnitFramesImproved_Style_PlayerFrame)

		hooksecurefunc(TargetFrame, "CheckClassification", UnitFramesImproved_TargetFrame_CheckFaction)
		-- hooksecurefunc(TargetFrame, "CheckFaction", UnitFramesImproved_TargetFrame_CheckFaction)
		hooksecurefunc(FocusFrame, "CheckClassification", UnitFramesImproved_TargetFrame_CheckFaction)

        local function EnableUnitFramesImproved()
            UnitFramesImproved_Style_PlayerFrame()
            UnitFramesImproved_Style_PetFrame(PetFrame)
            UnitFramesImproved_Style_TargetFrame(TargetFrame)
            UnitFramesImproved_Style_TargetFrame(FocusFrame)
            UnitFramesImproved_Style_TargetOfTargetFrame(TargetFrameToT)
            UnitFramesImproved_Style_TargetOfTargetFrame(FocusFrameToT)
            UnitFramesImproved_BossTargetFrame_Style(Boss1TargetFrame)
            UnitFramesImproved_BossTargetFrame_Style(Boss2TargetFrame)
            UnitFramesImproved_BossTargetFrame_Style(Boss3TargetFrame)
            UnitFramesImproved_BossTargetFrame_Style(Boss4TargetFrame)
            UnitFramesImproved_BossTargetFrame_Style(Boss5TargetFrame)
        end
		
		EnableUnitFramesImproved()

        local pfEvent = CreateFrame("Frame")
        pfEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
        pfEvent:RegisterEvent("PLAYER_LOGIN")
        pfEvent:RegisterEvent("UNIT_ENTERED_VEHICLE")
        pfEvent:RegisterEvent("UNIT_EXITED_VEHICLE")
        pfEvent:RegisterEvent("PLAYER_DEAD")
        pfEvent:RegisterEvent("PLAYER_ALIVE")
        pfEvent:RegisterEvent("PLAYER_UNGHOST")
        pfEvent:SetScript("OnEvent", function(self, event)
			C_Timer.After(0.2, function()
				UnitFramesImproved_Style_PlayerFrame()
				UnitFramesImproved_Style_PetFrame(PetFrame)
				UnitFramesImproved_Style_TargetFrame(FocusFrame)
				UnitFramesImproved_Style_TargetOfTargetFrame(FocusFrameToT)
			end)
        end)

        -- 职业染色（不变）
        local color = true
        local function colors(self, unit)
            if unit and unit == self.unit then
                if UnitIsPlayer(unit) then
                    local _, class = UnitClass(unit)
                    color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
                elseif UnitReaction(unit, "player") then
                    color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                end
                if not UnitIsConnected(unit) then
                    self:SetStatusBarColor(0.5, 0.5, 0.5)
                else
                    if color then
                        self:SetStatusBarColor(color.r, color.g, color.b)
                    end
                end
            end
        end

        hooksecurefunc("UnitFrameHealthBar_Update", colors)
        hooksecurefunc("HealthBar_OnValueChanged", function(self)
            colors(self, self.unit)
        end)
        hooksecurefunc("UnitFrame_Update", function(self)
            if UnitClass(self.unit) then
                local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(self.unit))]
                self.name:SetTextColor(c.r, c.g, c.b, 1)
            end
        end)

        -- 目标框体材质（不变）
        local function UnitFramesImproved_TargetFrame_CheckClassification(self, forceNormalTexture)
            local classification = UnitClassification(self.unit)
            if forceNormalTexture then
                self.borderTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame")
            elseif classification == "minus" then
                self.borderTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame")
            elseif classification == "worldboss" or classification == "elite" then
                self.borderTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame-Elite")
            elseif classification == "rareelite" then
                self.borderTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame-Rare-Elite")
            elseif classification == "rare" then
                self.borderTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame-Rare")
            else
                self.borderTexture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame")
            end
            if classification == "minus" then
                self.threatIndicator:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame-Minus-Flash")
            else
                self.threatIndicator:SetTexture("Interface\\Addons\\" .. AddonName .. "\\media\\UI-TargetingFrame-Flash")
            end
            self.nameBackground:Hide()
        end

		hooksecurefunc(TargetFrame,"CheckClassification", UnitFramesImproved_TargetFrame_CheckClassification)
		hooksecurefunc(FocusFrame,"CheckClassification", UnitFramesImproved_TargetFrame_CheckClassification)
		-- hooksecurefunc(TargetFrame,"Update", UnitFramesImproved_TargetFrame_CheckClassification)
		-- hooksecurefunc(FocusFrame,"Update", UnitFramesImproved_TargetFrame_CheckClassification)
		
        -- 目标职业图标（不变）
        local targeticon = CreateFrame("Button", "TargetClass", TargetFrame)
        targeticon:Hide()
        targeticon:SetFrameStrata("HIGH")
        targeticon:SetWidth(32)
        targeticon:SetHeight(32)
        targeticon:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 135, 0)
        targeticon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        
        local bg = targeticon:CreateTexture("TargetClassBackground", "BACKGROUND")
        bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
        bg:SetWidth(20)
        bg:SetHeight(20)
        bg:SetPoint("CENTER")
        bg:SetVertexColor(0, 0, 0, 0.7)
        
        local icon = targeticon:CreateTexture("TargetClassIcon", "ARTWORK")
        icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
        icon:SetWidth(20)
        icon:SetHeight(20)
        icon:SetPoint("CENTER")
        
        local lay = targeticon:CreateTexture("TargetClassBorder", "OVERLAY")
        lay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        lay:SetWidth(54)
        lay:SetHeight(54)
        lay:SetPoint("CENTER", 11, -12)
        
        RaiseFrameLevel(targeticon)
        
        targeticon:SetScript("OnUpdate", function(self)
            if not UnitCanAttack("player", "target") and UnitIsPlayer("target") then
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
            if not UnitCanAttack("player", "target") and UnitIsPlayer("target") then
                if button == "LeftButton" then
                    havedown = TargetClassIconDown()
                    InspectUnit("target")
                elseif button == "RightButton" then
                    if CheckInteractDistance("target", 2) then
                        havedown = TargetClassIconDown()
                        InitiateTrade("target")
                    end
                elseif button == "MiddleButton" then
                    havedown = TargetClassIconDown()
                    local name, server = UnitName("target")
                    local fullname = name
                    if server and UnitRealmRelationship("target") ~= LE_REALM_RELATION_SAME then
                        fullname = name .. "-" .. server
                    end
                    ChatFrame_SendTell(fullname)
                elseif button == "Button4" then
                    if CheckInteractDistance("target", 4) then
                        havedown = TargetClassIconDown()
                        FollowUnit("target")
                    end
                else
                    if CheckInteractDistance("target", 1) then
                        havedown = TargetClassIconDown()
                        InspectAchievements("target")
                    end
                end
            end
        end)
        
        local function TargetClassIconUp()
            local point, relativeTo, relativePoint, offsetX, offsetY = TargetClassIcon:GetPoint()
            TargetClassIcon:SetPoint(point, relativeTo, relativePoint, offsetX - 1, offsetY + 1)
            return false
        end
        
        targeticon:SetScript("OnMouseUp", function(self)
            if havedown then
                havedown = TargetClassIconUp()
            end
        end)
        
        hooksecurefunc("UnitFrame_Update", function()
            if UnitIsPlayer("target") then
                local coord = CLASS_ICON_TCOORDS[select(2, UnitClass("target"))]
                TargetClassIcon:SetTexCoord(unpack(coord))
                targeticon:Show()
            else
                targeticon:Hide()
            end
        end)

		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
			--蓝条/能量闪光
			if select(2, UnitClass('player')) == 'WARRIOR' then return end
			local PowerSparkDB = {
				default = {
					name = 'PowerSparkFrameManaBar',
					parent = PlayerFrameManaBar
				},
				druid = {
					name = 'PowerSparkFrameDruidManaBar',
					parent = DruidBarFrame,
					enable = select(2, UnitClass('player')) == 'DRUID' and DruidBarFrame and DruidBarKey
				}
			}
			local PowerSparkFrame = CreateFrame('Frame')
			PowerSparkFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
			PowerSparkFrame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'player')
			PowerSparkFrame:SetScript('OnEvent', function(self, event)
				if event == 'PLAYER_ENTERING_WORLD' then
					local last
					if select(1, UnitPowerType('player')) == 3 then
						last = UnitPower('player')
					else
						last = UnitPower('player', 0)
					end
					PowerSparkFrame:init(PowerSparkDB.default, last)
					if PowerSparkDB.druid.enable then
						PowerSparkFrame:init(PowerSparkDB.druid, DruidBarKey.currentmana)
					end
				end
				if event == 'UNIT_POWER_UPDATE' then
					local powerType = select(1, UnitPowerType('player'))
					if powerType == 3 then
						PowerSparkFrame:energy(PowerSparkDB.default)
					elseif powerType == 0 then
						if not ChannelInfo() then
							PowerSparkFrame:mana(PowerSparkDB.default, UnitPower('player', 0))
						end
					end
					if PowerSparkDB.druid.enable and not ChannelInfo() then
						PowerSparkFrame:mana(PowerSparkDB.druid, DruidBarKey.currentmana)
					end
				end
			end)

			PowerSparkFrame:SetScript('OnUpdate', function()
				PowerSparkFrame:flash(PowerSparkDB.default)
				if PowerSparkDB.druid.enable then
					PowerSparkFrame:flash(PowerSparkDB.druid)
				end
			end)

			function PowerSparkFrame:init(power, last)
				if power.bar then return end
				power.bar = CreateFrame('Statusbar', power.name, power.parent)
				power.bar:SetWidth(PlayerFrameManaBar:GetWidth() - 2)
				power.bar:SetHeight(power.parent:GetHeight() - 2)
				power.bar:SetPoint('CENTER')
				power.spark = power.bar:CreateTexture(nil, 'OVERLAY')
				power.spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
				power.spark:SetWidth(32)
				power.spark:SetHeight(32)
				power.spark:SetBlendMode('ADD')
				power.spark:SetAlpha(0)
				power.timer = power.timer or GetTime()
				power.interval = power.interval or 2
				power.last = last

				if power.bar2 then return end
				power.bar2 = CreateFrame('Statusbar', power.name, power.parent)
				power.bar2:SetWidth(PlayerCastingBarFrame:GetWidth() - 36)
				power.bar2:SetHeight(4)
				power.bar2:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
				power.bar2:SetPoint("TOP", PlayerCastingBarFrame, "BOTTOM", 0, -4)
				power.bar2:SetStatusBarColor(1, 1, 1, 0.25)
				power.spark2 = power.bar2:CreateTexture(nil, 'OVERLAY')
				power.spark2:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
				power.spark2:SetWidth(16)
				power.spark2:SetHeight(16)
				power.spark2:SetBlendMode('ADD')
				power.spark2:SetAlpha(0)
			end

			function PowerSparkFrame:energy(power)
				if UnitPower('player') > power.last and UnitPower('player') <= power.last + 20 then
					power.timer = GetTime()
					power.interval = 2
				end
				power.last = UnitPower('player')
			end

			function PowerSparkFrame:mana(power, mp)
				if mp < power.last then
					power.timer = GetTime()
					power.interval = 5
				elseif GetTime() >= power.timer + power.interval then
					power.timer = GetTime()
					power.interval = 2
				end
				power.last = mp
			end

			function PowerSparkFrame:flash(power)
				local powerType = select(1, UnitPowerType('player'))
				if UnitIsDeadOrGhost('player') then
					power.bar:Hide()
					power.bar2:Hide()
				elseif powerType == 1 and not power.enable then
					power.bar:Hide()
					power.bar2:Hide()
				elseif powerType == 0 and UnitPower('player', 0) >= UnitPowerMax('player', 0) or power.enable and DruidBarKey.currentmana >= UnitPowerMax('player', 0) then
					power.bar:Hide()
					power.bar2:Hide()
				elseif powerType == 3 and not power.enable and UnitPower('player') >= UnitPowerMax('player') then
					if UnitCanAttack('player', 'target') and not UnitIsDeadOrGhost('target') then
						power.bar:Show()
						power.bar2:Show()
					else
						power.bar:Hide()
						power.bar2:Hide()
					end
				else
					power.bar:Show()
					power.bar2:Show()
				end
				if not power.bar:IsVisible() or not power.bar2:IsVisible() then return end

				if power.interval > 2 then
					if power.timer + power.interval > GetTime() then
						power.spark:SetAlpha(.75)
						power.spark2:SetAlpha(.75)
						local perc = (GetTime() - power.timer) / power.interval
						power.spark:SetPoint('CENTER', power.bar, 'LEFT', power.bar:GetWidth() * (1-perc), 0)
						power.spark2:SetPoint('CENTER', power.bar2, 'LEFT', power.bar2:GetWidth() * (1-perc), 0)
					else
						power.spark:SetAlpha(0)
						power.spark2:SetAlpha(0)
					end
				else
					power.spark:SetAlpha(.5)
					power.spark2:SetAlpha(.5)
					local perc = (GetTime() - power.timer) % power.interval / power.interval
					power.spark:SetPoint('CENTER', power.bar, 'LEFT', power.bar:GetWidth() * perc, 0)
					power.spark2:SetPoint('CENTER', power.bar2, 'LEFT', power.bar2:GetWidth() * perc, 0)
				end
			end
		end

    end


	--------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------团队框架-------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------

	--团队框架美化
	if DToolsDB.ruu == true then
		if C_AddOns.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
			-- if InCombatLockdown() then return end
			--姓名文本美化--
			local function PurgeKey(t, k)
				t[k] = nil
				local c = 42
				repeat
					if t[c] == nil then
						t[c] = nil
					end
					c = c + 1
				until issecurevariable(t, k)
			end
			if CompactUnitFrame_SetName then
				PurgeKey(CompactUnitFrame_SetName, "updateNameUsesGetUnitName")
			end

			hooksecurefunc("CompactUnitFrame_UpdateName", function(f)
				if not f or not f.name or f:IsForbidden() then return end
				local fname = f.name and f:GetName()
				local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
				if not namematch then return end

                if f.name.hasStyled then return end
                f.name:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
                f.name.hasStyled = true
			end)

			--血量数字--
			hooksecurefunc("CompactUnitFrame_UpdateStatusText", function(f)
				if not f or not f.statusText then return end
				if f:IsForbidden() then return end
				local fname = f.name and f:GetName()
				local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
				if not namematch then return end

				if not f.fontStyled then
					-- local fontName, fontSize = f.statusText:GetFont()
					-- f.statusText:SetFont(fontName, fontSize, "OUTLINE")
					f.statusText:SetScale(0.9)
					f.statusText:SetTextColor(.8, .8, .8)
					f.statusText:SetShadowColor(0, 0, 0, 0)
					f.fontStyled = true
				end
			end)

			-- 不显示输出职责图标
			hooksecurefunc("CompactUnitFrame_UpdateRoleIcon",function(f)
				if not f or not f.roleIcon or f:IsForbidden() then return end

				-- 获取当前职责
				local role = UnitGroupRolesAssigned(f.unit)

				-- if role == "TANK" then
				-- 	f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\ROLE-N",true)
				-- 	f.roleIcon:SetTexCoord(.04,.25,.35,.61)
				-- elseif role == "HEALER" then
				-- 	f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\ROLE-N",true)
				-- 	f.roleIcon:SetTexCoord(.35,.57,.04,.27)
				-- elseif role == "DAMAGER" then
				-- 	f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\ROLE-TDPS",true)
				-- 	f.roleIcon:SetTexCoord(.34,.63,.34,.66)
				-- end

				-- if role == "TANK" then
				-- 	f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\roles\\MiirGui_TANK",true)
				-- 	f.roleIcon:SetTexCoord(0.12,.88,0,1)
				-- elseif role == "HEALER" then
				-- 	f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\roles\\MiirGui_HEALER",true)
				-- 	f.roleIcon:SetTexCoord(0.05,.95,0,1)
				-- elseif role == "DAMAGER" then
				-- 	f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\roles\\Blizzard3_DAMAGER",true)
				-- 	f.roleIcon:SetTexCoord(0.95,.05,0,1)
				-- end

				if role == "TANK" then
					f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\roles\\Default2_ROLES",true)
					f.roleIcon:SetTexCoord(0.05,.21,.3,.48)
				elseif role == "HEALER" then
					f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\roles\\Default2_ROLES",true)
					f.roleIcon:SetTexCoord(.315,.47,.04,.205)
				elseif role == "DAMAGER" then
					f.roleIcon:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\roles\\Default2_ROLES",true)
					f.roleIcon:SetTexCoord(.47,.31,.29,.47)
				end



				-- 记录 shouldShowRole（保留你原来的逻辑）
				f.roleIcon.shouldShowRole = (f.roleIcon.shouldShowRole == nil and f.roleIcon:IsShown()) or f.roleIcon.shouldShowRole

				-- 显示隐藏逻辑（和你原版完全一致）
				if f.roleIcon.shouldShowRole then
					if role == "TANK" or role == "HEALER" then
						f.roleIcon:SetAlpha(1)
						f.roleIcon:SetSize(16,16)
                    else
                        f.roleIcon:SetAlpha(0)
						f.roleIcon:SetSize(0.1,16)
					end
				end
			end)

            hooksecurefunc("CompactUnitFrame_UpdateHealth", function(f)
                if not f or not f.unit or not f.healthBar or f:IsForbidden() then return end
                
                local fname = f.name and f:GetName()
                local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
                if not namematch then return end
				local role = UnitGroupRolesAssigned(f.unit);
				local rfdp = tonumber(GetCVar("raidFramesDisplayPowerBars"))
				local rfdop = tonumber(GetCVar("raidFramesDisplayOnlyHealerPowerBars"))
				if (role == "HEALER" and rfdp == 1 and rfdop == 1) or (rfdp == 1 and rfdop == 0) then
					f.healthBar:SetPoint("TOPLEFT", f, "TOPLEFT", 0.5, -0.3);
					f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -0.5, 8);
					f.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER");
					f.powerBar:SetPoint("TOPLEFT", f.healthBar, "BOTTOMLEFT", 0, -1);
					f.powerBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -0.5, 1);
				else
					f.healthBar:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1);
					f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1.5, 1);
				end
				f.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER");
				-- f.background:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\normal")
				-- f.background:SetTexture(130937)--背景材质
				f.background:SetColorTexture(0,0,0,.8)--背景颜色
				f.background:SetPoint("TOPLEFT", f, "TOPLEFT", 0.5, 0);
				f.background:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -0.5, 0.5);


				if f.healthBar.hasSetCustomTexture then return end -- 只设置一次

				if DToolsDB.bart ~= 0 then f.healthBar:GetStatusBarTexture():SetTexture(hptexture) end
				-- f.powerBar:GetStatusBarTexture():SetTexture(hptexture1)

				f.healthBar.hasSetCustomTexture = true

            end)

            hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
                if not frame or not frame.unit or not frame.healthBar or frame:IsForbidden() then return end
                
                local fname = frame.name and frame:GetName()
                local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
                if not namematch then return end

                local unitIsConnected = UnitIsConnected(frame.unit);
                local unitIsDead = unitIsConnected and UnitIsDead(frame.unit);
                local Classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(frame.unit))]

                if not unitIsConnected then
                    frame.healthBar:SetStatusBarColor(.5, .5, .5)
                elseif unitIsDead then 
                    frame.healthBar:SetStatusBarColor(.1, .1, .1)
                elseif ((frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit)) and Classcolor and frame.optionTable.useClassColors) then
                    frame.healthBar:SetStatusBarColor(Classcolor.r, Classcolor.g, Classcolor.b)
                end

            end)


            -- --法力条
			-- hooksecurefunc('CompactUnitFrame_UpdatePower', function (f)
            --     if not f or not f.powerBar or f:IsForbidden() then return end
            --     if f.powerBar.hasStyled then return end
			-- 	local fname = f.name and f:GetName()
			-- 	local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
			-- 	if not namematch then return end

			-- 	local role = UnitGroupRolesAssigned(f.unit);
			-- 	if role == "HEALER" then
			-- 		-- f.healthBar:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
			-- 		f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 6);
			-- 		--f.powerBar:Show();
			-- 		f.powerBar:SetAlpha(1);
			-- 	else
			-- 		f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 60);
			-- 		f.powerBar:SetAlpha(1);
            --         -- f.healthBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0);
			-- 		f.powerBar:Hide();
			-- 		f.powerBar:SetAlpha(0);	--只显示治疗的法力值
            --     end
            --     f.powerBar.hasStyled = true
			-- end)


			-- --隐藏队伍显示--
			-- hooksecurefunc('CompactRaidGroup_UpdateLayout', function (f)
			-- 	-- if InCombatLockdown() then return end
			-- 	f.title:SetAlpha(0);
			-- end)

			--超距渐隐--
			hooksecurefunc('CompactUnitFrame_UpdateInRange', function (f)
				if not f or not f.optionTable.fadeOutOfRange then return end
				if f:IsForbidden() then return end
				local fname = f.name and f:GetName()
				local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
				if not namematch then return end

				local inRange, checkedRange = UnitInRange(f.displayedUnit);
				if (checkedRange and not inRange) then
					f:SetAlpha(0.35);
				else
					f:SetAlpha(1);
				end
			end)
			--

			-- --美化 buffs and debuffs--
			-- local function CompactUnitFrame_UpdateAurasInternal(f)
			-- 	if not f or not f.buffFrames then return end
			-- 	if f:IsForbidden() then return end
			-- 	local fname = f.name and f:GetName()
			-- 	local namematch = (fname and fname:match("^CompactRaidGroup%d")) or(fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))
			-- 	if not namematch then return end

			-- 	local role = UnitGroupRolesAssigned(f.unit);
			-- 	--f.buffFrames[1]:ClearAllPoints();
			-- 	if role == "HEALER" then
			-- 	f.buffFrames[1]:SetPoint("BOTTOMRIGHT", f.healthBar, "BOTTOMRIGHT", -1.5, 1);
			-- 	else
			-- 	f.buffFrames[1]:SetPoint("BOTTOMRIGHT", f.healthBar, "BOTTOMRIGHT", -1.5, 1);
			-- 	end

			-- 	for i=1, #f.buffFrames do
			-- 	if (i > 1) then
			-- 	--f.buffFrames[i]:ClearAllPoints();
			-- 	f.buffFrames[i]:SetPoint("BOTTOMRIGHT", f.buffFrames[i-1], "BOTTOMLEFT", 0, 0);
			-- 	end
			-- 	f.buffFrames[i]:SetScale(1.22);
			-- 	f.buffFrames[i].icon:SetTexCoord(0.03, 0.97, 0.03, 0.97);
			-- 	end

			-- 	--f.debuffFrames[1]:ClearAllPoints();
			-- 	if role == "HEALER" then
			-- 		f.debuffFrames[1]:SetPoint("BOTTOMLEFT", f.healthBar, "BOTTOMLEFT", 1, 2);
			-- 		else
			-- 		f.debuffFrames[1]:SetPoint("BOTTOMLEFT", f.healthBar, "BOTTOMLEFT", 1, 2);
			-- 		end			for i=1, #f.debuffFrames do
			-- 	if (i > 1) then
			-- 	f.debuffFrames[i]:ClearAllPoints();
			-- 	f.debuffFrames[i]:SetPoint("BOTTOMLEFT", f.debuffFrames[i-1], "BOTTOMRIGHT", 0, 0);
			-- 	end
			-- 	f.debuffFrames[i]:SetScale(1.2);
			-- 	f.debuffFrames[i].icon:SetTexCoord(0.03, 0.97, 0.03, 0.97);

			-- 	end
			-- end
			-- -- hooksecurefunc('CompactUnitFrame_UpdateAuras', CompactUnitFrame_UpdateAurasInternal)

		end
	end
	--]]

	--------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------姓名板---------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------


	--姓名板
	if DToolsDB.npu == true then

		-- 字体描边
		SystemFont_NamePlate_Outlined:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE SLUG")
		SystemFont_NamePlate:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE SLUG")

		-- 设置修改
		-- if not DToolsDB.npucav then
			-- if tonumber(GetCVar("nameplateSize")) < 4 then
			-- 	C_CVar.SetCVar("nameplateSize", 4)
			-- end
			-- C_CVar.SetCVar("nameplateStyle", 5)
			-- C_CVar.SetCVar("nameplateAuraScale", 0.7)
			C_CVar.SetCVar("nameplateMinAlpha", 0.95)
			C_CVar.SetCVar("nameplateMaxScale", 1.1)
			C_CVar.SetCVar("nameplateMinScale", 1)
			C_CVar.SetCVar("nameplateSelectedScale", 1.2)
			C_CVar.SetCVar("nameplateOccludedAlphaMult", 0.75)
			-- C_CVar.SetCVar("nameplateShowFriendlyNpcs", 0)
		-- end

		C_CVar.SetCVar("UnitNameFriendlyPlayerName", 1)
		C_CVar.SetCVar("nameplateShowOnlyNameForFriendlyPlayerUnits", 1)
		C_CVar.SetCVar("nameplateUseClassColorForFriendlyPlayerUnitNames", 1)

		-- 颜色16进制转换
		local function GetHexColorFromRGB(r, g, b)
			return string.format("%02x%02x%02x", r*255, g*255, b*255)
		end

		-- 判断是否是友方玩家
		local function IsFriendlyUnit(unit)
			if not unit then return false end
			if not UnitIsPlayer(unit) then return false end
			-- 检查是否玩家自己
			if UnitIsUnit(unit, "player") then
				return false
			end
			-- 检查是否是友方
			return UnitIsFriend("player", unit) or UnitInParty(unit) or UnitInRaid(unit)
		end

		-- 友方玩家姓名板只显示名字,隐藏服务器名字
		local function PurgeKey(t, k)
			t[k] = nil
			local c = 42
			repeat
				if t[c] == nil then
					t[c] = nil
				end
				c = c + 1
			until issecurevariable(t, k)
		end
		if NamePlateFriendlyFrameOptions then
			PurgeKey(NamePlateFriendlyFrameOptions, "updateNameUsesGetUnitName")
		end

		-- 姓名板大小
		hooksecurefunc(NamePlateUnitFrameMixin,"UpdateAnchors", function(self)
			if Ustyled then return end
			if self:IsForbidden() then return end
			if not self or not self.healthBar then return end
			if DToolsDB.bart ~= 0 then self.healthBar:GetStatusBarTexture():SetTexture(hptexture) end

			local customOptions = self.customOptions;
			local setupOptions = NamePlateSetupOptions;
			local healthBar = self.HealthBarsContainer.healthBar;
			local castbar = self.CastBarsContainer.castBar
			local npsize = CVarCallbackRegistry:GetCVarNumberOrDefault(NamePlateConstants.SIZE_CVAR)
			local npstyle = CVarCallbackRegistry:GetCVarNumberOrDefault(NamePlateConstants.STYLE_CVAR)
			if npstyle == 6 then 
				self.name:SetJustifyH("LEFT")
				PixelUtil.SetPoint(self.name, "LEFT", self.HealthBarsContainer, "LEFT", 4, 0);
				PixelUtil.SetPoint(self.name, "RIGHT", self.HealthBarsContainer, "RIGHT", -4, 0);

				healthBar.LeftText:SetTextHeight(6 + 2*npsize)
				healthBar.RightText:SetTextHeight(6 + 2*npsize)
				healthBar.Text:SetTextHeight(6 + 2*npsize)

				return 
			end
			
			-- if not InCombatLockdown() then
			-- 	if npsize > 3 then
			-- 		C_CVar.SetCVar("nameplateAuraScale", 0.7)
			-- 	else
			-- 		C_CVar.SetCVar("nameplateAuraScale", 0.1 + 1 - (npsize/10))
			-- 	end
			-- end

				
			-- PixelUtil.SetPoint(castbar.ImportantCastIndicator, "TOPLEFT", castbar, "TOPLEFT", -18 - npsize, 3);
			-- PixelUtil.SetPoint(castbar.ImportantCastIndicator, "BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 18 + npsize, -3);

			healthBar.bgTexture:SetAlpha(0.6)
			PixelUtil.SetPoint(healthBar.bgTexture, "TOPLEFT", healthBar, "TOPLEFT", -2, 2);
			PixelUtil.SetPoint(healthBar.bgTexture, "BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 6, -6)

			-- if npsize > 3 then
			-- 	PixelUtil.SetPoint(healthBar.bgTexture, "TOPLEFT", healthBar, "TOPLEFT", -2, 2);
			-- 	PixelUtil.SetPoint(healthBar.bgTexture, "BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 6, -6)

			-- 	-- PixelUtil.SetPoint(healthBar.selectedBorder, "TOPLEFT", healthBar, "TOPLEFT", -3, 3);
			-- 	-- PixelUtil.SetPoint(healthBar.selectedBorder, "BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 3, -3);
			-- else
			-- 	PixelUtil.SetPoint(healthBar.bgTexture, "TOPLEFT", healthBar, "TOPLEFT", -2, 2);
			-- 	PixelUtil.SetPoint(healthBar.bgTexture, "BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 6, -6)

			-- 	-- PixelUtil.SetPoint(healthBar.selectedBorder, "TOPLEFT", healthBar, "TOPLEFT", -3, 3);
			-- 	-- PixelUtil.SetPoint(healthBar.selectedBorder, "BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 3, -3);
			-- end

			if setupOptions.spellNameInsideCastBar == true then
				if npsize > 2 then
					PixelUtil.SetPoint(castbar, "BOTTOMLEFT", self, "BOTTOMLEFT", 20 + 15*npsize, 0);
					PixelUtil.SetPoint(castbar, "BOTTOMRIGHT", self, "BOTTOMRIGHT", -20 - 15*npsize, 0);
				end

				-- if npsize == 4 then
				-- 	PixelUtil.SetPoint(castbar, "BOTTOMLEFT", self, "BOTTOMLEFT", 85, 0);
				-- 	PixelUtil.SetPoint(castbar, "BOTTOMRIGHT", self, "BOTTOMRIGHT", -85, 0);
				-- elseif npsize == 5 then
				-- 	PixelUtil.SetPoint(castbar, "BOTTOMLEFT", self, "BOTTOMLEFT", 100, 0);
				-- 	PixelUtil.SetPoint(castbar, "BOTTOMRIGHT", self, "BOTTOMRIGHT", -100, 0);
				-- end
				PixelUtil.SetPoint(castbar.Icon, "LEFT", castbar, "LEFT", 0, 0);
				PixelUtil.SetHeight(castbar, 11);
			else

				if npsize > 2 then
					PixelUtil.SetPoint(castbar.Icon, "BOTTOMLEFT", self, "BOTTOMLEFT", 20 + 15*npsize, 0);
					PixelUtil.SetPoint(castbar, "BOTTOM", castbar.Icon, "TOP", 0, -1);
					PixelUtil.SetPoint(castbar, "LEFT", self, "BOTTOMLEFT", 20 + 15*npsize, 0);
					PixelUtil.SetPoint(castbar, "RIGHT", self, "BOTTOMRIGHT", -20 - 15*npsize, 0);
				end

				-- if npsize == 4 then
				-- 	PixelUtil.SetPoint(castbar.Icon, "BOTTOMLEFT", self, "BOTTOMLEFT", 85, 0);
				-- 	PixelUtil.SetPoint(castbar, "BOTTOM", castbar.Icon, "TOP", 0, -1);
				-- 	PixelUtil.SetPoint(castbar, "LEFT", self, "BOTTOMLEFT", 85, 0);
				-- 	PixelUtil.SetPoint(castbar, "RIGHT", self, "BOTTOMRIGHT", -85, 0);
				-- elseif npsize == 5 then
				-- 	PixelUtil.SetPoint(castbar.Icon, "BOTTOMLEFT", self, "BOTTOMLEFT", 100, 0);
				-- 	PixelUtil.SetPoint(castbar, "BOTTOM", castbar.Icon, "TOP", 0, 0);
				-- 	PixelUtil.SetPoint(castbar, "LEFT", self, "BOTTOMLEFT", 100, 0);
				-- 	PixelUtil.SetPoint(castbar, "RIGHT", self, "BOTTOMRIGHT", -100, 0);
				-- end
				PixelUtil.SetHeight(castbar, 8);
			end

			self.name:ClearAllPoints();
			healthBar.Text:ClearAllPoints();
			healthBar.LeftText:ClearAllPoints();
			healthBar.RightText:ClearAllPoints();
			self.RaidTargetFrame:ClearAllPoints();

			if self:IsShowOnlyName() then
				PixelUtil.SetPoint(self.HealthBarsContainer, "BOTTOMLEFT", castbar, "TOPLEFT", 0, -10);
				PixelUtil.SetPoint(self.HealthBarsContainer, "BOTTOMRIGHT", castbar, "TOPRIGHT", 0, -10);
				PixelUtil.SetPoint(self.name, "LEFT", self.HealthBarsContainer, "LEFT", 4, 0);
				PixelUtil.SetPoint(self.name, "RIGHT", self.HealthBarsContainer, "RIGHT", -4, 0);
				PixelUtil.SetPoint(self.RaidTargetFrame, "BOTTOM", self.name, "TOP", 0, 8);
				if npsize > 2 then
					self.name:SetTextHeight(9 + 2*npsize)
				else
					self.name:SetTextHeight(12 + npsize)
				end
			else
				PixelUtil.SetPoint(self.HealthBarsContainer, "BOTTOMLEFT", castbar, "TOPLEFT", 0, 2);
				PixelUtil.SetPoint(self.HealthBarsContainer, "BOTTOMRIGHT", castbar, "TOPRIGHT", 0, 2);
				if setupOptions.unitNameAnchorStyle == NamePlateConstants.NAME_ANCHOR_STYLES.InsideHealthBar then
					PixelUtil.SetPoint(healthBar.LeftText, "RIGHT", self.HealthBarsContainer.healthBar, "RIGHT", -2, 0);
					PixelUtil.SetPoint(healthBar.RightText, "RIGHT", healthBar.LeftText, "LEFT", 2, 0);
					PixelUtil.SetPoint(healthBar.Text, "RIGHT", healthBar.RightText, "LEFT", 2, 0);
					PixelUtil.SetPoint(self.name, "LEFT", self.HealthBarsContainer, "LEFT", 2, 0);
					PixelUtil.SetPoint(self.name, "RIGHT", healthBar.Text, "LEFT", -2, 0);
					if npsize > 2 then
						self.name:SetTextHeight(8 + npsize)
					else
						self.name:SetTextHeight(10 + npsize)
					end
				else
					PixelUtil.SetPoint(healthBar.LeftText, "RIGHT", self.HealthBarsContainer.healthBar, "RIGHT", -2, 0);
					PixelUtil.SetPoint(healthBar.RightText, "RIGHT", healthBar.LeftText, "LEFT", 2, 0);
					PixelUtil.SetPoint(healthBar.Text, "RIGHT", healthBar.RightText, "LEFT", 2, 0);
					PixelUtil.SetPoint(self.name, "BOTTOMLEFT", self.HealthBarsContainer, "TOPLEFT", 2, 2);
					PixelUtil.SetPoint(self.name, "BOTTOMRIGHT", self.HealthBarsContainer, "TOPRIGHT", -2, 2);
					self.name:SetTextHeight(12 + npsize)
				end

				if npsize > 2 then
					if setupOptions.unitNameAnchorStyle == NamePlateConstants.NAME_ANCHOR_STYLES.InsideHealthBar then
						PixelUtil.SetHeight(self.HealthBarsContainer, 13 + npsize);
					else
						PixelUtil.SetHeight(self.HealthBarsContainer, 9 + npsize);
					end
					-- healthBar.Text:SetTextHeight(8 + npsize);
					-- healthBar.LeftText:SetTextHeight(8 + npsize);
					-- healthBar.RightText:SetTextHeight(8 + npsize);
					PixelUtil.SetSize(castbar.Icon, 12 + npsize, 12 + npsize);
					PixelUtil.SetSize(castbar.BorderShield, 12 + npsize, 12 + npsize);
					PixelUtil.SetSize(self.classificationIndicator,8 + npsize, 8 + npsize);
					PixelUtil.SetPoint(self.classificationIndicator, "RIGHT", self.HealthBarsContainer, "LEFT", 0, -2);
				else
					PixelUtil.SetSize(self.classificationIndicator, 18 + npsize, 18 + npsize);
				end

				-- if npsize == 4 then
				-- 	PixelUtil.SetHeight(self.HealthBarsContainer, 12);
				-- 	PixelUtil.SetSize(castbar.Icon, 16, 16);
				-- 	PixelUtil.SetSize(castbar.BorderShield, 16, 16);
				-- 	PixelUtil.SetSize(self.classificationIndicator,13,13);
				-- 	PixelUtil.SetPoint(self.classificationIndicator, "BOTTOMRIGHT", self.HealthBarsContainer, "BOTTOMLEFT", 0, -2);
				-- 	healthBar.Text:SetTextHeight(11);
				-- 	healthBar.LeftText:SetTextHeight(11);
				-- 	healthBar.RightText:SetTextHeight(11);
				-- elseif npsize == 5 then
				-- 	PixelUtil.SetHeight(self.HealthBarsContainer, 14);
				-- 	PixelUtil.SetSize(castbar.Icon, 17, 17);
				-- 	PixelUtil.SetSize(castbar.BorderShield, 17, 17);
				-- 	PixelUtil.SetSize(self.classificationIndicator,14,14);
				-- 	PixelUtil.SetPoint(self.classificationIndicator, "BOTTOMRIGHT", self.HealthBarsContainer, "BOTTOMLEFT", 0, -2);
				-- 	healthBar.Text:SetTextHeight(12);
				-- 	healthBar.LeftText:SetTextHeight(12);
				-- 	healthBar.RightText:SetTextHeight(12);
				-- end

				PixelUtil.SetPoint(self.RaidTargetFrame, "RIGHT", self.HealthBarsContainer, "LEFT", 0, 1);
				if self.RaidTargetFrame:IsShown() then
					PixelUtil.SetPoint(self.AurasFrame.BuffListFrame, "RIGHT", self.HealthBarsContainer, "LEFT", -24, 1);
				elseif self.classificationIndicator:IsShown() then
					if npsize > 2 then
						PixelUtil.SetPoint(self.AurasFrame.BuffListFrame, "RIGHT", self.HealthBarsContainer, "LEFT", -8 - 4*npsize, 1);
					else
						PixelUtil.SetPoint(self.AurasFrame.BuffListFrame, "RIGHT", self.HealthBarsContainer, "LEFT", -14 - 4*npsize, 1);
					end
				else
					PixelUtil.SetPoint(self.AurasFrame.BuffListFrame, "RIGHT", self.HealthBarsContainer, "LEFT", -4, 1);
				end
			end

			local UAstyled = true
		end)


		-- 名字修改,添加等级显示
		local maxlevel
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			maxlevel = 60
		elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
			maxlevel = 70
		elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
			maxlevel = 80
		elseif WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
			maxlevel = 90
		end

		hooksecurefunc("CompactUnitFrame_UpdateName", function (frame)
			if CUFUstyled then return end
			if not frame or frame:IsForbidden() then return end
			local name = UnitName(frame.unit)
			if not name then return end
			
			local fname = frame:GetName()
			if (fname and fname:match("^CompactRaidFrame%d")) or (fname and fname:match("^CompactPartyFrameMember%d"))  then return end

			local level = UnitLevel(frame.unit)
			local Color = GetCreatureDifficultyColor((level > 0) and level or 999)
			local hexColor = GetHexColorFromRGB(Color.r, Color.g, Color.b)
			local rcp = "|cffff00ff*|r"
			local ecp = "|cffffff00+|r"

			local fontName, _fontSize, fontFlags = frame.name:GetFont()
			frame.name:SetFont(STANDARD_TEXT_FONT, _fontSize, "OUTLINE SLUG")

			if UnitIsPlayer(frame.unit) then
				frame.name:Show()
				-- 更新颜色和文字
				local _, class = UnitClass(frame.unit)
				local classcs = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
				-- frame.name:SetText("|c" .. classcs .. name .. "|r")
				name = "|c" .. classcs .. name .. "|r"
			else
				--Set the tag based on UnitClassification, can return "worldboss", "rare", "rareelite", "elite", "normal", "minus"
				if UnitClassification(frame.unit) == "worldboss" or level == -1 then
					level = "??"
				elseif UnitClassification(frame.unit) == "rare" then
					name = rcp..name
				elseif UnitClassification(frame.unit) == "rareelite" then
					name = rcp..name
					-- level = ecp..level
				-- elseif UnitClassification(frame.unit) == "elite" then
					-- level = ecp..level
				end
			end

			local npstyle = CVarCallbackRegistry:GetCVarNumberOrDefault(NamePlateConstants.STYLE_CVAR)
			-- if name and level and (not IsFriendlyUnit(frame.unit)) then
				if npstyle == 6 or level == 0 or level == maxlevel then
					frame.name:SetText(name)
				else
					frame.name:SetText("|cff"..hexColor..level.."|r "..name)
				end
			-- end

			if frame.HealthBarsContainer then
				frame.HealthBarsContainer.healthBar.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE SLUG");
				frame.HealthBarsContainer.healthBar.LeftText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE SLUG");
				frame.HealthBarsContainer.healthBar.RightText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE SLUG");
			end

			-- if frame.healthBar:IsShown() and level ~= 0 then
			-- 	frame.name:Show()
			-- end

			local CUFUstyled = true
		end)


		-- 备用

		-- 友方角色姓名板只显示名字

		-- local mainFrame = CreateFrame("Frame")
		-- mainFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		-- mainFrame:SetScript("OnEvent", function(self, event, ...)
		-- 	if tonumber(GetCVar("nameplateShowOnlyNameForFriendlyPlayerUnits")) ~= 1 then return end

		-- 	-- local unit = ...
		-- 	-- if self:IsForbidden() then return end
		-- 	-- if unit and not nameplatestyled then
		-- 	-- 	local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
		-- 	-- 	if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.unit then
		-- 	-- 		local unit = nameplate.UnitFrame.unit
		-- 	-- 		if unit and IsFriendlyUnit(unit) and nameplate.UnitFrame.name then
		-- 	-- 			-- local f,s = nameplate.UnitFrame.name:GetFont()
		-- 	-- 			nameplate.UnitFrame.name:SetFont("Fonts\\ARKai_T.ttf", 16, "OUTLINE SLUG")
		-- 	-- 			-- nameplate.UnitFrame:ClearAllPoints()
		-- 	-- 			nameplate.UnitFrame:SetPoint("BOTTOM", nameplate, "BOTTOM", 0, -20)
		-- 	-- 		end
		-- 	-- 	end
		-- 	-- 	local nameplatestyled = true
		-- 	-- end


		-- 	local unit = ...
		-- 	if not unit then return end

		-- 	local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
		-- 	if not nameplate or not nameplate.UnitFrame then return end

		-- 	local frame = nameplate.UnitFrame
		-- 	local unitId = frame.unit
		-- 	if not unitId then return end

		-- 	-- 只处理友方玩家（非自己）
		-- 	if IsFriendlyUnit(unitId) and frame.name  then
		-- 		-- 创建自定义字体（仅一次）
		-- 		if not frame.customNameFontString then
		-- 			-- frame:SetPoint("TOPLEFT",nameplate,"TOPLEFT", 0, 50)
		-- 			-- frame:SetPoint("BOTTOMRIGHT",nameplate,"BOTTOMRIGHT", 0, 50)
		-- 			-- nameplate:ClearAllPoints()
					
		-- 			-- nameplate:SetPoint("BOTTOM", 0, 150)
		-- 			local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		-- 			text:SetFont(STANDARD_TEXT_FONT, 17, "OUTLINE SLUG")
		-- 			text:SetPoint("CENTER", frame, "CENTER", 0, 0)
		-- 			frame.customNameFontString = text
		-- 		end
				
		-- 		-- 更新颜色和文字
		-- 		local _, class = UnitClass(unitId)
		-- 		local classcs = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
		-- 		frame.customNameFontString:SetText("|c" .. classcs .. frame.name:GetText() .. "|r")
				
		-- 		-- 隐藏原姓名板名字
		-- 		frame.name:SetAlpha(0.01)
		-- 	elseif frame.customNameFontString then
		-- 		-- 清理不满足条件的自定义字体
		-- 		frame.customNameFontString:SetText("")
		-- 	end

		-- end)

		-- -- 方案2
		-- hooksecurefunc(NamePlateUnitFrameMixin,"UpdateAnchors", function(self)
		-- 	if self:IsForbidden() then return end
		-- 	local unit = self.unit
		-- 	if unit and not nameplatestyled then
		-- 		-- local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
		-- 		-- if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.unit then
		-- 			-- local unit = nameplate.UnitFrame.unit
		-- 			if unit and IsFriendlyUnit(unit) and self.name then
		-- 				-- local f,s = nameplate.UnitFrame.name:GetFont()
		-- 				self.name:SetFont("Fonts\\ARKai_T.ttf", 16, "OUTLINE SLUG")
		-- 				self.name:ClearAllPoints()
		-- 				self.name:SetPoint("CENTER", self, "CENTER", 0, 0)
		-- 			end
		-- 		-- end
		-- 		local nameplatestyled = true
		-- 	end
		-- end)

		-- hooksecurefunc(NamePlateUnitFrameMixin,"UpdateAnchors", function(self)
		-- 	if self:IsForbidden() then return end
		-- 	local unit = self.unit
		-- 	if unit and IsFriendlyUnit(unit) and self.name then

		-- 		-- 检查是否已经创建过自定义字体
		-- 		if not self.customNameFontString then
		-- 			local t = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		-- 			t:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE SLUG")
		-- 			t:SetPoint("BOTTOM", self, "BOTTOM", 0, 16)
		-- 			self.customNameFontString = t
		-- 		end
		-- 		-- 更新文字内容（名称可能变化，比如进出队伍时）
		-- 		local classcs = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(unit))].colorStr
		-- 		self.customNameFontString:SetText("|c" .. classcs .. self.name:GetText() .. "|r")

		-- 		self.name:SetAlpha(0.01)

		-- 	elseif self.customNameFontString then
		-- 		-- 如果不满足条件但之前创建过，隐藏或清空
		-- 		self.customNameFontString:SetText("")
		-- 		-- 或者：self.customNameFontString:Hide()
		-- 	end
		-- end)


		-- 姓名板颜色
		local function UpdateHpbarColor(frame)
			if framestyled then return end
			if frame:IsForbidden() then return end
			if not frame.unit then return end
			if not UnitIsPlayer(frame.unit) then
				local Threat = UnitThreatSituation("player", frame.unit) or 0
				local InCombat = not ns.isSecret(UnitAffectingCombat(frame.unit)) and UnitAffectingCombat(frame.unit)
				local Reaction = not ns.isSecret(UnitReaction(frame.unit, "player")) and UnitReaction(frame.unit, "player")

				if UnitIsTapDenied(frame.unit) then	--没拾取
					frame.healthBar:SetStatusBarColor(0.7, 0.7, 0.7)

				elseif Threat < 2 and UnitIsUnit(frame.unit,"focus") then	--焦点
					frame.healthBar:SetStatusBarColor(0.64, 0.21, 0.93)	

				elseif Threat == 0 and InCombat then	--无仇恨
					frame.healthBar:SetStatusBarColor(0, 1, 1)

				elseif Threat == 1 and InCombat then	--有仇恨
					frame.healthBar:SetStatusBarColor(1, 1, 0)
					
				elseif Threat == 2 and InCombat then	--高仇恨
					frame.healthBar:SetStatusBarColor(1, 1, 0)
					
				elseif Threat == 3  and InCombat then	--仇恨是你
					frame.healthBar:SetStatusBarColor(1, 0, 0)

				-- elseif frame.isTarget the		-- 目标颜色
				-- 	frame.healthBar:SetStatusBarColor(1,0,0)

				elseif Reaction and Reaction >= 5 then	-- 友方npc
					frame.healthBar:SetStatusBarColor(0, 1, 0)	

				elseif Reaction and Reaction == 4 then	-- 中立
					frame.healthBar:SetStatusBarColor(1, 1, 0)

				else
					frame.healthBar:SetStatusBarColor(1, 0, 0)

				end
						
			end
			local framestyled = true
		end

		hooksecurefunc("CompactUnitFrame_UpdateSelectionHighlight", function(frame)
			if not frame.unit then return end
			if frame.unit:lower():match("nameplate") then
				UpdateHpbarColor(frame)
			end
		end)
		hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		--UNIT_NAME_UPDATE
		--UNIT_THREAT_LIST_UPDATE
		--UNIT_CONNECTION
			if not frame.unit then return end
			if string.match(frame.unit,"nameplate") then
				UpdateHpbarColor(frame)
			end
		end)

		local function NoFrameUpdateHpBar()
			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
				UpdateHpbarColor(namePlate.UnitFrame)
			end
		end

		local focusColor = CreateFrame("Frame")
		focusColor:RegisterEvent("PLAYER_FOCUS_CHANGED")
		focusColor:RegisterEvent("PLAYER_DEAD")
		focusColor:RegisterEvent("PLAYER_ALIVE")
		focusColor:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
		focusColor:RegisterEvent("PLAYER_TARGET_CHANGED")
		focusColor:RegisterEvent("UNIT_COMBAT")
		focusColor:SetScript("OnEvent", function(self, event,frame)
			if event == "PLAYER_FOCUS_CHANGED" then
				NoFrameUpdateHpBar()
			else
				NoFrameUpdateHpBar()
			end
		end)

		DToolsDB.npucav = true
	else
		--设置还原
		if DToolsDB.npucav then
			-- C_CVar.SetCVar("nameplateSize", 1)
			-- C_CVar.SetCVar("nameplateStyle", 5)
			-- C_CVar.SetCVar("nameplateAuraScale", 1)
			C_CVar.SetCVar("nameplateMinAlpha", 0.6)
			C_CVar.SetCVar("nameplateMaxScale", 1.1)
			C_CVar.SetCVar("nameplateMinScale", 0.9)
			C_CVar.SetCVar("nameplateSelectedScale", 1.2)
			C_CVar.SetCVar("nameplateOccludedAlphaMult", 0.5)
			C_CVar.SetCVar("nameplateShowOnlyNameForFriendlyPlayerUnits", 0)
			C_CVar.SetCVar("nameplateUseClassColorForFriendlyPlayerUnitNames", 1)
			DToolsDB.npucav = false
		end
	end
	--]]

end)