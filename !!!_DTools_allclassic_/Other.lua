local _
local _, ns =...
local L = ns.L
--if InCombatLockdown() then return end

--缩写重置命令
SlashCmdList["RELOAD"] = function() ReloadUI() end SLASH_RELOAD1 = "/rl"
--]]


--关闭插件CPU占用监控
C_AddOnProfiler.IsEnabled = function()
    return false
end
--]]


--删除自动输入DELETE
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(boxEditor)boxEditor.EditBox:SetText(DELETE_ITEM_CONFIRM_STRING)end)
--]]


--宏界面增强 --NGA
local tempScrollPer = nil

local function Init()
    -- 当选择宏时恢复滚动条位置
    hooksecurefunc(MacroFrame, "SelectMacro", function(self, index)
        if tempScrollPer then
            MacroFrame.MacroSelector.ScrollBox:SetScrollPercentage(tempScrollPer)
            tempScrollPer = nil  -- 重置临时存储
        end
    end)

    -- 调整宏选择框和其他界面元素的高度和位置
	MacroFrame:SetScale(1.1)
    MacroFrame:SetHeight(587) -- 外框高度
    MacroFrame:SetWidth(668) -- 外框宽度
    MacroFrame.MacroSelector:SetHeight(487) -- 宏图标范围高度
	MacroFrameTextBackground.NineSlice:SetWidth(670)
    MacroFrameSelectedMacroBackground:ClearAllPoints()
    MacroFrameSelectedMacroBackground:SetPoint("TOPLEFT", MacroFrame, "TOPLEFT", 330, -60)

    MacroFrameTextBackground:ClearAllPoints()
    MacroFrameTextBackground:SetPoint("TOPLEFT", MacroFrame, "TOPLEFT", 334, -132)
    MacroFrameTextBackground:SetHeight(412) -- 输入框高度

    MacroFrameScrollFrame:SetHeight(402) -- 滚动条高度

    MacroFrameCharLimitText:ClearAllPoints()
    MacroFrameCharLimitText:SetPoint("TOP", MacroFrameTextBackground, "BOTTOM", 0, 0)

    -- MacroHorizontalBarLeft:ClearAllPoints()
end

-- 创建监听事件的框架
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" then
        if addon == "Blizzard_MacroUI" then
            Init() -- 初始化宏界面
            f:UnregisterEvent("ADDON_LOADED") -- 完成后取消注册
        end
    elseif MacroFrame then
        tempScrollPer = MacroFrame.MacroSelector.ScrollBox.scrollPercentage
    end
end)

-- 监听事件
f:RegisterEvent("ADDON_LOADED") -- 监听宏插件的加载事件
f:RegisterEvent("UPDATE_MACROS") -- 监听宏界面更新事件
--]]


--[[设置界面网格
SLASH_EALIGN_UPDATED1 = "/wg"
local DEFAULT_SQUARE = 32
local f, square

SlashCmdList["EALIGN_UPDATED"] = function(msg)
	square = tonumber(msg) or DEFAULT_SQUARE
	if f and f:IsVisible() then
		f:Hide()
	else
		f = CreateFrame('Frame', nil, UIParent) 
		f:SetAllPoints(UIParent)
		local w = GetScreenWidth() / (square*2)
		local h = GetScreenHeight() / (square/16*9*2)
		for i = 0, square*2 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == square then
				t:SetColorTexture(1, 0, 0, 0.8)
				t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
				t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
			elseif i > square then
				t:SetColorTexture(0, 0, 0, 0.5)
				t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w, 0)
				t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
			else
				t:SetColorTexture(0, 0, 0, 0.5)
				t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
				t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w, 0)
			end
		end
		for i = 0, (square/16*9)*2 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == square/16*9 then
				t:SetColorTexture(1, 0, 0, 0.8)
				t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
				t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
			elseif i > square/16*9 then
				t:SetColorTexture(0, 0, 0, 0.5)
				t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
				t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h)
			else
				t:SetColorTexture(0, 0, 0, 0.5)
				t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h)
				t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
			end

		end	
	end
end
--]]


--好友列表染色显示服务器
local _, _, _, mygame = GetBuildInfo()

hooksecurefunc("FriendsFrame_UpdateFriendButton", function(friendbutton)
	if not FriendsListFrame or not FriendsListFrame:IsShown() then return end
	if not friendbutton.id then return end
	if friendbutton.buttonType == 3 then return end
	if not C_BattleNet.GetFriendAccountInfo(friendbutton.id) then return end
	local areaName = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.areaName	--区域名
	local realmDisplayName = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.realmDisplayName	--服务器
	local characterName = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.characterName --角色名
	local bnname = Ambiguate(C_BattleNet.GetFriendAccountInfo(friendbutton.id).battleTag,"short")	--战网名
	local className = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.className	--职业名
	local level = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.characterLevel	--等级
	--local factionName = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.factionName--阵营
	local gamename = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.wowProjectID	--游戏id,1是正式服,11是wlk
	local rich = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.richPresence	--丰富返回游戏版本-区域-服务器
	local timerunningSeasonID = C_BattleNet.GetFriendAccountInfo(friendbutton.id).gameAccountInfo.timerunningSeasonID --赛季ID用于幻彩服务器
	--标题栏
	local class
	if characterName and className then
		for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
			if v == className then
				class =RAID_CLASS_COLORS[k].colorStr
			end
		end
		friendbutton.name:SetText(bnname.."|c"..class.." ("..characterName..")".."|r    ")
	end

	--信息栏
	if realmDisplayName and areaName and gamename == 1 then
		if timerunningSeasonID then--如果在赛季服
			friendbutton.info:SetText("|A:timerunning-glues-icon:12:12:0:0|a"..areaName.."-"..realmDisplayName.."-"..level)
		else
			friendbutton.info:SetText(areaName.."-"..realmDisplayName.."-"..level)
		end
	elseif areaName and gamename == 14 then
		local _,fwq = strsplit("-",rich)	--怀旧服只要服务器名字
		if realmDisplayName then
			friendbutton.info:SetText("CTM".."-"..areaName.."-"..realmDisplayName.."-"..level)
		elseif fwq then
			friendbutton.info:SetText("CTM".."-"..areaName.."-"..fwq.."-"..level)
		end
	elseif areaName and gamename == 11 then
		local _,fwq = strsplit("-",rich)	--怀旧服只要服务器名字
		if realmDisplayName then
			friendbutton.info:SetText("WLK".."-"..areaName.."-"..realmDisplayName.."-"..level)
		elseif fwq then
			friendbutton.info:SetText("WLK".."-"..areaName.."-"..fwq.."-"..level)
		end
	elseif areaName and gamename == 2 then
		local _,fwq = strsplit("-",rich)	--怀旧服只要服务器名字
		if realmDisplayName then
			friendbutton.info:SetText("("..(L.era or "怀旧").."60)".."-"..areaName.."-"..realmDisplayName.."-"..level)
		elseif fwq then
			friendbutton.info:SetText("("..(L.era or "怀旧").."60)".."-"..areaName.."-"..fwq.."-"..level)
		end
	end
	--对比游戏版本
	if mygame > 90000 then
		if not gamename or gamename == 1 then
			friendbutton.name:SetAlpha(1)
			friendbutton.info:SetAlpha(1)
		else
			friendbutton.name:SetAlpha(.4)
			friendbutton.info:SetAlpha(.4)
		end
	end

end)
--]]



--聊天反和谐
local function fuckyou()
--ConsoleExec("portal TW")
ConsoleExec("profanityFilter 0")
end
local fuckyouall = CreateFrame("FRAME")
fuckyouall:RegisterEvent("ADDON_LOADED")
fuckyouall:SetScript("OnEvent", fuckyou)

--9.1反和谐好友不能组队https://bbs.nga.cn/read.php?&tid=27432996
local pre = C_BattleNet.GetFriendGameAccountInfo
C_BattleNet.GetFriendGameAccountInfo = function(...)
local gameAccountInfo = pre(...)
gameAccountInfo.isInCurrentRegion = true
return gameAccountInfo;
end
--]]


--聊天记录1024行 解除框体限制--
for i = 1, 50 do
	if _G["ChatFrame"..i] then
		_G["ChatFrame"..i]:SetClampRectInsets(0, 0, 0, 0);
		_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
	end
	if _G["ChatFrame"..i] and _G["ChatFrame"..i]:GetMaxLines() ~= 1024 then
		_G["ChatFrame"..i]:SetMaxLines(1024);
	end
end
hooksecurefunc("FloatingChatFrame_UpdateBackgroundAnchors", function(self)
	self:SetClampRectInsets(0, 0, 0, 0);
end)
hooksecurefunc("FCF_OpenTemporaryWindow", function()--解除框体限制----疑似失效
	local cf = FCF_GetCurrentChatFrame():GetName() or nil
	if cf then
		_G[cf]:SetClampRectInsets(0, 0, 0, 0);
		_G[cf.."EditBox"]:SetAltArrowKeyMode(false)
		if (_G[cf]:GetMaxLines() ~= 1024) then
			_G[cf]:SetMaxLines(1024);
		end
	end
end)
--]]



--鼠标缩放小地图
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)
--]]


--重置喊话
local T=CreateFrame("frame")
T:RegisterEvent('CHAT_MSG_SYSTEM')
T:SetScript("OnEvent", function(_, _, msg)
	if (msg:lower():match(L.untre or"无法重置") or msg:lower():match(L.hbre or "已被重置")) and IsInGroup() and UnitIsGroupLeader("player") then
		SendChatMessage(msg, 'PARTY')
	end
end)
--]]


--始终显示额外能量条的数值
if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
	hooksecurefunc("UnitPowerBarAlt_SetUp", function(self)
		local statusFrame = self.statusFrame
		if statusFrame.enabled then
			statusFrame:Show()
			statusFrame.Hide = statusFrame.Show
		end
	end)
end
--]]


--报错修正

-- 怀旧服修复 WOW UI 自身的一些错误
-- https://github.com/Stanzilla/WoWUIBugs/issues/247
if not InspectTalentFrameSpentPoints then
	InspectTalentFrameSpentPoints = CreateFrame("Frame")
end

-- --预创建报错http://bbs.ngacn.cc/read.php?&tid=12561149&pid=245895632&to=1
-- if GetLocale() == "zhCN" then
-- StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
-- text = L.ftayt or "针对此项活动，你的队伍人数已满，将被移出列表。",
-- button1 = OKAY,
-- timeout = 0,
-- whileDead = 1,
-- preferredIndex = 3
--  }
-- end
-- --社区报错--eke提供
-- GuildControlUIRankSettingsFrameRosterLabel = CreateFrame("Frame")
-- GuildControlUIRankSettingsFrameRosterLabel:Hide()

-- --隐藏系统自带的界面NPC对话框
-- LoadAddOn('Blizzard_TalkingHeadUI')
-- hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function()
-- 	TalkingHeadFrame:Hide()
-- end)

--]]


--[[小地图地图右键点击查询--------------------------------
Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
	ToggleDropDownMenu(1, nil, MiniMapTrackingButton, "MiniMapTracking", 0, -5)
	PlaySound("856")
	else
	Minimap_OnClick(self)
	end
end)
--]]

--[[谁在点小地图
local addon = CreateFrame('ScrollingMessageFrame', nil, Minimap)
	addon:SetHeight(40)
	addon:SetWidth(200)
	addon:SetPoint('BOTTOM', Minimap, 0, -31)
	addon:SetFont(ChatFontNormal:GetFont(), 14, 'OUTLINE')
	addon:SetJustifyH("CENTER")
	--  addon:SetJustifyV("CENTER")
	addon:SetMaxLines(1)
	addon:SetFading(true)
	addon:SetFadeDuration(1)
	addon:SetTimeVisible(8)
	addon:RegisterEvent'MINIMAP_PING'
	addon:SetScript('OnEvent', function(self, event, u)
		local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(u))]
		local name = UnitName(u)
		local pname = UnitName("player")
		if(name ~= pname or name == pname) then
		addon:AddMessage("|cffffffff"..UnitLevel(u).."|r "..name, c.r, c.g, c.b);
		--DEFAULT_CHAT_FRAME:AddMessage("点击小地图：|cffffffff"..UnitLevel(u).."|r "..name, c.r, c.g, c.b); 	--在聊天栏显示
		end
	end)
_G.yPing = addon
--]]


--  --大地图职业颜色Leatrix_Maps-\\Leatrix_Maps.lua
--  local WorldMapUnitPin, WorldMapUnitPinSizes
--  local partyTexture = "Interface\\AddOns\\AddUI\\UI\\media\\mapicon.blp"
--  for pin in WorldMapFrame:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
-- 	 WorldMapUnitPin = pin
-- 	 WorldMapUnitPinSizes = pin.dataProvider:GetUnitPinSizesTable()
-- 	 WorldMapUnitPin:SetPinTexture("raid", partyTexture)
-- 	 WorldMapUnitPin:SetPinTexture("party", partyTexture)
-- 	 hooksecurefunc(WorldMapUnitPin, "UpdateAppearanceData", function(self)
-- 		 self:SetPinTexture("raid", partyTexture)
-- 		 self:SetPinTexture("party", partyTexture)
-- 	 end)
-- 	 break
--  end
--  WorldMapUnitPin:SetAppearanceField("party", "useClassColor", true)
--  WorldMapUnitPin:SetAppearanceField("raid", "useClassColor", true)



----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-------------------------------		测试	--------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------














-----------------------------------------------------------------------
-------------------------  备用  --------------------------------------
-----------------------------------------------------------------------
--[[简化血量字体
if (GetLocale() == "zhCN") then
local f = function(v)
	if (v >= 1e8) then
		return ("%.2f亿"):format(v/1e8)

	elseif (v >= 1e6) then
		return ("%.2f万"):format(v/1e4)
	elseif (v == 0) then
		return ""
	else
		return ("%d"):format(v/1)
	end
end

hooksecurefunc("TextStatusBar_UpdateTextString", function(s)
	if not GetCVarBool("statusTextPercentage") then
		if s.TextString and s.currValue then
			s.TextString:SetText(f(s:GetValue()))
		end
		if s.RightText and s.currValue then
			s.RightText:SetText(f(s:GetValue()))
		end
	end
end)
end
--]]


--[[按alt一次买一组
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	--if InCombatLockdown() then return end
	if (IsAltKeyDown()) then
		local itemLink = GetMerchantItemLink(self:GetID())
		if not itemLink then
			return
		end
		local maxStack = select(8, GetItemInfo(itemLink))
		if (maxStack and maxStack > 1) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end
--]]


--[[姓名板字体放大并描边
local function SetFont(obj, optSize)
	local fontName, _, fontFlags = obj:GetFont()
	obj:SetFont(fontName, optSize, "OUTLINE")
	-- obj:SetShadowOffset(1, -1)
end

SetFont(SystemFont_LargeNamePlate, 13)
SetFont(SystemFont_NamePlate, 12)
SetFont(SystemFont_LargeNamePlateFixed, 13)
SetFont(SystemFont_NamePlateFixed, 12)
SetFont(SystemFont_NamePlateCastBar, 12)

--]]



--[[離開和進入戰鬥, 大文字提示
-----------------------------------
local locale = GetLocale()
local L = {
	enterCombat = { default = "Enter Combat", zhTW = "進入戰鬥", zhCN = "进入战斗" },
	leaveCombat = { default = "Leave Combat", zhTW = "離開戰鬥", zhCN = "离开战斗" },
 }
local alertFrame = CreateFrame("Frame")
alertFrame:SetSize(400, 65)
alertFrame:SetPoint("TOP", 0, -280)
alertFrame:SetScale(0.9)
alertFrame:Hide()
alertFrame.Bg = alertFrame:CreateTexture(nil, "BACKGROUND")
alertFrame.Bg:SetTexture("Interface\\LevelUp\\MinorTalents")
alertFrame.Bg:SetPoint("TOP")
alertFrame.Bg:SetSize(400, 67)
alertFrame.Bg:SetTexCoord(0, 400/512, 341/512, 407/512)
alertFrame.Bg:SetVertexColor(1, 1, 1, 0.4)
alertFrame.text = alertFrame:CreateFontString(nil, "ARTWORK", "GameFont_Gigantic")
alertFrame.text:SetPoint("CENTER")
alertFrame:SetScript("OnUpdate", function(self, elapsed)
	self.timer = self.timer + elapsed
	if (self.timer > self.totalTime) then self:Hide() end
	if (self.timer <= 0.5) then
	if self.timer < 0 then self.timer = 0 end
		self:SetAlpha(self.timer*2)
	elseif (self.timer > 2) then
		self:SetAlpha(1.2-self.timer/self.totalTime)
	end
end)
alertFrame:SetScript("OnShow", function(self)
	self.totalTime = 3.2
	self.timer = 0
end)
alertFrame:SetScript("OnEvent", function(self, event, ...)
	self:Hide()
	if (event == "PLAYER_REGEN_DISABLED") then
		self.text:SetText(L.enterCombat[locale] or L.enterCombat.default)
	elseif (event == "PLAYER_REGEN_ENABLED") then
		self.text:SetText(L.leaveCombat[locale] or L.leaveCombat.default)
	end
	self:Show()
end)
alertFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
alertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
--]]



--[[倒计时置顶防止被钥匙框体遮挡
local CD=CreateFrame("frame")
CD:RegisterEvent('START_TIMER')
CD:SetScript("OnEvent", function()
	TimerTrackerTimer1:SetFrameStrata("TOOLTIP")
end)
--]]


--[[就位确认置顶防止被钥匙框体遮挡
local ReadyC=CreateFrame("frame")
ReadyC:RegisterEvent('READY_CHECK')
ReadyC:SetScript("OnEvent", function()
	ReadyCheckFrame:SetFrameStrata("TOOLTIP")
end)
--]]


--[[区域文字位置(大秘境开门快速选怪会碍事)
EventToastManagerFrame:ClearAllPoints()
EventToastManagerFrame:SetPoint("TOP", UIParent, "TOP", 0, -30)
--]]

--[[隐藏中间团队拾取框, 鼠标会点不动
GroupLootContainer:Hide()
--]]

--[[就位声音
local RC=CreateFrame("frame")
RC:RegisterEvent('READY_CHECK')
RC:SetScript("OnEvent", function()
	PlaySoundFile(567478, "Master")
end)
--]]


--[[创建离开队伍按钮
local LFGLP = CreateFrame("Button", "ltteam", PVEFrame, "UIPanelButtonTemplate")
LFGLP:SetText(L.ltteam or "退队")
LFGLP:SetWidth(50)
LFGLP:SetHeight(22)
LFGLP:SetPoint("BOTTOMLEFT", 10, 10)
LFGLP:SetScript("OnClick", function()
LeaveParty()
end)
--]]