	local _
	---------------
	--数据模块--
	---------------

	--get the addon namespace
	local _, ns =...
	local L = ns.L

	-- --petbattle handler
	-- local petbattleHandler = CreateFrame("Frame", nil, UIParent)
	-- petbattleHandler:RegisterEvent("PET_BATTLE_OPENING_START")
	-- petbattleHandler:RegisterEvent("PET_BATTLE_CLOSE")
	-- --event
	-- petbattleHandler:SetScript("OnEvent", function(...)
	-- local self, event, arg1 =...
	-- if event == "PET_BATTLE_OPENING_START" then
	-- self:Hide()
	-- elseif event == "PET_BATTLE_CLOSE" then
	-- self:Show()
	-- end
	-- end)
	local f = CreateFrame("Frame", "InfoStrings", UIParent)
	f:RegisterEvent("PET_BATTLE_OPENING_START")
	f:RegisterEvent("PET_BATTLE_CLOSE")
	f:SetScript("OnEvent", function(self, event)
		if event == "PET_BATTLE_OPENING_START" then
			self:Hide()
		elseif event == "PET_BATTLE_CLOSE" then
			self:Show()
		end
	end)

	f:SetSize(100,100)
	f:SetPoint("BOTTOM", UIParent, "BOTTOMRIGHT", -255, 0)


	local infocfg = {}
	ns.infocfg = infocfg

	infocfg.unlock = true--解锁位置
	infocfg.pos = { a1 = "BOTTOMRIGHT", af = f, a2 = "BOTTOM", x = 0, y = 2 }
	infocfg.ttpos = { a1 = "BOTTOMLEFT", af = f, a2 = "BOTTOM", x = -235, y = 0 }

	infocfg.showAttribute = true--绿字属性 fa
	infocfg.showSysinfo = true--系统信息 f1
	infocfg.showSpeed = true--移动速度 f2
	infocfg.showSpec = false--拾取天赋 f3
	infocfg.showZone = false--区域坐标 f4
	infocfg.showExpRep = false--经验声望 f5

	local fa = CreateFrame("Button", "InfoStringsa", f)
	local f1 = CreateFrame("Button", "InfoStrings1", f)
	local f2 = CreateFrame("Button", "InfoStrings2", f)
	local f3 = CreateFrame("Button", "InfoStrings3", f)
	local f4 = CreateFrame("Button", "InfoStrings4", f)
	local f5 = CreateFrame("Button", "InfoStrings5", f)

	fa:SetFrameStrata("MEDIUM")
	f1:SetFrameStrata("MEDIUM")
	f2:SetFrameStrata("MEDIUM")
	f3:SetFrameStrata("MEDIUM")
	f4:SetFrameStrata("MEDIUM")
	f5:SetFrameStrata("MEDIUM")


	--字体格式

	local function rsiCreateFontString(f, size, fx)
	local t = f:CreateFontString("Text", "ARTWORK", fx)
	t:SetFont(STANDARD_TEXT_FONT, size, "OUTLINE")
	t:SetPoint("CENTER", f)
	return t
	end

	--"GameFontHighlightLeft""GameFontHighlight""GameFontHighlightRight"---文本对齐方向
	fatype = rsiCreateFontString(fa, 16, "GameFontHighlightRight")
	fatype:SetPoint("BOTTOMRIGHT", fa, "BOTTOM", 1, 0)
	fat = rsiCreateFontString(fa, 16, "GameFontHighlightLeft")
	fat:SetPoint("BOTTOMLEFT", fa, "BOTTOM", -1, 0)
	f1t = rsiCreateFontString(f1, 13, "GameFontHighlight")
	f2t = rsiCreateFontString(f2, 13, "GameFontHighlight")
	f3t = rsiCreateFontString(f3, 15, "GameFontHighlight")
	f4t = rsiCreateFontString(f4, 16, "GameFontHighlight")
	f5t = rsiCreateFontString(f5, 13, "GameFontHighlight")

	--mem format func
	local memformat = function(number)
	if number > 10240 then
	return string.format("%.2f mb", (number/1024))
	else
	return string.format("%d kb", floor(number))
	end
	end

	--number format func
	local numformat = function(v)
		if (GetLocale() == "zhCN") then
			if v > 1E8 then
				return (floor((v/1E8)*10)/10).."亿"
			elseif v > 1E5 then
				return (floor((v/1E4)*10)/10).."万"
			else
				return v
			end
		else
			if v > 1E7 then
				return (floor((v/1E6)*10)/10).."M"
			elseif v > 1E4 then
				return (floor((v/1E3)*10)/10).."K"
			else
				return v
			end
		end
	end

	--f1
	f1:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y)
	--f2
	if infocfg.showSysinfo then
	f2:SetPoint("BOTTOM", f1, "TOP", 0, 1)
	else
	f2:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y)
	--f2:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y+13)
	end
	--f3
	if infocfg.showSpeed then
	f3:SetPoint("BOTTOM", f2, "TOP", 0, 1)
	elseif infocfg.showSysinfo then
	f3:SetPoint("BOTTOM", f1, "TOP", 0, 1)
	else
	f3:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y)
	end
	--f4
	if infocfg.showSpec then
	f4:SetPoint("BOTTOM", f3, "TOP", 0, 1)
	elseif infocfg.showSpeed then
	f4:SetPoint("BOTTOM", f2, "TOP", 0, 1)
	elseif infocfg.showSysinfo then
	f4:SetPoint("BOTTOM", f1, "TOP", 0, 1)
	else
	f4:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y)
	end
	--f5
	if infocfg.showZone then
	f5:SetPoint("BOTTOM", f4, "TOP", 0, 1)
	elseif infocfg.showSpec then
	f5:SetPoint("BOTTOM", f3, "TOP", 0, 1)
	elseif infocfg.showSpeed then
	f5:SetPoint("BOTTOM", f2, "TOP", 0, 1)
	elseif infocfg.showSysinfo then
	f5:SetPoint("BOTTOM", f1, "TOP", 0, 1)
	else
	f5:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y)
	--f5:SetPoint(infocfg.pos.a1, infocfg.pos.af, infocfg.pos.a2, infocfg.pos.x, infocfg.pos.y+26)
	end

	fa:SetPoint(infocfg.ttpos.a1, infocfg.ttpos.af, infocfg.ttpos.a2, infocfg.ttpos.x, infocfg.ttpos.y)


ns.event("PLAYER_LOGIN", function()

	if DToolsDB.ifs == true then

		--get the config values
		local classcs = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass("player"))].colorStr

		--延迟帧数
		local function Sysinfo()
		return
		--"|c"..classcs.."每秒帧数:".."|r".."|cff00ff00"..floor(GetFramerate()).."|r".."\n"..
		--"|c"..classcs.."本地:".."|r".."|cff00ff00"..select(3, GetNetStats()).."|r".."ms"..
		--"|c"..classcs.."世界:".."|r".."|cff00ff00"..select(4, GetNetStats()).."|r".."ms"
		"|c"..classcs..(L.fps or "帧数")..":|r".."|cff00ff00"..floor(GetFramerate()).."|r "..
		"|c"..classcs..(L.lag or "延迟")..":|r".."|cff00ff00"..select(3, GetNetStats()).."|r".."/".."|cff00ff00"..select(4, GetNetStats()).."|r"
		end

		--移动速度
		local function Speed()
		local hasTarget = UnitExists("target") and not UnitIsUnit("player", "target") and not UnitIsUnit("vehicle", "target")

		if hasTarget and not UnitExists("vehicle") then
		return
		"|c"..classcs..(L.player or "玩家")..":|r".."|cff00ff00"..floor(GetUnitSpeed("player")*100/7+0.4).."|r".."%".." ".."|c"..classcs..(L.target or "目标")..":|r".."|cff00ff00"..floor(GetUnitSpeed("target")*100/7+0.4).."|r".."%"
		elseif hasTarget and UnitExists("vehicle") then
		return
		"|c"..classcs..(L.vehicle or "载具")..":|r".."|cff00ff00"..floor(GetUnitSpeed("vehicle")*100/7+0.4).."|r".."%".." ".."|c"..classcs..(L.target or "目标")..":|r".."|cff00ff00"..floor(GetUnitSpeed("target")*100/7+0.4).."|r".."%"
		elseif UnitExists("vehicle") then
		return
		"|c"..classcs..(L.vehicle or "载具")..":|r".."|cff00ff00"..floor(GetUnitSpeed("vehicle")*100/7+0.4).."|r".."%"
		else
		return
		"|c"..classcs..(L.player or "玩家")..":|r".."|cff00ff00"..floor(GetUnitSpeed("player")*100/7+0.4).."|r".."%"
		end
		end

		--内存占用
		local function Memory()
		local t = 0
		UpdateAddOnMemoryUsage()
		for i=1, GetNumAddOns(), 1 do
		t = t + GetAddOnMemoryUsage(i)
		end
		return memformat(t)
		end

		local function ZoneCoords()
		local zone = ""
		local x, y
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID then
		local mapPosObject = C_Map.GetPlayerMapPosition(mapID, "player")
		if mapPosObject then
		x, y = mapPosObject:GetXY()
		end
		end
		local coords
		if x and y and x ~= 0 and y ~= 0 then
		coords = format("%.2d/%.2d", x*100, y*100)
		end
		if coords then
		zone = "|cff00ff00"..GetMinimapZoneText().."|r".."["..coords.."]"
		else
		zone = "|cff00ff00"..GetMinimapZoneText().."|r"
		end
		return zone
		end

		--经验声望
		local function ExpRep()
		local xp = ""

		if not IsXPUserDisabled() and (UnitLevel("player")<MAX_PLAYER_LEVEL) then
		xp = "|c00FA58F4"..numformat(UnitXP("player")).."/"..numformat(UnitXPMax("player")).." |r|c00ffb400("..numformat(GetXPExhaustion() or 0)..")|r|c00FA58F4 | "..string.format("%.0f", (UnitXP("player")/UnitXPMax("player")*100)).."%|r"
		else
		local _, _, minimum, maximum, value = GetWatchedFactionInfo()
		if ((value-minimum) == 999) and ((maximum-minimum) == 1000) then
		xp = "|c"..classcs.."MAXED OUT|r"
		else
		xp = "|c"..classcs..""..numformat(value-minimum).."/"..numformat(maximum-minimum).." | "..string.format("%.0f", (value-minimum)/(maximum-minimum)*100).."%|r"
		end
		end
		return xp
		end

		--拾取天赋

		local function LootSpec()
			local specID = GetLootSpecialization()
			local _, lootspec0 = GetSpecializationInfo(GetSpecialization())
			local _, lootspec = GetSpecializationInfoByID(specID)

			if specID == 0 and lootspec0 then
				return "|c"..classcs..(L.lootspec or "专精拾取")..":|r".."|cff00ff00"..lootspec0.."|r"
			elseif lootspec then
				return "|c"..classcs..(L.lootspec or "专精拾取")..":|r".."|cffff0000"..lootspec.."|r"
			end





		end


		--绿字属性
		--[[
		local function Attribute()
		return
		"|cff00ff00".."爆击:".."|r".."|c"..classcs..string.format("%.2f", GetCritChance()).."|r".."%".."\n"..
		"|cff00ff00".."急速:".."|r".."|c"..classcs..string.format("%.2f", GetHaste()).."|r".."%".."\n"..
		"|cff00ff00".."精通:".."|r".."|c"..classcs..string.format("%.2f", GetMasteryEffect()).."|r".."%".."\n"..
		"|cff00ff00".."全能:".."|r".."|c"..classcs..string.format("%.2f", GetCombatRatingBonus(29)).."|r".."%"
		end
		--]]


		local tplayerClass = string.upper(select(2, UnitClass('player')))
		local _, _, num1, _ = select(3, GetTalentTabInfo(1))
		local _, _, num2, _ = select(3, GetTalentTabInfo(2))
		local _, _, num3, _ = select(3, GetTalentTabInfo(3))
		local usetalent
		if num1 > num2 and num1 > num3 then
			usetalent = 1
		elseif num2 > num1 and num2 > num3 then
			usetalent = 2
		elseif num3 > num1 and num3 > num2 then
			usetalent = 3
		else
			usetalent = 1
		end

		if tplayerClass == "DRUID" then
			-- 德鲁伊，现在是4系天赋，分别是法术、坦克、物理、治疗
			if usetalent == 1 then
				PlayAs = 2
			elseif usetalent == 3 then
				PlayAs = 3
			elseif usetalent == 2 and GetShapeshiftFormID() == 8 then
				PlayAs = 4
			else
				PlayAs = 1
			end
		elseif tplayerClass == "PALADIN" then
			-- 圣骑士不好说……因为有防惩的存在……还是以天赋判定吧
			if usetalent == 1 then
				PlayAs = 3
			elseif usetalent == 2 then
				PlayAs = 4
			else
				PlayAs = 1
			end
			-- 1,2,同时能做3样的
		elseif tplayerClass == "SHAMAN" then
			-- 萨满，根据天赋判定了……
			if usetalent == 1 then
				PlayAs = 2
			elseif usetalent == 2 then
				PlayAs = 1
			else
				PlayAs = 3
			end
		elseif tplayerClass == "PRIEST" then
			-- 牧师，当天赋为暗影时被认为是法系DPS，否则被认为治疗
			if usetalent == 3 then
				PlayAs = 2
			else
				PlayAs = 3
			end
			-- 3,4 can play as 能做DPS和治疗的
		elseif tplayerClass == "WARRIOR" then
			-- 战士，开防御姿态认定为坦克
			if GetShapeshiftFormID() == 18 then
				PlayAs = 4
			else
				PlayAs = 1
			end
			-- 5,6 can play as 能做DPS和坦克的
		elseif tplayerClass == "ROGUE" then
			PlayAs = 1
		elseif tplayerClass == "HUNTER" then
			PlayAs = 5 -- 猎人要看远程的，所以单独
			--7 to 8 :只能做物理DPS
		elseif tplayerClass == "MAGE" then
			PlayAs = 2
		elseif tplayerClass == "WARLOCK" then
			PlayAs = 2
			--9 to 10:只能做法系DPS
		elseif tplayerClass == "DEATHKNIGHT" then
				PlayAs = 6
		end


		local function Attributetype()

			local baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
			local SpellDamageFire = GetSpellBonusDamage(3)
			local SpellDamageNature = GetSpellBonusDamage(4)
			local SpellDamageFrost = GetSpellBonusDamage(5)
			local SpellDamageShadow = GetSpellBonusDamage(6)
			local SpellDamageArcane =  GetSpellBonusDamage(7)
			local arr = {SpellDamageFire,SpellDamageNature,SpellDamageFrost,SpellDamageShadow,SpellDamageArcane}
			if SpellDamageFire == SpellDamageNature and SpellDamageNature == SpellDamageFrost and SpellDamageFrost == SpellDamageShadow and SpellDamageShadow  == SpellDamageArcane then
				spellSuffix = L.spbd or "法伤"
			elseif  SpellDamage  ==  SpellDamageFire then
				spellSuffix = L.spbd or "火伤"
			elseif SpellDamage == SpellDamageNature then
				spellSuffix = L.spbd or "自然伤"
			elseif SpellDamage == SpellDamageFrost then
				spellSuffix = L.spbd or "冰伤"
			elseif SpellDamage == SpellDamageShadow then
				spellSuffix = L.spbd or "暗伤"
			elseif SpellDamage == SpellDamageArcane then
				spellSuffix = L.spbd or "奥伤"
			end

			if PlayAs == 1 then
				return
					"|cff00ff00"..(L.attp or "攻强")..":|r".."\n"..
					"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
					"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
					"|cff00ff00"..(L.armp or "破甲")..":|r"

			elseif PlayAs == 2 then
				return
					"|cff00ff00"..spellSuffix..":|r".."\n"..
					"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
					"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
					"|cff00ff00"..(L.manar or "法回")..":|r"

			elseif PlayAs == 3 then
				return
					"|cff00ff00"..(L.spbd or "奶强")..":|r".."\n"..
					"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
					"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
					"|cff00ff00"..(L.manar or "法回")..":|r"
			elseif PlayAs == 4 then
				if GetBlockChance() ~= 0 then
					return
						"|cff00ff00"..(L.armor or "护甲")..":|r".."\n"..
						"|cff00ff00"..(L.dodge or "躲闪")..":|r".."\n"..
						"|cff00ff00"..(L.parry or "招架")..":|r".."\n"..
						"|cff00ff00"..(L.block or "格挡")..":|r"
				else
					return
						"|cff00ff00"..(L.armor or "护甲")..":|r".."\n"..
						"|cff00ff00"..(L.dodge or "躲闪")..":|r".."\n"..
						"|cff00ff00"..(L.attp or "攻强")..":|r".."\n"..
						"|cff00ff00"..(L.atts or "攻速")..":|r"
				end
			elseif PlayAs == 5 then

				return
					"|cff00ff00"..(L.attp or "攻强")..":|r".."\n"..
					"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
					"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
					"|cff00ff00"..(L.armp or "破甲")..":|r"

			elseif PlayAs == 6 then
				if effectiveArmor >= 20000 then
					return
						"|cff00ff00"..(L.armor or "护甲")..":|r".."\n"..
						"|cff00ff00"..(L.dodge or "躲闪")..":|r".."\n"..
						"|cff00ff00"..(L.parry or "招架")..":|r".."\n"..
						"|cff00ff00"..(L.attp or "攻强")..":|r"
				else
					return
						"|cff00ff00"..(L.attp or "攻强")..":|r".."\n"..
						"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
						"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
						"|cff00ff00"..(L.atts or "攻速")..":|r"
				end
			end
		end



















		local function Attribute()

			local baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
			local SpellDamageFire = GetSpellBonusDamage(3)
			local SpellDamageNature = GetSpellBonusDamage(4)
			local SpellDamageFrost = GetSpellBonusDamage(5)
			local SpellDamageShadow = GetSpellBonusDamage(6)
			local SpellDamageArcane =  GetSpellBonusDamage(7)
			local arr = {SpellDamageFire,SpellDamageNature,SpellDamageFrost,SpellDamageShadow,SpellDamageArcane}

			local base, casting = GetManaRegen()
			local stat = {
			str = UnitStat("player", 1),
			agi = UnitStat("player", 2),
			int = UnitStat("player", 4),
			has = format("%.2f", GetHaste()),
			-- mhas = format("%.2f", GetCombatRatingBonus(CR_HASTE_MELEE)),
			ampt = format("%.2f", GetArmorPenetration()),
			-- shas = format("%.2f", GetCombatRatingBonus(CR_HASTE_SPELL)),
			-- rhas = format("%.2f", GetCombatRatingBonus(CR_HASTE_RANGED)),
			cri = format("%.2f", GetCritChance()),
			scri = format("%.2f",GetSpellCritChance(7)),
			hcri = format("%.2f",GetSpellCritChance(2)),
			rcri = format("%.2f", GetRangedCritChance()),
			-- ver = format("%.2f", GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)),
			-- mas = format("%.2f", GetMasteryEffect()),

			dodge = format("%.2f", GetDodgeChance()),
			parry = format("%.2f", GetParryChance()),
			block = format("%.2f", GetBlockChance()),
			aspeed = format("%.2f", UnitAttackSpeed("player")),

			SpellDamage = math.max(unpack(arr)),
			ManaRegen = format("%d", base * 5).."|r/".."|c"..classcs..format("%d", casting * 5),
			}

			if PlayAs == 1 then
				local base, posBuff, negBuff = UnitAttackPower("player");
				local effective = base + posBuff + negBuff;
				return
					"|c"..classcs..effective.."|r".."\n"..
					"|c"..classcs..stat.cri.."|r".."%".."\n"..
					"|c"..classcs..stat.has.."|r".."%".."\n"..
					"|c"..classcs..stat.ampt.."|r".."%"

			elseif PlayAs == 2 then
				return
					"|c"..classcs..stat.SpellDamage.."|r".."\n"..
					"|c"..classcs..stat.scri.."|r".."%".."\n"..
					"|c"..classcs..stat.has.."|r".."%".."\n"..
					"|c"..classcs..stat.ManaRegen.."|r"

			elseif PlayAs == 3 then
				return
					"|c"..classcs..GetSpellBonusHealing().."|r".."\n"..
					"|c"..classcs..stat.hcri.."|r".."%".."\n"..
					"|c"..classcs..stat.has.."|r".."%".."\n"..
					"|c"..classcs..stat.ManaRegen.."|r"
			elseif PlayAs == 4 then
				if GetBlockChance() ~= 0 then
					return
						"|c"..classcs..effectiveArmor.."|r".."\n"..
						"|c"..classcs..stat.dodge.."|r".."%".."\n"..
						"|c"..classcs..stat.parry.."|r".."%".."\n"..
						"|c"..classcs..stat.block.."|r".."%"
				else
					local base, posBuff, negBuff = UnitAttackPower("player");
					local effective = base + posBuff + negBuff;
					return
						"|c"..classcs..effectiveArmor.."|r".."\n"..
						"|c"..classcs..stat.dodge.."|r".."%".."\n"..
						"|c"..classcs..effective.."|r".."%".."\n"..
						"|c"..classcs..stat.aspeed.."|r"
				end
			elseif PlayAs == 5 then
				local base, posBuff, negBuff = UnitRangedAttackPower("player");
				local effective = base + posBuff + negBuff;
				return
					"|c"..classcs..effective.."|r".."\n"..
					"|c"..classcs..stat.rcri.."|r".."%".."\n"..
					"|c"..classcs..stat.has.."|r".."%".."\n"..
					"|c"..classcs..stat.ampt.."|r".."%"

			elseif PlayAs == 6 then
				local base, posBuff, negBuff = UnitAttackPower("player");
				local effective = base + posBuff + negBuff;
				if effectiveArmor >= 6000 then
					return
						"|c"..classcs..effectiveArmor.."|r".."\n"..
						"|c"..classcs..stat.dodge.."|r".."%".."\n"..
						"|c"..classcs..stat.parry.."|r".."%".."\n"..
						"|c"..classcs..effective.."|r"
				else
					return
						"|c"..classcs..effective.."|r".."\n"..
						"|c"..classcs..stat.cri.."|r".."%".."\n"..
						"|c"..classcs..stat.has.."|r".."%".."\n"..
						"|c"..classcs..stat.aspeed.."|r"
				end
			end

		end







		--创建数据
		local function UpdateF1Strings()
			local f1Text = ""
			if infocfg.showSysinfo then
			f1Text = Sysinfo()
			end
			f1t:SetText(f1Text or "")
			f1:SetHeight(f1t:GetStringHeight())
			f1:SetWidth(120)
		end
		local function UpdateF2Strings()
			-- if InCombatLockdown() then return end

			local f2Text = ""
			if infocfg.showSpeed then
			f2Text = Speed()
			end
			f2t:SetText(f2Text or "")
			f2:SetHeight(f2t:GetStringHeight())
			f2:SetWidth(120)
		end

		local function UpdateF3Strings()
			local f3Text = ""
			if infocfg.showSpec then
			f3Text = LootSpec()
			end
			f3t:SetText(f3Text or "")
			f3:SetHeight(f3t:GetStringHeight())
			f3:SetWidth(140)
		end

		local function UpdateF45Strings()
			local f4Text = ""
			if infocfg.showZone then
			f4Text = ZoneCoords()
			end
			f4t:SetText(f4Text or "")
			f4:SetHeight(f4t:GetStringHeight())
			f4:SetWidth(150)

			local f5Text = ""
			if infocfg.showExpRep then
			f5Text = ExpRep()
			end
			f5t:SetText(f5Text or "")
			f5:SetHeight(f5t:GetStringHeight())
			f5:SetWidth(150)
		end

		local function UpdateFaStrings()
			-- if InCombatLockdown() then return end

			local fatypeText = ""
			if infocfg.showAttribute then
				fatypeText = Attributetype()
			end
			fatype:SetText(fatypeText or "")

			local faText = ""
			if infocfg.showAttribute then
				faText = Attribute()
			end
			fat:SetText(faText or "")
			fa:SetHeight(fatype:GetStringHeight())
			fa:SetWidth(100)
		end


		--刷新数据

		local a = CreateFrame("Frame")
		a:RegisterEvent("PLAYER_LOGIN")
		a:RegisterEvent("PLAYER_ENTERING_WORLD")
		a:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
				local ufslow = C_Timer.NewTicker(0.5, function()
					UpdateF1Strings()
					UpdateF3Strings()
					UpdateF45Strings()
				end)
				local uffast = C_Timer.NewTicker(0.25, function()
					UpdateF2Strings()
					UpdateFaStrings()
				end)
				local ufstart = C_Timer.After(0.2, function()
					UpdateFaStrings()
				end)
				-- local cleanupTimer = C_Timer.NewTicker(30, function()
				-- 	collectgarbage("collect")
				-- 	UpdateAddOnMemoryUsage()
				-- 	print("自动内存清理完成")
				-- end)
			end
		end)



		--点击操作实现

		--清理插件内存
		local function ClearGarbage()
		UpdateAddOnMemoryUsage()
		local before = gcinfo()
		collectgarbage()
		UpdateAddOnMemoryUsage()
		local after = gcinfo()
		print((L.clearm or "清理插件内存")..": "..memformat(before-after))
		end

		f1:EnableMouse(true)
		f1:SetScript("OnMouseDown", function()
		ClearGarbage()
		end)

		local addoncompare = function(a, b)
		return a.memory > b.memory
		end

		--插件内存明细
		local addonlist = 50
		local function ShowMemTooltip(self)
		local color = { r=0/255, g=255/255, b=0/255 }
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 30)
		local blizz = collectgarbage("count")
		local addons = {}
		local enry, memory
		local total = 0
		local nr = 0
		UpdateAddOnMemoryUsage()
		-- GameTooltip:AddLine("Top "..addonlist.." AddOns", color.r, color.g, color.b)
		GameTooltip:AddLine("")
		for i=1, C_AddOns.GetNumAddOns(), 1 do
		if (GetAddOnMemoryUsage(i) > 0) then
		memory = GetAddOnMemoryUsage(i)
		entry = { name = C_AddOns.GetAddOnInfo(i), memory = memory }
		table.insert(addons, entry)
		total = total + memory
		end
		end
		table.sort(addons, addoncompare)
		for _, entry in pairs(addons) do
		if nr < addonlist then
		GameTooltip:AddDoubleLine(entry.name, memformat(entry.memory), 1, 1, 1, 1, 1, 1)
		nr = nr+1
		end
		end
		GameTooltip:AddLine("")
		GameTooltip:AddDoubleLine(L.total or "总计", memformat(total), color.r, color.g, color.b, color.r, color.g, color.b)
		GameTooltip:AddDoubleLine(L.totalb or "总计(包括暴雪插件)", memformat(blizz), color.r, color.g, color.b, color.r, color.g, color.b)
		GameTooltip:Show()
		end

		f1:SetScript("OnEnter", function() ShowMemTooltip(f1) end)
		f1:SetScript("OnLeave", function() GameTooltip:Hide() end)

	
		if DToolsDB.ifss == true then

			fatype = rsiCreateFontString(fa, 20, "GameFontHighlightRight")
			fatype:SetPoint("BOTTOMRIGHT", fa, "BOTTOM", -15, 0)
			fat = rsiCreateFontString(fa, 20, "GameFontHighlightLeft")
			fat:SetPoint("BOTTOMLEFT", fa, "BOTTOM", -16, 0)

			f1t = rsiCreateFontString(f1, 16, "GameFontHighlight")
			f2t = rsiCreateFontString(f2, 16, "GameFontHighlight")
			f3t = rsiCreateFontString(f3, 18, "GameFontHighlight")
			f4t = rsiCreateFontString(f4, 18, "GameFontHighlight")
			f5t = rsiCreateFontString(f5, 16, "GameFontHighlight")
		
		end

	end

	end)