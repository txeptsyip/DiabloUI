local _
local AddonName, ns, _ =...

ns.event("PLAYER_LOGIN", function()
	
	if C_AddOns.IsAddOnLoaded("ElvUI") == true then return end
	if C_AddOns.IsAddOnLoaded("NDui") == true then return end
	if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end
	
	if DToolsDB.uis == false then return end

	
	-- 战网提示窗口
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

	if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end

	-- local us = tonumber(GetCVar("uiScale"))
	-- if us <= 0.71 then
	-- 	BuffFrame:SetScale(1.15) --BUFF
	-- 	TemporaryEnchantFrame:SetScale(1.15) --武器临时附魔
	-- 	CastingBarFrame:SetScale(1.1) --施法条
	-- 	if AATimerBar then AATimerBar:SetScale(1.1) end		--自动攻击条

	-- 	PartyMemberFrame1:SetScale(1.2) --小队
	-- 	PartyMemberFrame2:SetScale(1.2)
	-- 	PartyMemberFrame3:SetScale(1.2)
	-- 	PartyMemberFrame4:SetScale(1.2)

	-- 	MinimapCluster:SetScale(1.15) --小地图
	-- end

	-- OverrideActionBar:SetScale(1.05)	--载具动作条

	MinimapCluster.BorderTop:Hide() --顶部材质
	MinimapZoneText:SetFont(STANDARD_TEXT_FONT,16, "OUTLINE")
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton, "CENTER", 9, 1)
	-- MinimapZoneTextButton:SetParent(Minimap) --地理位置文字
	-- MinimapZoneTextButton:ClearAllPoints()
	-- MinimapZoneTextButton:SetPoint("BOTTOM", Minimap, "TOP", 0, 3) --地理位置文字位置
	--MiniMapTracking:Hide() --查询按钮
	-- MiniMapWorldMapButton:SetAlpha(0) --世界地图图标
	MinimapZoomIn:Hide() --放大图标
	MinimapZoomOut:Hide() --缩小图标
	MinimapToggleButton:SetFrameStrata("HIGH")
	MinimapToggleButton:SetAlpha(0.01)
	--Minimap:SetQuestBlobRingScalar(0) --任务追踪环形网格
	--MinimapNorthTag:Hide()
	-- GameTimeFrame:Hide() --日历
	-- GameTimeFrame:SetScale(0.7)
	-- GameTimeFrame:ClearAllPoints()
	-- GameTimeFrame:SetPoint("TOP", MinimapToggleButton, "BOTTOM", -1, 5)


	-- -- 小地图时间
	-- C_AddOns.LoadAddOn("Blizzard_TimeManager")
	-- -- select(1, TimeManagerClockButton:GetRegions()):Hide()
	TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	TimeManagerClockTicker:SetJustifyH("CENTER")
	TimeManagerClockTicker:SetTextColor(0, 0.95, 0.1)--时间字体颜色
	if WOW_PROJECT_ID ~= WOW_PROJECT_MISTS_CLASSIC then
		TimeManagerClockTicker:ClearAllPoints()
		TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 2, 0)
	end
	-- TimeManagerClockButton:ClearAllPoints()
	-- TimeManagerClockButton:SetPoint("CENTER", MinimapCluster, "BOTTOM", 0, 7)--时间位置


	-- UIWidgetBelowMinimapContainerFrame:SetScale(1)
	-- UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
	-- UIWidgetBelowMinimapContainerFrame:SetPoint("TOP", UIParent, "TOP", 0, -150)
	-- UIWidgetBelowMinimapContainerFrame.ClearAllPoints = function() end
	-- UIWidgetBelowMinimapContainerFrame.SetPoint = function() end


	--CompactRaidFrameContainer:SetScale(0.8) --团队框架
	--CompactRaidFrameManager:SetAlpha(0.6)
	--隐藏自带团队框架
	--CompactRaidFrameManager:UnregisterAllEvents()
	--CompactRaidFrameManager:Hide()
	--CompactRaidFrameManager:SetScript("OnShow",CompactRaidFrameManager.Hide)
	--CompactRaidFrameContainer:UnregisterAllEvents()
	--CompactRaidFrameContainer:Hide()
	--CompactRaidFrameContainer:SetScript("OnShow",CompactRaidFrameContainer.Hide)


	-- --任务物品
	-- local function moveQuestObjectiveItems(self)
	--     --if InCombatLockdown() then return end
	--     local a = { self:GetPoint() }

	--     self:ClearAllPoints()
	--     self:SetPoint("TOPRIGHT", a[2], "TOPLEFT", -16, 1)
	--     self:SetScale(1.4)
	--     --self:SetFrameStrata("MEDIUM")
	--     --self:SetFrameLevel(25)
	-- end

	-- local qitime = 0
	-- local qiinterval = 1

	-- hooksecurefunc("QuestWatchFrameItem_OnUpdate", function(self, elapsed)
	--     --if InCombatLockdown() then return end
	--     qitime = qitime + elapsed
	--     moveQuestObjectiveItems(self)
	--     qitime = 0
	-- end)



	-- UIWidgetTopCenterContainerFrame:SetScale(1.0) --顶部状态文字
	--UIWidgetTopCenterContainerFrame:SetPoint("TOP", UIParent, "TOP", 0, -27)


	-- MirrorTimer1:SetScale(1) --计时条
	-- MirrorTimer2:SetScale(1)
	-- MirrorTimer3:SetScale(1)
	--MirrorTimer1:SetPoint("TOP", UIParent, "TOP", 0, -200)


end)