SlashCmdList["RELOAD"] = function() ReloadUI() end SLASH_RELOAD1 = "/rl"

-- WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
-- WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
-- WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
-- WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
-- WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC

local AddonName, ns, _ =...
local L = ns.L
local oUF = ns.oUF or oUF

local diablomodel = false
if C_AddOns.IsAddOnLoaded("!!!_Diablo_allclassic_") == true then
 	diablomodel = true
end

local FirstloadFrame = CreateFrame("FRAME");
-- FirstloadFrame:RegisterEvent("ADDON_LOADED");
FirstloadFrame:RegisterEvent("PLAYER_LOGIN");
FirstloadFrame:SetScript("OnEvent", function(...)
	if C_AddOns.IsAddOnLoaded("!!!_DTools_classic_") == true or C_AddOns.IsAddOnLoaded("!!!_DTools_titan_") == true or C_AddOns.IsAddOnLoaded("!!!_DTools_anni_") == true or C_AddOns.IsAddOnLoaded("!!!_DTools_era_") == true then
		print("|cffff0000>DiabloUI:请删除旧版本插件!|r ")
		print("|cffff0000>DiabloUI:請刪除舊版本插件!|r ")
		print("|cffff0000>DiabloUI:Please delete the old version of the addon!|r ")
		print("|cffff0000>DiabloUI:Пожалуйста, удалите старую версию аддона!|r ")
		print("|cffff0000>DiabloUI:Veuillez supprimer l'ancienne version de l'addon!|r ")
	end
end)


function ns.isSecret(value)
	if issecretvalue(value) or issecrettable(value) then
		return true
	else
		return false
	end
end

local AddVersion = C_AddOns.GetAddOnMetadata(AddonName, "Version")
local AddTitle = C_AddOns.GetAddOnMetadata(AddonName, "Title")

--DB
ns.DToolsDefaultDB = {

	glob = true,
	aab = false,
	acu = true,
	acm = 0,
	acc = true,
	acp = false,
	acr = false,
	aur = true,
	aus = true,
	aua = true,
	aug = false,
	bart = 1,
	bfm = true,
	cbb = true,
	cbi = false,
	cfp = true,
	cfbb = false,
	chr = false,
	cname = L.pnc3 or "|cff00FF00/CN|r更改名字",
	ctbr = false,
	fsl = true,
	ftipa = 2,
	hsf = false,
	ifs = true,
	ifss = false,
	ist = true,
	npu = true,
	otb = false,
	otu = true,
	pnc = false,
	ruu = true,
	sfu = false,
	spellq = 250,
	tiu = true,
	tiub = false,
	unu = true,
	uns = false,
	unft= false,
	unfn= false,
	una = false,
	unc = true,
	vap = false,


	-- oUF UnitFrame
	oufd = true,
	oufc = true,
	dadf = true,
	dhpg = false,
	dpet = true,
	dduf = true,
	uisl = false,
	daml = true,

 }

--事件加载by:AddUI
local onceEvents = {
    ["PLAYER_ENTERING_WORLD"] = true,
    ["PLAYER_LOGIN"] = true,
}
function ns.event(event, handler, isOnce)--ns.event(event, handler, true)只执行一次的事件
    EventRegistry:RegisterFrameEventAndCallback(event, function(self, ...)
        if (isOnce or onceEvents[event]) and self then
            EventRegistry:UnregisterFrameEventAndCallback(event, self)
        end
        handler(event, ...)
    end)
end

----------ONLOAD EVENT---------
local loadFrame = CreateFrame("FRAME");
loadFrame:RegisterEvent("ADDON_LOADED");
loadFrame:RegisterEvent("PLAYER_LOGIN");
loadFrame:RegisterEvent("PLAYER_LOGOUT");

function loadFrame:OnEvent(event, arg1)
	if not DToolsDB_CHAR then DToolsDB_CHAR = {} end
	for i, j in pairs(ns.DToolsDefaultDB) do
		if type(j) == "table" then
			if DToolsDB_CHAR[i] == nil then DToolsDB_CHAR[i] = {} end
			for k, v in pairs(j) do
				if DToolsDB_CHAR[i][k] == nil then
					DToolsDB_CHAR[i][k] = v
				end
			end
		else
			if DToolsDB_CHAR[i] == nil then DToolsDB_CHAR[i] = j end
		end
	end

	if not DToolsDB_GLOB then DToolsDB_GLOB = {} end
	for i, j in pairs(ns.DToolsDefaultDB) do
		if type(j) == "table" then
			if DToolsDB_GLOB[i] == nil then DToolsDB_GLOB[i] = {} end
			for k, v in pairs(j) do
				if DToolsDB_GLOB[i][k] == nil then
					DToolsDB_GLOB[i][k] = v
				end
			end
		else
			if DToolsDB_GLOB[i] == nil then DToolsDB_GLOB[i] = j end
		end
	end
end
loadFrame:SetScript("OnEvent", loadFrame.OnEvent);
loadFrame:OnEvent()

local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("ADDON_LOADED")
Event:RegisterEvent("PLAYER_LOGOUT");
Event:SetScript("OnEvent", function(...)
	if DToolsDB_CHAR.glob == true then
		DToolsDB = DToolsDB_GLOB
	else
		DToolsDB = DToolsDB_CHAR
	end
end)

----------------------------------
--By Wind Chat Filter (WCF)
StaticPopupDialogs["DTools_EDITBOX"] = {
	text = "",
	button1 = _G.OKAY,
	hasEditBox = true,
	OnShow = function(self, data)
		self.EditBox:SetAutoFocus(false)
		self.EditBox.width = self.EditBox:GetWidth()
		self.EditBox:SetWidth(270)
		self.EditBox:AddHistoryLine("text")
		self.EditBox.temptxt = data
		self.EditBox:SetText(data)
		self.EditBox:HighlightText()
		self.EditBox:SetJustifyH("CENTER")

		-- self.text:SetText(self.text.text_arg1)
	end,
	OnHide = function(self)
		self.EditBox:SetWidth(self.EditBox.width or 50)
		self.EditBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		--self:ClearFocus()
	end,
	OnAccept = function()
		return
	end,
	whileDead = true,
	preferredIndex = 3,
	hideOnEscape = true
 }
--

local DToolsGUI = CreateFrame("Frame")
local category = Settings.RegisterCanvasLayoutCategory(DToolsGUI, AddonName)
Settings.RegisterAddOnCategory(category)

SlashCmdList["DTools"] = function()
	if InCombatLockdown() then 
		print("|cffff0000!!!|r|cff00ff00>|rInCombatLockdown!")
	else
		Settings.OpenToCategory(category:GetID())
	end
end
SLASH_DTools1 = "/di"
SLASH_DTools2 = "/zz"
print("|cffff0000>|r |cff00ff00\/Di|r "..(L.print or "打开设置界面"))

local function newFont(offx, offy, scale, createframe, anchora, anchroframe, anchorb, text, fontsize)
	local font = createframe:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	font:SetPoint(anchora, anchroframe, anchorb, offx, offy)
	font:SetText(text)
	font:SetScale(scale)
	font:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
	return font

end

local function newCheckbox(a, x, y, s, text, tip, db)
	-- if text == "" then return end
	local check = CreateFrame("CheckButton", "DToolsCheck"..text, DToolsGUI, "InterfaceOptionsCheckButtonTemplate")
	check:SetPoint("TOPLEFT", a, "BOTTOMLEFT", x, y)
	check:SetScale(s)
	check:SetChecked(DToolsDB[db])
	-- check.label = _G[check:GetName().."Text"]
	check.text:SetText("|cffFFFFFF"..text.."|r")
	check.text:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")

	check:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -5, -3)
		GameTooltip:AddLine("|cff00DD00"..tip.."|r")
		GameTooltip:Show()
	end)
	check:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	check:SetScript("OnClick", function (...)
		DToolsDB[db] = check:GetChecked()
	end)
	--check.tooltipRequirement = tip
	return check
end


local function resetdefault()
	StaticPopup_Show("resetdefault")
end
StaticPopupDialogs["resetdefault"] = {
	text = L.resd or "重载界面恢复默认",
	button1 = L.confirm or "确认",
	button2 = L.cancel or "放弃",
	OnAccept = function()
		DToolsDB_GLOB = DToolsDefaultDB
		DToolsDB_CHAR = DToolsDefaultDB
		ReloadUI()
	end,
	OnCancel = function()
		--ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
	}


ns.event("PLAYER_LOGIN", function()

	DTools = newFont(5, -4, 1, DToolsGUI, "TOPLEFT", DToolsGUI, "TOPLEFT", "|cff990000"..AddTitle.."|r", 50)
	-- DTools2 = newFont(0, 5, 1, DToolsGUI, "BOTTOMLEFT", DTools, "BOTTOMRIGHT", L.dtools2 or "界面美化", 25)
	-- if not DToolsGUI.captext then
	-- 	DToolsGUI.captext = DToolsGUI:CreateFontString(nil, "OVERLAY");
	-- end
	-- DToolsGUI.captext:SetFontObject("GameFontHighlight");
	-- DToolsGUI.captext:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 30, -70);
	-- DToolsGUI.captext:SetJustifyH("LEFT")
	-- DToolsGUI.captext:SetText();
	-- DToolsGUI.captext:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")


	local Dtools_glob = CreateFrame("CheckButton", "DToolsCheck"..(L.glob1 or "全局配置模式"), DToolsGUI, "InterfaceOptionsCheckButtonTemplate")
	Dtools_glob:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 5, -32)
	Dtools_glob:SetScale(1.6)
	Dtools_glob:SetChecked(DToolsDB_CHAR.glob)
	-- check.label = _G[check:GetName().."Text"]
	Dtools_glob.text:SetText("|cff00FF00"..(L.glob1 or "全局配置模式").."|r")
	Dtools_glob.text:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")

	Dtools_glob:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -5, -3)
		GameTooltip:AddLine("|cff00DD00"..(L.glob2 or "全部角色共用一个配置(更改后需要重载界面)").."|r")
		GameTooltip:Show()
	end)
	Dtools_glob:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	Dtools_glob:SetScript("OnClick", function (...)
		DToolsDB_CHAR.glob = Dtools_glob:GetChecked()
	end)

	-- Dtools_glob = newCheckbox(300, -40, 1.5, L.glob1 or "全局配置", L.glob2 or "全部角色共用一个配置(更改后需要重载界面)", "glob")

	StaticPopupDialogs.printh = {
		text = L.captext or "按住|cff00EE00Shift|r移动默认头像,暗黑血球,数据信息等\n(可以关闭动作条增强使用其他动作条插件)\n|cff00EE00/di|r 快速打开设置界面\n|cff00EE00/npd|r 恢复姓名板默认设置",
		button1 = OKAY,
		timeout = 0,
		whileDead = 1,
		preferredIndex = 3
 	}
	local printh = CreateFrame("Button", "Diablo_UISaveButton", DToolsGUI, "UIPanelButtonTemplate")
	printh:SetText(L.printh or "弹出说明")
	printh:SetWidth(150)
	printh:SetHeight(30)
	printh:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 488, -16)
	printh:SetScript("OnClick", function()
		StaticPopup_Show("printh")
	end)


	Dtools_acu = newCheckbox(Dtools_glob, 5, 0, 1.12, L.acu1 or "动作条增强", L.acu2 or "动作条增强和美化", "acu")
		Dtools_acc = newCheckbox(Dtools_acu, 16, 7, 0.944, L.acc1 or "黑化边框", L.acc2 or "染色动作条按钮边框", "acc")
		Dtools_acp = newCheckbox(Dtools_acc, 0, 7, 0.944, L.acp1 or "高级美化", L.acp2 or "美化动作条按钮边框背景", "acp")
		-- Dtools_acr = newCheckbox(Dtools_acp, 0, 7, 0.916, L.acr1 or  "隐藏动画", L.acr2 or "关闭10.0新增的图标施法动画", "acr")
	Dtools_unu = newCheckbox(Dtools_acu, 0, -30, 1.12, L.unu1 or "默认头像增强", L.unu2 or "默认头像框架美化增强", "unu")
		-- Dtools_uns = newCheckbox(Dtools_unu, 16, 7, 0.944, L.uns1 or "放大框体", L.uns2 or "更大的默认头像框架", "uns")
		Dtools_unft = newCheckbox(Dtools_unu, 16, 7, 0.944, L.unft1 or "金龙材质", L.unft2 or "玩家头像金龙材质", "unft")
	Dtools_una = newCheckbox(Dtools_unu, 0, -13, 1.12, L.una1 or "头像渐隐", L.una2 or "脱战无目标渐隐头像框架", "una")
	Dtools_unfn = newCheckbox(Dtools_una, 0, 2, 1.12, L.unfn1 or "隐藏名字", L.unfn2 or "隐藏玩家头像角色名字", "unfn")
	Dtools_pnc = newCheckbox(Dtools_unfn, 0, 2, 1.12, L.pnc1 or "玩家角色改名", L.pnc2 or "|cff00FF00/改名/CN/cname|r更改本地玩家角色名字", "pnc")
	Dtools_unc = newCheckbox(Dtools_pnc, 0, 2, 1.12, L.unc1 or "职业配色调整", L.unc2 or "使用一套比较鲜艳的职业配色", "unc")
	-- Dtools_otb = newCheckbox(Dtools_unc, 0, 2, 1.12, (L.otb1 or "任务追踪美化").."|cffFF8800 !|r", L.otb2 or "任务追踪文字美化(战斗中会导致界面行为失败)", "otb")
	Dtools_sfu = newCheckbox(Dtools_unc, 0, 2, 1.12, L.sfu1 or "系统字体美化", L.sfu2 or "美化游戏中大部分文字", "sfu")
	Dtools_ruu = newCheckbox(Dtools_sfu, 0, 2, 1.12, L.ruu1 or "团队框架美化", L.ruu2 or "自带团队框架美化", "ruu")
	Dtools_npu = newCheckbox(Dtools_ruu, 0, 2, 1.12, L.npu1 or "姓名板增强", L.npu2 or "简单的姓名板美化增强", "npu")
	Dtools_cbb = newCheckbox(Dtools_npu, 0, 2, 1.12, L.cbb1 or "施法条美化", L.cbb2 or "施法条简单美化", "cbb")
	Dtools_aab = newCheckbox(Dtools_cbb, 0, 2, 1.12, L.aab1 or "攻击计时器", L.aab2 or "武器自动攻击计时器", "aab")
	Dtools_ctbr = newCheckbox(Dtools_aab, 0, 2, 1.12, L.ctbr1 or "战斗计时器", L.ctbr2 or "战斗和战复计时工具", "ctbr")
	Dtools_cbi = newCheckbox(Dtools_ctbr, 0, 2, 1.12, L.cbi1 or "浮动战斗信息", L.cbi2 or "大脚经典战斗信息提示", "cbi")
		
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		Dtools_aur = newCheckbox(Dtools_glob, 220, 0, 1.12, L.aur1 or "自动修理", L.aur2 or "自动修理装备(优先使用公会修理)", "aur")
	else
		Dtools_hsf = newCheckbox(Dtools_glob, 220, 0, 1.12, L.hsf1 or "|cff00FF00Shift|r设置焦点", L.hsf2 or "按住|cffFFFF00Shift|r快速设定焦点", "hsf")
		Dtools_aur = newCheckbox(Dtools_hsf, 0, 2, 1.12, L.aur1 or "自动修理", L.aur2 or "自动修理装备(优先使用公会修理)", "aur")
	end
	Dtools_aus = newCheckbox(Dtools_aur, 0, 2, 1.12, L.aus1 or "自动售卖垃圾", L.aus2 or "自动出售灰色垃圾", "aus")
	Dtools_aua = newCheckbox(Dtools_aus, 0, 2, 1.12, L.aua1 or "自动成就截图", L.aua2 or "获得成就自动截图", "aua")
	Dtools_aug = newCheckbox(Dtools_aua, 0, 2, 1.12, L.aug1 or "密语自动组队", L.aug2 or "密语自动邀请组队(|cffFFFF00密语:1/组|r)", "aug")
	Dtools_fsl = newCheckbox(Dtools_aug, 0, 2, 1.12, L.fsl1 or "快速拾取", L.fsl2 or "拾取框架加速", "fsl")
	Dtools_ist = newCheckbox(Dtools_fsl, 0, 2, 1.12, L.ist1 or "打断提示", L.ist2 or "打断目标施法提示", "ist")
	Dtools_vap = newCheckbox(Dtools_ist, 0, 2, 1.12, L.vap1 or "语音播报", L.vap2 or "标记增益语音提示", "vap")
	Dtools_bfm = newCheckbox(Dtools_vap, 0, 2, 1.12, L.bfm1 or "面板移动", L.bfm2 or "自带面板框架自由移动", "bfm")
	Dtools_chr = newCheckbox(Dtools_bfm, 0, 2, 1.12, L.chr1 or "聊天历史", L.chr2 or "恢复上次游戏的聊天记录", "chr")
	Dtools_cfp = newCheckbox(Dtools_chr, 0, 2, 1.12, L.cfp1 or "聊天增强", L.cfp2 or "聊美化和增强", "cfp")
		Dtools_cfbb = newCheckbox(Dtools_cfp, 16, 7, 0.944, L.cfbb1 or "底部按钮", L.cfbb2 or "聊天条按钮移动到框架底部", "cfbb")
	Dtools_ifs = newCheckbox(Dtools_cfp, 0, -13, 1.12, L.ifs1 or "属性数据信息", L.ifs2 or "绿字属性拾取移速帧数延迟显示", "ifs")
		Dtools_ifss = newCheckbox(Dtools_ifs, 16, 7, 0.944, L.ifss1 or "字体增大", L.ifss2 or "数据信息字体增大", "ifss")
	Dtools_tiu = newCheckbox(Dtools_ifs, 0, -13, 1.12, L.tiu1 or "鼠标提示增强", L.tiu2 or "鼠标提示美化和增强", "tiu")
		Dtools_tiub = newCheckbox(Dtools_tiu, 16, 7, 0.916, L.tiub1 or "放大提示框", L.tiub2 or "鼠标提示框体放大", "tiub")

	if diablomodel then
		Dtools_oufd = newCheckbox(Dtools_glob, 300, 2, 1.6, L.oufd1 or "暗黑血球", (L.oufd2 or "基于oUF的经典暗黑血球框架").."\n"..(L.diablotip or "|cffffff00插件列表可完全关闭血球|r"), "oufd")
		if DToolsDB.oufd == nil or DToolsDB.oufd == true then
			-- if not DiabloUIConfigPanel then
			-- 	Dtools_dadf = newCheckbox(Dtools_oufd, 20, 6, 1, L.dadf1 or "装饰材质", L.dadf2 or "恶魔和天使装饰材质", "dadf")
			-- 	Dtools_oufc = newCheckbox(Dtools_dadf, 0, 6, 1, L.oufc1 or "职业染色", L.oufc2 or "血球职业染色", "oufc")
			-- 	Dtools_dhpg = newCheckbox(Dtools_dadf, 0, 6, 1, L.dhpg1 or "血球边框", L.dhpg2 or "血球周围的边框", "dhpg")
			-- 	Dtools_dpet = newCheckbox(Dtools_dhpg, 0, 6, 1, L.dpet1 or "宠物框体", L.dpet2 or "生命球上方宠物框架", "dpet")

			-- end
			-- if ns.panel then
				local orbconfig = CreateFrame("Button", "DP", DToolsGUI, "UIPanelButtonTemplate")
				orbconfig:SetText(L.bloodcc or"设置")
				orbconfig:SetWidth(100)
				orbconfig:SetHeight(36)
				orbconfig:SetPoint("TOPLEFT", Dtools_oufd, "BOTTOMLEFT", 18, 0)
				orbconfig:SetScript("OnClick", function()
					if DcSlashCmd then DcSlashCmd() end
				end)
				Dtools_dadf = newCheckbox(orbconfig, 0, -4, 1, L.dadf1 or "装饰材质", L.dadf2 or "恶魔和天使装饰材质", "dadf")

				-- Dtools_oufc = newCheckbox(Dtools_dadf, 0, 6, 1, L.oufc1 or "职业染色", L.oufc2 or "血球职业染色", "oufc")
				-- Dtools_dhpg = newCheckbox(Dtools_oufc, 0, 6, 1, L.dhpg1 or "血球边框", L.dhpg2 or "血球周围的边框", "dhpg")
				-- Dtools_dpet = newCheckbox(Dtools_dhpg, 0, 6, 1, L.dpet1 or "宠物框体", L.dpet2 or "生命球上方宠物框架", "dpet")
				Dtools_dpet = newCheckbox(Dtools_dadf, 0, 6, 1, L.dpet1 or "宠物框体", L.dpet2 or "生命球上方宠物框架", "dpet")
			-- end
			
			Dtools_dduf = newCheckbox(Dtools_dpet, 0, 6, 1, L.dduf1 or "默认框架", L.dduf2 or "启用被oUF隐藏的默认头像", "dduf")
			Dtools_uisl = newCheckbox(Dtools_dduf, 0, 6, 1, L.uisl1 or "UI缩放锁定", L.uisl2 or "打开并锁定UI缩放(调整UI缩放后需要重置位置)", "uisl")
			Dtools_daml = newCheckbox(Dtools_uisl, 0, 6, 1, (L.daml1 or "动作条微调").."|cffFF8800 !|r", L.daml2 or "自定义并锁定一部分动作条(战斗中编辑模式会报错)", "daml")
			if DToolsDB.daml == true then
				local info = {}
				local AcmDropdown = CreateFrame("Frame", "Acm", DToolsGUI, "UIDropDownMenuTemplate")
				AcmDropdown:SetPoint("TOPLEFT", Dtools_daml, "BOTTOMLEFT", -14, 2)
				AcmDropdown:SetScale(0.944)
				AcmDropdown.initialize = function()
					wipe(info)
					local fonts = { 0, 3}
					local names = { L.acm0 or "常规布局", L.acm3 or "三行布局" }
					for i, font in next, fonts do
						info.text = names[i]
						info.value = font
						info.func = function(self)
							DToolsDB.acm = self.value
							AcmText:SetText(self:GetText())
							DToolActionBar_Layout()
						end
						info.checked = font == DToolsDB.acm
						UIDropDownMenu_AddButton(info)
					end

				end
				local acmtextt
				if DToolsDB.acm == 0 then acmtextt = L.acm0 or "常规布局"
				elseif DToolsDB.acm == 3 then acmtextt = L.acm3 or "三行布局"
				else acmtextt = L.acm0 or "常规布局"
				end
				UIDropDownMenu_SetWidth(AcmDropdown, 85)
				UIDropDownMenu_SetText(AcmDropdown, acmtextt)
			end
		end
	end


	local Bartextures = newFont(16, -520, 1, DToolsGUI, "TOPLEFT", DToolsGUI, "TOPLEFT", (L.bart or "状态条材质")..":", 18)

	local hptexture1 = "Interface\\AddOns\\"..AddonName.."\\media\\Raid-Bar-Hp-Fill"
	local hptexture2 = "Interface\\AddOns\\"..AddonName.."\\media\\Raid-Bar-Hp-ad"
	local hptexture3 = "Interface\\AddOns\\"..AddonName.."\\media\\statusbar5"
	local hptexture4 = "UI-HUD-UnitFrame-Player-PortraitOff-Bar-Health-Status"
	
	local info = {}
	local BarTDropdown = CreateFrame("Frame", "Bartexture", DToolsGUI, "UIDropDownMenuTemplate")
	BarTDropdown:SetPoint("LEFT", Bartextures, "RIGHT", -16, -2)
	BarTDropdown:SetScale(1.1)
	BarTDropdown.initialize = function()
		wipe(info)
		local values = { 1, 2, 3 }
		local names = { 
		"|T"..hptexture1..":12:40|t", 
		"|T"..hptexture2 ..":12:40|t", 
		"|T"..hptexture3..":12:40|t",
		L.Default or "默认"
		}
		for i, value in next, values do
			info.text = names[i]
			info.value = value
			info.func = function(self)
				DToolsDB.bart = self.value
				BartextureText:SetText(self:GetText())
				BartextureText:SetPoint("RIGHT", BarTDropdown, -43, 2)
			end
			info.checked = value == DToolsDB.bart
			UIDropDownMenu_AddButton(info)
		end

	end
	local tiptextt
	if DToolsDB.bart == 1 then tiptextt = "|T"..hptexture1..":12:40:0:-1|t"
	elseif DToolsDB.bart == 2 then tiptextt = "|T"..hptexture2 ..":12:40:0:-1|t"
	elseif DToolsDB.bart == 3 then tiptextt = "|T"..hptexture3..":12:40:0:-1|t"
	elseif DToolsDB.bart == 0 then tiptextt = L.Default or "默认"
	end
	UIDropDownMenu_SetWidth(BarTDropdown, 80)
	UIDropDownMenu_SetText(BarTDropdown, tiptextt)


	local Tipcursors = newFont(16, -555, 1, DToolsGUI, "TOPLEFT", DToolsGUI, "TOPLEFT", (L.tipc or "鼠标提示")..":", 18)
	local info = {}
	local TipDropdown = CreateFrame("Frame", "Tipcursor", DToolsGUI, "UIDropDownMenuTemplate")
	TipDropdown:SetPoint("LEFT", Tipcursors, "RIGHT", -16, -2)
	TipDropdown:SetScale(1.1)
	TipDropdown.initialize = function()
		wipe(info)
		local values = { 1, 0, 2 }
		local names = { L.tipc1 or "跟随", L.tipc2 or "不跟随", L.tipc3 or "非战斗跟随" }
		for i, value in next, values do
			info.text = names[i]
			info.value = value
			info.func = function(self)
				DToolsDB.ftipa = self.value
				TipcursorText:SetText(self:GetText())
			end
			info.checked = value == DToolsDB.ftipa
			UIDropDownMenu_AddButton(info)
		end

	end
	local tiptextt
	if DToolsDB.ftipa == 1 then tiptextt = L.tipc1 or "跟随"
	elseif DToolsDB.ftipa == 0 then tiptextt = L.tipc2 or "不跟随"
	elseif DToolsDB.ftipa == 2 then tiptextt = L.tipc3 or "非战斗跟随"
	end
	UIDropDownMenu_SetWidth(TipDropdown, 95)
	UIDropDownMenu_SetText(TipDropdown, tiptextt)

	--鼠标提示位置 ----高CPU占用
	hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
		if (not tooltip or not parent) then return end
		if DToolsDB.ftipa ~= nil and DToolsDB.ftipa == 1 then
			tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", 20, 0, true)
		elseif DToolsDB.ftipa ~= nil and DToolsDB.ftipa == 2 then
			if InCombatLockdown() then return end
			tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", 20, 0, true)
		end
	end)

	local function newSlider(SliderName, x, y, minValue, maxValue, curValue, valueStep, lowText, highText, upText, tipText, varformat)
	local pSlider = CreateFrame("Slider", "Slider"..SliderName, DToolsGUI, "OptionsSliderTemplate");
	pSlider:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", x, y);
	pSlider:SetMinMaxValues(minValue, maxValue);
	pSlider:SetValue(curValue);
	pSlider:SetValueStep(valueStep);
	pSlider:SetObeyStepOnDrag(true);
	pSlider:SetScale(1.05)
	pSlider.textLow = _G["Slider"..SliderName.."Low"]
	pSlider.textHigh = _G["Slider"..SliderName.."High"]
	pSlider.text = _G["Slider"..SliderName.."Text"]
	pSlider.textLow:SetText(lowText)
	pSlider.textHigh:SetText(highText)
	pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format(varformat, pSlider:GetValue()).."|r")

	pSlider:SetScript("OnValueChanged", function(pSlider, event, arg1)
			pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format(varformat, pSlider:GetValue()).."|r")
	end)
	pSlider.tooltipText = tipText
	--body
	return pSlider
	end

	DToolsGUI.Spell = newSlider("Spell", 240, -535, 0, 400, 400, 1, "", "", L.sqw1 or "施法序列延迟", L.sqw2 or "施法序列延迟", "%d")
	DToolsGUI.Spell:SetValue(DToolsDB.spellq)
	DToolsGUI.Spell:HookScript("OnValueChanged", function(self, value)
		DToolsDB.spellq = tonumber(string.format("%d", self:GetValue()))
		SetCVar("spellqueueWindow", DToolsDB.spellq)
	end)

	local respos = CreateFrame("Button", "DToolsrp", DToolsGUI, "UIPanelButtonTemplate")
	respos:SetText("|cffff8800"..(L.respos or "重置位置").."|r")
	respos:SetWidth(150)
	respos:SetHeight(30)
	respos:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 488, -398)
	respos:SetScript("OnClick", function()
		DToolsReset()
		if diablomodel then DiabloReset() end
	end)

	local resdef = CreateFrame("Button", "DToolsSaveButton", DToolsGUI, "UIPanelButtonTemplate")
	resdef:SetText(L.resdef or "恢复默认设置")
	resdef:SetWidth(150)
	resdef:SetHeight(30)
	resdef:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 488, -432)
	resdef:SetScript("OnClick", function()

		resetdefault()
		--ReloadUI()
	end)

	local slb = CreateFrame("Button", "Proposal", DToolsGUI, "UIPanelButtonTemplate")
	slb:SetText(L.slb or "意见和建议")
	slb:SetWidth(150)
	slb:SetHeight(30)
	slb:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 488, -466)
	slb:SetScript("OnClick", function()
		StaticPopup_Show("DTools_EDITBOX", "CurseForg", nil, "https://www.curseforge.com/wow/addons/diablo/comments")
	end)


	local adrl = CreateFrame("Button", "DToolsrl", DToolsGUI, "UIPanelButtonTemplate")
	adrl:SetText(L.adrl or "重载插件")
	adrl:SetWidth(150)
	adrl:SetHeight(40)
	adrl:SetPoint("TOPLEFT", DToolsGUI, "TOPLEFT", 488, -510)
	adrl:SetScript("OnClick", function()
			ReloadUI()
	end)

	local brtx = DToolsGUI:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	brtx:SetPoint("TOP", adrl, "BOTTOM", 0, -10)
	brtx:SetText((L.brtx or "版本")..":|cff00FFFF"..AddVersion.."|r")
	brtx:SetJustifyH("CENTER")
	brtx:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')

	local feedback = DToolsGUI:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	feedback:SetPoint("BOTTOM", respos, "TOP", 0, 5)
	feedback:SetText(L.feedback or "|cffEEFF7FQQ群:|r974344392")
	feedback:SetJustifyH("CENTER")
	feedback:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')


	if diablomodel then
		if DToolsDB.oufd ~= nil and DToolsDB.oufd == false then
			-- DiabloDemonFrame:Hide()
			-- DiabloAngelFrame:Hide()
			-- DiabloHealthOrb:Hide()
			-- DiabloPowerOrb:Hide()
			-- unit.player.Combat:Hide()
			-- unit.player.Resting:Hide()
			-- unit.player.PvP:Hide()
			DiabloPlayerFrame:SetScale(0.001)
			-- DiabloExpBar:SetScale(0.001)
			-- DiabloRepBar:SetScale(0.001)
			-- ExpBar:SetScale(0.001)
			-- RepBar:SetScale(0.001)
		else
			-- MainMenuBar.EndCaps:SetAlpha(0)
			-- MainMenuBar.BorderArt:SetAlpha(0)
			-- MainMenuBar.ActionBarPageNumber:SetAlpha(0)
			-- MainMenuBar.UpdateDividers = nil
			-- MainMenuBar.HorizontalDividersPool:ReleaseAll()
			-- MainMenuBar.VerticalDividersPool:ReleaseAll()

			if DToolsDB.dduf ~= nil and DToolsDB.dduf == false then
				PlayerFrame:SetAlpha(0)
				PlayerFrame:SetScale(0.001)
				PlayerFrame:UnregisterAllEvents()
				-- PlayerFrame:Hide()
			-- else
			-- 	PlayerFrame.classPowerBar:SetScale(1.25)
			-- 	PlayerFrame.classPowerBar:ClearAllPoints()
			-- 	PlayerFrame.classPowerBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 160)
			end

			if DToolsDB.dadf ~= nil and DToolsDB.dadf == false then
				DiabloDemonFrame:SetScale(0.001)
				DiabloAngelFrame:SetScale(0.001)
			end
			if not DiabloUIConfigPanel then
				if DToolsDB.dhpg == false then
					DiabloHealthOrb.grid:SetAlpha(0)
					DiabloPowerOrb.grid:SetAlpha(0)
					DiabloHealthOrb.background:SetAlpha(0.1)
					DiabloPowerOrb.background:SetAlpha(0.1)
					DiabloHealthOrb.highlight:SetAlpha(0.8)
					DiabloPowerOrb.highlight:SetAlpha(0.8)
					DiabloHealthOrb.orbshadow:SetAlpha(0.3)
					DiabloPowerOrb.orbshadow:SetAlpha(0.3)
					-- Threatorb.threat:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow")
					-- Threatorb:SetFrameLevel(1)
				else
					DiabloHealthOrb.grid:SetAlpha(1)
					DiabloPowerOrb.grid:SetAlpha(1)
					DiabloHealthOrb.background:SetAlpha(0.1)
					DiabloPowerOrb.background:SetAlpha(0.1)
					DiabloHealthOrb.highlight:SetAlpha(0.6)
					DiabloPowerOrb.highlight:SetAlpha(0.6)
					DiabloHealthOrb.orbshadow:SetAlpha(0.3)
					DiabloPowerOrb.orbshadow:SetAlpha(0.3)
					-- Threatorb.threat:SetTexture("Interface\\AddOns\\"..AddonName.."\\media\\orb_debuff_glow")
					-- Threatorb:SetFrameLevel(1)
				end
				--职业染色
				if DToolsDB.oufc == false then
					DiabloHealthOrb.filling.colorClass = false
				end
			end
		end

		if DToolsDB.oufd == false or DToolsDB.dpet == false then
			PetHealthbar:Hide()
			DiabloPetFrame:SetScale(0.001)
		else
			PetHealthbar:Show()
		end

		if DToolsDB.oufd == false or DToolsDB.dpet == false then
			PetTargetHealthbar:Hide()
			DiabloPetTargetFrame:SetScale(0.001)
		else
			PetTargetHealthbar:Show()
		end
	end

end)