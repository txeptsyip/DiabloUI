---------------------------------------------
--rTooltip
---------------------------------------------

--A simple tooltip mod
--Galaxy-2016

---------------------------------------------
local _, ns =...
local L = ns.L

ns.event("PLAYER_LOGIN", function()


	-- if C_AddOns.IsAddOnLoaded("ElvUI") == true then return end
	-- if C_AddOns.IsAddOnLoaded("NDui") == true then return end
	-- if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end

	if DToolsDB.tiu ~= true then return end


	local unpack, type = unpack, type
	--local RAID_CLASS_COLORS = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)
	--local FACTION_BAR_COLORS = FACTION_BAR_COLORS
	local WorldFrame = WorldFrame
	local GameTooltip = GameTooltip
	local GameTooltipStatusBar = GameTooltipStatusBar

	---------------------------------------------
	--FUNCTIONS
	---------------------------------------------

	--change some text sizes
	if DToolsDB.tiub == true then
		GameTooltipHeaderText:SetFont(STANDARD_TEXT_FONT, 23, "THINOUTLINE")
		GameTooltipText:SetFont(STANDARD_TEXT_FONT, 19, "THINOUTLINE")
		Tooltip_Small:SetFont(STANDARD_TEXT_FONT, 17, "THINOUTLINE")
	else
		GameTooltipHeaderText:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
		GameTooltipText:SetFont(STANDARD_TEXT_FONT, 15, "THINOUTLINE")
		Tooltip_Small:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
	end

	--gametooltip statusbar
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("LEFT", 4, 0)
	GameTooltipStatusBar:SetPoint("RIGHT", -4, 0)
	GameTooltipStatusBar:SetPoint("BOTTOM", GameTooltipStatusBar:GetParent(), "TOP", 0, -6)
	GameTooltipStatusBar:SetHeight(4)
	--gametooltip statusbar bg
	--GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
	--GameTooltipStatusBar.bg:SetPoint("TOPLEFT", -1, 1)
	--GameTooltipStatusBar.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	--GameTooltipStatusBar.bg:SetTexture(0, 0, 0)
	--GameTooltipStatusBar.bg:SetVertexColor(0, 0, 0, 0.7)

	--HookScript GameTooltip OnTooltipCleared
	-- GameTooltip:HookScript("OnTooltipCleared", function(self)
	-- 	--GameTooltip_ClearStatusBars(self)
	-- 	--self.NineSlice:SetCenterColor(0, 0, 0, 1)
	-- 	--self.NineSlice:SetBorderColor(1, 1, 1, 1)
	-- end)

	-- --hooksecurefunc GameTooltip_SetDefaultAnchor

	-- hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	-- 	--if InCombatLockdown() then return end
	-- 	--tooltip:SetOwner(UIParent, "ANCHOR_CURSOR_RIGHT", 40, 0, true)	--"ANCHOR_CURSOR_LEFT"

	-- 	--tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	-- 	--tooltip:ClearAllPoints()
	-- 	--tooltip:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

		-- GameTooltip:SetScale(1.5)
	-- end)

	local function DToolsCOLOR(text, unit)
		if not text or not unit then return end
		if UnitIsPlayer(unit) then
			local _, class = UnitClass(unit)
			local colorStr = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
			return ("|c"..colorStr..text.."|r")
		elseif UnitReaction(unit, "player") then
			local color = FACTION_BAR_COLORS and FACTION_BAR_COLORS[UnitReaction(unit, "player")]
			return ("|cff%.2x%.2x%.2x"..text.."|r"):format(color.r*255, color.g*255, color.b*255)
		end
	end


	--目标鼠标提示
	local  function TooltipStyle(self)
		local unit = select(2, self:GetUnit())--[[or (GetMouseFocus() and GetMouseFocus():GetAttribute("unit"))]] or (UnitExists("mouseover") and "mouseover")

		if not unit or (unit and type(unit) ~= "string") then return end
		if not UnitGUID(unit) then return end

		if UnitIsPlayer(unit) then
			
			local _, class = UnitClass(unit)
			local color = class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
			--health bar
			GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
			GameTooltipStatusBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")--血条材质，自己改喜欢的

			--name line
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetText(DToolsCOLOR(text, unit))

			if UnitIsAFK(unit) then
				self:AppendText(" |cff00ffff<"..(L.afk or"暂离")..">|r")
			elseif UnitIsDND(unit) then
				self:AppendText(" |cffcc0000<"..(L.offl or"离线")..">|r")
			end

			--position raidicon
			local ricon = GetRaidTargetIndex(unit)
			if ricon then
				local text = GameTooltipTextLeft1:GetText()
				GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."14|t", text))
			end

			--guild line
			local guild, gRank, gRankId = GetGuildInfo(unit)
			local hasText = GameTooltipTextLeft2:GetText()

			if guild and hasText then
				if (gRank and gRankId) then
					gRank = gRank.."("..gRankId..")"
				end
				local grcolor = "AAAAAA"
				if gRankId == 0 then
					grcolor = "FF8000"
				elseif gRankId == 1 then
					grcolor = "C154FF"
				elseif gRankId == 2 then
					grcolor = "0080FF"
				elseif gRankId == 3 then
					grcolor = "1EFF00"
				elseif gRankId == 4 then
					grcolor = "FFFFFF"
				end
				GameTooltipTextLeft2:SetFormattedText("|cff3BFF3B<%s>|r |cff"..grcolor.."%s|r", guild, gRank or "")
			end

			--level line
			local levelLine = guild and GameTooltipTextLeft3 or GameTooltipTextLeft2
			local l = UnitLevel(unit)
			local color = GetCreatureDifficultyColor((l > 0) and l or 999)
			levelLine:SetTextColor(color.r, color.g, color.b)

			--class line
			if guild and GameTooltipTextLeft4 then
				local text4 = GameTooltipTextLeft4:GetText()
				GameTooltipTextLeft4:SetText(DToolsCOLOR(text4, unit))
			elseif GameTooltipTextLeft3 then
				local text3 = GameTooltipTextLeft3:GetText()
				GameTooltipTextLeft3:SetText(DToolsCOLOR(text3, unit))
			end
			
		else

			local reaction = UnitReaction(unit, "player")
			if reaction then
				local color = FACTION_BAR_COLORS[reaction]
				if color then
				GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
				GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
				end
			end

			local unitClassification = UnitClassification(unit)
			if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
				if UnitReaction(unit, "player") == 2 then
					--highlight bosses
					GameTooltipTextLeft1:SetTextColor(1, 0, 0)
				end
				self:AppendText(" |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t")
			elseif unitClassification == "rare" then
				self:AppendText("|cffff00ff<"..(L.rare or"稀有")..">|r")
			elseif unitClassification == "rareelite" then
				self:AppendText("|cffff00ff<"..(L.raree or"稀有精英")..">|r")
			elseif unitClassification == "elite" then
				self:AppendText("|cffffff00<"..(L.elite or"精英")..">|r")
			end
		end

		--ghost or dead
		if UnitIsGhost(unit) then
		self:AppendText(" |cff808080<"..(L.ghost or"幽灵")..">|r")
		-- GameTooltipTextLeft1:SetTextColor(0.5, 0.5, 0.5)
		elseif UnitIsDead(unit) then
		self:AppendText(" |cffff2200<"..(L.dead or"死亡")..">|r")
		-- GameTooltipTextLeft1:SetTextColor(1, 0, 0)
		end

		--显示目标
		if (UnitIsUnit("player", unit.."target")) then
			-- local targetText = ns.ADDUICOLOR(UnitName("mouseovertarget"),"mouseovertarget")
			self:AddDoubleLine((L.targ or"目标")..": ".."|cffff0000>"..(L.you or "你").."<|r")----self:AddLine("< YOU >", 0.5, 1)
		elseif (UnitName(unit.."target")) then
			-- local targetText = ns.ADDUICOLOR(UnitName("mouseovertarget"),"mouseovertarget")
			self:AddDoubleLine((L.targ or"目标")..": "..DToolsCOLOR(UnitName(unit.."target"), unit.."target"))
		end

		-- if (UnitName(unit.."target")) then
		-- 	local targetText = ns.ADDUICOLOR(UnitName("mouseovertarget"),"mouseovertarget")
		-- 	self:AddDoubleLine(targetText and (L.targ or"目标")..": "..targetText or nil)
		-- end

	end

	GameTooltip:HookScript("OnTooltipSetUnit", TooltipStyle)

	--NPCID
	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		local guid = UnitGUID("mouseover")
		local _, _, _, _, _, id = strsplit("-", guid or "")
		if id then
			self:AddDoubleLine("|cff0088ffNPCID:|r|cff00FF00"..id.."|r")
		end

	end)

	--物品ID--来自idtip
	local tipitemid =  function(self)
	local link = select(2, self:GetItem())
	if not link then return end

	local itemString = string.match(link, "item:([%-?%d:]+)")
	if not itemString then return end

	local enchantid = ""
	local bonusid = ""
	local gemid = ""
	local bonuses = {}
	local itemSplit = {}

	for v in string.gmatch(itemString, "(%d*:?)") do
		if v == ":" then
		itemSplit[#itemSplit + 1] = 0
		else
		itemSplit[#itemSplit + 1] = string.gsub(v, ":", "")
		end
	end

	for index = 1, tonumber(itemSplit[13]) do
		bonuses[#bonuses + 1] = itemSplit[13 + index]
	end

	local gems = {}
	if GetItemGem then
		for i=1, 4 do
		local _,gemLink = GetItemGem(link, i)
		if gemLink then
			local gemDetail = string.match(gemLink, "item[%-?%d:]+")
			gems[#gems + 1] = string.match(gemDetail, "item:(%d+):")
		elseif flags == 256 then
			gems[#gems + 1] = "0"
		end
		end
	end
	local id = string.match(link, "item:(%d*)")
	if (id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex then
		local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
		for i = 1, 8 do
		if GetMouseFocus().reagentIndex == i then
			id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d*)") or nil
			break
		end
		end
	end

	if id then
		self:AddDoubleLine("|cff0088ff"..(L.item or"物品").."ID:|r|cff00FF00".."|r", "|cff00ff00"..id.."|r")
	end
	end
	GameTooltip:HookScript("OnTooltipSetItem", tipitemid)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", tipitemid)
	ShoppingTooltip2:HookScript("OnTooltipSetItem", tipitemid)
	ItemRefTooltip:HookScript("OnTooltipSetItem", tipitemid)

	--buff来源
	local function SetCaster(self, unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,_,spellId = UnitAura(unit, index, filter)
	if unitCaster then
	local uname, urealm = UnitName(unitCaster)
	local _, uclass = UnitClass(unitCaster)
	local cr,cb,cg = GetClassColor(uclass)
	if urealm then uname = uname .. '-' .. urealm end
	self:AddDoubleLine("|cff0088ff"..(L.spell or"法术").."ID:|r|cff00FF00"..spellId.."|r",uname, nil, nil, nil,cr,cb,cg)
	self:Show()
	end
	end
	hooksecurefunc(GameTooltip, 'SetUnitAura', SetCaster)
	hooksecurefunc(GameTooltip, 'SetUnitBuff', function(self, unit, index, filter)
	filter = filter and ('HELPFUL ' .. filter) or 'HELPFUL'
	SetCaster(self, unit, index, filter)
	end)
	hooksecurefunc(GameTooltip, 'SetUnitDebuff', function(self, unit, index, filter)
	filter = filter and ('HARMFUL ' .. filter) or 'HARMFUL'
	SetCaster(self, unit, index, filter)
	end)

	--法术ID
	GameTooltip:HookScript("OnTooltipSetSpell", function(self)
		if not self or not self:GetSpell() then return end
		self:AddDoubleLine("|cff0088ff"..(L.spell or"法术").."ID:|r|cff00FF00"..select(2, self:GetSpell()).."|r")
	end)
	-- AddLine((L.spell or"法术").."ID: "..id, 0, 0.5, 1) /
	--https://bbs.nga.cn/read.php?&tid=5367373
	GameTooltip:HookScript("OnTooltipSetUnit", function(self,...)
		if (showTooltip) then
			showTooltip()
		end
	end)


	--物品单价
	local function SimpleVendorPriceTooltip()
		GameTooltip:HookScript("OnTooltipSetItem", function(self)
			local name, link = self:GetItem()
			if link then
				local itemID = link:match("item:(%d+)")
				if itemID then
					local vendorPrice = select(11, GetItemInfo(tonumber(itemID)))
					if vendorPrice and vendorPrice > 0 then
						self:AddDoubleLine("|cffffffff"..(L.ppu or "单价")..":|r","|cffffffff"..GetCoinTextureString(vendorPrice).."|r")
						self:Show()
					end
				end
			end
		end)
	end
	SimpleVendorPriceTooltip()


	------------------------------
	----------物品等级------------		by:MiniToolTip
	------------------------------
	if WOW_PROJECT_ID ~= WOW_PROJECT_MISTS_CLASSIC then
		-- Add the item level text to the tooltip
		local function SetToolTipText(tooltip, itemLevel, itemClassID, rowIndex, isShoppingTooltip)

			-- Weapon, Armor, or Projectile
			if itemClassID == 2 or itemClassID == 4 or itemClassID == 6 then
			local left = _G[tooltip:GetName() .. 'TextLeft' .. rowIndex]
				local leftText = left:GetText()

			-- There's a weird interaction with new lines for the shopping tooltips, the text gets spaces inserted on render; can't remove
			-- So instead if is shopping tt, then move then combine the existing line with the next one
			if isShoppingTooltip then
				left:SetText("|cffffd100"..(L.iteml or "物品等级")..": " .. itemLevel .. "|r")

				local nextLeft = _G[tooltip:GetName() .. 'TextLeft' .. rowIndex+1]
				nextLeft:SetText(leftText .. "|n" .. nextLeft:GetText())
			else
				left:SetText("|cffffd100"..(L.iteml or "物品等级")..": " .. itemLevel .. "|r|n" .. leftText)
			end

				tooltip:Show()
			end
		end

		-- Get the item info from the given item link provided
		local function GetItemInfoFromLink(link)
			if link then
				local _, _, _, itemLevel,_,_,_,_,_,_,_, classID,_ = GetItemInfo(link)

				return itemLevel, classID
			end
		end

		-- Modify the on hover tooltip's text to include current item context's item level
		local function GameTooltipSetItem(tooltip, ...)
			if tooltip:IsForbidden() then return end

			local _, link = tooltip:GetItem()

			local itemLevel, classID = GetItemInfoFromLink(link)

			SetToolTipText(tooltip, itemLevel, classID, 2)
		end

		-- The on-item link click tooltip
		local function ItemRefTooltipSetItem(tooltip, ...)
			if tooltip:IsForbidden() then return end

			local _, link = tooltip:GetItem()

			local itemLevel, classID = GetItemInfoFromLink(link)

			SetToolTipText(tooltip, itemLevel, classID, 2)
		end

		-- The first comparison tooltip when comparison modifier is true, e.g shift key pressed on hover
		local function ShoppingTooltip1SetItem(tooltip, ...)
			if tooltip:IsForbidden() then return end

			local _, link = tooltip:GetItem()

			local itemLevel, classID = GetItemInfoFromLink(link)

			SetToolTipText(tooltip, itemLevel, classID, 3, true)
		end

		-- The second comparison tooltip when comparison modifier is true, e.g shift key pressed on hover
		local function ShoppingTooltip2SetItem(tooltip, ...)
			if tooltip:IsForbidden() then return end

			local _, link = tooltip:GetItem()

			local itemLevel, classID = GetItemInfoFromLink(link)

			SetToolTipText(tooltip, itemLevel, classID, 3, true)
		end

		-- The third comparison tooltip when comparison modifier is true, e.g shift key pressed on hover
		local function ShoppingTooltip3SetItem(tooltip, ...)
			if tooltip:IsForbidden() then return end

			local _, link = tooltip:GetItem()

			local itemLevel, classID = GetItemInfoFromLink(link)

			SetToolTipText(tooltip, itemLevel, classID, 3, true)
		end

		GameTooltip:HookScript("OnTooltipSetItem", GameTooltipSetItem)
		ItemRefTooltip:HookScript("OnTooltipSetItem", ItemRefTooltipSetItem)
		ShoppingTooltip1:HookScript("OnTooltipSetItem", ShoppingTooltip1SetItem)
		ShoppingTooltip2:HookScript("OnTooltipSetItem", ShoppingTooltip2SetItem)
		--ShoppingTooltip3:HookScript("OnTooltipSetItem", ShoppingTooltip3SetItem) -- Don't think the third one ever gets used
	end

end)