local _
local AddonName, ns =...
local oUF = ns.oUF or oUF
--get the config
local cfg = ns.cfg

oUF.colors.power.MANA:SetRGB(0, 0.4, 1)
-- oUF.colors.power["MANA"] = {0, 0.36, 1}

if OverrideActionBar then OverrideActionBar:SetScale(1.05) end	--载具动作条

SlashCmdList["RELOAD"] = function() ReloadUI() end SLASH_RELOAD1 = "/rl"


local FirstloadFrame = CreateFrame("FRAME");
-- FirstloadFrame:RegisterEvent("ADDON_LOADED");
FirstloadFrame:RegisterEvent("PLAYER_LOGIN");
FirstloadFrame:SetScript("OnEvent", function(...)
	if C_AddOns.IsAddOnLoaded("!!!_Diablo_classic_") == true or C_AddOns.IsAddOnLoaded("!!!_Diablo_titan_") == true or C_AddOns.IsAddOnLoaded("!!!_Diablo_anni_") == true or C_AddOns.IsAddOnLoaded("!!!_Diablo_era_") == true then
		print("|cffff0000>DiabloUI:请删除旧版本插件!|r ")
		print("|cffff0000>DiabloUI:請刪除舊版本插件!|r ")
		print("|cffff0000>DiabloUI:Please delete the old version of the addon!|r ")
		print("|cffff0000>DiabloUI:Пожалуйста, удалите старую версию аддона!|r ")
		print("|cffff0000>DiabloUI:Veuillez supprimer l'ancienne version de l'addon!|r ")
	end
end)


-- uisl = CreateFrame"Frame"
-- uisl:RegisterEvent"PLAYER_ENTERING_WORLD"
-- uisl:SetScript("OnEvent", function(self, event)
-- 	self:UnregisterEvent"PLAYER_ENTERING_WORLD"
-- 	SetCVar("useUiScale", 1)
-- 	SetCVar("uiScale", 0.65)--0.711
-- end)

---------------------------------------------
--VARIABLES
---------------------------------------------
local tinsert, tremove, floor, mod, format = tinsert, tremove, floor, mod, format
---------------------------------------------
--FUNCTIONS
---------------------------------------------

--移动模块
Diablo_Move_frame = {
	"DiabloPlayerFrame",
	-- "DiabloHealthOrb",
	"DiabloPowerOrb",
	-- "DiabloAddPower",
	"DruidManabar",
	"DiabloAngelFrame",
	"DiabloDemonFrame",
	"DiabloPetFrame",
	"DiabloPetTargetFrame",
	"TTFMFrame",
	}

local function SetupMovableFrame(v)
	if InCombatLockdown() then return end
	local frame = _G[v]
	if not frame then return end
	local isDragging = false

	-- 设置可移动属性
	if v ~= "TTFMFrame" and frame:IsShown() then frame:EnableMouse(true) end
	frame:SetClampedToScreen(false)
	frame:RegisterForDrag("LeftButton")
	
	-- 拖动开始
	frame:HookScript("OnDragStart", function(self, button)
		if InCombatLockdown() then 
			print("|cffff0000!!!|r|cff00ff00>|rInCombatLockdown!") 
		else
			frame:SetMovable(true)
			if IsShiftKeyDown() then
				self:StartMoving()
			end
		end
		isDragging = true
	end)
	
	-- 拖动结束
	frame:HookScript("OnDragStop", function(self, button)
		if InCombatLockdown() then return end
		self:StopMovingOrSizing()
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
		if relativeTo and relativeTo:GetName() then relativeTo = relativeTo:GetName() end
		if point then
			-- 保存完整信息
			Diablo_DB_GLOB[v] = {
				point = point,
				relativeTo = relativeTo,
				relativePoint = relativePoint,
				xOfs = xOfs,
				yOfs = yOfs
			}
		end
		isDragging = false
	end)
	
	if Diablo_DB_GLOB and Diablo_DB_GLOB[v] then
		if isDragging then return end
		local pos = Diablo_DB_GLOB[v]
		if not pos then return end
		local point = pos.point
		local relativeTo = pos.relativeTo
		local relativePoint = pos.relativePoint
		local xOfs = pos.xOfs
		local yOfs = pos.yOfs
		frame:ClearAllPoints()
		frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
	end
end

local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(...)
	for _, v in pairs(Diablo_Move_frame) do
		SetupMovableFrame(v)
	end
end)

local function SetupFramePoints(v)
	local frame = _G[v]
	if not frame then return end
	local pos = Diablo_DB_GLOB[v]
	if not pos then return end
	local point = pos.point
	local relativeTo = pos.relativeTo
	local relativePoint = pos.relativePoint
	local xOfs = pos.xOfs
	local yOfs = pos.yOfs
	frame:ClearAllPoints()
	frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
end

function DiabloReset()
	if InCombatLockdown() then print("|cffff0000!!!|r|cff00ff00>|rInCombatLockdown!") return end
	Diablo_DB_GLOB.DiabloPlayerFrame = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = -360, yOfs = 0}
	-- Diablo_DB_GLOB.DiabloHealthOrb = {point = "CENTER", relativeTo = "DiabloPlayerFrame", relativePoint = "CENTER", xOfs = 0, yOfs = 0}
	Diablo_DB_GLOB.DiabloPowerOrb = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = 360, yOfs = 0}
	Diablo_DB_GLOB.DruidManabar = {point = "BOTTOM", relativeTo = "DiabloPowerOrb", relativePoint = "TOP", xOfs = 0, yOfs = 16}
	-- Diablo_DB_GLOB.DiabloAddPower = {point = "BOTTOM", relativeTo = "DiabloPowerOrb", relativePoint = "TOP", xOfs = 0, yOfs = 16}
	Diablo_DB_GLOB.DiabloAngelFrame = {point = "BOTTOMLEFT", relativeTo = "DiabloPowerOrb", relativePoint = "BOTTOMRIGHT", xOfs = 8, yOfs = 0}
	Diablo_DB_GLOB.DiabloDemonFrame = {point = "BOTTOMRIGHT", relativeTo = "DiabloHealthOrb", relativePoint = "BOTTOMLEFT", xOfs = -8, yOfs = 0}
	Diablo_DB_GLOB.DiabloPetFrame = {point = "BOTTOMRIGHT", relativeTo = "DiabloHealthOrb", relativePoint = "TOPLEFT", xOfs = 5, yOfs = -20}
	Diablo_DB_GLOB.DiabloPetTargetFrame = {point = "BOTTOM", relativeTo = "DiabloPetFrame", relativePoint = "TOP", xOfs = 0, yOfs = 20}

	Diablo_DB_GLOB.TTFMFrame = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = -360, yOfs = 160}

	for _, v in pairs(Diablo_Move_frame) do
		SetupFramePoints(v)
	end

end

SlashCmdList["DIABLOFR"] =  function() DiabloReset() end
SLASH_DIABLOFR1 = "/dr"
-- SLASH_DIABLOFR2 = "/dfr"


--number format func
if (GetLocale() == "zhCN") then
	ns.numFormat = function(v)
		if v > 1e8 then return format("%.1f", v/1e8).."亿"
		elseif v > 1e6 then return format("%.1f", v/1e4).."万"
		else return v end
	end
else
	ns.numFormat = function(v)
		if v > 1e7 then return format("%.1f", v/1e6).."M"
		elseif v > 1e4 then return format("%.1f", v/1e3).."K"
		else return v end
	end
end

--
--fontstring func
ns.createFontString = function(f, font, size, outline, layer)
	local fs = f:CreateFontString(nil, layer or "ARTWORK")
	fs:SetFont(font, size, outline)
	fs:SetShadowColor(0, 0, 0, 1)
	return fs
end
--
--create icon func
ns.createIcon = function(f, layer, size, anchorframe, anchorpoint1, anchorpoint2, posx, posy, sublevel)
	local icon = f:CreateTexture(nil, "ARTWORK", nil, sublevel)
	icon:SetSize(size, size)
	icon:SetPoint(anchorpoint1, anchorframe, anchorpoint2, posx, posy)
	return icon
end
--
--update health func
ns.updateHealth = function(bar, unit, min, max)
	local d = floor(min/max*100)
	--low hp
	if d <= 25 or dead == 1 then
		bar.highlight:SetAlpha(0)
		bar.glow:SetVertexColor(1, 0, 0, 1)
	else
		--inner shadow
		bar.glow:SetVertexColor(0, 0, 0, 0.7)
		bar.highlight:SetAlpha(0)
	end
	--bar.highlight:SetAlpha((min/max)*0)
end
--
--basic slider func
--round number
ns.round = function(val)
	return floor(val*100)/100
	end
--update power func
ns.updatePower = function(bar, unit, min, max)
	local color = PowerBarColor[select(2, UnitPowerType(unit))]
	if not color then
		--prevent powertype from bugging out on certain encounters.
		color = { r = 1, g = 0.5, b = 0.25 }
	end
	bar:SetStatusBarColor(color.r, color.g, color.b, 1)
end
--
-- if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
-- 	--total absorb
-- 	ns.totalAbsorb = function(self)
-- 		local w = self.Health:GetWidth()
-- 		if w == 0 then w = self:GetWidth()-60-24.5 end
-- 		--if w == 0 then
-- 		--w = self:GetWidth()-24.5-24.5--raids and party have no width on the health frame for whatever reason, thus use self and subtract the setpoint values
-- 		--end
-- 		local absorbBar = CreateFrame("StatusBar", nil, self.Health)
-- 		--new anchorpoint, absorb will now overlay the healthbar from right to left
-- 		absorbBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
-- 		absorbBar:SetPoint("TOPRIGHT", self.Health, 0, 0)
-- 		absorbBar:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
-- 		absorbBar:SetWidth(w)
-- 		absorbBar:SetStatusBarTexture("Interface\\AddOns\\"..AddonName.."\\media\\absorb_statusbar_overlay")
-- 		absorbBar:SetStatusBarColor(0.7, 1, 1, 0.9)
-- 		absorbBar:SetReverseFill(true)
-- 		--Register with oUF
-- 		if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
-- 			self.CustomAbsorb = absorbBar
-- 		else
-- 			self.TotalAbsorb = absorbBar
-- 		end
-- 	end
-- end
-- --
-- ns.HealthPrediction = function(self)
-- 	--Position and size
-- 	local myBar = CreateFrame("StatusBar", nil, self.Health)
-- 	myBar:SetPoint"TOP"
-- 	myBar:SetPoint"BOTTOM"
-- 	myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
-- 	myBar:SetWidth(200)
-- 	myBar:SetStatusBarTexture("Interface\\AddOns\\"..AddonName.."\\media\\absorb_statusbar_overlay")
-- 	myBar:SetStatusBarColor(0.7, 1, 1, 0.9)
-- 	local otherBar = CreateFrame("StatusBar", nil, self.Health)
-- 	otherBar:SetPoint"TOP"
-- 	otherBar:SetPoint"BOTTOM"
-- 	otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
-- 	otherBar:SetWidth(200)
-- 	otherBar:SetStatusBarTexture("Interface\\AddOns\\"..AddonName.."\\media\\absorb_statusbar_overlay")
-- 	otherBar:SetStatusBarColor(0.7, 1, 1, 0.9)
-- 	--[[
-- 		local absorbBar = CreateFrame('StatusBar', nil, self.Health)
-- 		absorbBar:SetPoint('TOP')
-- 		absorbBar:SetPoint('BOTTOM')
-- 		absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), 'RIGHT')
-- 		absorbBar:SetWidth(200)
-- 		absorbBar:SetStatusBarTexture("Interface\\AddOns\\"..AddonName.."\\media\\absorb_statusbar_overlay")
-- 		absorbBar:SetStatusBarColor(0.7, 1, 1, 0.9)
-- 	]]
-- 	local healAbsorbBar = CreateFrame("StatusBar", nil, self.Health)
-- 	healAbsorbBar:SetPoint"TOP"
-- 	healAbsorbBar:SetPoint"BOTTOM"
-- 	healAbsorbBar:SetPoint("RIGHT", self.Health:GetStatusBarTexture())
-- 	healAbsorbBar:SetWidth(200)
-- 	healAbsorbBar:SetReverseFill(true)
-- 	healAbsorbBar:SetStatusBarTexture("Interface\\AddOns\\"..AddonName.."\\media\\absorb_statusbar_overlay")
-- 	healAbsorbBar:SetStatusBarColor(1, 0, 0, 0.9)
-- 	local overAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
-- 	overAbsorb:SetPoint"TOP"
-- 	overAbsorb:SetPoint"BOTTOM"
-- 	overAbsorb:SetPoint("LEFT", self.Health, "RIGHT")
-- 	overAbsorb:SetWidth(10)
-- 	local overHealAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
-- 	overHealAbsorb:SetPoint"TOP"
-- 	overHealAbsorb:SetPoint"BOTTOM"
-- 	overHealAbsorb:SetPoint("RIGHT", self.Health, "LEFT")
-- 	overHealAbsorb:SetWidth(10)
-- 	--Register with oUF
-- 	self.HealthPrediction = {
-- 		healingAll = myBar,
-- 		healingPlayer = myBar,
-- 		healingOther = otherBar,
-- 		-- damageAbsorb = absorbBar,
-- 		healAbsorb = healAbsorbBar,
-- 		-- overDamageAbsorbIndicator = overAbsorb,
-- 		-- overHealAbsorbIndicator = overHealAbsorb,

-- 		-- extra options
-- 		-- incomingHealOverflow = 1.05,
-- 		frequentUpdates = true
-- 		}
-- end

oUF.Tags.Methods["topdefhp"] = function(unit)
	local val = oUF.Tags.Methods["perhp"](unit)
	return val or ""
end
oUF.Tags.Events["topdefhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["botdefhp"] = function(unit)
	local val = oUF.Tags.Methods["curhp"](unit)
	val = ns.numFormat(val)
	return val or ""
end
oUF.Tags.Events["botdefhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["botcurhp"] = function(unit)
	local val = oUF.Tags.Methods["curhp"](unit)
	return val or ""
end
oUF.Tags.Events["botcurhp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["topdefpp"] = function(unit)
	local val = oUF.Tags.Methods["perpp"](unit)
	return val or ""
end
oUF.Tags.Events["topdefpp"] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_MAXPOWER UNIT_CONNECTION"

oUF.Tags.Methods["botdefpp"] = function(unit)
	local val = oUF.Tags.Methods["curpp"](unit)
	val = ns.numFormat(val)
	return val or ""
end
oUF.Tags.Events["botdefpp"] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_MAXPOWER UNIT_CONNECTION"

oUF.Tags.Methods["botcurpp"] = function(unit)
	local val = oUF.Tags.Methods["curpp"](unit)
	return val or ""
end
oUF.Tags.Events["botcurpp"] = "UNIT_DISPLAYPOWER UNIT_POWER_UPDATE UNIT_MAXPOWER UNIT_CONNECTION"

--rgb to hex func
local function RGBPercToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 1
	g = g <= 1 and g >= 0 and g or 1
	b = b <= 1 and b >= 0 and b or 1
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

--color tag
oUF.Tags.Methods["diablo:color"] = function(unit)
	local color = { r = 1, g = 1, b = 1 }
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then color = { r = 0.5, g = 0.5, b = 0.5 }
	elseif UnitIsPlayer(unit) then
		color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(unit))]
		--happiness removed in 4.1
		--elseif UnitIsUnit(unit, "pet") and GetPetHappiness() then
		--color = cfg.happycolors[GetPetHappiness()]
	elseif UnitIsUnit(unit, "target") and UnitIsTapDenied"target" then color = { r = 0.5, g = 0.5, b = 0.5 }
	else color = FACTION_BAR_COLORS[UnitReaction(unit, "player")] end
	if color then return RGBPercToHex(color.r, color.g, color.b)
	else return "ffffff" end
end
--name tag
oUF.Tags.Methods["diablo:name"] = function(unit)
	local cc = ("|cff%s%%s|r"):format(oUF.Tags.Methods["diablo:color"](unit))
	local unitID = C_AddOns.IsAddOnLoaded"Totalrp3" and TRP3_API.utils.str.getUnitID(unit)
	local fullName = unitID and TRP3_API.chat.getFullnameForUnitUsingChatMethod(unitID)
	return cc:format(fullName or UnitName(unit) or "")
end
oUF.Tags.Events["diablo:name"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["diablo:misshp"] = function(unit)
	local color = oUF.Tags.Methods["diablo:colorsimple"](unit)
	local hpval
	if UnitIsDeadOrGhost(unit) then hpval = "Dead"
	elseif not UnitIsConnected(unit) then hpval = "Offline"
	else
		local max, min = UnitHealthMax(unit), UnitHealth(unit)
		if max-min > 0 then hpval = "-"..ns.numFormat(max-min) end
	end
	return "|cff"..color..(hpval or "").."|r"
end
oUF.Tags.Events["diablo:misshp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"