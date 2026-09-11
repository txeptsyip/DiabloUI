--部分修改自NGA链接http://bbs.ngacn.cc/read.php?tid=9706946
local _, ns = ...
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(...)


	-- if IsAddOnLoaded("ElvUI") == true then return end
	
	if DToolsDB.cfp == nil or DToolsDB.cfp == false then return end


--精简公共频道 (true/false) (精简/不精简) FCF_StopAlertFlash
local ShortChannel = true

--配置聊天框分页------------------------------------

local function GetChatFrame(cname)
	local index = 0
	for i = 1, NUM_CHAT_WINDOWS do
		name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(i)
		if name == cname then
			index = i
			break
		end
	end
	return _G["ChatFrame"..index]
end

local function ChatAddWindow(name)
	FCF_OpenNewWindow(name)
	FCF_DockUpdate();
	local chatFrame = GetChatFrame(name)
	ChatFrame_RemoveAllChannels(chatFrame)
	ChatFrame_RemoveAllMessageGroups(chatFrame)
	if name == "综合" then
		JoinChannelByName("大脚世界频道")
		chatFrame:AddChannel("大脚世界频道")
		ChatFrame_AddMessageGroup(chatFrame, "WHISPER")
	end
	if name == "聊天" then
		ChatFrame_AddMessageGroup(chatFrame, "SAY")--说
		ChatFrame_AddMessageGroup(chatFrame, "YELL")--喊
		ChatFrame_AddMessageGroup(chatFrame, "EMOTE")--表情
		ChatFrame_AddMessageGroup(chatFrame, "GUILD")--公会
		ChatFrame_AddMessageGroup(chatFrame, "OFFICER")--官员
		ChatFrame_AddMessageGroup(chatFrame, "GUILD_ACHIEVEMENT")--公会通告
		ChatFrame_AddMessageGroup(chatFrame, "ACHIEVEMENT")--成就通告
		ChatFrame_AddMessageGroup(chatFrame, "WHISPER")--密语
		ChatFrame_AddMessageGroup(chatFrame, "BN_WHISPER")--战网密语
		ChatFrame_AddMessageGroup(chatFrame, "PARTY")--小队
		ChatFrame_AddMessageGroup(chatFrame, "PARTY_LEADER")--队长
		ChatFrame_AddMessageGroup(chatFrame, "RAID")--团队
		ChatFrame_AddMessageGroup(chatFrame, "RAID_LEADER")--团队领袖
		ChatFrame_AddMessageGroup(chatFrame, "RAID_WARNING")--团队警报
		ChatFrame_AddMessageGroup(chatFrame, "INSTANCE_CHAT")--副本队伍
		ChatFrame_AddMessageGroup(chatFrame, "INSTANCE_CHAT_LEADER")--副本领袖

		--ChatFrame_AddMessageGroup(chatFrame, "COMBAT_XP_GAIN")--经验
		--ChatFrame_AddMessageGroup(chatFrame, "COMBAT_GUILD_XP_GAIN")--公会经验
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_HONOR_GAIN")--荣誉
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_FACTION_CHANGE")--声望
		ChatFrame_AddMessageGroup(chatFrame, "SKILL")--技能提升
		ChatFrame_AddMessageGroup(chatFrame, "LOOT")--物品拾取
		ChatFrame_AddMessageGroup(chatFrame, "CURRENCY")--货币
		ChatFrame_AddMessageGroup(chatFrame, "MONEY")--金钱拾取
		--ChatFrame_AddMessageGroup(chatFrame, "TRADESKILLS")--商业技能
		ChatFrame_AddMessageGroup(chatFrame, "OPENING")--正在打开
		ChatFrame_AddMessageGroup(chatFrame, "PET_INFO")--宠物信息
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_MISC_INFO")--其他信息

		ChatFrame_AddMessageGroup(chatFrame, "BG_HORDE")--战场部落
		ChatFrame_AddMessageGroup(chatFrame, "BG_ALLIANCE")--战场联盟
		ChatFrame_AddMessageGroup(chatFrame, "BG_NEUTRAL")--战场中立

		ChatFrame_AddMessageGroup(chatFrame, "SYSTEM")--系统
		ChatFrame_AddMessageGroup(chatFrame, "ERRORS")--错误
		ChatFrame_AddMessageGroup(chatFrame, "IGNORED")--已屏蔽
		ChatFrame_AddMessageGroup(chatFrame, "TARGETICONS")--目标图标
		ChatFrame_AddMessageGroup(chatFrame, "BN_INLINE_TOAST_ALERT")--战网提示
		--ChatFrame_AddMessageGroup(chatFrame, "PET_BATTLE_COMBAT_LOG")--宠物对战
		--ChatFrame_AddMessageGroup(chatFrame, "PET_BATTLE_INFO")--宠物对战信息

		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_SAY")--怪物说
		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_EMOTE")--怪物表情
		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_YELL")--怪物喊
		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_WHISPER")--怪物密语
		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_BOSS_EMOTE")--首领台词
		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_BOSS_WHISPER")--首领密语

	end
	if name == "密语" then
		ChatFrame_AddMessageGroup(chatFrame, "WHISPER")
		ChatFrame_AddMessageGroup(chatFrame, "BN_WHISPER")
		ChatFrame_AddMessageGroup(chatFrame, "MONSTER_PARTY")
	end
	if name == "拾取" then
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_XP_GAIN")--经验
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_GUILD_XP_GAIN")--公会经验
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_HONOR_GAIN")--荣誉
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_FACTION_CHANGE")--声望
		ChatFrame_AddMessageGroup(chatFrame, "SKILL")--技能提升
		ChatFrame_AddMessageGroup(chatFrame, "LOOT")--物品拾取
		ChatFrame_AddMessageGroup(chatFrame, "CURRENCY")--货币
		ChatFrame_AddMessageGroup(chatFrame, "MONEY")--金钱拾取
		-- ChatFrame_AddMessageGroup(chatFrame, "TRADESKILLS")--商业技能
		ChatFrame_AddMessageGroup(chatFrame, "OPENING")--正在打开
		ChatFrame_AddMessageGroup(chatFrame, "PET_INFO")--宠物信息
		ChatFrame_AddMessageGroup(chatFrame, "COMBAT_MISC_INFO")--其他信息
	end
end

local function Chat()
	FCF_ResetChatWindows()
	ChatFrame_RemoveAllChannels(GetChatFrame("综合"))
	GetChatFrame("综合"):AddChannel("综合")
	GetChatFrame("综合"):AddChannel("交易")
	GetChatFrame("综合"):AddChannel("本地防务")
	GetChatFrame("综合"):AddChannel("大脚世界频道")
	FCF_SetWindowName(ChatFrame2, "战斗记录");
	--ChatAddWindow("综合")
	ChatAddWindow("聊天")
	ChatAddWindow("密语")
	ChatAddWindow("拾取")
	SetCVar("whisperMode", "inline")

    for k,v in pairs(CHAT_CONFIG_CHAT_LEFT) do
        SetChatColorNameByClass(v.type, true)
    end
    for k,v in pairs({GetChannelList()}) do
        local id = tonumber(v)
        if id then
            SetChatColorNameByClass("CHANNEL"..id, true)
        end
    end

	for i = 1,10 do FCF_SetWindowAlpha(_G["ChatFrame"..i], .2) end
	FCF_SetChatWindowFontSize(self, ChatFrame1, 15)
	DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 35, 36);
	DEFAULT_CHAT_FRAME:SetSize(440, 236)
	FCF_DockUpdate();
    FCF_SavePositionAndDimensions(DEFAULT_CHAT_FRAME)
    FCF_RestorePositionAndDimensions(DEFAULT_CHAT_FRAME)

    FCF_SelectDockFrame(DEFAULT_CHAT_FRAME)
    FCF_FadeInChatFrame(FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK));

	--聊天信息职业着色
	for k, v in pairs(CHAT_CONFIG_CHAT_LEFT) do
		SetChatColorNameByClass(v.type, true)
	end
	for k, v in pairs({ GetChannelList() }) do
		local id = tonumber(v)
		if id then
			SetChatColorNameByClass("CHANNEL"..id, true)
		end
	end
	SetCVar("remoteTextToSpeech", 0)	--在语音聊天中为我发言
end

SLASH_CHAT1 = "/setchat"		--输入命令执行
SlashCmdList["CHAT"] = function (msg, editbox)
	if InCombatLockdown() then
		print("Reseting frames is not possible in combat.")
	elseif msg == "" then 
		Chat()
	end
end


--聊天框指向显示装备详情
----------------------------------------------------------------------------------------
--  Based on tekKompare(by Tekkub)
----------------------------------------------------------------------------------------
local orig1, orig2, GameTooltip = {}, {}, GameTooltip
local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true, instancelock = true, currency = true}

local function OnHyperlinkEnter(frame, link, ...)
if not link then return end
   local linktype = link:match("^([^:]+)")
   if linktype and linktype == "battlepet" then
      GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT", 250, 0)
      GameTooltip:Show()
      local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(":", link)
      BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed))
   elseif linktype and linktypes[linktype] then
      GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT", 250, 0)
      GameTooltip:SetHyperlink(link)
      GameTooltip:Show()
   end

   if orig1[frame] then return orig1[frame](frame, link, ...) end
end

local function OnHyperlinkLeave(frame, link, ...)
   --local linktype = link:match("^([^:]+)")
   --if linktype and linktype == "battlepet" then
     -- BattlePetTooltip:Hide()
   --elseif linktype and linktypes[linktype] then
      GameTooltip:Hide()
   --end

   if orig1[frame] then return orig1[frame](frame, link, ...) end
end

for i = 1, NUM_CHAT_WINDOWS do
   local frame = _G["ChatFrame"..i]
   orig1[frame] = frame:GetScript("OnHyperlinkEnter")
   frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

   orig2[frame] = frame:GetScript("OnHyperlinkLeave")
   frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end
--]]




------------ == == == == == == == == == == 频道精简 == == == == == == == == ==------------
if ShortChannel then
---- == == == == == == == == == == == == == == == 精简聊天频道, 可修改汉字自定义 == == == == == == == == == == == == ==----
	if (GetLocale() == "zhTW") then
	--公会
	CHAT_GUILD_GET = "|Hchannel:GUILD|h[公會]|h %s:"
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官員]|h %s:"

	--团队
	CHAT_RAID_GET = "|Hchannel:RAID|h[團隊]|h %s:"
	CHAT_RAID_WARNING_GET = "[通知] %s:"
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[團長]|h %s:"

	--队伍
	CHAT_PARTY_GET = "|Hchannel:PARTY|h[隊伍]|h %s:"
	CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[隊長]|h %s:"
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[向導]|h %s:"

	--战场
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[戰場]|h %s:"
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[領袖]|h %s:"

	--说/喊
	CHAT_SAY_GET = "%s:"
	CHAT_YELL_GET = "%s:"

	--密语
	CHAT_WHISPER_INFORM_GET = "發送給%s:"
	CHAT_WHISPER_GET = "%s悄悄話:"

	CHAT_FLAG_AFK = "[暫離] "
	CHAT_FLAG_DND = "[勿擾] "
	CHAT_FLAG_GM = "[GM] "

	elseif (GetLocale() == "zhCN") then

	--公会
	CHAT_GUILD_GET = "|Hchannel:GUILD|h[会]|h %s:"
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官]|h %s:"

	--团队
	CHAT_RAID_GET = "|Hchannel:RAID|h[团]|h %s:"
	CHAT_RAID_WARNING_GET = "[通知] %s:"
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[团长]|h %s:"

	--队伍
	CHAT_PARTY_GET = "|Hchannel:PARTY|h[队]|h %s:"
	CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[队长]|h %s:"
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[向导]:|h %s:"

	--战场
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[副]|h %s:"
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[领袖]|h %s:"

	--密语
	CHAT_WHISPER_INFORM_GET = "对%s说:"
	CHAT_WHISPER_GET = "%s说:"
	CHAT_BN_WHISPER_INFORM_GET = "对%s说:"
	CHAT_BN_WHISPER_GET = "%s说:"

	--说/喊
	CHAT_SAY_GET = "%s:"
	CHAT_YELL_GET = "%s:"

	--flags
	CHAT_FLAG_AFK = "[暂离]"
	CHAT_FLAG_DND = "[勿扰]"
	CHAT_FLAG_GM = "[GM]"

	else
	CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "
	CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
	CHAT_RAID_WARNING_GET = "RW %s "
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "
	CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
	CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|hPL|h %s "
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|hPG|h %s "
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|hB|h %s "
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|hBL|h %s "
	CHAT_WHISPER_INFORM_GET = "to %s "
	CHAT_WHISPER_GET = "from %s "
	CHAT_BN_WHISPER_INFORM_GET = "to %s "
	CHAT_BN_WHISPER_GET = "from %s "
	CHAT_SAY_GET = "%s "
	CHAT_YELL_GET = "%s "
	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "
	end

	--================================公共频道和自定义频道精简================================--
	local gsub = _G.string.gsub
	local newAddMsg = {}
	local chn, rplc
		if (GetLocale() == "zhCN") then  ---国服在此修改
		rplc = {
			"[%1综]",
			"[%1交]",
			"[%1本]",
			"[%1组]",
			"[%1防]",
			"[%1招]",
			"[%1世]",
			"[%1世]",    -- 自定义频道缩写请自行修改
		}

		elseif (GetLocale() == "zhTW") then  ---台服
			rplc = {
			"[%1綜合]",
			"[%1貿易]",
			"[%1防務]",
			"[%1組隊]",
			"[%1世界]",
			"[%1招募]",
			"[%1世界]",
			"[%1世界]",   -- 自定义频道缩写请自行修改
			}
			else

		rplc = {
			"[GEN]",
			"[TR]",
			"[WD]",
			"[LD]",
			"[LFG]",
			"[GR]",
			"[BFC]",
			"[CL]",      -- 英文缩写
		}
			end

		chn = {
			"%[%d+%. General.-%]",
			"%[%d+%. Trade.-%]",
			"%[%d+%. LocalDefense.-%]",
			"%[%d+%. LookingForGroup%]",
			"%[%d+%. WorldDefense%]",
			"%[%d+%. GuildRecruitment.-%]",
			"%[%d+%. BigFootChannel.-%]",
			"%[%d+%. CustomChannel.-%]",       -- 自定义频道英文名随便填写
		}

	---------------------------------------- 国服 ---------------------------------------------
		local L = GetLocale()
		if L == "zhCN" then
			chn[1] = "%[%d+%. 综合.-%]"
			chn[2] = "%[%d+%. 交易.-%]"
			chn[3] = "%[%d+%. 本地防务.-%]"
			chn[4] = "%[%d+%. 寻求组队%]"
			chn[5] = "%[%d+%. 世界防务%]"
			chn[6] = "%[%d+%. 公会招募.-%]"
			chn[7] = "%[%d+%. 大脚世界频道.-%]"
			chn[8] = "%[%d+%. 世界频道.-%]"   -- 请修改频道名对应你游戏里的频道

	---------------------------------------- 台服 ---------------------------------------------
			elseif L == "zhTW" then
			chn[1] = "%[%d+%. 綜合.-%]"
			chn[2] = "%[%d+%. 貿易.-%]"
			chn[3] = "%[%d+%. 本地防務.-%]"
			chn[4] = "%[%d+%. 尋求組隊%]"
			chn[5] = "%[%d+%. 世界防務%]"
			chn[6] = "%[%d+%. 公會招募.-%]"
			chn[7] = "%[%d+%. 大脚世界频道.-%]"
			chn[8] = "%[%d+%. 世界频道.-%]"   -- 请修改频道名对应你游戏里的频道
		else
	---------------------------------------- 英文 -----------------------------------------------
			chn[1] = "%[%d+%. General.-%]"
			chn[2] = "%[%d+%. Trade.-%]"
			chn[3] = "%[%d+%. LocalDefense.-%]"
			chn[4] = "%[%d+%. LookingForGroup%]"
			chn[5] = "%[%d+%. WorldDefense%]"
			chn[6] = "%[%d+%. GuildRecruitment.-%]"
			chn[7] = "%[%d+%. BigFootChannel.-%]"
			chn[8] = "%[%d+%. CustomChannel.-%]"   -- 自定义频道英文名随便填写

		end

	local function AddMessage(frame, text, ...)
		for i = 1, 8 do	 -- 对应上面几个频道(如果有9个频道就for i = 1, 9 do)
			text = gsub(text, chn[i], rplc[i])
		end

		text = gsub(text, "%[(%d0?)%. .-%]", "%1.")
		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	if ShortChannel then
		for i = 1, 5 do
			if i ~= 2 then
				local f = _G[format("%s%d", "ChatFrame", i)]
				newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
				f.AddMessage = AddMessage
			end
		end
	end
end



----------离队入队染上职业颜色----------
if C_AddOns.IsAddOnLoaded("BiaoGe") ~= true then
	local lastraidjoinname
	local lastpartyjoinname
	local function MsgClassColor(self, event, msg, player, l, cs, t, flag, channelId, ...)
		if msg:match("%s$") then return end

		local raidleavename = strmatch(msg, ERR_RAID_MEMBER_REMOVED_S:gsub("%%s", "(.+)"))
		local raidjoinname = strmatch(msg, ERR_RAID_MEMBER_ADDED_S:gsub("%%s", "(.+)"))
		local partyleavename = strmatch(msg, ERR_LEFT_GROUP_S:gsub("%%s", "(.+)"))
		local partyjoinname = strmatch(msg, ERR_JOINED_GROUP_S:gsub("%%s", "(.+)"))

		-- 离开了团队
		if raidleavename then
			if IsInRaid(1) then
				local raidleavenamelink = "|Hplayer:" .. raidleavename .. "|h[" .. raidleavename .. "]|h"
				msg = format(ERR_RAID_MEMBER_REMOVED_S, "|cffcccccc"..raidleavenamelink.."|r")
				lastraidjoinname = nil
				return false, msg, player, l, cs, t, flag, channelId, ...
			end					
		-- 加入了团队
		elseif raidjoinname then
			C_Timer.After(0.1, function()
				if not IsInRaid(1) then return end
				if lastraidjoinname == raidjoinname then return end
				local raidjoinnamelink = "|Hplayer:" .. raidjoinname .. "|h[" .. raidjoinname .. "]|h"
				local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(raidjoinname))].colorStr
				local colorname = "|c" .. color .. raidjoinnamelink .. "|r"
				SendSystemMessage(format(ERR_RAID_MEMBER_ADDED_S .. " ", colorname))
				lastraidjoinname = raidjoinname
			end)
			return true

		-- 离开了队伍
		elseif partyleavename then
			if IsInGroup(1) then
				local partyleavenamelink = "|Hplayer:" .. partyleavename .. "|h[" .. partyleavename .. "]|h"
				msg = format(ERR_LEFT_GROUP_S, "|cffcccccc"..partyleavenamelink.."|r")
				lastpartyjoinname = nil
				return false, msg, player, l, cs, t, flag, channelId, ...
			end
		-- 加入了队伍
		elseif partyjoinname then
			C_Timer.After(0.1, function()
				if not IsInGroup(1) then return end
				if lastpartyjoinname == partyjoinname then return end
				local partyjoinnamelink = "|Hplayer:" .. partyjoinname .. "|h[" .. partyjoinname .. "]|h"
				local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(partyjoinname))].colorStr
				local colorname = "|c" .. color .. partyjoinnamelink .. "|r"
				SendSystemMessage(format(ERR_JOINED_GROUP_S .. " ", colorname))
				lastpartyjoinname = partyjoinname
			end)
			return true
		end
	end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MsgClassColor)

	local f = CreateFrame("Frame")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")
	f:SetScript("OnEvent", function(...)
		if not IsInRaid(1) then
			lastraidjoinname = nil
		end
		if not IsInGroup(1) then
			lastpartyjoinname = nil
		end
	end)
end
--]]


end)



local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(...)

if DToolsDB.sfu == true then return end

	--聊天标签字体美化------------------------------------------------------------------------------------------------
	local ChatFrameColor = function(self, selected) 
		self:SetAlpha(1)

		if ( selected ) then
			self.leftSelectedTexture:Show();
			self.middleSelectedTexture:Show();
			self.rightSelectedTexture:Show();
		else
			self.leftSelectedTexture:Hide();
			self.middleSelectedTexture:Hide();
			self.rightSelectedTexture:Hide();
		end

		local font, fontSize = GameFontNormalSmall:GetFont()
		local colorTable = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass("player"))] ;
		self:GetFontString():SetFont(font, fontSize + 2, "OUTLINE SLUG");
		if ( selected ) then
			self:GetFontString():SetTextColor(colorTable.r, colorTable.g, colorTable.b, 1);
		else
			self:GetFontString():SetTextColor(1, 1, 1, 0.85);
		end

		-- self:HookScript("OnEnter", function()
		-- 	self:GetFontString():SetTextColor(colorTable.r, colorTable.g, colorTable.b, 1);
		-- end)
		-- self:HookScript("OnLeave",  function()
		-- 	if ( selected ) then
		-- 		self:GetFontString():SetTextColor(colorTable.r, colorTable.g, colorTable.b, 0.9);
		-- 	else
		-- 		self:GetFontString():SetTextColor(1, 1, 1, 0.9);
		-- 	end
		-- end)

		-- self.leftTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.middleTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.rightTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);

		-- self.leftSelectedTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.middleSelectedTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.rightSelectedTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);

		-- self.leftHighlightTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.middleHighlightTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.rightHighlightTexture:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);
		-- self.glow:SetVertexColor(colorTable.r, colorTable.g, colorTable.b, 0.01);

		self.leftTexture:SetAlpha(0.01)
		self.middleTexture:SetAlpha(0.01)
		self.rightTexture:SetAlpha(0.01)

		self.leftSelectedTexture:SetAlpha(0.01)
		self.middleSelectedTexture:SetAlpha(0.01)
		self.rightSelectedTexture:SetAlpha(0.01)

		self.leftHighlightTexture:SetAlpha(0.16)
		self.middleHighlightTexture:SetAlpha(0.16)
		self.rightHighlightTexture:SetAlpha(0.16)
		self.glow:SetAlpha(0.01)

		if ( self.conversationIcon ) then
			self.conversationIcon:SetAlpha(0.01)
		end

		local minimizedFrame = _G["ChatFrame"..self:GetID().."Minimized"];
		if ( minimizedFrame ) then
			minimizedFrame.selectedColorTable = self.selectedColorTable;
			FCFMin_UpdateColors(minimizedFrame);
		end
	end

	FCF_FadeInChatFrame = function() end
	FCF_FadeOutChatFrame = function() end

	hooksecurefunc("FCFTab_UpdateColors", ChatFrameColor) 
	for i=2,7 do 
	ChatFrameColor(_G["ChatFrame" .. i .. "Tab"]) 
	end 

	FCF_HideOnFadeFinished = function() end

	FCF_StartAlertFlash = function(self) 
		local chatTab = _G[self:GetName().."Tab"]
		chatTab:GetFontString():SetAlpha(1)
	end
	FCF_StopAlertFlash = function(self) 
		local chatTab = _G[self:GetName().."Tab"]
		chatTab:GetFontString():SetAlpha(1)
	end

	--]]
end)








--------备用------------------------


--[[--
FCF_StartAlertFlash = function(chatFrame)
	local chatTab = _G[chatFrame:GetName().."Tab"]

	if chatFrame.minFrame then
		if not anims[chatFrame.minFrame] then
			anims[chatFrame.minFrame] = chatFrame.minFrame.glow:CreateAnimationGroup()

			local fade1 = anims[chatFrame.minFrame]:CreateAnimation("Alpha")
			fade1:SetDuration(1)
			fade1:SetFromAlpha(0)
			fade1:SetToAlpha(1)
			fade1:SetOrder(1)

			local fade2 = anims[chatFrame.minFrame]:CreateAnimation("Alpha")
			fade2:SetDuration(1)
			fade2:SetFromAlpha(1)
			fade2:SetToAlpha(0)
			fade2:SetOrder(2)
		end
		chatFrame.minFrame.glow:Show()
		chatFrame.minFrame.glow:SetAlpha(0)
		anims[chatFrame.minFrame]:SetLooping("REPEAT")
		anims[chatFrame.minFrame]:Play()
		--chatFrame.minFrame.alerting = true
		alerting[chatFrame.minFrame] = true
	end

	if not anims[chatTab.glow] then
		anims[chatTab.glow] = chatTab.glow:CreateAnimationGroup()

		local fade1 = anims[chatTab.glow]:CreateAnimation("Alpha")
		fade1:SetDuration(1)
		fade1:SetFromAlpha(0)
		fade1:SetToAlpha(1)
		fade1:SetOrder(1)

		local fade2 = anims[chatTab.glow]:CreateAnimation("Alpha")
		fade2:SetDuration(1)
		fade2:SetFromAlpha(1)
		fade2:SetToAlpha(0)
		fade2:SetOrder(2)
	end
	chatTab.glow:Show()
	chatTab.glow:SetAlpha(0)
	anims[chatTab.glow]:SetLooping("REPEAT")
	anims[chatTab.glow]:Play()
	--chatTab.alerting = true
	alerting[chatTab] = true


	-- START function FCFTab_UpdateAlpha(chatFrame)
	local mouseOverAlpha, noMouseAlpha = 0, 0
	if not chatFrame.isDocked or chatFrame == FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) then
		mouseOverAlpha = 1.0 --CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA
		noMouseAlpha = 0.4 -- CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA
	else
		mouseOverAlpha = 1.0 -- CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA
		noMouseAlpha = 1.0 -- CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA
	end
	if chatFrame.hasBeenFaded then
		chatTab:SetAlpha(mouseOverAlpha)
	else
		chatTab:SetAlpha(noMouseAlpha)
	end
	--END function FCFTab_UpdateAlpha(chatFrame)

	--FCFDockOverflowButton_UpdatePulseState(GENERAL_CHAT_DOCK.overflowButton)
end

FCF_StopAlertFlash = function(chatFrame)
	local chatTab = _G[chatFrame:GetName().."Tab"]

	if chatFrame.minFrame then
		if anims[chatFrame.minFrame] then
			anims[chatFrame.minFrame]:Stop()
		end
		chatFrame.minFrame.glow:Hide()
		--chatFrame.minFrame.alerting = false
		alerting[chatFrame.minFrame] = nil
	end

	if anims[chatTab.glow] then
		anims[chatTab.glow]:Stop()
	end
	chatTab.glow:Hide()
	--chatTab.alerting = false
	alerting[chatTab] = nil

	-- START function FCFTab_UpdateAlpha(chatFrame)
	local mouseOverAlpha, noMouseAlpha = 0, 0
	if not chatFrame.isDocked or chatFrame == FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) then
		mouseOverAlpha = 1.0 --CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA
		noMouseAlpha = 0.4 -- CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA
	else
		mouseOverAlpha = 0.6 --CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA
		noMouseAlpha = 0.2 --CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA
	end
	if chatFrame.hasBeenFaded then
		chatTab:SetAlpha(mouseOverAlpha)
	else
		chatTab:SetAlpha(noMouseAlpha)
	end
	--END function FCFTab_UpdateAlpha(chatFrame)

	--FCFDockOverflowButton_UpdatePulseState(GENERAL_CHAT_DOCK.overflowButton)
end
--]]