local _
local AddonName, ns =...

local AACTBFrame = CreateFrame("Frame","AACTBFrame",UIParent)
AACTBFrame:SetPoint("BOTTOM",UIParent, 0, 220)
AACTBFrame:SetSize(80, 20)
AACTBFrame:EnableMouse(false)


ns.event("PLAYER_LOGIN", function()

if DToolsDB.cbb == true then
    if C_AddOns.IsAddOnLoaded("DragonflightUI") == true then return end

    --施法条---------------------
    -- 玩家、目标、焦点施法条位置、大小、字体调整
    PlayerCastingBarFrame:SetHeight(14)	--施法条宽
    -- PlayerCastingBarFrame:SetScale(1.1)
    PlayerCastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    PlayerCastingBarFrame.Text:ClearAllPoints()
    PlayerCastingBarFrame.Text:SetPoint("CENTER", PlayerCastingBarFrame, 0, 3)
	PlayerCastingBarFrame:HookScript("OnUpdate", function()
		PlayerCastingBarFrame.Icon:Show()
		PlayerCastingBarFrame.Icon:SetHeight(24)
		PlayerCastingBarFrame.Icon:SetWidth(24)
		-- PlayerCastingBarFrame.Icon:SetTexCoord(0.05,0.95,0.05,0.95)
		PlayerCastingBarFrame.Icon:ClearAllPoints()
		PlayerCastingBarFrame.Icon:SetPoint("RIGHT", PlayerCastingBarFrame, "LEFT", -10, 2.5) -- 调整位置
	end)
    PlayerCastingBarFrame.timer = PlayerCastingBarFrame:CreateFontString(nil)
    PlayerCastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
    PlayerCastingBarFrame.timer:SetPoint("LEFT", PlayerCastingBarFrame, "RIGHT", 9, 2.5) -- 调整位置
    PlayerCastingBarFrame.update = .1

    TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("CENTER", TargetFrameSpellBar, 0, 0)
    -- TargetFrameSpellBar.Icon:Show()
    -- TargetFrameSpellBar.Icon:SetHeight(15)
    -- TargetFrameSpellBar.Icon:SetWidth(15)
    -- TargetFrameSpellBar.Icon:SetTexCoord(0.05,0.95,0.05,0.95)
    TargetFrameSpellBar.Icon:SetPoint("LEFT", TargetFrameSpellBar, -22, 0)
    TargetFrameSpellBar.timer = TargetFrameSpellBar:CreateFontString(nil)
    TargetFrameSpellBar.timer:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    TargetFrameSpellBar.timer:SetPoint("LEFT", TargetFrameSpellBar, "RIGHT", 4, 1)
    TargetFrameSpellBar.update = .1

    FocusFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    FocusFrameSpellBar.Text:ClearAllPoints()
    FocusFrameSpellBar.Text:SetPoint("CENTER", FocusFrameSpellBar, 0, 0)
    -- FocusFrameSpellBar.Icon:SetHeight(15)
    -- FocusFrameSpellBar.Icon:SetWidth(15)
    -- FocusFrameSpellBar.Icon:SetTexCoord(0.05,0.95,0.05,0.95)
    FocusFrameSpellBar.Icon:SetPoint("LEFT", FocusFrameSpellBar, -21, 0)
    FocusFrameSpellBar.timer = FocusFrameSpellBar:CreateFontString(nil)
    FocusFrameSpellBar.timer:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
    FocusFrameSpellBar.timer:SetPoint("LEFT", FocusFrameSpellBar, "RIGHT", 4, 0)
    FocusFrameSpellBar.update = .1

    -- PetCastingBarFrame:SetScale(0.5)--宠物施法条缩放
    -- PetCastingBarFrame:ClearAllPoints()
    -- PetCastingBarFrame:SetPoint("BOTTOM",UIParent, -700, 333)
    -- PetCastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 22, "OUTLINE")
    -- PetCastingBarFrame.Text:ClearAllPoints()
    -- PetCastingBarFrame.Text:SetPoint("CENTER", PetCastingBarFrame, 0, 2)
    -- PetCastingBarFrame.Icon:SetHeight(20)
    -- PetCastingBarFrame.Icon:SetWidth(20)
    -- PetCastingBarFrame.Icon:ClearAllPoints()
    -- PetCastingBarFrame.Icon:SetPoint( "RIGHT", PetCastingBarFrame, "LEFT", -8, 2 )
    -- PetCastingBarFrame.timer = PetCastingBarFrame:CreateFontString(nil)
    -- PetCastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT, 22, "OUTLINE")
    -- PetCastingBarFrame.timer:SetPoint("RIGHT", PetCastingBarFrame, "RIGHT", -2, 1) -- 调整位置
    -- PetCastingBarFrame.update = .1
    -- PetCastingBarFrame.Border:SetTexture(nil)	--宠物施法条边框材质隐藏
    -- PetCastingBarFrame.Flash:SetTexture(nil)	--宠物施法条施法结束时边框材质隐藏
    -- PetCastingBarFrame:SetSize(213,14)	--宠物施法条长宽
    -- PetCastingBarFrame:HookScript("OnValueChanged", function() 	PetCastingBarFrame:Show() end );

    local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
        if not self.timer then
            return
        end
        if self.update and self.update < elapsed then
            if self.casting then
                self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
                --self.timer:SetText(format("%.1f/%.1f", max(self.value, 0), self.maxValue))--显示施法时间与总施法时间
            elseif self.channeling then
                self.timer:SetText(format("%.1f", max(self.value, 0)))
                --self.timer:SetText(format("%.1f/%.1f", max(self.value, 0), self.maxValue))--显示引导施法时间与总引导施法时间
            else
                self.timer:SetText("")
            end
            self.update = .1
        else
            self.update = self.update - elapsed
        end
    end

    PlayerCastingBarFrame:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
    TargetFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
    FocusFrameSpellBar:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
    -- PetCastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)

    -- 施法延迟显示
    local lagmeter = PlayerCastingBarFrame:CreateTexture(nil, "BACKGROUND", nil, 7);
    lagmeter:SetHeight(PlayerCastingBarFrame:GetHeight());
    lagmeter:SetWidth(0);
    lagmeter:SetPoint("RIGHT", PlayerCastingBarFrame, "RIGHT", 0, 2);
    lagmeter:SetTexture("Interface\\ChatFrame\\ChatFrameBackground");
    lagmeter:SetVertexColor(0.8, 0, 0); -- 延迟颜色

    hooksecurefunc(PlayerCastingBarFrame, "Show", function()
        down, up, lag = GetNetStats();
        local castingmin, castingmax = PlayerCastingBarFrame:GetMinMaxValues();
        local lagvalue = (lag / 1000) / (castingmax - castingmin);

        if (lagvalue < 0) then
            lagvalue = 0;
        elseif (lagvalue > 1) then
            lagvalue = 1;
        end

        lagmeter:SetWidth(PlayerCastingBarFrame:GetWidth() * lagvalue);
    end);
    --]]
end


if DToolsDB.aab == true then

	--自动攻击计时条------------------------
	local AATimer_Enabled = true;
	local AATimer_LastSpeed = UnitAttackSpeed("player");

	function AATimer_OnLoad(self)
		RegisterForSaveFrame(self, self:GetName());
		self:SetMinMaxValues(0, 1);
		self:SetValue(1);
	end

	local AATimerBar = CreateFrame("StatusBar", "AATimerBar", UIParent)
	AATimerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	AATimerBar:SetSize(195, 13)
	AATimerBar:SetPoint("CENTER", AACTBFrame, "CENTER", 0, 3)
	AATimerBar:SetFrameStrata("BACKGROUND")
	AATimerBar:SetScale(PlayerCastingBarFrame:GetScale())
	AATimerBar:Hide()

	local bg = AATimerBar:CreateTexture("$parentBorder", "BACKGROUND")
	bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	bg:SetSize(195, 13)
	bg:SetAllPoints(AATimerBar)
	bg:SetVertexColor(0, 0, 0, 0.5)

	local icon = AATimerBar:CreateTexture("$parentBorder", "ARTWORK", nil, 7)
	icon:SetSize(24,24)
	icon:SetPoint("RIGHT", AATimerBar, "LEFT", -10, -0.5)
	icon:SetTexture(GetSpellTexture(6603))

	local border = AATimerBar:CreateTexture("$parentBorder", "ARTWORK", nil, 6)
	border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")
	border:SetSize(256,64)
	border:SetPoint("CENTER")

	local AATimerBarTextLeft = AATimerBar:CreateFontString("$parentTextLeft", "ARTWORK", "GameFontHighlight")
	AATimerBarTextLeft:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	AATimerBarTextLeft:SetText(GetSpellInfo(6603))
	AATimerBarTextLeft:SetPoint("CENTER")

	local AATimerBarTextRight = AATimerBar:CreateFontString("$parentTextRight", "ARTWORK", "GameFontHighlight")
	AATimerBarTextRight:SetJustifyH("LEFT")
	AATimerBarTextRight:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
	AATimerBarTextRight:SetPoint("LEFT", AATimerBar, "RIGHT", 9, 1)


	local AATimerBarSpark = AATimerBar:CreateTexture("$parentSpark", "OVERLAY")
	AATimerBarSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	AATimerBarSpark:SetBlendMode("ADD")
	AATimerBarSpark:SetSize(32, 32)
	AATimerBarSpark:SetPoint("CENTER")

	local AATimerBarFlash = AATimerBar:CreateTexture("$parentFlash", "OVERLAY")
	AATimerBarFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash")
	AATimerBarFlash:SetBlendMode("ADD")
	AATimerBarFlash:SetSize(256, 64)
	AATimerBarFlash:SetPoint("CENTER")

	AATimerBar:SetScript("OnLoad", function(self, event)
		AATimer_OnLoad(self);
	end)
	AATimerBar:SetScript("OnUpdate", function(self, event)
		AATimer_OnUpdate(self);
	end)

	local function AATimer_FlashBar()
		if AATimerBar:IsShown() then
			local _min, _max = AATimerBar:GetMinMaxValues();
			AATimerBar:SetValue(_max);
			AATimerBar:SetStatusBarColor(0, 1, 0);
			AATimerBarSpark:Hide();
			AATimerBarFlash:SetAlpha(0);
			AATimerBarFlash:Show();
			AATimerBar.casting = nil;
			AATimerBar.flash = 1;
			AATimerBar.fadeOut = 1;
		end
	end

	local function AATimer_OnAttack(parry)
		local _min, _max = GetTime();
		local curTime, mainS, isHands = _min, UnitAttackSpeed("player");
		if isHands then
			return
		end
		if (parry and AATimerBar.start and AATimerBar.stop) then
			if (not AATimerBar:IsVisible()) then
				return
			end
			_min = AATimerBar.start;
			_max = AATimerBar.stop;
			if ((curTime - _min) < 0.6 * mainS) then
				_max = _max - 0.4 * mainS;
			end
		else
			_max = _min + mainS;
		end
		AATimerBar:SetStatusBarColor(1, 0.7, 0);
		AATimerBar:SetMinMaxValues(_min, _max);
		AATimerBar:SetValue(curTime);
		AATimerBar:SetAlpha(1);
		AATimerBar.start = _min;
		AATimerBar.stop = _max;
		AATimerBar.casting = 1;
		AATimerBar.fadeOut = nil;
		AATimerBarSpark:Show();
		AATimerBar:Show();
        AACTBFrame:EnableMouse(true)
	end
	
	local Event = CreateFrame("Frame")
	Event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Event:RegisterEvent("UNIT_ATTACK_SPEED")
	Event:RegisterEvent("PLAYER_REGEN_ENABLED")
	Event:RegisterEvent("PLAYER_REGEN_DISABLED")
	Event:RegisterUnitEvent("UNIT_SPELLCAST_START","player")
	Event:SetScript("OnEvent", function(self, event)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, auraId, auraName = CombatLogGetCurrentEventInfo();
			if event == "SWING_MISSED" then
				if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)) then
					AATimer_OnAttack();
				elseif (CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME) and auraId == "PARRY") then
					AATimer_OnAttack(true);
				end
			elseif event == "SWING_DAMAGE" then
				if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)) then
					AATimer_OnAttack();
				end
			end
		end

		if event == "UNIT_ATTACK_SPEED" then
			local mainSpeed, isHands = UnitAttackSpeed("player");
			if isHands then
				return
			end
			if (mainSpeed ~= AATimer_LastSpeed and AATimerBar.start) then
				AATimer_LastSpeed = mainSpeed;
				AATimerBar.stop = AATimerBar.start + mainSpeed;
				AATimerBar:SetMinMaxValues(AATimerBar.start, AATimerBar.stop);
				AATimerBar:SetValue(GetTime());
			end
		end

		if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" or event == "UNIT_SPELLCAST_START" then
			if AATimerBar:IsVisible() then
				AATimerBar:Hide();
                AACTBFrame:EnableMouse(false)
			end
		end

	end)

	function AATimer_OnUpdate(self)
		if (not AATimer_Enabled) then
			return;
		end
		local _min, _max = AATimerBar:GetMinMaxValues();
		if self.casting then
			local status = GetTime();
			if status > _max then
				status = _max;
			end
			AATimerBarTextRight:SetText(format("%0.1f", _max - status));
			AATimerBar:SetValue(status);
			AATimerBarFlash:Hide();
			local sparkPosition = ((status - _min) / (_max - _min)) * 195;
			if sparkPosition < 0 then
				sparkPosition = 0;
			end
			AATimerBarSpark:SetPoint("CENTER", AATimerBar, "LEFT", sparkPosition, 0);
			if _max - status <= 0 then
				AATimer_FlashBar();
			end
		elseif self.flash then
			local alpha = AATimerBarFlash:GetAlpha();
			if alpha < 1 then
				AATimerBarFlash:SetAlpha(alpha);
			else
				AATimerBarFlash:SetAlpha(1.0);
				self.flash = nil;
			end
		elseif self.fadeOut then
			local alpha = self:GetAlpha();
			if alpha > 0 then
				self:SetAlpha(alpha);
			else
				self.fadeOut = nil;
				self:Hide();
			end
		end
	end


end

	--]]

end)