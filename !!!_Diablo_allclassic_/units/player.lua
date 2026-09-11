local _
local AddonName, ns =...
local oUF = ns.oUF or oUF
local db = ns.db
--" HIGH MEDIUM LOW "
local floor, abs, sin, pi = floor, math.abs, math.sin, math.pi
local tinsert = tinsert
local mediapath = "Interface\\AddOns\\"..AddonName.."\\media\\"
local Classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass"player")]
local unit = CreateFrame("Frame")
unit:Hide()
ns.unit = unit

function oUF:DisableBlizzard(unit)--显示全部
	--PlayerFrame:UnregisterAllEvents()
	--PlayerFrame:Hide()
end

--图腾条
local TTFMF = CreateFrame("Button","TTFMFrame",UIParent)
TTFMF:SetPoint("BOTTOM", UIParent, "BOTTOM", -360, 160)
TTFMF:SetSize(110,110)
TTFMF:EnableMouse(false)

local nogrid = true

local cfg = {}
if nogrid then
	cfg = {
		unlock = true,
		texture = "Interface\\AddOns\\"..AddonName.."\\media\\orb_filling11",	--球素材
		texturepower = "Interface\\AddOns\\"..AddonName.."\\media\\orb_filling11_fh",	--球素材
		healthcolor = { r = 0.9, g = 0, b = 0, },
		powercolor = { r = 0, g = 0.4, b = 1, },
		colorAuto = true,
		size = 160,
		scale = 1,
		pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x =-360, y = 0 },

		orbalpha = 1,			--生命球
		orbgridalpha = 0,		--外圈

		modelalpha = 0.2,		--整体大气泡

		backgroundalpha = 0.1, 	--背景
		highlightalpha = 0.8,	--光照阴影
		orbshadowalpha = 0.2,	--阴影边框

		sparkalpha = 1,		--血线波浪

		--旋转素材
		bubblesalpha = 0.3,	--旋转小气泡
		galaxiesalpha = 0.8,	--旋转星空
		pic1salpha = 0.6,		--发光素材
		pic2salpha = 0.5,		--不透明素材
		pic1stexture = "orb_filling2",
		pic1sfhtexture = "orb_filling2_fh",
		pic2stexture = "orb_filling3",
		pic2sfhtexture = "orb_filling3_fh",

		--value
		value = {
			hideOnEmpty = true,
			hideOnFull = false,
			short = true,
			alpha = 1,
			top = {
				color = { r = 1, g = 1, b = 1, },
				tag = "topdef",
				},
			bottom = {
				color = { r = 0.8, g = 0.8, b = 0.8, },
				tag = "botdef",
				},
			},
		--经验 声望 神器能量
		erabar = {
			show = true,
			size = { w = 580, h = 6 },
			space = 0,
			pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 0 },
		}
	}
		
else
	cfg = {
		unlock = true,
		texture = "Interface\\AddOns\\"..AddonName.."\\media\\orb_filling11",	--球素材
		texturepower = "Interface\\AddOns\\"..AddonName.."\\media\\orb_filling11_fh",	--球素材
		healthcolor = { r = 0.95, g = 0, b = 0, },
		powercolor = { r = 0, g = 0.4, b = 1, },
		colorAuto = true,
		size = 155,
		scale = 1,
		pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x =-360, y = 0 },

		orbalpha = 1,			--生命球
		orbgridalpha = 1,		--外圈

		modelalpha = 0.1,		--整体大气泡

		backgroundalpha = 0.1, 	--背景
		highlightalpha = 0.6,	--光照阴影
		orbshadowalpha = 0.4,	--阴影边框

		sparkalpha = 1,		--血线波浪

		--旋转素材
		bubblesalpha = 0.1,	--旋转小气泡
		galaxiesalpha = 0.5,	--旋转星空
		pic1salpha = 0.4,		--发光素材
		pic2salpha = 0.1,		--不透明素材
		pic1stexture = "orb_filling2",
		pic1sfhtexture = "orb_filling2_fh",
		pic2stexture = "orb_filling3",
		pic2sfhtexture = "orb_filling3_fh",

		--value
		value = {
			hideOnEmpty = true,
			hideOnFull = false,
			short = true,
			alpha = 1,
			top = {
				color = { r = 1, g = 1, b = 1, },
				tag = "topdef",
				},
			bottom = {
				color = { r = 0.8, g = 0.8, b = 0.8, },
				tag = "botdef",
				},
			},
		--经验 声望 神器能量
		erabar = {
			show = true,
			size = { w = 580, h = 6 },
			space = 0,
			pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 0 },
		}
	}
end


--create galaxy func
local createGalaxy = function(frame, type, x, y, size, duration, texture, sublevel, degree, blend)
	local t = frame:CreateTexture(nil, "ARTWORK", nil, sublevel)
	t:SetSize(size, size)
	t:SetPoint("CENTER", x, y)
	t:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\"..texture)
	t:SetBlendMode(blend)	--ADD=发光;BLEND=不透明
	t.ag = t:CreateAnimationGroup()
	t.ag.ro1 = t.ag:CreateAnimation("Rotation")
	t.ag.ro1:SetDegrees(degree)
	t.ag.ro1:SetDuration(duration)
	t.ag.ro1:SetOrder(1)

	t.ag:Play()
	t.ag:SetLooping("REPEAT")

	t.aga = t:CreateAnimationGroup()
	t.aga.allow = t.aga:CreateAnimation("Alpha")
	--t.aga.allow:SetFromAlpha(1)
	--t.aga.allow:SetToAlpha(0.5)
	t.aga.allow:SetDuration(duration/3+6)
	t.aga.allow:SetOrder(1)

	t.aga.alhigh = t.aga:CreateAnimation("Alpha")
	--t.aga.alhigh:SetFromAlpha(0.5)
	--t.aga.alhigh:SetToAlpha(1)
	t.aga.alhigh:SetDuration(duration/3+6)
	t.aga.alhigh:SetOrder(2)

	t.aga:Play()
	t.aga:SetLooping("REPEAT")

	return t
end


--update StatusBarColor func
local updateStatusBarColor = function(bar)
	local orb = bar:GetParent()
	local r, g, b = orb.filling:GetStatusBarColor()
	if orb.filling2 then orb.filling2:SetVertexColor(r, g, b) end
	if orb.spark then orb.spark:SetVertexColor(r, g, b) end
	if orb.bubbles then
		for i, bubble in pairs(orb.bubbles) do
			bubble:SetVertexColor(r, g, b)
		end
	end
	if orb.galaxies then
		for i, galaxy in pairs(orb.galaxies) do
			galaxy:SetVertexColor(r, g, b)
		end
	end
	if orb.pic1s then
		for i, pic1 in pairs(orb.pic1s) do
			pic1:SetVertexColor(r, g, b)
		end
	end
	if orb.pic2s then
		for i, pic2 in pairs(orb.pic2s) do
			pic2:SetVertexColor(r, g, b)
		end
	end
end

--post update orb func (used to display lowHp on percentage)
local updateValue = function(bar, unit, cur, max)
	max = max or 0
	local per = 0
	if max > 0 then per = floor(cur/max*100) end
	local orb = bar:GetParent()
	local self = orb:GetParent()

	if orb.type == "HEALTH" and (per <= 20 or UnitIsDeadOrGhost(unit)) then orb.lowHP:Show()
	elseif orb.type == "HEALTH" then orb.lowHP:Hide() end
	if orb.type == "HEALTH" and UnitIsDeadOrGhost(unit) then orb.skull:Show()
	elseif orb.type == "HEALTH" then orb.skull:Hide() end
	if db then
		if db.char[orb.type].value.hideOnEmpty and (UnitIsDeadOrGhost(unit) or cur < 1) then
			orb.values:Hide()
		elseif db.char[orb.type].value.hideOnFull and (cur == max) then
			orb.values:Hide()
		elseif not orb.values:IsShown() then
			orb.values:Show()
		end
		if orb.type == "HEALTH" then
			orb.values.top:SetText(oUF.Tags.Methods["diablo:HealthOrbTop"](self.unit or "player"))
			orb.values.bottom:SetText(oUF.Tags.Methods["diablo:HealthOrbBottom"](self.unit or "player"))
		elseif orb.type == "POWER" then
			orb.values.top:SetText(oUF.Tags.Methods["diablo:PowerOrbTop"](self.unit or "player"))
			orb.values.bottom:SetText(oUF.Tags.Methods["diablo:PowerOrbBottom"](self.unit or "player"))
		end
		if ns.panel then
			if ns.panel:IsShown() then
				ns.panel.eventHelper:SetOrbsToMax()
			end
		end
	else
		if cfg.value.hideOnEmpty and (UnitIsDeadOrGhost(unit) or cur < 1) then
			orb.values:Hide()
		elseif cfg.value.hideOnFull and (cur == max) then
			orb.values:Hide()
		elseif not orb.values:IsShown() then
			orb.values:Show()
		end
		if orb.type == "HEALTH" then
			orb.values.top:SetText(oUF.Tags.Methods["topdefhp"]"player")
			orb.values.bottom:SetText(oUF.Tags.Methods["botdefhp"]"player")
		elseif orb.type == "POWER" then
			orb.values.top:SetText(oUF.Tags.Methods["topdefpp"]"player")
			orb.values.bottom:SetText(oUF.Tags.Methods["botdefpp"]"player")
		end
	end
	if UnitIsDeadOrGhost(unit) then bar:SetValue(0) end
end


--update orb func
local function updateOrb(bar, value)
	local orb = bar:GetParent()
	if not orb or not orb.spark then return end
	if UnitIsDeadOrGhost("player") then
		if orb.spark:IsShown() then orb.spark:Hide() end
		return
	end
	if not orb.spark:IsShown() then orb.spark:Show() end
end


--init parameters
local initUnitParameters = function(self)
	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(1)
	self:SetSize(cfg.size, cfg.size)
	self:SetScale(cfg.scale)
	self:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x/cfg.scale, cfg.pos.y/cfg.scale)
	self:RegisterForClicks("AnyDown")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
end


--create health orb func
local d3_health = function(self, type)

	--create the orb baseframe
	local orb = CreateFrame("Frame", "DiabloHealthOrb", self)
	--orb data
	orb.self = self
	orb.type = type
	orb:SetSize(cfg.size, cfg.size)
	orb:SetPoint("CENTER")
	-- orb:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x/cfg.scale, cfg.pos.y/cfg.scale)
	-- orb:SetScale(cfg.scale)

	--Background
	local Background = orb:CreateTexture("$parentBG", "BACKGROUND", nil, -6)
	Background:SetAllPoints(orb)
	Background:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_back")
	Background:SetAlpha(cfg.backgroundalpha)
	orb.background = Background

	-- TempLoss
	local TempLoss = CreateFrame('StatusBar', "$parenttempl", orb)
    TempLoss:SetStatusBarTexture(cfg.texture)
	TempLoss:SetStatusBarColor(0.3, 0.3, 0.3, 0)
    TempLoss:SetReverseFill(true)
	TempLoss:SetOrientation("VERTICAL")
    TempLoss:SetWidth(cfg.size)
    TempLoss:SetPoint('TOP')
    TempLoss:SetPoint('LEFT')
    TempLoss:SetPoint('RIGHT')

	TempLoss.clipFrame = CreateFrame("Frame", nil, TempLoss)
	TempLoss.clipFrame:SetClipsChildren(true)
	TempLoss.clipFrame:SetPoint("TOPLEFT", TempLoss)
	TempLoss.clipFrame:SetPoint("BOTTOMRIGHT", TempLoss:GetStatusBarTexture())

	TempLoss.clipFrame.fill = TempLoss.clipFrame:CreateTexture(nil, "BACKGROUND", nil, 4)
	TempLoss.clipFrame.fill:SetSize(cfg.size + 6, cfg.size + 6)
	TempLoss.clipFrame.fill:SetPoint("TOP")

	TempLoss.clipFrame.fill:SetBlendMode("BLEND")
	TempLoss.clipFrame.fill:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_filling6")
	TempLoss.clipFrame.fill:SetVertexColor(0.5, 0.5, 0.5, 1)
	orb.TempLoss = TempLoss


	--filling statusbar
	local filling = CreateFrame("StatusBar", "$parentFill", orb)
	filling:SetSize(cfg.size, cfg.size)

	-- filling:SetAllPoints()

	filling:SetPoint('BOTTOM')
    filling:SetPoint('TOPLEFT', TempLoss:GetStatusBarTexture(), 'BOTTOMLEFT')
    filling:SetPoint('TOPRIGHT', TempLoss:GetStatusBarTexture(), 'BOTTOMRIGHT')

	filling:SetMinMaxValues(0, 100)
	filling:SetStatusBarTexture(cfg.texture)
	filling:SetStatusBarColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
	-- filling:SetAlpha(cfg.orbalpha)
	filling:SetAlpha(0)
	filling:SetOrientation("VERTICAL")
	orb.filling = filling

    local fillingTex = filling:GetStatusBarTexture()
    fillingTex:SetDrawLayer("BACKGROUND", 0)
    orb.fillingTex = fillingTex

	filling:SetScript("OnValueChanged", updateOrb)

	--clip frame
    local clipFrame = CreateFrame("Frame", "$parentClip", orb)
    clipFrame:SetFrameLevel(orb:GetFrameLevel() + 1)
    clipFrame:SetPoint("BOTTOMLEFT", filling, "BOTTOMLEFT")
    clipFrame:SetPoint("BOTTOMRIGHT", filling, "BOTTOMRIGHT")
    clipFrame:SetPoint("TOP", fillingTex, "TOP", 0, 0)
    clipFrame:SetClipsChildren(true)
    clipFrame:EnableMouse(false)
    orb.clipFrame = clipFrame

	--filling statusbar
	local filling2 = clipFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
	filling2:SetSize(cfg.size, cfg.size)
	filling2:SetAllPoints(orb)
	filling2:SetTexture(cfg.texture)
	filling2:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
	filling2:SetAlpha(cfg.orbalpha)
	orb.filling2 = filling2

    --scroll child
    local scrollChild = CreateFrame("Frame", nil, clipFrame)
    scrollChild:SetSize(orb:GetSize())
    scrollChild:SetPoint("BOTTOM", orb, "BOTTOM")
    scrollChild:EnableMouse(false)
    orb.scrollChild = scrollChild


	--orb model
	-- local model = CreateFrame("PlayerModel", nil, scrollChild)
	local model = CreateFrame("PlayerModel", nil, orb)
	model:SetSize(cfg.size+5, cfg.size+5)
	-- model:SetPoint("TOP")
	model:SetAllPoints(orb)
	model:SetAlpha(cfg.modelalpha)
	--update model func
	function model:Update()
		if db then
			local cfg = db.char[self.type].model
			if cfg.animated then
				self:SetParent(scrollChild)
			else
				self:SetParent(orb)
			end
			self:SetCamDistanceScale(cfg.camDistanceScale)
			self:SetPosition(0, cfg.pos_x, cfg.pos_y)
			self:SetRotation(cfg.rotation)
			self:SetPortraitZoom(cfg.portraitZoom)
			self:ClearModel()
			self:SetDisplayInfo(cfg.displayInfo)
		else
			self:SetCamDistanceScale(0.86)
			self:SetPosition(0, 0, 0.1)
			self:SetRotation(0)
			self:SetPortraitZoom(0)
			self:ClearModel()
			self:SetDisplayInfo(32368)
		end
	end
	model.type = orb.type

	-- model:RegisterEvent("PLAYER_ENTERING_WORLD")
	model:RegisterEvent("PLAYER_LOGIN")
	model:SetScript("OnEvent", function(self) self:Update() end)
	-- model:SetScript("OnShow", function(self) self:Update() end)
	-- model:Update()
	orb.model = model


	--rotaing model
	--bubbles
	orb.bubbles = {}
	-- tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+8, 24, "orb_rotation_bubbles1", -2, 360, "ADD"))	--ADD=发光;BLEND=不透明
	tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+8, 30, "orb_rotation_bubbles1_fh", -2, -360, "ADD"))
	tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+2, 30, "orb_rotation_bubbles2", -3, 360, "ADD"))
	-- tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+2, 36, "orb_rotation_bubbles2_fh", -3, -360, "ADD"))
	for i, bubble in pairs(orb.bubbles) do
		-- bubble:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
		bubble:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--bubble:SetAlpha(cfg.bubblesalpha)
			bubble.aga.allow:SetFromAlpha(cfg.bubblesalpha)
			bubble.aga.allow:SetToAlpha(0.3*cfg.bubblesalpha)
			bubble.aga.alhigh:SetFromAlpha(0.3*cfg.bubblesalpha)
			bubble.aga.alhigh:SetToAlpha(cfg.bubblesalpha)
		end
	end

	--galaxies
	orb.galaxies = {}
	-- tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 60, "galaxy1", -4, 360, "BLEND"))
	tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 66, "galaxy1_fh", -4, -360, "ADD"))
	tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 90, "galaxy2", -5, -360, "BLEND"))
	-- tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 180, "galaxy3", -5, 360, "BLEND"))
	for i, galaxy in pairs(orb.galaxies) do
		-- galaxy:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
		galaxy:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--galaxy:SetAlpha(cfg.galaxiesalpha)
			galaxy.aga.allow:SetFromAlpha(cfg.galaxiesalpha)
			galaxy.aga.allow:SetToAlpha(0.3*cfg.galaxiesalpha)
			galaxy.aga.alhigh:SetFromAlpha(0.3*cfg.galaxiesalpha)
			galaxy.aga.alhigh:SetToAlpha(cfg.galaxiesalpha)
		end
	end
	--pic1s
	orb.pic1s = {}
	tinsert(orb.pic1s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 60, cfg.pic1stexture, -1, 360, "ADD"))
	-- tinsert(orb.pic1s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 66, cfg.pic1sfhtexture, -1, -360, "ADD"))
	for i, pic1 in pairs(orb.pic1s) do
		-- pic1:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
		pic1:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--pic1:SetAlpha(cfg.pic1salpha)
			pic1.aga.allow:SetFromAlpha(cfg.pic1salpha)
			pic1.aga.allow:SetToAlpha(0.3*cfg.pic1salpha)
			pic1.aga.alhigh:SetFromAlpha(0.3*cfg.pic1salpha)
			pic1.aga.alhigh:SetToAlpha(cfg.pic1salpha)
		end
	end
	--pic2s
	orb.pic2s = {}
	tinsert(orb.pic2s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 90, cfg.pic2stexture, -6, -360, "BLEND"))
	-- tinsert(orb.pic2s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 99, cfg.pic2sfhtexture, -6, 360, "BLEND"))
	for i, pic2 in pairs(orb.pic2s) do
		-- pic2:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
		pic2:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--pic2:SetAlpha(cfg.pic2salpha)
			pic2.aga.allow:SetFromAlpha(cfg.pic2salpha)
			pic2.aga.allow:SetToAlpha(0.3*cfg.pic2salpha)
			pic2.aga.alhigh:SetFromAlpha(0.3*cfg.pic2salpha)
			pic2.aga.alhigh:SetToAlpha(cfg.pic2salpha)
		end
	end


	--overlay frame
	local overlay = CreateFrame("Frame", "$parentOverlay", orb)
	overlay:SetFrameLevel(orb:GetFrameLevel()+2)
	overlay:SetAllPoints(orb)
	orb.overlay = overlay
	
	--TexturekMask frame
	local TexturekMask = overlay:CreateMaskTexture()
	-- TexturekMask:SetAllPoints(overlay)
	TexturekMask:SetPoint("TOP", 0, 12)
	TexturekMask:SetPoint("LEFT", -12, 0)
	TexturekMask:SetPoint("RIGHT", 12, 0)
	TexturekMask:SetPoint("BOTTOM", 0, -12)
	TexturekMask:SetTexture(
		"Interface\\AddOns\\"..AddonName.."\\media\\orb_spark_mask",
		"CLAMPTOBLACKADDITIVE",
		"CLAMPTOBLACKADDITIVE"
	)


	--orbgrid
	local orbgrid = overlay:CreateTexture(nil, "BACKGROUND", nil, 3)
	orbgrid:SetPoint("TOP", 0, 25)
	orbgrid:SetPoint("LEFT", -26, 0)
	orbgrid:SetPoint("RIGHT", 25, 0)
	orbgrid:SetPoint("BOTTOM", 0, -25)
	orbgrid:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_grid1")
	orbgrid:SetAlpha(cfg.orbgridalpha)
	orb.grid = orbgrid


	--highlight
	local highlight = overlay:CreateTexture(nil, "BACKGROUND", nil, 3)
	highlight:SetPoint("TOP", 0, 1)
	highlight:SetPoint("LEFT", -1, 0)
	highlight:SetPoint("RIGHT", 1, 0)
	highlight:SetPoint("BOTTOM", 0, -1)
	highlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_gloss")
	highlight:SetAlpha(cfg.highlightalpha)
	orb.highlight = highlight


	--orbshadow
	local orbshadow = overlay:CreateTexture(nil, "BACKGROUND", nil, 3)
	-- orbshadow:SetAllPoints()
	orbshadow:SetPoint("TOP", 0, 1)
	orbshadow:SetPoint("LEFT", -1, 0)
	orbshadow:SetPoint("RIGHT", 1, 0)
	orbshadow:SetPoint("BOTTOM", 0, -1)
	orbshadow:SetVertexColor(0, 0, 0)
	orbshadow:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_shadow")
	orbshadow:SetAlpha(cfg.orbshadowalpha)
	orb.orbshadow = orbshadow


	--spark
	local spark = overlay:CreateTexture(nil, "BACKGROUND", nil, -3)
	spark:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_spark")
	spark:SetSize(1.2*cfg.size, 0.05*cfg.size)
	spark:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
	spark:SetAlpha(cfg.sparkalpha or 1)
	spark:SetBlendMode("ADD")
	spark:SetPoint("CENTER", fillingTex, "TOP", 0, 0)
	-- spark:SetPoint("CENTER", clipFrame, 0, 0)
	spark:AddMaskTexture(TexturekMask)
    spark:Hide()
    orb.spark = spark


	--skull+lowhp
	local skull = overlay:CreateTexture(nil, "BACKGROUND", nil, 1)
	skull:SetPoint("CENTER", 0, 0)
	skull:SetSize(cfg.size-20, cfg.size-20)
	skull:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\d2_skull")
	skull:SetBlendMode("ADD")
	skull:SetAlpha(0.6)
	skull:Hide()
	orb.skull = skull
	local lowHP = overlay:CreateTexture(nil, "BACKGROUND", nil, 2)
	lowHP:SetPoint("CENTER", 0, 0)
	lowHP:SetSize(cfg.size+5, cfg.size+5)
	lowHP:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_lowhp_glow")
	lowHP:SetBlendMode("ADD")
	lowHP:SetVertexColor(1, 0, 0, 1)
	lowHP:Hide()
	orb.lowHP = lowHP


	--orb values
	local values = CreateFrame("Frame", "$parentValues", overlay)
	--values:SetFrameStrata("BACKGROUND")
	values:SetAllPoints(orb)
	--top value
	values.top = ns.createFontString(values, STANDARD_TEXT_FONT, 27, "OUTLINE")
	values.top:SetPoint("BOTTOM", overlay, "CENTER", 0, -5)
	values.top:SetTextColor(cfg.value.top.color.r, cfg.value.top.color.g, cfg.value.top.color.b)
	--bottom value
	values.bottom = ns.createFontString(values, STANDARD_TEXT_FONT, 16, "OUTLINE")
	values.bottom:SetPoint("TOP", overlay, "CENTER", 0, -4)
	values.bottom:SetTextColor(cfg.value.bottom.color.r, cfg.value.bottom.color.g, cfg.value.bottom.color.b)
	orb.values = values
	--register the tags
	if db then
		self:Tag(orb.values.top, "[diablo:HealthOrbTop]")
		self:Tag(orb.values.bottom, "[diablo:HealthOrbBottom]")
	elseif cfg.value.short then
		self:Tag(orb.values.top, "[topdefhp]")
		self:Tag(orb.values.bottom, "[botdefhp]")
	else
		self:Tag(orb.values.top, "[topdefhp]")
		self:Tag(orb.values.bottom, "[botcurhp]")
	end


	--DemonFrame
	local DemonFrame = CreateFrame("Frame", "DiabloDemonFrame", DiabloHealthOrb)
	DemonFrame:SetSize(cfg.size*0.8, cfg.size*0.8)
	DemonFrame:SetFrameStrata("LOW")
	DemonFrame:SetFrameLevel(0)
	DemonFrame:SetPoint("BOTTOMRIGHT", "DiabloHealthOrb", "BOTTOMLEFT", -8/cfg.scale, 0)

	local dt = DemonFrame:CreateTexture(nil, "BACKGROUND", nil, 2)
	dt:SetPoint("TOP", 0, 110)
	dt:SetPoint("LEFT", -30, 0)
	dt:SetPoint("RIGHT", 80, 0)
	dt:SetPoint("BOTTOM", 0, 0)
	dt:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\_demon1")
	dt:SetVertexColor(1, 1, 1, 1)
	orb.textureframe = DemonFrame


	--Register with oUF
	self.Health = filling
	self.Health.TempLoss = TempLoss
	ns.HealthOrb = orb--save the orb in the namespace
	-- self.Health.frequentUpdates = true
	-- self.Health.colorTapping = false
	-- self.Health.colorDisconnected = false
	self.Health.Smooth = true

	self.Health.colorClass = cfg.colorAuto or false
	-- self.Health.colorReaction = false
	-- self.Health.colorHealth = false
	hooksecurefunc(self.Health, "SetStatusBarColor", updateStatusBarColor)
	self.Health.PostUpdate = updateValue
	--Make the background darker.
	Background.multiplier = 0.3
	--Register it with oUF
	filling.bg = Background


	--吸收护盾
	if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
		local absorbBar = CreateFrame("StatusBar", nil, overlay)

			absorbBar:EnableMouse(false)
			absorbBar:SetPoint("CENTER", 0 , 0)
			absorbBar:SetSize(cfg.size + 6, cfg.size + 6)
			absorbBar:SetMinMaxValues(0, 100)
			absorbBar:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])
			absorbBar:SetStatusBarColor(1, 1, 1, 0)
			absorbBar:SetOrientation("VERTICAL")
			absorbBar:SetFillStyle(3)
			absorbBar:SetRotatesTexture(true)

			absorbBar.clipFrame = CreateFrame("Frame", nil, absorbBar)
			absorbBar.clipFrame:SetClipsChildren(true)
			absorbBar.clipFrame:SetPoint("TOPLEFT", absorbBar)
			absorbBar.clipFrame:SetPoint("BOTTOMRIGHT", absorbBar:GetStatusBarTexture())

			absorbBar.clipFrame.fill = absorbBar.clipFrame:CreateTexture(nil, "BACKGROUND", nil, 4)
			absorbBar.clipFrame.fill:SetSize(cfg.size + 6, cfg.size + 6)
			absorbBar.clipFrame.fill:SetPoint("TOP")
		
			-- -- 风格1
			-- absorbBar.clipFrame.fill:SetBlendMode("BLEND")
			-- absorbBar.clipFrame.fill:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb_glow")
			-- absorbBar.bg = absorbBar:CreateTexture(nil, "BACKGROUND", nil, -8)
			-- absorbBar.bg:SetAllPoints()
			-- absorbBar.bg:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb_glow")
			-- absorbBar.bg:SetAlpha(0)
			-- absorbBar:HookScript("OnValueChanged", function(bar, absorb)
			-- 	local minVal, maxHealth = bar:GetMinMaxValues()
			-- 	if absorb/maxHealth < 0.05 then bar.bg:SetAlpha(0)
			-- 	else bar.bg:SetAlpha(0.1) end
			-- end)

			-- 风格2
			absorbBar.clipFrame.fill:SetBlendMode("ADD")
			absorbBar.clipFrame.fill:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb")
			absorbBar.clipFrame.fill:SetVertexColor(0.3, 0.8, 1, 1)
			absorbBar.bg = absorbBar:CreateTexture(nil, "BACKGROUND", nil, -8)
			absorbBar.bg:SetAllPoints()
			absorbBar.bg:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb")
			absorbBar.bg:SetVertexColor(0.3, 0.8, 1, 0)
			absorbBar.bg:SetBlendMode("ADD")
			absorbBar.spark = absorbBar:CreateTexture(nil, "BACKGROUND", nil, -3)
			absorbBar.spark:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb_spark")
			absorbBar.spark:SetSize(1.1*cfg.size, 0.04*cfg.size)
			absorbBar.spark:SetVertexColor(0.3, 0.8, 1)
			absorbBar.spark:SetAlpha(0.35)
			absorbBar.spark:SetBlendMode("ADD")
			absorbBar.spark:SetPoint("BOTTOM", absorbBar:GetStatusBarTexture(), "BOTTOM", 0, 0)
			absorbBar.spark:AddMaskTexture(TexturekMask)
			absorbBar:HookScript("OnValueChanged", function(bar, absorb)
				local minVal, maxHealth = bar:GetMinMaxValues()
				if absorb/maxHealth < 0.05 then bar.bg:SetAlpha(0)
				else bar.bg:SetAlpha(0.2) end
			end)



		--Register with oUF
		self.CustomAbsorb = absorbBar
		self.CustomAbsorb.Smooth = true
	end

	--治疗预估
	--Position and size
	local myBar = CreateFrame("StatusBar", nil, overlay)
		myBar:EnableMouse(false)
		myBar:SetPoint("CENTER")
		myBar:SetSize(cfg.size, cfg.size)
		myBar:SetStatusBarTexture(cfg.texture)
		myBar:SetStatusBarColor(Classcolor.r, Classcolor.g, Classcolor.b, 0)
		myBar:SetOrientation("VERTICAL")
		myBar:SetPoint("BOTTOM", filling:GetStatusBarTexture(), "TOP")	

		myBar.clipFrame = CreateFrame("Frame", nil, myBar)
		myBar.clipFrame:SetClipsChildren(true)
		myBar.clipFrame:SetPoint("TOPLEFT", myBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		myBar.clipFrame:SetPoint("BOTTOMRIGHT", myBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)

		myBar.clipFrame.fill = myBar.clipFrame:CreateTexture(nil, "BACKGROUND", nil, 4)
		myBar.clipFrame.fill:SetSize(cfg.size, cfg.size)
		myBar.clipFrame.fill:SetPoint("CENTER", orb, "CENTER")
		myBar.clipFrame.fill:SetTexture(cfg.texture)
		myBar.clipFrame.fill:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b, 0.25)


	local otherBar = CreateFrame("StatusBar", nil, overlay)
		otherBar:EnableMouse(false)
		otherBar:SetPoint("CENTER")
		otherBar:SetSize(cfg.size, cfg.size)
		otherBar:SetStatusBarTexture(cfg.texture)
		otherBar:SetStatusBarColor(0, 1, 0, 0)
		otherBar:SetOrientation("VERTICAL")
		otherBar:SetPoint("BOTTOM", filling:GetStatusBarTexture(), "TOP")	

		otherBar.clipFrame = CreateFrame("Frame", nil, otherBar)
		otherBar.clipFrame:SetClipsChildren(true)
		otherBar.clipFrame:SetPoint("TOPLEFT", otherBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		otherBar.clipFrame:SetPoint("BOTTOMRIGHT", otherBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)

		otherBar.clipFrame.fill = otherBar.clipFrame:CreateTexture(nil, "BACKGROUND", nil, 4)
		otherBar.clipFrame.fill:SetSize(cfg.size, cfg.size)
		otherBar.clipFrame.fill:SetPoint("CENTER", orb, "CENTER")
		otherBar.clipFrame.fill:SetTexture(cfg.texture)
		otherBar.clipFrame.fill:SetVertexColor(0, 1, 0, 0.25)

	--治疗吸收
	local healAbsorbBar = CreateFrame("StatusBar", nil, overlay)

		healAbsorbBar:EnableMouse(false)
		healAbsorbBar:SetPoint("CENTER", 0 , 0)
		healAbsorbBar:SetSize(cfg.size + 6, cfg.size + 6)
		healAbsorbBar:SetMinMaxValues(0, 100)
		healAbsorbBar:SetStatusBarTexture([[Interface\Buttons\WHITE8X8]])
		healAbsorbBar:SetStatusBarColor(1, 0, 0, 0)
		healAbsorbBar:SetOrientation("VERTICAL")
		healAbsorbBar:SetFillStyle(3)
		healAbsorbBar:SetRotatesTexture(true)

		healAbsorbBar.clipFrame = CreateFrame("Frame", nil, healAbsorbBar)
		healAbsorbBar.clipFrame:SetClipsChildren(true)
		healAbsorbBar.clipFrame:SetPoint("TOPLEFT", healAbsorbBar)
		healAbsorbBar.clipFrame:SetPoint("BOTTOMRIGHT", healAbsorbBar:GetStatusBarTexture())

		healAbsorbBar.clipFrame.fill = healAbsorbBar.clipFrame:CreateTexture(nil, "BACKGROUND", nil, 4)
		healAbsorbBar.clipFrame.fill:SetSize(cfg.size + 6, cfg.size + 6)
		healAbsorbBar.clipFrame.fill:SetPoint("TOPLEFT")

		-- 风格1
		healAbsorbBar.clipFrame.fill:SetBlendMode("BLEND")
		healAbsorbBar.clipFrame.fill:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb_glow")
		healAbsorbBar.clipFrame.fill:SetVertexColor(1, 0, 0, 1)
		healAbsorbBar.bg = healAbsorbBar:CreateTexture(nil, "BACKGROUND", nil, -7)
		healAbsorbBar.bg:SetAllPoints()
		healAbsorbBar.bg:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb_glow")
		healAbsorbBar.bg:SetVertexColor(1, 0, 0, 0)
		healAbsorbBar:HookScript("OnValueChanged", function(bar, absorb)
		local minVal, maxHealth = bar:GetMinMaxValues()
			if absorb/maxHealth == 0 then bar.bg:SetAlpha(0)
			else bar.bg:SetAlpha(0.2) end
		end)

		-- -- 风格2
		-- healAbsorbBar.clipFrame.fill:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb")
		-- healAbsorbBar.clipFrame.fill:SetVertexColor(1, 0, 0, 1)
		-- healAbsorbBar.bg = healAbsorbBar:CreateTexture(nil, "BACKGROUND", nil, -8)
		-- healAbsorbBar.bg:SetAllPoints()
		-- healAbsorbBar.bg:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb")
		-- healAbsorbBar.bg:SetVertexColor(1, 0, 0, 0)
		-- healAbsorbBar.bg:SetBlendMode("ADD")
		-- healAbsorbBar.spark = healAbsorbBar:CreateTexture(nil, "BACKGROUND", nil, -3)
		-- healAbsorbBar.spark:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb_spark")
		-- healAbsorbBar.spark:SetSize(1.1*cfg.size, 0.04*cfg.size)
		-- healAbsorbBar.spark:SetVertexColor(1, 0, 0)
		-- healAbsorbBar.spark:SetAlpha(0.7)
		-- healAbsorbBar.spark:SetBlendMode("ADD")
		-- healAbsorbBar.spark:SetPoint("BOTTOM", healAbsorbBar:GetStatusBarTexture(), "BOTTOM", 0, 0)
		-- healAbsorbBar.spark:AddMaskTexture(TexturekMask)
		-- healAbsorbBar:HookScript("OnValueChanged", function(bar, absorb)
		-- 	local minVal, maxHealth = bar:GetMinMaxValues()
		-- 	if absorb/maxHealth < 0.05 then bar.bg:SetAlpha(0)
		-- 	else bar.bg:SetAlpha(0.25) end
		-- end)


	-- local absorbInd = self.Health:CreateTexture(nil, "OVERLAY")
	-- 	absorbInd:SetPoint("CENTER", 0 , 0)
	-- 	absorbInd:SetSize(cfg.size + 8, cfg.size + 8)
	-- 	absorbInd:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb")
	-- 	absorbInd:SetVertexColor(0.8, 0.9, 0.9, 0.5)

    -- local healAbsorbInd = self.Health:CreateTexture(nil, "OVERLAY")
	-- 	healAbsorbInd:SetPoint("CENTER", 0 , 0)
	-- 	healAbsorbInd:SetSize(cfg.size + 8, cfg.size + 8)
	-- 	healAbsorbInd:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_absorb")
	-- 	healAbsorbInd:SetVertexColor(1, 0, 0, 0.5)

	--Register with oUF
	self.HealthPrediction = {
		-- healingAll = myBar,
		healingPlayer = myBar,
		healingOther = otherBar,
        -- damageAbsorb = absorbBar,
		healAbsorb = healAbsorbBar,
		-- overDamageAbsorbIndicator = absorbInd,
        -- overHealAbsorbIndicator = healAbsorbInd,

        -- extra options
        -- incomingHealOverflow = 1.05,
		frequentUpdates = true
		}


	if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
		--Can Dispellabledebuff glow
		local Dispellable = {}
		local Debuffglow = CreateFrame("Frame", nil, overlay)
		local texture = Debuffglow:CreateTexture(nil, 'OVERLAY')
		if nogrid then 
			texture:SetSize(cfg.size+14, cfg.size+14)
			texture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
			Debuffglow:SetFrameLevel(1)
		else
			texture:SetSize(cfg.size+12, cfg.size+12)
			texture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
		end
		texture:SetPoint("CENTER", "DiabloHealthOrb", "CENTER", -0.3, 0.2)
		-- texture:SetBlendMode("BLEND")
		texture:SetVertexColor(1, 0, 0, 1) --set alpha to 0 to hide the texture

		-- Register with oUF
		Dispellable.dispelTexture = texture
		self.Dispellable = Dispellable
		if db then
			self.Dispellable.PostUpdate = function(self)
				if db.char[orb.type].filling.grid then 
					self.dispelTexture:SetSize(cfg.size+12, cfg.size+12)
					self.dispelTexture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
					Debuffglow:SetFrameLevel(9)
				else
					self.dispelTexture:SetSize(cfg.size+14, cfg.size+14)
					self.dispelTexture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
					Debuffglow:SetFrameLevel(1)
				end
			end

		end

		-- ---------------------------------------------------------------------
		-- -- debuffhighlight
		-- ---------------------------------------------------------------------

		-- local function GetDebuffTypeColor(element, unit, data, position)
		-- 	if data and data.dispelName then
		-- 		return C_UnitAuras.GetAuraDispelTypeColor(unit, data.auraInstanceID, element.dispelColorCurve)
		-- 	else
		-- 		return nil
		-- 	end
		-- end

		-- local Debuffs = CreateFrame("Frame", nil, overlay)
		-- local dbhighlight = Debuffs:CreateTexture(nil, 'OVERLAY')
		-- 	if nogrid then 
		-- 		dbhighlight:SetSize(cfg.size+14, cfg.size+14)
		-- 		dbhighlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
		-- 		Debuffs:SetFrameLevel(1)
		-- 	else
		-- 		dbhighlight:SetSize(cfg.size+12, cfg.size+12)
		-- 		dbhighlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
		-- 	end

		-- 	dbhighlight:SetPoint("CENTER", "DiabloHealthOrb", "CENTER", -0.3, 0.2)
		-- 	-- dbhighlight:SetBlendMode("ADD")
		-- 	dbhighlight:SetVertexColor(1, 0, 0, 0)

		-- Debuffs.dbhighlight = dbhighlight
		-- self.Debuffs = Debuffs
		-- self.Debuffs.PostUpdate = function(self,unit)
		-- 	if db then
		-- 		if db.char[orb.type].filling.grid then 
		-- 			self.dbhighlight:SetSize(cfg.size+12, cfg.size+12)
		-- 			self.dbhighlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
		-- 			self:SetFrameLevel(9)
		-- 		else
		-- 			self.dbhighlight:SetSize(cfg.size+14, cfg.size+14)
		-- 			self.dbhighlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
		-- 			self:SetFrameLevel(1)
		-- 		end
		-- 	end

		-- 	local color = nil
		-- 	for i = 1, math.min(40, #self.sorted) do
		-- 		color = GetDebuffTypeColor(self, unit, self.sorted[i], i)
		-- 		if color then
		-- 			self.dbhighlight:SetVertexColor(color:GetRGBA())
		-- 			break
		-- 		end
		-- 	end
		-- 	if not color then
		-- 		self.dbhighlight:SetVertexColor(0.8, 0, 0, 0)
		-- 	end
		-- end

	elseif WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then

		--debuff glow
		local Debuffglow = CreateFrame("Frame", nil, overlay)
		local texture = Debuffglow:CreateTexture(nil, 'OVERLAY')
		if nogrid then 
			texture:SetSize(cfg.size+14, cfg.size+14)
			texture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
			Debuffglow:SetFrameLevel(1)
		else
			texture:SetSize(cfg.size+12, cfg.size+12)
			texture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
		end
		texture:SetPoint("CENTER", "DiabloHealthOrb", "CENTER", -0.3, 0.2)
		-- texture:SetBlendMode("BLEND")
		texture:SetVertexColor(1, 0, 0, 1) --set alpha to 0 to hide the texture

		-- Register with oUF
		self.DebuffHighlight = texture
		-- self.DebuffHighlightAlpha = 1
		self.DebuffHighlight.Filter = true
		if db then
			self.DebuffHighlight.PostUpdate = function(self)
				if db.char[orb.type].filling.grid then 
					self:SetSize(cfg.size+12, cfg.size+12)
					self:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
					Debuffglow:SetFrameLevel(9)
				else
					self:SetSize(cfg.size+14, cfg.size+14)
					self:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
					Debuffglow:SetFrameLevel(1)
				end
			end
		end

	end




	--threat glow
	local Threatorb = CreateFrame("Frame", "Threatorb", overlay)
	local threat = Threatorb:CreateTexture(nil, 'OVERLAY')
		if nogrid then
			threat:SetSize(cfg.size+14, cfg.size+14)
			threat:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
			Threatorb:SetFrameLevel(1)
		else
			threat:SetSize(cfg.size+12, cfg.size+12)
			threat:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
		end
		threat:SetPoint("CENTER", "DiabloHealthOrb", "CENTER", -0.3, 0.2)
		-- threat:SetBlendMode("BLEND")
		threat:SetVertexColor(1, 0, 0, 1) --set alpha to 0 to hide the texture
		-- Threatorb:SetFrameStrata("BACKGROUND")

	--Register with oUF
	Threatorb.threat = threat
	self.ThreatIndicator = Threatorb.threat
	if db then
		self.ThreatIndicator.PostUpdate = function(self)
			if db.char[orb.type].filling.grid then 
				self:SetSize(cfg.size+12, cfg.size+12)
				self:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite")
				Threatorb:SetFrameLevel(9)
			else
				self:SetSize(cfg.size+14, cfg.size+14)
				self:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow_lite+")
				Threatorb:SetFrameLevel(1)
			end
			local Role = UnitGroupRolesAssigned("player")
			if Role == "TANK" then
				Threatorb:Hide()
			else
				Threatorb:Show()
			end
		end
	else
		-- Threatorb:RegisterEvent("PLAYER_ENTERING_WORLD")
		Threatorb:RegisterEvent("PLAYER_LOGIN")
		Threatorb:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		Threatorb:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		Threatorb:SetScript("OnEvent", function(...)
			local Role = UnitGroupRolesAssigned("player")
			if Role == "TANK" then
				Threatorb:Hide()
			else
				Threatorb:Show()
			end
		end)
	end


	--图腾条
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or  WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
		local Totems = {}
		for index = 1, 5 do
			--Position and size of the totem indicator
			local Totem = CreateFrame('Button', "DiabloTotemBar", DiabloHealthOrb)
			if MultiCastActionBarFrame then
				Totem:SetSize(32, 32)
			else
				Totem:SetSize(36, 36)
			end
			Totem:HookScript("OnUpdate",function()
				if MultiCastActionBarFrame and MultiCastActionBarFrame:IsShown() then
					Totem:SetPoint('LEFT', MultiCastActionBarFrame, 'RIGHT', 10 + (index-1)*(Totem:GetWidth() + 6), 0)
				-- elseif DiabloPetFrame:IsShown() then
				-- 	Totem:SetPoint('BOTTOM', "DiabloHealthOrb", 'TOP', -84, 16 + (index-1)*(Totem:GetHeight() + 4))
				else
					if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
						if index == 1 then Totem:SetPoint('TOPRIGHT', TTFMF, 'CENTER', -2, -2) end
						if index == 2 then Totem:SetPoint('TOPLEFT', TTFMF, 'CENTER', 2, -2) end
						if index == 3 then Totem:SetPoint('BOTTOMRIGHT', TTFMF, 'CENTER', -2, 2) end
						if index == 4 then Totem:SetPoint('BOTTOMLEFT', TTFMF, 'CENTER', 2, 2) end
						if index == 5 then Totem:SetPoint('BOTTOM', TTFMF, 'CENTER', 0, 40) end
					else
						Totem:SetPoint('BOTTOM', TTFMF, 'BOTTOM', 0, 22 + (index-1)*(Totem:GetHeight() + 4))
					end
				end
			end)
			-- Totem:SetPoint('BOTTOM', "DiabloHealthOrb", 'TOP', 0, 16 + (index-1)*(Totem:GetHeight() + 4))
			
			local Icon = Totem:CreateTexture(nil, 'OVERLAY')
			Icon:SetAllPoints()
			-- Icon:SetTexCoord(0.05, 0.93, 0.05, 0.93)
			local Cooldown = CreateFrame('Cooldown', nil, Totem, 'CooldownFrameTemplate')
			Cooldown:SetAllPoints()
			Cooldown:SetPoint("TOPLEFT", 1, 0)
			Cooldown:SetPoint("BOTTOMRIGHT", 0, -1)
			Cooldown:SetAlpha(0.8) 
			Cooldown:SetReverse(true)
			local normalTexture = Totem:CreateTexture(nil, "OVERLAY", nil, 3)
			normalTexture:SetAllPoints()
			normalTexture:SetPoint("TOPLEFT", -1, 1)
			normalTexture:SetPoint("BOTTOMRIGHT", 1, -1)
			normalTexture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\button_dragon")
			-- normalTexture:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b, 1)
			normalTexture:SetVertexColor(0, 0, 0, 1)
			Totem.Icon = Icon
			Totem.Cooldown = Cooldown

			Totems[index] = Totem
		end

		if WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
			hooksecurefunc(TotemFrame, "Update",function()
				local activeTotems = 0
				for button in _G.TotemFrame.totemPool:EnumerateActive() do
					activeTotems = activeTotems + 1
					local totem = Totems[activeTotems]
					button:ClearAllPoints()
					button:SetParent(totem)
					button:SetAllPoints(totem)
					button:SetAlpha(0)
					button:SetFrameLevel(totem:GetFrameLevel() + 1)
				end
			end)
		end

		--Register with oUF
		self.Totemsac = Totems
	end

end




--create power orb func
local d3_power = function(self, type)

	--create the orb baseframe
	local orb = CreateFrame("Frame", "DiabloPowerOrb", self)
	--orb data
	orb.self = self
	orb.type = type
	orb:SetSize(cfg.size, cfg.size)
	-- orb:SetPoint("CENTER")
	orb:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, -1*cfg.pos.x/cfg.scale, cfg.pos.y/cfg.scale)
	-- orb:SetScale(cfg.scale)

	--background
	local Background = orb:CreateTexture(nil, "BACKGROUND", nil, -6)
	Background:SetAllPoints(orb)
	Background:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_back")
	Background:SetAlpha(cfg.backgroundalpha)
	orb.background = Background


	--filling statusbar
	local filling = CreateFrame("StatusBar", "$parentFill", orb)
	filling:SetSize(cfg.size, cfg.size)
	filling:SetAllPoints()
	filling:SetMinMaxValues(0, 100)
	filling:SetStatusBarTexture(cfg.texturepower)
	filling:SetStatusBarColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)
	filling:SetAlpha(cfg.orbalpha)
	filling:SetOrientation("VERTICAL")
	orb.filling = filling

    local fillingTex = filling:GetStatusBarTexture()
    fillingTex:SetDrawLayer("BACKGROUND", 0)
    orb.fillingTex = fillingTex

	filling:SetScript("OnValueChanged", updateOrb)

	--scroll frame
    local clipFrame = CreateFrame("Frame", "$parentClip", orb)
    clipFrame:SetFrameLevel(orb:GetFrameLevel() + 2)
    clipFrame:SetPoint("BOTTOMLEFT", filling, "BOTTOMLEFT")
    clipFrame:SetPoint("BOTTOMRIGHT", filling, "BOTTOMRIGHT")
    clipFrame:SetPoint("TOP", fillingTex, "TOP", 0, 0)
    clipFrame:SetClipsChildren(true)
    clipFrame:EnableMouse(false)
    orb.clipFrame = clipFrame

    --scroll child
    local scrollChild = CreateFrame("Frame", nil, clipFrame)
    scrollChild:SetSize(orb:GetSize())
    scrollChild:SetPoint("BOTTOM", orb, "BOTTOM")
    scrollChild:EnableMouse(false)
    orb.scrollChild = scrollChild


	--orb model
	-- local model = CreateFrame("PlayerModel", nil, scrollChild)
	local model = CreateFrame("PlayerModel", nil, orb)
	model:SetSize(cfg.size+5, cfg.size+5)
	-- model:SetPoint("TOP")
	model:SetAllPoints(orb)
	model:SetAlpha(cfg.modelalpha)
	--update model func
	function model:Update()
		if db then
			local cfg = db.char[self.type].model
			if cfg.animated then
				self:SetParent(scrollChild)
			else
				self:SetParent(orb)
			end
			self:SetCamDistanceScale(cfg.camDistanceScale)
			self:SetPosition(0, cfg.pos_x*-1, cfg.pos_y)
			self:SetRotation(cfg.rotation*-1)
			self:SetPortraitZoom(cfg.portraitZoom)
			self:ClearModel()
			--self:SetModel("interface\\buttons\\talktomequestionmark.m2")--in case setdisplayinfo fails
			self:SetDisplayInfo(cfg.displayInfo)
		else
			self:SetCamDistanceScale(0.86)
			self:SetPosition(0, 0, 0.1)
			self:SetRotation(0)
			self:SetPortraitZoom(0)
			self:ClearModel()
			--self:SetModel("interface\\buttons\\talktomequestionmark.m2")--in case setdisplayinfo fails
			self:SetDisplayInfo(32368)
		end
	end
	model.type = orb.type

	-- model:RegisterEvent("PLAYER_ENTERING_WORLD")
	model:RegisterEvent("PLAYER_LOGIN")
	model:SetScript("OnEvent", function(self) self:Update() end)
	-- model:SetScript("OnShow", function(self) self:Update() end)
	-- model:Update()
	orb.model = model


	--rotaing model
	--bubbles
	orb.bubbles = {}
	-- tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+8, 24, "orb_rotation_bubbles1_fh", -2, -360, "ADD"))	--ADD=发光;BLEND=不透明
	tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+8, 30, "orb_rotation_bubbles1", -2, 360, "ADD"))
	tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+2, 30, "orb_rotation_bubbles2_fh", -3, -360, "ADD"))
	-- tinsert(orb.bubbles, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size+2, 36, "orb_rotation_bubbles2", -3, 360, "ADD"))
	for i, bubble in pairs(orb.bubbles) do
		-- bubble:SetVertexColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)
		bubble:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--bubble:SetAlpha(cfg.bubblesalpha)
			bubble.aga.allow:SetFromAlpha(cfg.bubblesalpha)
			bubble.aga.allow:SetToAlpha(0.3*cfg.bubblesalpha)
			bubble.aga.alhigh:SetFromAlpha(0.3*cfg.bubblesalpha)
			bubble.aga.alhigh:SetToAlpha(cfg.bubblesalpha)
		end
	end

	--galaxies
	orb.galaxies = {}
	-- tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 60, "galaxy1_fh", -4, -360, "BLEND"))
	tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 66, "galaxy1", -4, 360, "ADD"))
	tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 90, "galaxy2_fh", -5, 360, "BLEND"))
	-- tinsert(orb.galaxies, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size-0, 180, "galaxy3_fh", -6, -360, "BLEND"))
	for i, galaxy in pairs(orb.galaxies) do
		-- galaxy:SetVertexColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)
		galaxy:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--galaxy:SetAlpha(cfg.galaxiesalpha)
			galaxy.aga.allow:SetFromAlpha(cfg.galaxiesalpha)
			galaxy.aga.allow:SetToAlpha(0.3*cfg.galaxiesalpha)
			galaxy.aga.alhigh:SetFromAlpha(0.3*cfg.galaxiesalpha)
			galaxy.aga.alhigh:SetToAlpha(cfg.galaxiesalpha)
		end
	end
	--pic1s
	orb.pic1s = {}
	tinsert(orb.pic1s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 60, cfg.pic1sfhtexture, -1, -360, "ADD"))
	-- tinsert(orb.pic1s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 66, cfg.pic1stexture, -1, 360, "ADD"))
	for i, pic1 in pairs(orb.pic1s) do
		-- pic1:SetVertexColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)
		pic1:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--pic1:SetAlpha(cfg.pic1salpha)
			pic1.aga.allow:SetFromAlpha(cfg.pic1salpha)
			pic1.aga.allow:SetToAlpha(0.3*cfg.pic1salpha)
			pic1.aga.alhigh:SetFromAlpha(0.3*cfg.pic1salpha)
			pic1.aga.alhigh:SetToAlpha(cfg.pic1salpha)
		end
	end
	--pic2s
	orb.pic2s = {}
	tinsert(orb.pic2s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 90, cfg.pic2sfhtexture, -6, 360, "BLEND"))
	-- tinsert(orb.pic2s, createGalaxy(scrollChild, orb.type, 0, 0, cfg.size + 0, 99, cfg.pic2stexture, -6, -360, "BLEND"))
	for i, pic2 in pairs(orb.pic2s) do
		-- pic2:SetVertexColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)
		pic2:SetVertexColor(0.5, 0.5, 0.5)
		if not db then
			--pic2:SetAlpha(cfg.pic2salpha)
			pic2.aga.allow:SetFromAlpha(cfg.pic2salpha)
			pic2.aga.allow:SetToAlpha(0.3*cfg.pic2salpha)
			pic2.aga.alhigh:SetFromAlpha(0.3*cfg.pic2salpha)
			pic2.aga.alhigh:SetToAlpha(cfg.pic2salpha)
		end
	end


	--overlay frame
	local overlay = CreateFrame("Frame", "$parentOverlay", orb)
	overlay:SetFrameLevel(orb:GetFrameLevel()+2)
	overlay:SetAllPoints(orb)
	orb.overlay = overlay

	--TexturekMask frame
	local TexturekMask = overlay:CreateMaskTexture()
	-- TexturekMask:SetAllPoints(overlay)
	TexturekMask:SetPoint("TOP", 0, 12)
	TexturekMask:SetPoint("LEFT", -12, 0)
	TexturekMask:SetPoint("RIGHT", 12, 0)
	TexturekMask:SetPoint("BOTTOM", 0, -12)
	TexturekMask:SetTexture(
		"Interface\\AddOns\\"..AddonName.."\\media\\orb_spark_mask",
		"CLAMPTOBLACKADDITIVE",
		"CLAMPTOBLACKADDITIVE"
	)

	--orbgrid
	local orbgrid = overlay:CreateTexture(nil, "BACKGROUND", nil, 3)
	orbgrid:SetPoint("TOP", 0, 25)
	orbgrid:SetPoint("LEFT", -25, 0)
	orbgrid:SetPoint("RIGHT", 26, 0)
	orbgrid:SetPoint("BOTTOM", 0, -25)
	orbgrid:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_grid1_fh")
	orbgrid:SetAlpha(cfg.orbgridalpha)
	orb.grid = orbgrid


	--highlight
	local highlight = overlay:CreateTexture(nil, "BACKGROUND", nil, 3)
	--highlight:SetAllPoints()
	highlight:SetPoint("TOP", 0, 1)
	highlight:SetPoint("LEFT", -1, 0)
	highlight:SetPoint("RIGHT", 1, 0)
	highlight:SetPoint("BOTTOM", 0, -1)
	highlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_gloss_fh")
	highlight:SetAlpha(cfg.highlightalpha or 1)
	orb.highlight = highlight


	--orbshadow
	local orbshadow = overlay:CreateTexture(nil, "BACKGROUND", nil, 3)
	-- orbshadow:SetAllPoints()
	orbshadow:SetPoint("TOP", 0, 1)
	orbshadow:SetPoint("LEFT", -1, 0)
	orbshadow:SetPoint("RIGHT", 1, 0)
	orbshadow:SetPoint("BOTTOM", 0, -1)
	orbshadow:SetVertexColor(0, 0, 0)
	orbshadow:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_shadow")
	orbshadow:SetAlpha(cfg.orbshadowalpha)
	orb.orbshadow = orbshadow


	--spark
	local spark = overlay:CreateTexture(nil, "BACKGROUND", nil, -3)
	spark:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_spark_fh")
	spark:SetSize(1.2*cfg.size, 0.05*cfg.size)
	spark:SetVertexColor(cfg.healthcolor.r, cfg.healthcolor.g, cfg.healthcolor.b)
	spark:SetAlpha(cfg.sparkalpha or 1)
	spark:SetBlendMode("ADD")
	spark:SetPoint("CENTER", fillingTex, "TOP", 0, 0)
	-- spark:SetPoint("CENTER", clipFrame, 0, 0)
	spark:AddMaskTexture(TexturekMask)
    spark:Hide()
    orb.spark = spark


	--orb values
	local values = CreateFrame("Frame", "$parentValues", overlay)
	--values:SetFrameStrata"BACKGROUND"
	values:SetAllPoints(orb)
	--top value
	values.top = ns.createFontString(values, STANDARD_TEXT_FONT, 27, "OUTLINE")
	values.top:SetPoint("BOTTOM", overlay, "CENTER", 0, -5)
	values.top:SetTextColor(cfg.value.top.color.r, cfg.value.top.color.g, cfg.value.top.color.b)
	--bottom value
	values.bottom = ns.createFontString(values, STANDARD_TEXT_FONT, 16, "OUTLINE")
	values.bottom:SetPoint("TOP", overlay, "CENTER", 0, -4)
	values.bottom:SetTextColor(cfg.value.bottom.color.r, cfg.value.bottom.color.g, cfg.value.bottom.color.b)
	orb.values = values
	--register the tags
	if db then
		self:Tag(orb.values.top, "[diablo:PowerOrbTop]")
		self:Tag(orb.values.bottom, "[diablo:PowerOrbBottom]")
	elseif cfg.value.short then
		self:Tag(orb.values.top, "[topdefpp]")
		self:Tag(orb.values.bottom, "[botdefpp]")
	else
		self:Tag(orb.values.top, "[topdefpp]")
		self:Tag(orb.values.bottom, "[botcurpp]")
	end


	--AngelFrame
	local AngelFrame = CreateFrame("Frame", "DiabloAngelFrame", DiabloPowerOrb)
	AngelFrame:SetSize(cfg.size*0.8, cfg.size*0.8)
	AngelFrame:SetFrameStrata("LOW")
	AngelFrame:SetFrameLevel(0)
	AngelFrame:SetPoint("BOTTOMLEFT", "DiabloPowerOrb", "BOTTOMRIGHT", 8/cfg.scale, 0)

	local at = AngelFrame:CreateTexture(nil, "BACKGROUND", nil, 2)
	at:SetPoint("TOP", 0, 110)
	at:SetPoint("LEFT", -80, 0)
	at:SetPoint("RIGHT", 30, 0)
	at:SetPoint("BOTTOM", 0, 0)
	at:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\_angel1")
	at:SetVertexColor(1, 1, 1, 1)
	orb.textureframe = AngelFrame


	--Register with oUF
	self.Power = filling
	ns.PowerOrb = orb--save the orb in the namespace
	self.Power.frequentUpdates = true
	-- self.Power.colorTapping = false
	-- self.Power.colorDisconnected = false
	self.Power.Smooth = true
	self.Power.colorPower = true	--cfg.colorAuto or false
	-- self.Power.colorReaction = false
	-- self.Power.colorClass = false
	hooksecurefunc(self.Power, "SetStatusBarColor", updateStatusBarColor)
	self.Power.PostUpdate = updateValue
	--Make the background darker.
	Background.multiplier = 0.3
	--Register it with oUF
	filling.bg = Background






	
	-- --addpower
	-- local class = select(2, UnitClass"player")
	-- --Create AddPower frame
	-- local AP = CreateFrame("StatusBar", "DiabloAddPower", self)
	-- AP:SetSize(110, 16)
	-- AP:SetPoint("BOTTOM", "DiabloPowerOrb", "TOP", 0, 16)
	-- AP:SetFrameStrata("LOW")
	-- AP:SetFrameLevel(1)
	-- AP:SetStatusBarTexture("Interface\\AddOns\\"..AddonName.."\\media\\power")
	-- --AP:SetStatusBarColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)

	-- --Add Artwork
	-- local b = CreateFrame("Frame", nil, DiabloAddPower)
	-- b:SetSize(AP:GetSize())
	-- b:SetPoint("CENTER")
	-- b:SetFrameStrata("BACKGROUND")
	-- local br = b:CreateTexture(nil, "ARTWORK")
	-- br:SetPoint("TOP", 0, 1)
	-- br:SetPoint("LEFT", -7, 0)
	-- br:SetPoint("RIGHT", 7, 0)
	-- br:SetPoint("BOTTOM", 0, -1)
	-- br:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\powerborder")
	-- --[[
	-- -- AP:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- AP:RegisterEvent("PLAYER_LOGIN")
	-- AP:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	-- AP:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	-- AP:SetScript("OnEvent", function(...)
	-- 	local self, event, unit =...
	-- 	if unit and unit ~= "player" then return end
	-- 	local playerclass = select(2, UnitClass"player")
	-- 	if playerclass == "PRIEST" and GetSpecialization() == 3 then AP:Show()
	-- 	elseif playerclass == "DRUID" and GetSpecialization() ~= 4 and GetSpecialization() ~= 2 and GetSpecialization() ~= 3 and GetShapeshiftForm() ~= 1 and GetShapeshiftForm() ~= 2 and GetShapeshiftForm() ~= 3 and GetShapeshiftForm() ~= 6 then AP:Show()
	-- 	elseif playerclass == "SHAMAN" and GetSpecialization() == 1 then AP:Show()
	-- 	else AP:Hide() end
	-- end)
	-- --]]
	-- --Register with oUF
	-- self.AdditionalPower = AP
	-- self.AdditionalPower.frequentUpdates = true
	-- self.AdditionalPower.colorPower = false
	-- self.AdditionalPower.bg = nil
	-- AP:SetStatusBarColor(cfg.powercolor.r, cfg.powercolor.g, cfg.powercolor.b)


end



local druidMana = function(self)
    local _, playerClass = UnitClass("player")
	if playerClass ~= "DRUID" then
		return
	end
    local DruidManabar = CreateFrame("StatusBar", "DruidManabar", self)
    DruidManabar:SetStatusBarTexture("Interface\\AddOns\\" .. AddonName .. "\\media\\power")
    DruidManabar:GetStatusBarTexture():SetHorizTile(false)
    DruidManabar:SetSize(110, 16)
    DruidManabar:SetPoint("BOTTOM", "DiabloPowerOrb", "TOP", 0, 16)
    DruidManabar:SetFrameStrata("LOW")
    DruidManabar:SetStatusBarColor(0, 0.4, 1)
	DruidManabar:SetFrameLevel(1)

    local border = CreateFrame("Frame", nil, DruidManabar)
    border:SetSize(DruidManabar:GetSize())
    border:SetPoint("CENTER")
	-- border:SetFrameStrata("BACKGROUND")

    local tex = border:CreateTexture(nil, "ARTWORK")
	tex:SetPoint("TOP", 0, 1)
	tex:SetPoint("LEFT", -7, 0)
	tex:SetPoint("RIGHT", 7, 0)
	tex:SetPoint("BOTTOM", 0, -1)
    tex:SetTexture("Interface\\AddOns\\" .. AddonName .. "\\media\\powerborder")

    local Label = CreateFrame("Frame","$parentValues",DruidManabar)
    Label:SetFrameStrata("HIGH")
    Label:SetAllPoints(border)
    Label = ns.createFontString(Label, STANDARD_TEXT_FONT, 12, "OUTLINE")
    Label:SetPoint("CENTER", 0, 0)
    Label:SetTextColor(1,1,1)

    DruidManabar.Label = Label
    DruidManabar.border = border

    local UNIT_PLAYER = "player"
    local POWERTYPE_MANA = Enum.PowerType.Mana
    local function On_Update(self, evt, arg1, arg2, ...)
        if evt == "UNIT_POWER_UPDATE" then
            if arg2 == "MANA" then
                local mana = UnitPower(UNIT_PLAYER, POWERTYPE_MANA)
                self:SetValue(mana / UnitPowerMax(UNIT_PLAYER, POWERTYPE_MANA))
                self.Label:SetText(mana)
            end
        elseif evt == "UNIT_DISPLAYPOWER" then
            local powerType, _ = UnitPowerType(UNIT_PLAYER)
            if powerType ~= POWERTYPE_MANA then
                self:Show()
                self.Label:Show()
            else
                self:Hide()
                self.Label:Hide()
            end
        elseif evt == "PLAYER_LOGIN" then
            -- Initialize
            On_Update(self, "UNIT_DISPLAYPOWER", UNIT_PLAYER)
            On_Update(self, "UNIT_POWER_UPDATE", UNIT_PLAYER, "MANA")

            -- Lable Justify, (Main Menu -> Interface -> Display -> Status Text Display)
            local style = GetCVar("statusTextDisplay")
            if style ~= "BOTH" then
                if style == "NONE" then
                    self.Label:Hide()
                else
                    self.Label:SetJustifyH("CENTER")
                end
            end
        end
    end
    DruidManabar:SetMinMaxValues(0, 1.0)

	DruidManabar:RegisterEvent("PLAYER_LOGIN")
	DruidManabar:RegisterUnitEvent("UNIT_POWER_UPDATE", UNIT_PLAYER)
	DruidManabar:RegisterUnitEvent("UNIT_DISPLAYPOWER", UNIT_PLAYER)
    DruidManabar:SetScript("OnEvent", On_Update)

end



---------------------------------------------
--PLAYER STYLE FUNC
---------------------------------------------
local createStyle = function(self)
	initUnitParameters(self)
	d3_health(self, "HEALTH")
	d3_power(self, "POWER")

	druidMana(self)

	-- self.CombatIndicator = ns.createIcon(DiabloDemonFrame, "ARTWORK", 32, "DiabloHealthOrb", "CENTER", "TOP", 0, 16, -1)
	self.CombatIndicator = ns.createIcon(DiabloDemonFrame, "ARTWORK", 32, "DiabloDemonFrame", "CENTER", "CENTER", 32, 83, -1)
	self.CombatIndicator:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
	self.CombatIndicator:SetTexCoord(.5, 1, 0, .49)
	self.RestingIndicator = ns.createIcon(DiabloDemonFrame, "ARTWORK", 32, "DiabloDemonFrame", "CENTER", "CENTER", -14, 70, -1)
	self.PvPIndicator = ns.createIcon(DiabloDemonFrame, "ARTWORK", 42, "DiabloDemonFrame", "CENTER", "CENTER", -48, 30, -1)
	unit.player = self

end


---------------------------------------------
--SPAWN PLAYER UNIT
---------------------------------------------
oUF:RegisterStyle("diablo:player", createStyle)
oUF:SetActiveStyle("diablo:player")
oUF:Spawn("player", "DiabloPlayerFrame")



-- 天赋切换
if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
	-- 材质转文本
	local GetTexStr = function(tex, size)
		local s = size or 13
		return "|T"..tex..":"..s..":"..s..":0:0:64:64:4:60:4:60|t"
	end

	local function TalentDropDown_Initialize(self, level, menuList)
		if UnitLevel("player") < 10 or GetNumSpecGroups() < 2  then return end
		local current_spec_index = C_SpecializationInfo.GetSpecialization(nil, nil, i)
		-- local current_lootspec_index = GetLootSpecialization()
		local cur_specID, cur_specName, _, cur_Icon = C_SpecializationInfo.GetSpecializationInfo(current_spec_index)
		-- local cur_LootspecID, cur_LootspecName = GetSpecializationInfoByID(current_lootspec_index)
		local info

		if level == 1 then
			-- info = UIDropDownMenu_CreateInfo()
			-- info.text = "|cffffff00"..(L.sspec or "    切换天赋").."|r"
			-- info.isTitle = true
			-- info.notCheckable = true
			-- UIDropDownMenu_AddButton(info, level)

			info = UIDropDownMenu_CreateInfo()
			for i = 1, 2 do
				local specIndex = C_SpecializationInfo.GetSpecialization(nil, nil, i)
				if specIndex then
					local id, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(specIndex)
					info.text = GetTexStr(icon).." "..name
					info.checked = (cur_specID == id)
					info.func = function()
						C_SpecializationInfo.SetActiveSpecGroup(i)
						HideDropDownMenu(1)
					end
					UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end

	DiabloPowerOrb.DropDown = CreateFrame("Frame", nil, DiabloPowerOrb, "UIDropDownMenuTemplate")
	DiabloPowerOrb:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			DiabloPowerOrb.DropDown.point = "BOTTOM";
			DiabloPowerOrb.DropDown.relativePoint = "TOP"
			ToggleDropDownMenu(1, nil, DiabloPowerOrb.DropDown, DiabloPowerOrb, 0, 5)
		end
	end)

	DiabloPowerOrb:SetScript("OnEvent", function(self, event)
		UIDropDownMenu_Initialize(self.DropDown, TalentDropDown_Initialize, "MENU")
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
		if event == "PLAYER_SPECIALIZATION_CHANGED" then
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		end
	end)

	DiabloPowerOrb:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	DiabloPowerOrb:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- DiabloPowerOrb:RegisterEvent("PLAYER_LOGIN")

elseif WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then

	local function TalentDropDown_Initialize(self, level, menuList)
		if InCombatLockdown() then return end
		if GetNumTalentGroups() < 2 then return end
		-- local current_spec_index = GetActiveTalentGroup()
		-- local cur_specID, cur_specName, _, cur_Icon = GetTalentTabInfo(current_spec_index)
		-- local numspec = GetNumTalentGroups()
		local info
		if level == 1 then
			-- info = UIDropDownMenu_CreateInfo()
			-- info.text = "|cffffff00"..(L.sspec or "    切换天赋").."|r"
			-- info.isTitle = true
			-- info.notCheckable = true
			-- UIDropDownMenu_AddButton(info, level)

			if UnitLevel("player") >= 10 then -- 10 级别后有天赋
				info = UIDropDownMenu_CreateInfo()
				info.text = (GetLocale()=="zhCN") and "切换天赋" or "Switch Spec"
				-- info.checked = (cur_specID == id)
				info.notCheckable = true
				info.func = function()
					local i = GetActiveTalentGroup()
					C_SpecializationInfo.SetActiveSpecGroup(i == 1 and 2 or 1)
					HideDropDownMenu(1)
					-- ToggleTalentFrame()
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end

	DiabloPowerOrb.DropDown = CreateFrame("Frame", nil, DiabloPowerOrb, "UIDropDownMenuTemplate")
	DiabloPowerOrb:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			DiabloPowerOrb.DropDown.point = "BOTTOM";
			DiabloPowerOrb.DropDown.relativePoint = "TOP"
			ToggleDropDownMenu(1, nil, DiabloPowerOrb.DropDown, DiabloPowerOrb, 0, 5)
		end
	end)

	DiabloPowerOrb:SetScript("OnEvent", function(self, event)
		UIDropDownMenu_Initialize(self.DropDown, TalentDropDown_Initialize, "MENU")
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
		-- if event == "PLAYER_SPECIALIZATION_CHANGED" then
		-- 	self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		-- end
	end)

	-- DiabloPowerOrb:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	DiabloPowerOrb:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- DiabloPowerOrb:RegisterEvent("PLAYER_LOGIN")


end


-- hooksecurefunc("UIParent_ManageFramePositions", function()
-- 	if OverrideActionBar:IsShown() then
-- 		DiabloDemonFrame:Hide()
-- 		DiabloAngelFrame:Hide()
-- 		DiabloHealthOrb:Hide()
-- 		DiabloPowerOrb:Hide()
-- 	else
-- 		DiabloDemonFrame:Show()
-- 		DiabloAngelFrame:Show()
-- 		DiabloHealthOrb:Show()
-- 		DiabloPowerOrb:Show()
-- 	end
-- 	-- if PetBattleFrame:IsShown() or OverrideActionBar:IsShown() then
-- 	-- 	BagsBar:Hide()
-- 	-- else
-- 	-- 	BagsBar:Show()
-- 	-- end
-- end)



--图腾条
if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC or  WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
	if not TotemFrame then return end
	local us = tonumber(GetCVar("uiScale"))
	if us <= 0.71 then
		TotemFrame:SetScale(1.2)
	else
		TotemFrame:SetScale(1)
	end
	local tots = TotemFrame:GetScale()

	hooksecurefunc(TotemFrame, "Update",function()
		for button in _G.TotemFrame.totemPool:EnumerateActive() do
			local hasTotem, _, start, dur, icon = GetTotemInfo(button.slot)
			button:SetAlpha(0)			--隐藏圆圈
			button.Icon:SetParent(UIParent)
			button.Icon:SetSize(30*tots,30*tots)
			-- button.Icon.Texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)

			local normalTexture = button.Icon:CreateTexture(nil, "OVERLAY", nil, 3)
			normalTexture:SetAllPoints()
			normalTexture:SetPoint("TOPLEFT", -1, 1)
			normalTexture:SetPoint("BOTTOMRIGHT", 1, -1)
			normalTexture:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\button_dragon")
			-- normalTexture:SetVertexColor(Classcolor.r, Classcolor.g, Classcolor.b, 1)
			normalTexture:SetVertexColor(0, 0, 0, 1)

			local cooldown = button.Icon.cooldown
			if not cooldown then
				cooldown = CreateFrame("Cooldown", nil, button.Icon, "CooldownFrameTemplate")
				cooldown:SetAllPoints(button.Icon)
				cooldown:SetPoint("TOPLEFT", 0, -1)
				cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
				cooldown:SetAlpha(0.8) 
				cooldown:SetReverse(true)
				button.Icon.cooldown = cooldown
			end

			if hasTotem and dur and dur > 0 and start then
				local remaining = start + dur - GetTime()
				if remaining > 0 then
					cooldown:SetCooldown(start, dur)
					cooldown:Show()
				end
			end
			button:HookScript("OnHide",function()
				cooldown:Hide()
			end)
			-- button.Duration:SetParent(UIParent)
			-- button.Duration:SetScale(0.01)	--隐藏下方的持续时间
			-- button.Duration:Hide()
		end
		TotemFrame.spacing = -1
		-- TotemFrame.layoutOnBottom = true

	end)


	TTFMF:SetSize(100*tots,80*tots)
	TotemFrame:HookScript("OnUpdate",function()
		TotemFrame:ClearAllPoints()
		TotemFrame:SetParent(TTFMF)
		if TotemFrame:GetParent() == TTFMF then
			TotemFrame:SetPoint("CENTER", TTFMF, "CENTER", -18, 0)
		end
		-- if TotemFrame:IsShown() then
		-- 	TTFMF:EnableMouse(true)
		-- else
		-- 	TTFMF:EnableMouse(false)
		-- end
	end)
	TotemFrame:HookScript("OnShow",function()
		TotemFrame:ClearAllPoints()
		TotemFrame:SetParent(TTFMF)
		if TotemFrame:GetParent() == TTFMF then
			TotemFrame:SetPoint("CENTER", TTFMF, "CENTER", -18, 0)
		end
		TTFMF:EnableMouse(true)
	end)
	TotemFrame:HookScript("OnHide",function()
		TTFMF:EnableMouse(false)
	end)

end