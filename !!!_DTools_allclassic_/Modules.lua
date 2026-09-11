local AddonName, ns =...
local L = ns.L
local mediapath = "Interface\\AddOns\\"..AddonName.."\\media\\"

-- local CTBRFrame = CreateFrame("Frame","CTBRFrame",UIParent)
-- CTBRFrame:SetPoint("BOTTOMRIGHT", ChatFrame1Background, "TOPRIGHT", 13, -20)
-- CTBRFrame:SetSize(80, 80)
-- CTBRFrame:EnableMouse(false)

local combatFrame = CreateFrame("Frame", "CombatTimer", UIParent)
combatFrame:SetSize(64, 20)
combatFrame:SetPoint("TOPRIGHT", ChatFrame1Background, "TOPRIGHT", -0.5, 0)
-- combatFrame:SetPoint("BOTTOM", CTBRFrame, "BOTTOM", 0, 0)
combatFrame:SetFrameStrata("MEDIUM")
combatFrame:EnableMouse(false)

-- local battleFrame = CreateFrame("Frame", "BattleResTimer", UIParent, "CooldownViewerBuffIconItemTemplate")
-- battleFrame:SetSize(42, 42)
-- battleFrame:SetPoint("BOTTOMRIGHT", ChatFrame1Background, "TOPRIGHT", 0, 2)
-- -- battleFrame:SetPoint("BOTTOM", combatFrame, "TOP", 0, 2)
-- battleFrame:SetFrameStrata("MEDIUM")
-- -- battleFrame:EnableMouse(false)

ns.event("PLAYER_LOGIN", function()

	--UI缩放锁定
	if DToolsDB.uisl == true then
		uisl = CreateFrame("Frame")
		uisl:RegisterEvent("PLAYER_ENTERING_WORLD")
		uisl:SetScript("OnEvent", function(self, event)
			local uus = tonumber(GetCVar("useUiScale"))
			local us = tonumber(GetCVar("uiScale"))
			if uus ~= 1 or us ~= 0.65 then
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", 0.65)-- 1080P = 0.711 1440P = 0.67 2106P = 0.71
			-- DToolsReset()
			end
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end)
	end

	----关闭屏幕错误信息提示(红字)
	-- if DToolsDB.???? == true then
	--  UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	-- else
	--  UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	-- end


	--头像渐隐效果（不需要渐隐效果的删除这段代码）----------------
	if DToolsDB.una == true and DToolsDB.dduf == true then
		local Event = CreateFrame("Frame")
		Event:RegisterEvent("UNIT_HEALTH")
		Event:RegisterEvent("UNIT_POWER_UPDATE")
		Event:RegisterEvent("PLAYER_ENTERING_WORLD", Update)
		Event:RegisterEvent("PLAYER_REGEN_DISABLED", Update)
		Event:RegisterEvent("PLAYER_REGEN_ENABLED")
		Event:RegisterEvent("UNIT_TARGET", Update)
		Event:RegisterEvent("PLAYER_TARGET_CHANGED")
		Event:SetScript("OnEvent", function(self, event, ...)
			local InCombat, Target = InCombatLockdown(), UnitExists("target")
			if event == "PLAYER_ENTERING_WORLD" and (UnitHealth("player")/UnitHealthMax("player") == 1) then
				PlayerFrame:SetAlpha(0.2)----登陆后满血头像透明度为0.2
			end
			if (InCombat or Target) then
					PlayerFrame:SetAlpha(1)----进入战斗头像透明度为1 and (UnitHealth("player")/UnitHealthMax("player") == 1)
			end
				if (not InCombat or not Target) then
					local _, class = UnitClass("player");
					if not (class == "ROGUE") or not (class == "WARRIOR") then
						if (UnitHealth("player")/UnitHealthMax("player") == 1) and (UnitPower("player")/UnitPowerMax("player") == 1) and (not InCombat and not Target) then
							PlayerFrame:SetAlpha(0.2)---血量不满 头像透明度为1
						else
							PlayerFrame:SetAlpha(1)
						end
					end
				if (class == "ROGUE") or (class == "WARRIOR") then
					if (UnitHealth("player")/UnitHealthMax("player") == 1) and (not InCombat and not Target) then
						PlayerFrame:SetAlpha(0.2)---不在战斗且无目标且血量满 头像透明度为0.2
					else
						PlayerFrame:SetAlpha(1)
					end
				end
			end
		end)
	end
	--]]

	--自动修理部分(优先使用公会修理)
	if DToolsDB.aur == true then
		-- local g = CreateFrame("Frame")
		-- g:RegisterEvent("MERCHANT_SHOW")
		-- g:SetScript("OnEvent", function()
		ns.event("MERCHANT_SHOW", function()
			--if (diminfo.AutoRepair == true and CanMerchantRepair()) then
			if CanMerchantRepair() then
				local cost = GetRepairAllCost()
				local gbwm = GetGuildBankWithdrawMoney()-cost
				local gbk = GetGuildBankMoney()
				if cost > 0 then
					local money = GetMoney()
					if IsInGuild() then
						local guildMoney = GetGuildBankWithdrawMoney()
						if guildMoney > GetGuildBankMoney() then
							guildMoney = GetGuildBankMoney()
						end
						if guildMoney >= cost and CanGuildBankRepair() then
							RepairAllItems(1)
							PlaySound("7994")
							print("|cff00FFFF"..(L.guildrepair or "本次使用公会维修")..": |r"..GetCoinTextureString(cost))
							if gbk >= gbwm then
								print((L.guildra or "剩余可用公修")..": "..GetCoinTextureString(gbwm))
							else
								print((L.guildra or "剩余可用公修")..": "..GetCoinTextureString(gbk))
							end
							return
						end
					end
					if money > cost then
						PlaySound("7994")
						RepairAllItems()
						print("|cffFF0000"..(L.selfrepair or "自费修理")..": |r"..GetCoinTextureString(cost))
					else
						print("|cff99CCFF"..(L.norepair or "没钱修装备了。").."|r")
					end
				end
			end
		end)
	end
	--]]

	--自动卖灰
	if DToolsDB.aus == true then

		-- local f = CreateFrame("Frame")
		-- f:RegisterEvent("MERCHANT_SHOW")
		-- f:SetScript("OnEvent", function(...)
		ns.event("MERCHANT_SHOW", function()
			local p, N, c, n=0
				for b=0, 4 do
					for s=1, C_Container.GetContainerNumSlots (b) do
						n=C_Container.GetContainerItemLink(b, s)
							if n and string.find(n, "9d9d9d") then
								N={ GetItemInfo(n) }
								c=GetItemCount(n) p=p+(N[11]*c)C_Container.UseContainerItem(b, s)
								--print(n)
							end
					end
				end
			if p ~= 0 then
				print("|cff44CCFF"..(L.sellg or "售卖垃圾")..": |r"..GetCoinText(p))
			end
		end)

	end
	--]]


	--成就自动截图
	if DToolsDB.aua == true then
		local function TakeScreen(delay, func, ...)
			local waitTable = {}
			local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
			waitFrame:SetScript("onUpdate", function(self, elapse)
				local count = #waitTable
				local i = 1
				while (i <= count) do
					local waitRecord = tremove(waitTable, i)
					local d = tremove(waitRecord, 1)
					local f = tremove(waitRecord, 1)
					local p = tremove(waitRecord, 1)
					if (d > elapse) then
						tinsert(waitTable, i, { d-elapse, f, p })
						i = i + 1
					else
						count = count-1
						f(unpack(p))
					end
				end
			end)
			tinsert(waitTable, { delay, func, {...}})
		end
		ns.event("ACHIEVEMENT_EARNED", function()
			TakeScreen(1, Screenshot)
		end)


		-- local function OnEvent(...)
		-- 	TakeScreen(1, Screenshot)
		-- end
		-- local AchScreen = CreateFrame("Frame")
		-- AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
		-- AchScreen:SetScript("OnEvent", OnEvent)
	end
	--]]


	--密语自动邀请
	if DToolsDB.aug == true then
	local f = CreateFrame("frame")
	--f:RegisterEvent("CHAT_MSG_SAY")				--说频道
	--f:RegisterEvent("CHAT_MSG_YELL")			--喊话频道
	--f:RegisterEvent("CHAT_MSG_Guild")			--公会频道
	f:RegisterEvent("CHAT_MSG_WHISPER")			--密语频道
	f:RegisterEvent("CHAT_MSG_BN_WHISPER")		--战网密语频道
	f:SetScript("OnEvent", function(self, event, arg1, arg2, _, _, _, _, _, _, _, _, _, _, arg13)
		if (not IsInGroup() or UnitIsGroupLeader("player"))
			and GetNumGroupMembers() <40			--当队伍小于40人执行邀请
			and (arg1 == "1")			--自动邀请“1”
			or (arg1 == "组")			--自动邀请“组”--包含关键字改成or arg1:lower():match("组"))
		then
		if (event == "CHAT_MSG_BN_WHISPER") then
			local characterName = C_BattleNet.GetAccountInfoByID(arg13).gameAccountInfo.characterName
			local realmName = C_BattleNet.GetAccountInfoByID(arg13).gameAccountInfo.realmDisplayName
			if characterName and realmName then
			C_PartyInfo.InviteUnit(characterName.."-"..realmName)
			else
				print(L.hidoroff or "对方隐身或者无角色在线, 无法邀请")
			end
		else
			C_PartyInfo.InviteUnit(arg2)
		end
		end
	end)
	end
	--]]


	--快速拾取
	if DToolsDB.fsl == true then

		-- local faster = CreateFrame("Frame")
		-- faster:RegisterEvent("LOOT_READY")
		-- faster:SetScript("OnEvent", function(self, event, ...)
		ns.event("LOOT_READY", function()
		--Time delay
		local tDelay = 0
			if GetTime()-tDelay >= 0.3 then
				tDelay = GetTime()
				if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
					for i = GetNumLootItems(), 1, -1 do
						LootSlot(i)
					end
					tDelay = GetTime()
				end
			end
		end)
	end
	--]]


	--打斷提示
	if DToolsDB.fsl == true then
		-- local frame = CreateFrame("Frame", nil, UIParent)
		-- frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then 
			ns.event("COMBAT_LOG_EVENT_UNFILTERED", function()
				local type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, destRaidFlags, spellId = select(2, CombatLogGetCurrentEventInfo());
				if (type == "SPELL_INTERRUPT" and UnitGUID("player") == sourceGUID) then
					local _, myInterruptSkill, _, _, targetSpellName = select(12, CombatLogGetCurrentEventInfo())
					local msg = format("%s>%s<[%s]", L.cutin or "已打断", destName or "", targetSpellName)
					SendChatMessage(msg, "EMOTE");
				end
			end)
		else
			ns.event("COMBAT_LOG_EVENT_UNFILTERED", function()
				local type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, destRaidFlags, spellId = select(2, CombatLogGetCurrentEventInfo());
				if (type == "SPELL_INTERRUPT" and UnitGUID("player") == sourceGUID) then
					local extraSpellID = select(15, CombatLogGetCurrentEventInfo())
					local interruptedSpell = GetSpellLink(extraSpellID);
					local msg = format("%s>%s<%s", L.cutin or "已打断", destName or "", interruptedSpell)
					-- local msg = (L.cutin or "已打断")..">"..(destName or "").."<"..interruptedSpell
					-- local msg = (L.cutin or "已打断")..(destName or "")..interruptedSpell
					SendChatMessage(msg, "EMOTE");
				end
			end)
		end
	end
	--]]


	--语音播报
	if DToolsDB.vap == true then
		-- local Event = CreateFrame("Frame")
		-- Event:RegisterEvent("UNIT_AURA")
		-- Event:SetScript("OnEvent", function(unit, unitAuraUpdateInfo)
		ns.event("UNIT_AURA", function(unit, unitAuraUpdateInfo)
			if unitAuraUpdateInfo.addedAuras ~= nil then
				for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
					if unit == "player" and aura.spellId == 10060 then
						PlaySoundFile(mediapath.."v_bguanzhu.mp3", "Master")
					end
					-- if unit == "player" and aura.spellId == 388007 then
					-- 	PlaySoundFile(mediapath.."v_bzhongxia.mp3", "Master")
					-- end
					-- if unit == "player" and aura.spellId == 388010 then
					-- 	PlaySoundFile(mediapath.."v_bmuqiu.mp3", "Master")
					-- end
				end
			end
		end)


		local targetindex = GetRaidTargetIndex("player") or 0
		-- local Event = CreateFrame("Frame")
		-- Event:RegisterEvent("RAID_TARGET_UPDATE")
		-- Event:SetScript("OnEvent", function(unit, index)
		ns.event("RAID_TARGET_UPDATE", function(unit, index)
			if targetindex ~= GetRaidTargetIndex("player") then
				targetindex = GetRaidTargetIndex("player") or 0
				if targetindex == 1 then
					PlaySoundFile(mediapath.."v_yxinxin.mp3", "Master")
				elseif targetindex == 2 then
					PlaySoundFile(mediapath.."v_ydabin.mp3", "Master")
				elseif targetindex == 3 then
					PlaySoundFile(mediapath.."v_yzilin.mp3", "Master")
				elseif targetindex == 4 then
					PlaySoundFile(mediapath.."v_yshanjiao.mp3", "Master")
				elseif targetindex == 5 then
					PlaySoundFile(mediapath.."v_yyueliang.mp3", "Master")
				elseif targetindex == 6 then
					PlaySoundFile(mediapath.."v_yfankuai.mp3", "Master")
				elseif targetindex == 7 then
					PlaySoundFile(mediapath.."v_yhongcha.mp3", "Master")
				elseif targetindex == 8 then
					PlaySoundFile(mediapath.."v_ykulou.mp3", "Master")
				end
			end
		end)

		--吃鱼
		-- local T=CreateFrame("frame")
		-- T:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
		-- T:SetScript("OnEvent", function(_, _, msg)
		ns.event("CHAT_MSG_MONSTER_EMOTE", function(_, _, msg)
			if string.match(msg,"摆放了一桌") and string.match(msg,"供大家享用") then
				PlaySoundFile(mediapath.."v_dachan.ogg","Master")
			end
		end)
		
	end
	--]]


	--Shift设置焦点
	if DToolsDB.hsf == true and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		-----------shift+右键点击头像或者目标快速设置系统焦点，shift+右键点击空白区域则取消-------

		local modifier = "shift"--按住shift，也可设置为alt或者crtl
		local mouseButton = "2"--鼠标按键 1是左键、2是右键、3是中键

		local function SetFocusHotkey(frame)
			frame:SetAttribute(modifier.."-type"..mouseButton, "focus")
		end

		local function CreateFrame_Hook(type, name, parent, template)
			if name and template == "SecureUnitButtonTemplate" then
				SetFocusHotkey(_G[name])
			end
		end
		hooksecurefunc("CreateFrame", CreateFrame_Hook)

		--团队框架设焦点http://bbs.ngacn.cc/read.php?&tid=13684940&pid=281141400&to=1
		hooksecurefunc("CompactUnitFrame_UpdateName", function(frame, ...)
			if InCombatLockdown() then return end
			if frame then
			SetFocusHotkey(frame)
			end
		end)


		local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
		f:SetAttribute("type1", "macro")
		f:SetAttribute("macrotext", "/focus [target=mouseover]")
		f:RegisterForClicks("AnyDown", "AnyUp")
		SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton")


		local duf = {
			PetFrame,
			PlayerFrame,
			PartyMemberFrame1,
			PartyMemberFrame2,
			PartyMemberFrame3,
			PartyMemberFrame4,
			PartyMemberFrame1PetFrame,
			PartyMemberFrame2PetFrame,
			PartyMemberFrame3PetFrame,
			PartyMemberFrame4PetFrame,
			PartyMemberFrame1TargetFrame,
			PartyMemberFrame2TargetFrame,
			PartyMemberFrame3TargetFrame,
			PartyMemberFrame4TargetFrame,
			TargetFrame,
			TargetFrameToT,
			TargetFrameToTTargetFrame,
			Boss1TargetFrame,
			Boss2TargetFrame,
			Boss3TargetFrame,
			Boss4TargetFrame,
			Boss5TargetFrame,
			ArenaEnemyFrame1,
			ArenaEnemyFrame2,
			ArenaEnemyFrame3,
			ArenaPrepFrame1,
			ArenaPrepFrame2,
			ArenaPrepFrame3,
			ArenaFrame1,
			ArenaFrame2,
			ArenaFrame3,
			DiabloPlayerFrame,
			DiabloPetFrame,
			DiabloPetTargetFrame,
		}

		for i, frame in pairs(duf) do
			SetFocusHotkey(frame)
		end
	end
	--]]


	--字体美化
	if DToolsDB.sfu == true then
		--系统字体样式
		-- SystemFont_Tiny:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE SLUG")
		-- -- SystemFont_Tiny:SetTextColor(0, 0, 0)
		-- -- SystemFont_Tiny:SetShadowColor(0.4, 0.4, 0.4)
		-- -- SystemFont_Tiny:SetShadowOffset(0, 0)
		-- -- SystemFont_Tiny:SetAlpha(0.75)

		-- SystemFont_Small:SetFont(STANDARD_TEXT_FONT, 13, "")	--成就内容

		SystemFont_Outline_Small:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE SLUG")		--条数字等

		-- SystemFont_Outline:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE SLUG")

		-- SystemFont_Shadow_Small:SetFont(STANDARD_TEXT_FONT, 13, "")		--各种小标题 聊天标题 BUFF持续时间等

		-- SystemFont_InverseShadow_Small:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE SLUG")


		-- SystemFont_Med1:SetFont(STANDARD_TEXT_FONT, 14, "")	--技能书小字体 目标板

		SystemFont_Shadow_Med1:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE SLUG")	--按钮

		-- SystemFont_Med2:SetFont(STANDARD_TEXT_FONT, 15, "")	--书信

		SystemFont_Shadow_Med2:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE SLUG")	--各种副标题

		-- SystemFont_Med3:SetFont(STANDARD_TEXT_FONT, 13, "") --页码

		SystemFont_Shadow_Med3:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE SLUG")	--成就标题

		-- SystemFont_Large:SetFont(STANDARD_TEXT_FONT, 13, "")	--技能书 公告板标题

		-- SystemFont_Shadow_Large:SetFont(STANDARD_TEXT_FONT, 17, "OUTLINE SLUG") --系统菜单
		-- SystemFont_Shadow_Large:SetShadowColor(0.2, 0.2, 0.2)
		-- SystemFont_Shadow_Large:SetShadowOffset(1, -1)

		SystemFont_Huge1:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE SLUG")
		SystemFont_Huge1:SetShadowOffset(0, -0)

		SystemFont_Shadow_Huge1:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE SLUG")
		SystemFont_Shadow_Huge1:SetShadowOffset(0, -0)

		SystemFont_OutlineThick_Huge2:SetFont(STANDARD_TEXT_FONT, 22, "THICKOUTLINE")

		SystemFont_Shadow_Huge3:SetFont(STANDARD_TEXT_FONT, 25, "OUTLINE SLUG")
		SystemFont_Shadow_Huge3:SetShadowOffset(0, -0)

		SystemFont_OutlineThick_Huge4:SetFont(STANDARD_TEXT_FONT, 26, "THICKOUTLINE")

		SystemFont_OutlineThick_WTF:SetFont(STANDARD_TEXT_FONT, 45, "THICKOUTLINE")

		ReputationDetailFont:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE SLUG")
		ReputationDetailFont:SetShadowOffset(0, -0)

		FriendsFont_Normal:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE SLUG")
		FriendsFont_Normal:SetShadowOffset(0, -0)

		FriendsFont_Large:SetFont(STANDARD_TEXT_FONT, 17, "OUTLINE SLUG")
		FriendsFont_Large:SetShadowOffset(0, -0)

		FriendsFont_UserText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE SLUG")
		FriendsFont_UserText:SetShadowOffset(0, -0)

		GameFont_Gigantic:SetFont(STANDARD_TEXT_FONT, 41, "OUTLINE SLUG")
		--GameFont_Gigantic:SetTextColor(1.0, 0.82, 0)
		--GameFont_Gigantic:SetShadowColor(0, 0, 0)
		GameFont_Gigantic:SetShadowOffset(0, -0)


		--聊天字体
		ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE SLUG")--输入框字体 預設值：14
		CHAT_FONT_HEIGHTS = {
				[1] = 12,
				[2] = 13,
				[3] = 14,
				[4] = 15,
				[5] = 16,
				[6] = 17,
				[7] = 18,
				[8] = 19,
				[9] = 20,
			};
		local function skinChat(self)
			local fontName, fontSize, fontFlags = self:GetFont()
			self:SetFont(fontName, fontSize, "OUTLINE SLUG")
		end
		for i = 1, NUM_CHAT_WINDOWS do
			skinChat(_G["ChatFrame"..i])
		end

		---------------------
		--BUFF&DEBUFF优化
		if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			local function Buff(self)
				self.Duration:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE SLUG")	--时间文字大小
				self.Duration:SetPoint("BOTTOMLEFT", -2, 0);
				self.Duration:SetPoint("BOTTOMRIGHT", 4, 0);
				-- local overlay = CreateFrame("Frame", nil, self)
				-- overlay:SetAllPoints()
				-- if self.Duration then self.Duration:SetParent(overlay) end
				-- --显示N/A--
				-- if ( self.buttonInfo.expirationTime == 0 ) then
				-- 	self.Duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE SLUG")
				-- 	self.Duration:SetText("|cff00ff00N/A|r");
				-- 	self.Duration:SetPoint("BOTTOMLEFT", -2, 3);
				-- 	self.Duration:SetPoint("BOTTOMRIGHT", 4, 3);
				-- 	self.Duration:Show();
				-- end

				self.Count:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE SLUG")
				self.Count:SetPoint("BOTTOMRIGHT", 1, 12)
				-- -- self.Icon:SetTexCoord(0.05, 0.96, 0.05, 0.93)
				-- local normalTexture = self:CreateTexture(nil, "OVERLAY", nil)
				-- -- normalTexture:SetSize(self:GetSize())
				-- -- normalTexture:SetAllPoints()
				-- normalTexture:SetPoint("TOPLEFT", 0, 0)
				-- normalTexture:SetPoint("BOTTOMRIGHT", 0, 10)
				-- normalTexture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\button_dragon")
				-- -- normalTexture:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b, 1)
				-- normalTexture:SetVertexColor(0, 0, 0, 1)
			end

			local function Debuff(self)
				self.Duration:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE SLUG")	--时间文字大小
				self.Duration:SetPoint("BOTTOMLEFT", -2, 0);
				self.Duration:SetPoint("BOTTOMRIGHT", 4, 0);
				self.Count:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE SLUG")
				self.Count:SetPoint("BOTTOMRIGHT", 1, 12)
				-- --显示N/A--
				-- if ( self.buttonInfo.expirationTime == 0 ) then
				-- 	self.Duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE SLUG")
				-- 	self.Duration:SetText("|cff00ff00N/A|r");
				-- 	self.Duration:SetPoint("BOTTOMLEFT", -2, 3);
				-- 	self.Duration:SetPoint("BOTTOMRIGHT", 4, 3);
				-- 	self.Duration:Show();
				-- end

				-- self.DebuffBorder:SetAllPoints()
				-- self.DebuffBorder:SetPoint("TOPLEFT", -2, 2)
				-- self.DebuffBorder:SetPoint("BOTTOMRIGHT", 1, 9)
				-- normalTexture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\button_dragon")

			end

			local function UpBuffDate()
				for _, Bufficon in ipairs(BuffFrame.auraFrames) do
					hooksecurefunc(Bufficon, "Update", Buff);
				end
				for _, DeBufficon in ipairs(DebuffFrame.auraFrames) do
					if DeBufficon.OnUpdate then
						hooksecurefunc(DeBufficon, "Update", Debuff);
					end
				end
			end
			UpBuffDate();
		end

	end


	--[[任务追踪美化--污染动作条风险
	if DToolsDB.otu == true then
		if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
			--if InCombatLockdown() then return end
			--大标题美化
			SystemFont_Shadow_Med2:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE SLUG")
			--字体颜色
			local ClassColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass("player"))]--职业颜色
						-- OBJECTIVE_TRACKER_COLOR["Complete"] = { r = 0, g = 1, b = 0 }--完成字体颜色									!!!!!!!!!!!!!!!!!!!!战斗中导致界面行为失败
						HeaderTextsize = 16					---任务标题字体
						HeaderTextsteyl = "OUTLINE SLUG"
						Textsize = 15						---任务描述字体
						Textsteyl = "OUTLINE SLUG"

			hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block, text, questLogIndex, isQuestComplete, questID)
				--if InCombatLockdown() then return end
				block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b, 0.95);
				block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
				block.HeaderText.colorStyle = headerColorStyle;
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(1, 1, 1);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(1, 1, 1);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			hooksecurefunc(CAMPAIGN_QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block, text, questLogIndex, isQuestComplete, questID)
				--if InCombatLockdown() then return end
				block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b, 0.95);
				block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
				block.HeaderText.colorStyle = headerColorStyle;
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(1, 1, 1);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(1, 1, 1);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderEnter", function(_, block)
				--if InCombatLockdown() then return end
				block.isHighlighted = true;
				if (block.HeaderText) then
					block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b);
					block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
					block.HeaderText.colorStyle = headerColorStyle;
				end
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(1, 1, 1);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(1, 1, 1);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "OnBlockHeaderLeave", function(_, block)
				--if InCombatLockdown() then return end
				block.isHighlighted = nil;
				if (block.HeaderText) then
					block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b, 0.95);
					block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
					block.HeaderText.colorStyle = headerColorStyle;
				end
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(0.85, 0.85, 0.85);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(0.85, 0.85, 0.85);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "SetBlockHeader", function(_, block, text, questLogIndex, isQuestComplete, questID)
				--if InCombatLockdown() then return end
				block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b, 0.95);
				block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
				block.HeaderText.colorStyle = headerColorStyle;
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(1, 1, 1);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(1, 1, 1);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", function(_, block)
				--if InCombatLockdown() then return end
				block.isHighlighted = true;
				if (block.HeaderText) then
					block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b);
					block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
					block.HeaderText.colorStyle = headerColorStyle;
				end
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(1, 1, 1);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(1, 1, 1);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", function(_, block)
				--if InCombatLockdown() then return end
				block.isHighlighted = nil;
				if (block.HeaderText) then
					block.HeaderText:SetTextColor(ClassColor.r, ClassColor.g, ClassColor.b, 0.95);
					block.HeaderText:SetFont(STANDARD_TEXT_FONT, HeaderTextsize, HeaderTextsteyl)---任务标题字体
					block.HeaderText.colorStyle = headerColorStyle;
				end
				for objectiveKey, line in pairs(block.lines) do
					local colorStyle = line.Text.colorStyle.reverse;
					if (colorStyle) then
						line.Text:SetTextColor(0.85, 0.85, 0.85);
						line.Text:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						line.Text.colorStyle = colorStyle;
						if (line.Dash) then
							line.Dash:SetTextColor(0.85, 0.85, 0.85);
							line.Dash:SetFont(STANDARD_TEXT_FONT, Textsize, Textsteyl)---任务描述字体
						end
					end
				end
			end)

			--美化战役任务板
			ScenarioStageBlock:HookScript("OnShow", function()
				--if InCombatLockdown() then return end
				if not ScenarioStageBlock.skinned then
					--ScenarioStageBlock.NormalBG:SetAlpha(0)
					--ScenarioStageBlock.FinalBG:SetAlpha(0)
					--ScenarioStageBlock.GlowTexture:SetTexture(nil)

					ScenarioStageBlock.Stage:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE SLUG")
					--ScenarioStageBlock.Stage:SetTextColor(1, 1, 1)

					ScenarioStageBlock.Name:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE SLUG")

					ScenarioStageBlock.CompleteLabel:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE SLUG")
					--ScenarioStageBlock.CompleteLabel:SetTextColor(1, 1, 1)
					--ScenarioStageBlock.skinned = true
				end
			end)

			--进本收起追踪
			--local eventframe = CreateFrame("Frame")
			--eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
			--eventframe:SetScript("OnEvent", function()
			--if IsInInstance() then
			--ObjectiveTracker_Collapse()
			--else
			--ObjectiveTracker_Expand()
			--end
			--end)

			--任务物品
			local function moveQuestObjectiveItems(self)
				--if InCombatLockdown() then return end
				local a = { self:GetPoint() }

				self:ClearAllPoints()
				self:SetPoint("TOPRIGHT", a[2], "TOPLEFT", -20, 1)
				self:SetScale(1.4)
				--self:SetFrameStrata("MEDIUM")
				--self:SetFrameLevel(25)
			end

			local qitime = 0
			local qiinterval = 1

			hooksecurefunc("QuestObjectiveItem_OnUpdate", function(self, elapsed)
				--if InCombatLockdown() then return end
				--qitime = qitime + elapsed
				moveQuestObjectiveItems(self)
				--qitime = 0
			end)

		end
	end
	--]]


	--简单的让某些东西可以移动
	if DToolsDB.bfm == true and C_AddOns.IsAddOnLoaded("BlizzMove") ~= true then
		--加载组件
		
		C_AddOns.LoadAddOn("Blizzard_TradeSkillUI")
		C_AddOns.LoadAddOn("Blizzard_MacroUI")
		C_AddOns.LoadAddOn("Blizzard_TalentUI")
		if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and WOW_PROJECT_ID ~= WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
			C_AddOns.LoadAddOn("Blizzard_AchievementUI")
		end

		if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
			C_AddOns.LoadAddOn("Blizzard_AuctionHouseUI")
		else
			C_AddOns.LoadAddOn("Blizzard_AuctionUI")
		end

		local frametable = {
		"CharacterFrame",	--角色
		"SpellBookFrame",	--法术书
		"PlayerTalentFrame",--天赋
		-- "ContainerFrame1",
		-- "ContainerFrame2",
		-- "ContainerFrame3",
		-- "ContainerFrame4",
		-- "ContainerFrame5",
		-- "ContainerFrame6",
		"FriendsFrame",		--好友
		"AchievementFrame",	--成就
		"PVEFrame",         --地下城与PVP
		"PVPFrame",			--PVP
		-- "CollectionsJournal",	--藏品
		"TradeSkillFrame",  --专业
		"AuctionFrame",     --拍卖
		"AuctionHouseFrame",     --拍卖
		"QuestLogFrame",	--任务
		"WorldMapFrame",	--大地图
		"GameMenuFrame",	--菜单
		"SettingsPanel",	--设置界面
		"MerchantFrame",	--售卖
		"AddonList",		--插件列表
		"MacroFrame",		--宏界面
			}
			
		for i, v in ipairs(frametable) do
			if _G[v] then
				_G[v]:SetMovable(true)
				_G[v]:SetScript("OnMouseDown", function()
					_G[v]:StartMoving()
				end)
				_G[v]:SetScript("OnMouseUp", function(self, button)
					_G[v]:StopMovingOrSizing()
				end)
			end
		end

	end
	--]]


	----战斗计时+战复次数
	if DToolsDB.ctbr == true then
		local function FormatTime(seconds)
			seconds = max(0, seconds)
			return string.format("%d:%02d.%1d", floor(seconds / 60), floor(seconds) % 60, floor(seconds * 10) % 10)
		end
		local refreshInterval = 0.1
		local combatRunning = InCombatLockdown()
		local combatStart = GetTime()
		local combatElapsed = 0
		local combatUpdateElapsed = 0

		-- local combatFrame = CreateFrame("Frame", "CombatTimer", UIParent)
		-- combatFrame:SetSize(70, 22)
		-- combatFrame:SetPoint("TOPRIGHT", ChatFrame1Background, "TOPRIGHT", 0, 0)
		-- -- combatFrame:SetPoint("BOTTOM", CTBRFrame, "BOTTOM", 0, 0)
		-- combatFrame:SetFrameStrata("TOOLTIP")
		-- combatFrame:EnableMouse(false)
		combatFrame.bg = combatFrame:CreateTexture(nil, "BACKGROUND")
		combatFrame.bg:SetAllPoints()
		combatFrame.bg:SetTexture("Interface/Buttons/WHITE8x8")
		combatFrame.bg:SetVertexColor(0, 0, 0, 0.5)
		combatFrame.text = combatFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		-- combatFrame.text:SetAllPoints()
		combatFrame.text:SetPoint("CENTER", combatFrame, "CENTER", 2, 0)
		combatFrame.text:SetFont(STANDARD_TEXT_FONT, 17, "OUTLINE SLUG")
		combatFrame.text:SetJustifyH("CENTER")
		combatFrame.text:SetTextColor(0, 0.9, 0, 1)
		combatFrame.text:SetText(FormatTime(combatRunning and (GetTime() - combatStart) or combatElapsed))
		combatFrame:SetScript("OnUpdate", function(self, elapsed)
			if not combatRunning then return end
			combatUpdateElapsed = combatUpdateElapsed + elapsed
			if combatUpdateElapsed < refreshInterval then return end
			combatUpdateElapsed = combatUpdateElapsed - refreshInterval
			self.text:SetText(FormatTime(GetTime() - combatStart))
		end)
		local function ResetCombatTimer()
			combatElapsed = 0
			combatRunning = true
			combatStart = GetTime()
		end
		ns.event("ENCOUNTER_STATE_CHANGED", function(_, isInProgress)
			if isInProgress then
				ResetCombatTimer()
			end
		end)

		ns.event("PLAYER_REGEN_DISABLED", ResetCombatTimer)

		ns.event("PLAYER_REGEN_ENABLED", function()
			combatElapsed = GetTime() - combatStart
			combatRunning = false
			combatFrame.text:SetText(FormatTime(combatElapsed))
		end)

		-- --战复
		-- -- local battleFrame = CreateFrame("Frame", "BattleResTimer", UIParent, "CooldownViewerBuffIconItemTemplate")
		-- -- battleFrame:SetSize(42, 42)
		-- -- battleFrame:SetPoint("TOPLEFT", ChatFrame1Background, "TOPRIGHT", 0, 2)
		-- -- -- battleFrame:SetPoint("BOTTOM", combatFrame, "TOP", 0, 2)
		-- -- battleFrame:SetFrameStrata("TOOLTIP")
		-- -- -- battleFrame:EnableMouse(false)
		-- battleFrame:Show()
		-- -- ns.AddEdit(battleFrame,"战复")
		-- battleFrame.Icon:SetTexture(C_Spell.GetSpellTexture(20484))
		-- battleFrame.Cooldown:SetReverse(false)
		-- battleFrame.Cooldown:SetCountdownAbbrevThreshold(600)
		-- battleFrame.Applications:SetScale(1.2)
		-- local battleUpdateElapsed = 0
		-- battleFrame:SetScript("OnUpdate", function(self, elapsed)
		-- 	battleUpdateElapsed = battleUpdateElapsed + elapsed
		-- 	if battleUpdateElapsed < 1 then return end
		-- 	battleUpdateElapsed = battleUpdateElapsed - 1
		-- 	local chargeInfo = C_Spell.GetSpellCharges(20484)
		-- 	if chargeInfo then
		-- 		local charges = chargeInfo.currentCharges or 0
		-- 		battleFrame.Cooldown:SetCooldown(chargeInfo.cooldownStartTime or 0, chargeInfo.cooldownDuration or 0)
		-- 		if charges > 0 then
		-- 			battleFrame.Applications.Applications:SetText(charges)
		-- 			battleFrame.Applications.Applications:SetTextColor(1, 1, 1)
		-- 		else
		-- 			battleFrame.Applications.Applications:SetText("0")
		-- 			battleFrame.Applications.Applications:SetTextColor(1, 0, 0)
		-- 		end
		-- 	else
		-- 		battleFrame.Cooldown:Clear()
		-- 		battleFrame.Applications.Applications:SetText("")
		-- 	end
		-- end)

	end


end)



local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(...)

	--聊天标签字体美化
	if DToolsDB.sfu == true then
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
	end
	--]]

	--改名
	if DToolsDB.pnc == true then

		StaticPopupDialogs.SC_NAME = {
				text = L.pnc1 or "输入你要改的名字,不输入为恢复原名",
				button1 = OKAY,
				button2 = CANCEL,
				--功能调用
				--OnAccept =  function() end,
				OnAccept = function (self, data, data2)
				DToolsDB.cname = self.EditBox:GetText()
				ReloadUI()
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = true,
				hasEditBox = true,
				preferredIndex = 5,
		}
		SLASH_SCNAME1 = "/CN"
		SLASH_SCNAME2 = "/cname"
		SLASH_SCNAME3 = "/改名"
		SlashCmdList["SCNAME"] = function()
				StaticPopup_Show("SC_NAME")
		end


		local cname = CreateFrame("Frame")
		cname:RegisterEvent("ADDON_LOADED")
		cname:SetScript("OnEvent", function(self, event)
		if DToolsDB.cname == nil then return end
		if DToolsDB.cname == ""  then return end
		local changedName = DToolsDB.cname


		local playerName = UnitName("player")
		local UnitNameStore = UnitName
		local function GetUnitName(unit)
			local realname,Server = UnitNameStore(unit)
			if realname == playerName then
				return changedName,Server
			else
				return realname,Server
			end
		end
		UnitName = GetUnitName

		local playercnClass, playerusClass ,playerClassid = UnitClass("player")
		local UnitClassStore = UnitClass
		local function GetUnitClass(unit)
			local cnclass,usclass,classid= UnitClassStore(unit)
			if usclass == nil then
				return playercnClass, playerusClass ,playerClassid
			else
				return cnclass,usclass,classid
			end
		end
		UnitClass = GetUnitClass

		-- --头像相关
		-- PlayerName:SetText(changedName)
		-- local function FrameName(self)
		-- 	if UnitIsUnit("player",self.unit) then
		-- 		if self.TargetFrameContent then
		-- 			self.TargetFrameContent.TargetFrameContentMain.Name:SetText(changedName)
		-- 		elseif self.HealthBar then
		-- 			if not self.Name then return end
		-- 			self.Name:SetText(changedName)
		-- 		end
		-- 	end
		-- end
		-- hooksecurefunc(TargetFrame, "CheckClassification", FrameName)
		-- hooksecurefunc(FocusFrame, "CheckClassification", FrameName)
		-- hooksecurefunc(TargetFrameToT, "Update", FrameName)
		-- hooksecurefunc(FocusFrameToT, "Update", FrameName)
		-- --团队框架
		-- hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		-- 	if frame:IsForbidden() then return end
		-- 	if not frame.name then return end
		-- 	if not frame.unit then return end
		-- 	--if UnitIsUnit("player",frame.unit) then
		-- 	--	frame.name:SetText(changedName)
		-- 	--end
		-- 	frame.name:SetText(UnitClass(frame.unit))
		-- end)

		-- --角色面板
		-- CharacterFrame:HookScript("OnShow", function(self)
		-- 	C_Timer.After(0,function()
		-- 		CharacterFrameTitleText:SetText(changedName)
		-- 	end)
		-- 	if C_AddOns.IsAddOnLoaded("TinyInspect") then
		-- 		PaperDollFrame.inspectFrame.title:SetText(changedName)
		-- 	end
		-- end)

		-- --鼠标提示
		-- local function mynamechange()
		-- 	local _, unit = GameTooltip:GetUnit()
		-- 	if unit and UnitIsUnit(unit,"player") then
		-- 		GameTooltipTextLeft1:SetText(changedName)
		-- 	end
		-- end
		-- TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, mynamechange)

		-- --details
		-- local NicknameDetails = changedName
		-- if C_AddOns.IsAddOnLoaded("Details") then
		-- 	local base = Details.container_combatentes
		-- 	local old = base.GetOrCreateActor
		-- 	base.GetOrCreateActor = function (self, actorSerial, actorName, actorFlags, bShouldCreateActor)
		-- 		local newActor, arg2, arg3 = old(self, actorSerial, actorName, actorFlags, bShouldCreateActor)
		-- 		if NicknameDetails then newActor.displayName = NicknameDetails end
		-- 		return newActor, arg2, arg3
		-- 	end
		-- end

		end)
	end
	--]]

end)



-- 聊天历史记录功能
-- 修改来源 Leatrix Plus
local historyFrame = CreateFrame("FRAME")
historyFrame:RegisterEvent("PLAYER_LOGIN")
historyFrame:RegisterEvent("PLAYER_LOGOUT")
historyFrame:SetScript("OnEvent", function(self, event)
    if not DToolsDB.chr then
        -- 功能关闭时清理保存的变量
        DToolsDB_GLOB["ChatHistoryName"] = nil
        DToolsDB_GLOB["ChatHistoryTime"] = nil
        for i = 1, 50 do
            DToolsDB_GLOB["ChatHistory"..i] = nil
            DToolsDB_GLOB["ChatTemp"..i] = nil
            DToolsDB_GLOB["ChatHistory"..i.."Count"] = nil
        end
        return
    end

    if event == "PLAYER_LOGOUT" then
        -- 登出时保存聊天记录
        local name, realm = UnitFullName("player")
        if not realm then realm = GetNormalizedRealmName() end
        if not name or not realm then return end

        for i = 1, 50 do
            if i ~= 2 and _G["ChatFrame"..i] and FCF_IsChatWindowIndexActive(i) then
                DToolsDB_GLOB["ChatHistory"..i] = {}
                local chatFrame = _G["ChatFrame"..i]
                local numMessages = chatFrame:GetNumMessages()
                local startMsg = math.max(1, numMessages - 127) -- 最多保存128条

                for msgIndex = startMsg, numMessages do
                    local chatMessage = chatFrame:GetMessageInfo(msgIndex)
                    if chatMessage then
                        -- 移除颜色代码
                        chatMessage = chatMessage:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                        tinsert(DToolsDB_GLOB["ChatHistory"..i], chatMessage)
                    end
                end
            end
        end

    elseif event == "PLAYER_LOGIN" then
        -- 登录时恢复聊天记录
        local name, realm = UnitFullName("player")
        if not realm then realm = GetNormalizedRealmName() end
        if not name or not realm then return end

        local colorCode = RGBToColorCode(0.7, 0.7, 0.7)
        local headerMessage = "|cff00ff00------ [|cff990000DiabloUI|r] "..(L.chr3 or "聊天历史").." ------|r"

        -- 保存当前会话消息用于去重
        for i = 1, 50 do
            if i ~= 2 and _G["ChatFrame"..i] and FCF_IsChatWindowIndexActive(i) then
                DToolsDB_GLOB["ChatTemp"..i] = {}
                local chatFrame = _G["ChatFrame"..i]
                local numMessages = chatFrame:GetNumMessages()
                
                for msgIndex = 1, numMessages do
                    local chatMessage, r, g, b, chatTypeID = chatFrame:GetMessageInfo(msgIndex)
                    if chatMessage then
                        local plainMessage = chatMessage:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                        DToolsDB_GLOB["ChatTemp"..i][plainMessage] = true
						if r and g and b then
							local colorCode = RGBToColorCode(r, g, b)
							chatMessage = colorCode..chatMessage
						end
                        tinsert(DToolsDB_GLOB["ChatTemp"..i], chatMessage)
                    end
                end
                chatFrame:Clear()
            end
        end

        -- 恢复历史聊天记录
        for i = 1, 50 do
            if i ~= 2 and _G["ChatFrame"..i] and DToolsDB_GLOB["ChatHistory"..i] and FCF_IsChatWindowIndexActive(i) then
                DToolsDB_GLOB["ChatHistory"..i.."Count"] = 0
                
                for k = 1, #DToolsDB_GLOB["ChatHistory"..i] do
                    local message = DToolsDB_GLOB["ChatHistory"..i][k]
                    local plainHeader = headerMessage:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                    
                    if message ~= plainHeader and (not DToolsDB_GLOB["ChatTemp"..i] or not DToolsDB_GLOB["ChatTemp"..i][message]) then
                        _G["ChatFrame"..i]:AddMessage(colorCode..message)
                        DToolsDB_GLOB["ChatHistory"..i.."Count"] = DToolsDB_GLOB["ChatHistory"..i.."Count"] + 1
                    end
                end
                
                -- 显示恢复统计
                if DToolsDB_GLOB["ChatHistory"..i.."Count"] ~= 0 then
                    _G["ChatFrame"..i]:AddMessage(headerMessage)
                end
            else
                DToolsDB_GLOB["ChatHistory"..i] = nil
            end
        end

        -- 恢复当前会话消息
        for i = 1, 50 do
            if i ~= 2 and _G["ChatFrame"..i] and DToolsDB_GLOB["ChatTemp"..i] and FCF_IsChatWindowIndexActive(i) then
                for k = 1, #DToolsDB_GLOB["ChatTemp"..i] do
                    _G["ChatFrame"..i]:AddMessage(DToolsDB_GLOB["ChatTemp"..i][k])
                end
            end
        end
    end
end)