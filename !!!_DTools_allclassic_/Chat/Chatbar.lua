local AddonName, ns =...
local L = ns.L

local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")	--PLAYER_LOGIN导致界面行为失败 ADDON_LOADED导致重复生成
Event:SetScript("OnEvent", function(...)


	if DToolsDB.cfp == nil or DToolsDB.cfp == false then return end

	
	--输入框位置调整
	local chatbarbottom
	if DToolsDB.cfbb == true then
		chatbarbottom = true
	else
		chatbarbottom = false
	end


--频道选择条位置瞄点
local ChatBarOffsetX = 0--相对于默认位置的X坐标偏移
local ChatBarOffsetY = 0--相对于默认位置的Y坐标偏移
local chatFrame = SELECTED_DOCK_FRAME--聊天框架
local inputbox = chatFrame.editBox--输入框

COLORSCHEME_BORDER = { 0.3, 0.3, 0.3, 1 }--边框颜色

--主框架初始化
local chatbar = CreateFrame("Frame", "ChatBarFrame", UIParent)

	-- chatbar:SetFrameStrata("HIGH")
	chatbar:SetSize(450,30)
	if chatFrame then
		if chatbarbottom then
			inputbox:ClearAllPoints()
			inputbox:SetPoint("BOTTOMLEFT", chatFrame, "BOTTOMLEFT", -35, -37)
			inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", -15, -37)
			-- inputbox:SetPoint("BOTTOMLEFT", chatFrame, "BOTTOMLEFT", -35, -58)	--留出按钮位置
			-- inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", -2, -58)
			-- inputbox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", -4, 21)	--输入框在上面
			-- inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", -17, 21)
			chatbar:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX - 36, ChatBarOffsetY - 6 )
		else
			inputbox:ClearAllPoints()
			inputbox:SetPoint("BOTTOMLEFT", chatFrame, "BOTTOMLEFT", -35, -37)
			inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", -15, -37)
			-- inputbox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", -4, 21)	--输入框在上面
			-- inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", -17, 21)
			chatbar:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", ChatBarOffsetX - 32, ChatBarOffsetY + 21)
		end
	else
		chatbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20, 20)
	end


--"说(/s)"--
local ChannelSay = CreateFrame("Button", "ChannelSay", chatbar);
ChannelSay:SetWidth(28);--按钮宽度
ChannelSay:SetHeight(28);--按钮高度
ChannelSay:SetPoint("LEFT", chatbar, "LEFT", 30, 0);	--锚点
ChannelSay:RegisterForClicks("AnyUp");
ChannelSay:SetScript("OnClick", function() ChannelSay_OnClick() end)

ChannelSayText = ChannelSay:CreateFontString("ChannelSayText", "OVERLAY")
ChannelSayText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")--字体设置
ChannelSayText:SetJustifyH("CENTER")
ChannelSayText:SetWidth(28)
ChannelSayText:SetHeight(28)
ChannelSayText:SetText(L.say or "说")--显示的文字
ChannelSayText:SetPoint("CENTER", 0, 0)
ChannelSayText:SetTextColor(1, 1, 1)--颜色

function ChannelSay_OnClick()
	  ChatFrame_OpenChat("/s ", chatFrame)
end

--"喊(/y)"--
local ChannelYell = CreateFrame("Button", "ChannelYell", chatbar);
ChannelYell:SetWidth(28);
ChannelYell:SetHeight(28);
ChannelYell:SetPoint("topright", ChannelSay, "TOPright", 30, 0);
ChannelYell:RegisterForClicks("AnyUp");
ChannelYell:SetScript("OnClick", function() ChannelYell_OnClick() end)

ChannelYellText = ChannelYell:CreateFontString("ChannelYellText", "OVERLAY")
ChannelYellText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
ChannelYellText:SetJustifyH("CENTER")
ChannelYellText:SetWidth(28)
ChannelYellText:SetHeight(28)
ChannelYellText:SetText(L.yell or "喊")
ChannelYellText:SetPoint("CENTER", 0, 0)
ChannelYellText:SetTextColor(275/275, 64/275, 64/275)

function ChannelYell_OnClick()
	  ChatFrame_OpenChat("/y ", chatFrame)
end


--"队伍(/p)"--
local ChannelParty = CreateFrame("Button", "ChannelParty", chatbar);
ChannelParty:SetWidth(28);
ChannelParty:SetHeight(28);
ChannelParty:SetPoint("topright", ChannelYell, "TOPright", 30, 0);
ChannelParty:RegisterForClicks("AnyUp");
ChannelParty:SetScript("OnClick", function() ChannelParty_OnClick() end)

ChannelPartyText = ChannelParty:CreateFontString("ChannelPartyText", "OVERLAY")
ChannelPartyText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
ChannelPartyText:SetJustifyH("CENTER")
ChannelPartyText:SetWidth(28)
ChannelPartyText:SetHeight(28)
ChannelPartyText:SetText(L.party or "队")
ChannelPartyText:SetPoint("CENTER", 0, 0)
ChannelPartyText:SetTextColor(170/275, 170/275, 275/275)

function ChannelParty_OnClick()
	  ChatFrame_OpenChat("/p ", chatFrame)
end

--"副本(/i)"--
local ChannelInstance = CreateFrame("Button", "ChannelInstance", chatbar);
ChannelInstance:SetWidth(28);
ChannelInstance:SetHeight(28);
ChannelInstance:SetPoint("topright", ChannelParty, "TOPright", 30, 0);
ChannelInstance:RegisterForClicks("AnyUp");
ChannelInstance:SetScript("OnClick", function() ChannelInstance_OnClick() end)

ChannelInstanceText = ChannelInstance:CreateFontString("ChannelInstanceText", "OVERLAY")
ChannelInstanceText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
ChannelInstanceText:SetJustifyH("CENTER")
ChannelInstanceText:SetWidth(28)
ChannelInstanceText:SetHeight(28)
ChannelInstanceText:SetText(L.instance or "副")
ChannelInstanceText:SetPoint("CENTER", 0, 0)
ChannelInstanceText:SetTextColor(275/275, 127/275, 0)

function ChannelInstance_OnClick()
	  ChatFrame_OpenChat("/bg ", chatFrame)
end

--"团队(/raid)"--
local ChannelRaid = CreateFrame("Button", "ChannelRaid", chatbar);
ChannelRaid:SetWidth(28);
ChannelRaid:SetHeight(28);
ChannelRaid:SetPoint("topright", ChannelInstance, "TOPright", 30, 0);
ChannelRaid:RegisterForClicks("AnyUp");
ChannelRaid:SetScript("OnClick", function() ChannelRaid_OnClick() end)

ChannelRaidText = ChannelRaid:CreateFontString("ChannelRaidText", "OVERLAY")
ChannelRaidText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
ChannelRaidText:SetJustifyH("CENTER")
ChannelRaidText:SetWidth(28)
ChannelRaidText:SetHeight(28)
ChannelRaidText:SetText(L.raid or "团")
ChannelRaidText:SetPoint("CENTER", 0, 0)
ChannelRaidText:SetTextColor(275/275, 127/275, 0)

function ChannelRaid_OnClick()
	  ChatFrame_OpenChat("/raid ", chatFrame)
end

--"公会(/g)"--
local ChannelGuild = CreateFrame("Button", "ChannelGuild", chatbar);
ChannelGuild:SetWidth(28);
ChannelGuild:SetHeight(28);
ChannelGuild:SetPoint("topright", ChannelRaid, "TOPright", 30, 0);
ChannelGuild:RegisterForClicks("AnyUp");
ChannelGuild:SetScript("OnClick", function() ChannelGuild_OnClick() end)

ChannelGuildText = ChannelGuild:CreateFontString("ChannelGuildText", "OVERLAY")
ChannelGuildText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
ChannelGuildText:SetJustifyH("CENTER")
ChannelGuildText:SetWidth(28)
ChannelGuildText:SetHeight(28)
ChannelGuildText:SetText(L.guild or "会")
ChannelGuildText:SetPoint("CENTER", 0, 0)
ChannelGuildText:SetTextColor(64/275, 275/275, 64/275)

function ChannelGuild_OnClick()
	  ChatFrame_OpenChat("/g ", chatFrame)
end

--"综合频道(/1)"--
local Channel_01 = CreateFrame("Button", "Channel_01", chatbar);
Channel_01:SetWidth(28);
Channel_01:SetHeight(28);
Channel_01:SetPoint("topright", ChannelGuild, "TOPright", 30, 0);
Channel_01:RegisterForClicks("AnyUp");
Channel_01:SetScript("OnClick", function() Channel_01_OnClick() end)

Channel_01Text = Channel_01:CreateFontString("Channel_01Text", "OVERLAY")
Channel_01Text:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
Channel_01Text:SetJustifyH("CENTER")
Channel_01Text:SetWidth(28)
Channel_01Text:SetHeight(28)
Channel_01Text:SetText(L.general1 or "综")
Channel_01Text:SetPoint("CENTER", 0, 0)
Channel_01Text:SetTextColor(210/275, 190/275, 140/275)

function Channel_01_OnClick()
	local jiaoyi, _, _ = GetChannelName(L.general2 or "综合")
	if jiaoyi == 0 then print(L.general3 or "你没有综合频道") return end
	ChatFrame_OpenChat("/"..jiaoyi.."", chatFrame)
end

--"交易频道(/2)"--
local Channel_02 = CreateFrame("Button", "Channel_02", chatbar);
Channel_02:SetWidth(28);
Channel_02:SetHeight(28);
Channel_02:SetPoint("topright", Channel_01, "TOPright", 30, 0);
Channel_02:RegisterForClicks("AnyUp");
Channel_02:SetScript("OnClick", function() Channel_02_OnClick() end)

Channel_02Text = Channel_02:CreateFontString("Channel_02Text", "OVERLAY")
Channel_02Text:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
Channel_02Text:SetJustifyH("CENTER")
Channel_02Text:SetWidth(28)
Channel_02Text:SetHeight(28)
Channel_02Text:SetText(L.trade1 or "交")
Channel_02Text:SetPoint("CENTER", 0, 0)
Channel_02Text:SetTextColor(275/275, 130/275, 130/275)

function Channel_02_OnClick()
	local jiaoyi, _, _ = GetChannelName(L.trade2 or "交易")
	if jiaoyi == 0 then print(L.trade3 or "你不在交易频道, 请去主城加入") return end
	ChatFrame_OpenChat("/"..jiaoyi.."", chatFrame)
end


--"寻求组队"--
local Channel_04 = CreateFrame("Button", "Channel_04", chatbar);
Channel_04:SetWidth(28);
Channel_04:SetHeight(28);
Channel_04:SetPoint("topright", Channel_02, "TOPright", 30, 0);
Channel_04:RegisterForClicks("AnyUp");
Channel_04:SetScript("OnClick", function(self, button) Channel_04_OnClick(self, button) end)

Channel_04Text = Channel_04:CreateFontString("Channel_04Text", "OVERLAY")
Channel_04Text:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
Channel_04Text:SetJustifyH("CENTER")
Channel_04Text:SetWidth(28)
Channel_04Text:SetHeight(28)
Channel_04Text:SetText(L.lookingforgroup1 or "组")
Channel_04Text:SetPoint("CENTER", 0, 0)
Channel_04Text:SetTextColor(200/275, 275/275, 150/275)

function Channel_04_OnClick(self, button)
	if button == "RightButton" then
		local _, channelName, _ = GetChannelName(L.lookingforgroup2 or "寻求组队")
		if channelName == nil then
			JoinPermanentChannel(L.salookingforgroupy2 or "寻求组队", nil, 1, 1)
			ChatFrame_RemoveMessageGroup(chatFrame, "CHANNEL")
			ChatFrame_AddChannel(chatFrame, L.lookingforgroup2 or "寻求组队")
			print("|cff00d200"..(L.lookingforgroup3 or "已加入寻求组队").."|r")
		else
			LeaveChannelByName(L.lookingforgroup2 or "寻求组队")
			print("|cffd20000"..(L.lookingforgroup4 or "已离开寻求组队").."|r")
		end
	else
		local channel, _, _ = GetChannelName(L.lookingforgroup2 or "寻求组队")
		ChatFrame_OpenChat("/"..channel.."", chatFrame)
	end
end

--"大脚世界频道(/0)"--
local Channel_05 = CreateFrame("Button", "Channel_05", chatbar);
Channel_05:SetWidth(28);
Channel_05:SetHeight(28);
Channel_05:SetPoint("topright", Channel_04, "TOPright", 30, 0);
Channel_05:RegisterForClicks("AnyUp");
Channel_05:SetScript("OnClick", function(self, button) Channel_05_OnClick(self, button) end)

Channel_05Text = Channel_05:CreateFontString("Channel_05Text", "OVERLAY")
Channel_05Text:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
Channel_05Text:SetJustifyH("CENTER")
Channel_05Text:SetWidth(28)
Channel_05Text:SetHeight(28)
Channel_05Text:SetText(L.world1 or "世")
Channel_05Text:SetPoint("CENTER", 0, 0)
Channel_05Text:SetTextColor(210/275, 190/275, 140/275)

function Channel_05_OnClick(self, button)
	if button == "RightButton" then
		local _, channelName, _ = GetChannelName(L.world2 or "大脚世界频道")
		if channelName == nil then
			JoinPermanentChannel(L.world2 or "大脚世界频道", nil, 1, 1)
			ChatFrame_RemoveMessageGroup(chatFrame, "CHANNEL")
			ChatFrame_AddChannel(chatFrame, L.world2 or "大脚世界频道")
			print("|cff00d200"..(L.world3 or "已加入世界频道").."|r")
		else
			LeaveChannelByName(L.world2 or "大脚世界频道")
			print("|cffd20000"..(L.world4 or "已离开世界频道").."|r")
		end
	else
		local channel, _, _ = GetChannelName(L.world2 or "大脚世界频道")
		ChatFrame_OpenChat("/"..channel.."", chatFrame)
	end
end

--"属性通报"--
local report = CreateFrame("Button", nil, chatbar)
report:SetScript("OnClick", ReportStat)
report:SetWidth(28);
report:SetHeight(28);
report:SetPoint("topright", Channel_05, "TOPright", 30, 0);
reportText =report:CreateFontString("reportText", "OVERLAY")
reportText:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE SLUG")
reportText:SetJustifyH("CENTER")
reportText:SetWidth(28)
reportText:SetHeight(28)
reportText:SetText(L.rep or "报")
reportText:SetPoint("CENTER", 0, 0)
reportText:SetTextColor(275/275, 275/275, 0/275)
report:SetScript("OnClick", function()
	local S_C = UnitStat("player", 1)							--力量
	local AG_C = UnitStat("player", 2)							--敏捷
	local IN_C = UnitStat("player", 4)							--智力
	if S_C > AG_C and S_C > IN_C then
		S = " "..(L.str or " 力量")..":"..S_C
	elseif AG_C > S_C and AG_C > IN_C then
		S = " "..(L.agi or " 敏捷")..":"..AG_C
	elseif IN_C > S_C and IN_C > AG_C then
		S = " "..(L.int or " 智力")..":"..IN_C
	end
	local stat =
	{
		[1] = (L.class or "职业")..":"..UnitClass("player"),
		[2] = (L.eql or "装等")..":"..format("%.1F", select(2, GetAverageItemLevel())).."/"..format("%.1F", select(1, GetAverageItemLevel())),
		-- [3] = (L.spec or "天赋")..":"..select(2, GetSpecializationInfo(GetSpecialization())),		--天赋
		[3] = S,
		[4] = (L.cri or "爆击")..":"..format("%.2F%%", GetCritChance()),
		[5] = (L.has or "急速")..":"..format("%.2F%%", GetHaste()),
		[6] = (L.mas or "精通")..":"..format("%.2F%%", GetMasteryEffect()),
		-- [8] = (L.ver or "全能")..":"..format("%.2F%%", GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE))
		--[1] = "ID:"..UnitName("player"),
	}
	local line = ""
	for i=1, #stat do
		line = line..stat[i].." "
	end

	ChatFrame_OpenChat(line, chatFrame)
end)


--Roll--
local roll = CreateFrame("Button", "rollMacro", chatbar)
roll:SetWidth(23);
roll:SetHeight(23);
roll:SetPoint("BOTTOM", report, "BOTTOM", 32, 1);
roll:RegisterForClicks("AnyUp");
roll:SetScript("OnClick", function() Roll_OnClick() end)
rollT = roll:CreateTexture("Button", nil, frame)
rollT:SetWidth(23)
rollT:SetHeight(23)
rollT:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
rollT:SetPoint("CENTER", 0, 0)

function Roll_OnClick()
	RandomRoll(1, 100)
end


--"表情"--
local ChatEmote = CreateFrame("Button", "ChatEmote", chatbar);
ChatEmote:SetWidth(33);
ChatEmote:SetHeight(33);
ChatEmote:SetPoint("BOTTOM", roll, "BOTTOM", 34, -1);
ChatEmote:RegisterForClicks("AnyUp");
ChatEmote:SetScript("OnClick", function() ChatEmote_OnClick() end)
ChatEmoteT = ChatEmote:CreateTexture("Button", nil, frame)
ChatEmoteT:SetWidth(28)
ChatEmoteT:SetHeight(28)
ChatEmoteT:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\emotes\\evil.tga")
ChatEmoteT:SetPoint("CENTER", 0, 0)

function ChatEmote_OnClick()
	  ToggleFrame(CustomEmoteFrame);
end


end)