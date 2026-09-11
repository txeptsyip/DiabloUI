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
	f:SetPoint("BOTTOM", UIParent, "BOTTOMRIGHT", -285, 1)


	local infocfg = {}
	ns.infocfg = infocfg

	infocfg.unlock = true--解锁位置
	infocfg.pos = { a1 = "BOTTOMRIGHT", af = f, a2 = "BOTTOM", x = 0, y = 2 }
	infocfg.ttpos = { a1 = "BOTTOMLEFT", af = f, a2 = "BOTTOM", x = -230, y = 0 }

	infocfg.showAttribute = true--绿字属性 fa
	infocfg.showSysinfo = true--系统信息 f1
	infocfg.showSpeed = true--移动速度 f2
	infocfg.showSpec = true--拾取天赋 f3
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
		local lootspecID = GetLootSpecialization()
		local _, lootspec0 = C_SpecializationInfo.GetSpecializationInfo(C_SpecializationInfo.GetSpecialization())
		local _, lootspec = GetSpecializationInfoByID(lootspecID)

		if lootspecID == 0 and lootspec0 then
			if UnitLevel("player") < 10 then
				return "|c"..classcs..(L.lootspec or "天赋拾取")..":|r".."|cff00ff00"..(L.none or "无").."|r"
			else
				return "|c"..classcs..(L.lootspec or "天赋拾取")..":|r".."|cff00ff00"..lootspec0.."|r"
			end
		elseif lootspec then
			return "|c"..classcs..(L.lootspec or "天赋拾取")..":|r".."|cffff0000"..lootspec.."|r"
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


		local function Attributetype()
			local stat = {
				str = UnitStat("player", 1),
				agi = UnitStat("player", 2),
				int = UnitStat("player", 4)
					}
			if stat.str > stat.agi and stat.str > stat.int then
				return
				"|cff00ff00"..(L.str or "攻强")..":|r".."\n"..
				"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
				"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
				"|cff00ff00"..(L.mas or "精通")..":|r"
			elseif stat.agi > stat.str and stat.agi > stat.int then
				return
				"|cff00ff00"..(L.str or "攻强")..":|r".."\n"..
				"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
				"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
				"|cff00ff00"..(L.mas or "精通")..":|r"
			elseif stat.int > stat.str and stat.int > stat.agi then
				return
				"|cff00ff00"..(L.spd or "法伤")..":|r".."\n"..
				"|cff00ff00"..(L.cri or "爆击")..":|r".."\n"..
				"|cff00ff00"..(L.has or "急速")..":|r".."\n"..
				"|cff00ff00"..(L.mas or "精通")..":|r"
			end
		end


		local function Attribute()
			local base, posBuff, negBuff = UnitAttackPower("player");
			local stat = {
				str = UnitStat("player", 1),
				agi = UnitStat("player", 2),
				int = UnitStat("player", 4),

            	eft = base + posBuff + negBuff,

				spd = math.max(GetSpellBonusDamage(2)),
				cri = format("%.2f", GetCritChance()),
				has = format("%.2f", GetHaste()),
				mas = format("%.2f", GetMasteryEffect()),
				-- ver = format("%.2f", GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)),

					}
			if stat.str > stat.agi and stat.str > stat.int then
				return
				"|c"..classcs..stat.eft.."|r".."\n"..
				"|c"..classcs..stat.cri.."|r".."%".."\n"..
				"|c"..classcs..stat.has.."|r".."%".."\n"..
				"|c"..classcs..stat.mas.."|r".."%"
			elseif stat.agi > stat.str and stat.agi > stat.int then
				return
				"|c"..classcs..stat.eft.."|r".."\n"..
				"|c"..classcs..stat.cri.."|r".."%".."\n"..
				"|c"..classcs..stat.has.."|r".."%".."\n"..
				"|c"..classcs..stat.mas.."|r".."%"
			elseif stat.int > stat.str and stat.int > stat.agi then
				return
				"|c"..classcs..stat.spd.."|r".."\n"..
				"|c"..classcs..stat.cri.."|r".."%".."\n"..
				"|c"..classcs..stat.has.."|r".."%".."\n"..
				"|c"..classcs..stat.mas.."|r".."%"
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

		--天赋拾取切换
		if infocfg.showSpec then
			
			-- 材质转文本
			local GetTexStr = function(tex, size)
				local s = size or 13
				return "|T"..tex..":"..s..":"..s..":0:0:64:64:4:60:4:60|t"
			end
			-- 拾取切换
			local function TalentDropDown_Initialize1(self, level, menuList)
				local current_spec_index = C_SpecializationInfo.GetSpecialization()
				local current_lootspec_index = GetLootSpecialization()
				local cur_specID, cur_specName, _, cur_Icon = C_SpecializationInfo.GetSpecializationInfo(current_spec_index)
				-- local cur_LootspecID, cur_LootspecName = GetSpecializationInfoByID(current_lootspec_index)
				local numspec = GetNumSpecializations()
				local info

				if level == 1 then
					info = UIDropDownMenu_CreateInfo()
					info.text = "|cffffff00"..(L.slspec or "    切换拾取天赋").."|r"
					info.isTitle = true
					info.notCheckable = true
					UIDropDownMenu_AddButton(info, level)

					info = UIDropDownMenu_CreateInfo()
					for i = 0, numspec do
						if i == 0 then
							info.text = string.format(LOOT_SPECIALIZATION_DEFAULT, GetTexStr(cur_Icon).." "..cur_specName)
							info.checked = (current_lootspec_index == 0)
							info.notCheckable = false
							info.func = function()
								SetLootSpecialization(0)
								HideDropDownMenu(1)
							end
						else
							local id, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(i)
							info.text = GetTexStr(icon).." "..name
							info.checked = (current_lootspec_index == id)
							info.notCheckable = false
							info.func = function()
								SetLootSpecialization(id)
								HideDropDownMenu(1)
							end
						end
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end
			--天赋切换
			local function TalentDropDown_Initialize2(self, level, menuList)
				if UnitLevel("player") < 10 or GetNumSpecGroups() < 2  then return end
				local current_spec_index = C_SpecializationInfo.GetSpecialization(nil, nil, i)
				-- local current_lootspec_index = GetLootSpecialization()
				local cur_specID, cur_specName, _, cur_Icon = C_SpecializationInfo.GetSpecializationInfo(current_spec_index)
				-- local cur_LootspecID, cur_LootspecName = GetSpecializationInfoByID(current_lootspec_index)
				local info

				if level == 1 then
					info = UIDropDownMenu_CreateInfo()
					info.text = "|cffffff00"..(L.sspec or "    切换天赋").."|r"
					info.isTitle = true
					info.notCheckable = true
					UIDropDownMenu_AddButton(info, level)
					
					info = UIDropDownMenu_CreateInfo()
					for i = 1, 2 do
						local specIndex = C_SpecializationInfo.GetSpecialization(nil, nil, i)
						if specIndex then
							local id, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(specIndex)
							info.text = GetTexStr(icon).." "..name
							info.checked = (cur_specID == id)
							info.notCheckable = false
							info.func = function()
								C_SpecializationInfo.SetActiveSpecGroup(i)
								HideDropDownMenu(1)
							end
							UIDropDownMenu_AddButton(info, level)
						end
					end
				end
			end


			f3.DropDown1 = CreateFrame("Frame", nil, f3, "UIDropDownMenuTemplate")
			f3.DropDown2 = CreateFrame("Frame", nil, f3, "UIDropDownMenuTemplate")
			f3:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					f3.DropDown1.point = "BOTTOM";
					f3.DropDown1.relativePoint = "TOP"
					ToggleDropDownMenu(1, nil, f3.DropDown1, f3, 0, 5)
				elseif button == "RightButton" then
					f3.DropDown2.point = "BOTTOM";
					f3.DropDown2.relativePoint = "TOP"
					ToggleDropDownMenu(1, nil, f3.DropDown2, f3, 0, 5)
				end
			end)

			f3:SetScript("OnEvent", function(self, event)
				UIDropDownMenu_Initialize(self.DropDown1, TalentDropDown_Initialize1, "MENU")
				UIDropDownMenu_Initialize(self.DropDown2, TalentDropDown_Initialize2, "MENU")
				if event == "PLAYER_ENTERING_WORLD" then
					self:UnregisterEvent("PLAYER_ENTERING_WORLD")
				end
				if event == "PLAYER_SPECIALIZATION_CHANGED" then
					self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
				end
				if event == "PLAYER_LOOT_SPEC_UPDATED" then
					self:UnregisterEvent("PLAYER_LOOT_SPEC_UPDATED")
				end
			end)

			f3:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
			f3:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
			f3:RegisterEvent("PLAYER_ENTERING_WORLD")

		end



		if DToolsDB.ifss == true then

		fatype = rsiCreateFontString(fa, 20, "GameFontHighlightRight")
		fatype:SetPoint("BOTTOMRIGHT", fa, "BOTTOM", -12, 0)
		fat = rsiCreateFontString(fa, 20, "GameFontHighlightLeft")
		fat:SetPoint("BOTTOMLEFT", fa, "BOTTOM", -13, 0)

		f1t = rsiCreateFontString(f1, 16, "GameFontHighlight")
		f2t = rsiCreateFontString(f2, 16, "GameFontHighlight")
		f3t = rsiCreateFontString(f3, 18, "GameFontHighlight")
		f4t = rsiCreateFontString(f4, 18, "GameFontHighlight")
		f5t = rsiCreateFontString(f5, 16, "GameFontHighlight")
		
		end

	end
end)