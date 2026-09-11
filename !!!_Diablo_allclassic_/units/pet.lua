local _
--get the addon namespace
local AddonName, ns =...
local oUF = ns.oUF or oUF

	local cfg = {}
	cfg = {
		show = true,
		unlock = true,
		scale = 1,
		width = 110,
		height = 20,
		pos = { a1 = "BOTTOMRIGHT", a2 = "TOPLEFT", af = "DiabloPlayerFrame", x = 5, y = -20 },
		health = {
			texture = "Interface\\AddOns\\"..AddonName.."\\media\\statusbar3",
			tag = "[diablo:misshp]"
			},
		power = {
			texture = "Interface\\AddOns\\"..AddonName.."\\media\\statusbar3"
			}
		}
	---------------------------------------------
	--UNIT SPECIFIC FUNCTIONS
	---------------------------------------------
	--init parameters
	local initUnitParameters = function(self)
		self:SetFrameStrata"BACKGROUND"
		self:SetFrameLevel(1)
		self:SetSize(cfg.width, cfg.height)
		self:SetScale(cfg.scale)
		self:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
		self:RegisterForClicks"AnyDown"
		self:SetScript("OnEnter", UnitFrame_OnEnter)
		self:SetScript("OnLeave", UnitFrame_OnLeave)
	end
	local d3_health = function(self)
		local health = CreateFrame("StatusBar", "PetHealthbar", self)
		health:SetSize(cfg.width, cfg.height)
		--health:SetAllPoints(self)
		health:SetPoint("TOP", 0, 0)
		health:SetPoint("LEFT", 0, 0)
		health:SetPoint("RIGHT", 0, 0)
		health:SetPoint("BOTTOM", 0, cfg.height*0.25)
		health:SetStatusBarTexture(cfg.health.texture)
		health:SetStatusBarColor(0.3, 0, 0)
		health.bg = health:CreateTexture(nil, "BACKGROUND", nil, -6)
		health.bg:SetTexture(cfg.health.texture)
		health.bg:SetAllPoints(health)
		health.bg:SetVertexColor(0, 0, 0, 0.3)
		health.glow = health:CreateTexture(nil, "OVERLAY", nil, -5)
		health.glow:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\targettarget_hpglow")
		health.glow:SetPoint("TOP", 0, 32*cfg.height/20)
		health.glow:SetPoint("LEFT", -32*cfg.width/110, 0)
		health.glow:SetPoint("RIGHT", 32*cfg.width/110, 0)
		health.glow:SetPoint("BOTTOM", 0, -48*cfg.height/20)
		health.glow:SetVertexColor(0, 0, 0, 0.1)
		health.highlight = health:CreateTexture(nil, "OVERLAY", nil, -4)
		health.highlight:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\targettarget_highlight")
		health.highlight:SetAllPoints(self)
		health.highlight:SetVertexColor(0, 0, 0, 0.5)

		--overlay frame
		health.overlay = CreateFrame("Frame", "$parentOverlay", PetHealthbar)
		-- overlay:SetFrameStrata"LOW"

		health.overlay:SetAllPoints(health)
		--orb.overlay = overlay 
		local br = health.overlay:CreateTexture(nil, "ARTWORK", nil, 1)
		br:SetPoint("TOP", 0, cfg.height/20)
		br:SetPoint("LEFT", -6*cfg.width/110, 0)
		br:SetPoint("RIGHT", 6*cfg.width/110, 0)
		br:SetPoint("BOTTOM", 0, -6*cfg.height/20)
		br:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\powerborder")

		--Options
		health.frequentUpdates = true

		if PetFrame_SetHappiness then
			hooksecurefunc("PetFrame_SetHappiness",function()	
				local t = GetPetHappiness()
				if t == 3 then 
					health:SetStatusBarColor(0, 1, 0)
				elseif t == 2 then
					health:SetStatusBarColor(1, 1, 0)
				elseif t == 1 then
					health:SetStatusBarColor(1, 0, 0)
				else
				-- health.colorTapping = true
				-- health.colorDisconnected = true
				-- health.colorClass = false
				health.colorHealth = true
				health.colorReaction = true
				end
			end)
		else
			-- health.colorTapping = true
			-- health.colorDisconnected = true
			-- health.colorClass = false
			health.colorHealth = true
			health.colorReaction = true
		end
		health.Smooth = true
		--Make the background darker.
		health.bg.multiplier = 0
		--Register it with oUF
		self.Health = health
	end
	local d3_power = function(self)
		local power = CreateFrame("StatusBar", "PetPowerbar", self.Health)
		power:SetFrameLevel(1)
		power:SetSize(cfg.width, cfg.height*0.25)
		power:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
		power:SetStatusBarTexture(cfg.power.texture)
		power:SetStatusBarColor(1, 0.5, 0.25)
		power.bg = power:CreateTexture(nil, "BACKGROUND", nil, -6)
		power.bg:SetTexture(cfg.power.texture)
		power.bg:SetAllPoints(power)
		power.bg:SetVertexColor(0, 0, 0, 0)
		power.glow = power:CreateTexture(nil, "OVERLAY", nil, -5)
		power.glow:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\targettarget_hpglow")
		power.glow:SetPoint("TOP", 0, 8*cfg.height/20)
		power.glow:SetPoint("LEFT", -32*cfg.width/110, 0)
		power.glow:SetPoint("RIGHT", 32*cfg.width/110, 0)
		power.glow:SetPoint("BOTTOM", 0, -11*cfg.height/20)
		power.glow:SetVertexColor(0, 0, 0, 0.1)

		--Options
		power.frequentUpdates = true
		power.colorTapping = true
		power.colorDisconnected = true
		power.colorClass = true
		power.colorpower = true
		power.colorReaction = false
		power.Smooth = true
		--Make the background darker.
		power.bg.multiplier = 0
		--Register it with oUF
		self.Power = power
	end
	----create health power strings
	local createHealthPowerStrings = function(self)
		local name = ns.createFontString(self.Health, STANDARD_TEXT_FONT, cfg.width/8, "OUTLINE")
		name:SetPoint("BOTTOM", self.Health, "TOP", 1, 3)
		--name:SetPoint("LEFT", self.Health, -7, 0)
		--name:SetPoint("RIGHT", self.Health, 10, 0)
		self.Name = name
		--local hpval = ns.createFontString(self.Health, STANDARD_TEXT_FONT, 11, "OUTLINE")
		--hpval:SetPoint("RIGHT", -2, 0)
		self:Tag(name, "[diablo:name]")
		self:Tag(hpval, cfg.health.tag or "")
	end

	local function CreatePetCastBar(self)
		local Castbar = CreateFrame("StatusBar", "PetCastBar", self)
		Castbar:SetSize(213,10)
		Castbar:SetScale(0.5)
		Castbar:SetPoint("BOTTOM", DiabloPetFrame, "BOTTOM", 0, 0)
		
		-- 设置纹理和颜色
		Castbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		Castbar:SetStatusBarColor(1, 0.7, 0)
		
		-- -- 添加边框
		-- local bg = Castbar:CreateTexture(nil, "BACKGROUND")
		-- bg:SetAllPoints(Castbar)
		-- bg:SetTexture(0, 0, 0, 0.5)
		
		-- 添加文字
		Castbar.Text = Castbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		Castbar.Text:SetFont(STANDARD_TEXT_FONT, 22, "OUTLINE")
		Castbar.Text:ClearAllPoints()
		Castbar.Text:SetPoint("BOTTOMLEFT", Castbar, "BOTTOMLEFT", 0, 1)
		
		-- 添加时间
		Castbar.Time = Castbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		Castbar.Time:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
		Castbar.Time:ClearAllPoints()
		Castbar.Time:SetPoint("BOTTOMRIGHT", Castbar, "BOTTOMRIGHT", -1, 0)
		
		-- 添加闪光
		Castbar.Flash = Castbar:CreateTexture(nil, "OVERLAY")
		Castbar.Flash:SetAllPoints(Castbar)
		Castbar.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash")
		Castbar.Flash:SetBlendMode("ADD")
		Castbar.Flash:Hide()

		-- Register it with oUF
		self.Castbar = Castbar
	end

	---------------------------------------------
	--PET STYLE FUNC
	---------------------------------------------
	local function createStyle(self)
		--init
		initUnitParameters(self)
		d3_health(self)
		d3_power(self)
		createHealthPowerStrings(self)
		CreatePetCastBar(self)
		--health power update
		self.Health.PostUpdate = ns.updateHealth
		self.Power.PostUpdate = ns.updatePower
		--icons

		self.RaidTargetIndicator = ns.createIcon(PetHealthbar.overlay, "BACKGROUND", 20, "PetHealthbar", "CENTER", "CENTER", 0, -2, 2)

		-- --add total absorb
		-- ns.totalAbsorb(self)
		-- ns.HealthPrediction(self)

	end

	---------------------------------------------
	--SPAWN PET UNIT
	---------------------------------------------
	if cfg.show then
		oUF:RegisterStyle("diablo:pet", createStyle)
		oUF:SetActiveStyle"diablo:pet"
		oUF:Spawn("pet", "DiabloPetFrame")
	end

	----actionbar background
	--local f = CreateFrame("Frame", "DiabloPetFrameBG", DiabloPetFrame)
	--f:SetSize(512*cfg.width/305, 256*cfg.height/30)
	--f:SetFrameStrata"MEDIUM"
	--f:SetFrameLevel(0)
	--f:SetPoint("CENTER", 0, 0.5)
	--f:SetScale(1)
	--local t = f:CreateTexture(nil, "BACKGROUND", nil, -8)
	--t:SetAllPoints(f)
	--t:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\targettarget")

--other

-- hooksecurefunc("UIParent_ManageFramePositions", function()
-- 	if OverrideActionBar:IsShown() then
-- 	PetHealthbar:Hide()
-- 	else
-- 	PetHealthbar:Show()
-- 	end
-- end)