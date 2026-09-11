local _
local _, ns =...
local L = ns.L
local function uiconfig()
		if InCombatLockdown() then
			print("|cffff0000"..(L.comlc or "战斗中禁用设置!").."|r")
		return end
	--恢复默认
	--InterfaceOptionsFrame_SetAllToDefaults() --慎用!

	--杂项
	--C_CVar.SetCVar("useUiScale", 1)
	--C_CVar.SetCVar("uiScale", 0.65)
	-- 背包显示剩余格子数量(同步正式服设置)

	C_CVar.SetCVar("scriptErrors", 0)	--显示lua错误
	C_CVar.SetCVar("UseSlug", 1) --新字体渲染

   hooksecurefunc("MainMenuBarBackpackButton_UpdateFreeSlots", function(...)
	MainMenuBarBackpackButtonCount:SetText(string.format("(%s)", MainMenuBarBackpackButton.freeSlots));
   end)
   	C_CVar.SetCVar("equipmentManager", 1) --自带一键换装
	-- SetInsertItemsLeftToRight(false) --新拾取物品方向放入背包
	C_CVar.SetCVar("cameraDistanceMaxZoomFactor", 4) --设置最远视角距离
	C_CVar.SetCVar("movieSubtitle", 1) --动画字幕
	C_CVar.SetCVar("UberTooltips", 1) --显示技能说明
	--C_CVar.SetCVar("mapFade", 1) --移动时地图透明
	C_CVar.SetCVar("Sound_EnableErrorSpeech", 0) --错误提示音
	C_CVar.SetCVar("worldPreloadNonCritical", 0) --加快蓝条，读完蓝条再载入游戏模组
	C_CVar.SetCVar("displayFreeBagSlots", 1) --背包剩余空间 1:开启 0:关闭
	C_CVar.SetCVar("overrideArchive", 0) --和谐国服 1:开启 0:关闭
	C_CVar.SetCVar("autoQuestWatch", 1) --自动追踪任务
	C_CVar.SetCVar("autoQuestProgress", 1) --换地图自动切换追踪任务
	C_CVar.SetCVar("screenshotQuality", 10) --截图品质(10最高)
	--C_CVar.SetCVar("scriptErrors", 1) --显示lua错误
	-- local e = tonumber(GetCVar("scriptErrors"))
	-- if C_AddOns.IsAddOnLoaded("!!!_BaudErrorFrameX") == true or C_AddOns.IsAddOnLoaded("BugSack") == true then
	-- if e == 1 then
	-- 	print("|cff00ff00"..(L.decpt or "检测到错误收集插件关闭默认LUA错误显示!").."|r")
	-- end
	-- C_CVar.SetCVar("scriptErrors", 0)
	-- else
	-- if e == 0 then
	-- 	print("|cff00ff00"..(L.nedtc or "没有检测到错误收集插件打开默认LUA错误显示!").."|r")
	-- end
	-- C_CVar.SetCVar("scriptErrors", 1) --显示lua错误
	-- end
	C_CVar.SetCVar("taintLog", 1) --错误收集-Logs\Taint.log文件内搜索关键词"Blocked"
	C_CVar.SetCVar("ffxGlow", 0) --关闭全屏幕泛光:
	C_CVar.SetCVar("xpBarText", 1) --经验条数值显示 1:开启 0:关闭
	C_CVar.SetCVar("screenshotFormat", "jpg") --截图格式，tga或jpg
	C_CVar.SetCVar("breakUpLargeNumbers", 0) --数字逗号显示 1:开启 0:关闭
	C_CVar.SetCVar("showFocusFrameSpellBar", 1) --显示焦点施法条

	--控制
	C_CVar.SetCVar("deselectOnClick",0) --目标锁定
	C_CVar.SetCVar("cameraSmoothTrackingStyle", 0) --引导技能转动视角
	C_CVar.SetCVar("autoClearAFK",1) --自动解除离开状态
	C_CVar.SetCVar("autoLootDefault",1) --自动拾取
	C_CVar.SetCVar("interactOnLeftClick",1) --左键点击操作
	C_CVar.SetCVar("lootUnderMouse",1) --鼠标位置打开拾取框
	--战斗
	C_CVar.SetCVar("findYourselfMode", 1) --高亮显示玩家角色(-1, 0=圆圈, 1=圆圈+轮廓线)
	C_CVar.SetCVar("findYourselfAnywhere", 1) --总是高亮显示角色
	C_CVar.SetCVar("findYourselfAnywhereOnlyInCombat", 1) --战斗中高亮显示角色
	C_CVar.SetCVar("SpellQueueWindow", 250) --施法序列延迟
	C_CVar.SetCVar("ActionButtonUseKeyDown", 1) --按下按键释放技能
	C_CVar.SetCVar("showTargetOfTarget",1) --目标的目标
	C_CVar.SetCVar("doNotFlashLowHealthWarning",0) --生命值过低时不闪烁屏幕
	C_CVar.SetCVar("autoSelfCast",1) --自动自我施法
	C_CVar.SetCVar("WorldTextScale", 1.25) -- 战斗字体大小缩放
	C_CVar.SetCVar("floatingCombatTextCombatDamage", 1) --伤害系统数字显示 1:开启 0:关闭
	C_CVar.SetCVar("floatingCombatTextSpellMechanics", 1) --显示目标受到的控制效果，(例如 诱捕(xxxx-xxxx)，沉默减速之类)
	C_CVar.SetCVar("floatingCombatTextSpellMechanicsOther", 1) --显示其他玩家受到的控制效果
	C_CVar.SetCVar("threatShowNumeric", 1) --头像百分比仇恨
	C_CVar.SetCVar("nameplateMaxDistance", 41) --姓名版距离

	--C_CVar.SetCVar("showTargetcastbar", 1) --目标施法条
	--[[--目标施法条自动设置
	local c = tonumber(GetCVar("showTargetcastbar"))
	if C_AddOns.IsAddOnLoaded("Quartz") then
	C_CVar.SetCVar("showTargetcastbar", 0)
	if c == 1 then
	print("|cffff0000Quartz已启用!重载界面关闭目标默认施法条!|r")
	end
	else
	C_CVar.SetCVar("showTargetcastbar", 1)
	if c == 0 then
	print("|cffff0000没有检测到Quartz重载界面开启目标默认施法条!|r")
	end
	end
	--]]
	--C_CVar.SetCVar("enableFloatingCombatText", 0) --滚动战斗记录
	--[[--滚动战斗记录自动设置
	local f = tonumber(GetCVar("enableFloatingCombatText"))
	if C_AddOns.IsAddOnLoaded("Parrot") == true then
	C_CVar.SetCVar("enableFloatingCombatText", 0)
	if f == 1 then
	print("|cffff0000Parrot已启用!重载界面关闭默认战斗信息!|r")
	end
	--elseif C_AddOns.IsAddOnLoaded("MikScrollingBattleText") == true then
	--C_CVar.SetCVar("enableFloatingCombatText", 0)
	--if f == 1 then
	--print("|cffff0000MikScrollingBattleText已启用!重载界面关闭默认战斗信息!|r")
	--end
	else
	C_CVar.SetCVar("enableFloatingCombatText", 1)
	if f == 0 then
	print("|cffff0000没有战斗信息重载界面打开默认战斗信息!|r")
	end
	end
	--]]
	C_CVar.SetCVar("floatingCombatTextFloatMode", 3) --滚动方向 1,2,3
	C_CVar.SetCVar("floatingCombatTextAuras", 0) --光环
	C_CVar.SetCVar("floatingCombatTextComboPoints", 0) --連擊點
	C_CVar.SetCVar("floatingCombatTextEnergyGains", 0) --資源獲得(法力、怒氣、能量、真氣，和連擊點不同)
	C_CVar.SetCVar("floatingCombatTextPeriodicEnergyGains", 0) --周期性能量
	C_CVar.SetCVar("floatingCombatTextHonorGains", 0) --榮譽擊殺
	C_CVar.SetCVar("floatingCombatTextRepChanges", 0) --聲望變化
	C_CVar.SetCVar("floatingCombatTextPetMeleeDamage", 1) --普攻
	C_CVar.SetCVar("floatingCombatTextPetSpellDamage", 1) --技能
	C_CVar.SetCVar("floatingCombatTextCombatDamageAllAutos", 1) --顯示所有的白字
	C_CVar.SetCVar("floatingCombatTextDodgeParryMiss", 1) --閃招
	C_CVar.SetCVar("floatingCombatTextDamageReduction", 1) --傷害減免/抵抗
	C_CVar.SetCVar("floatingCombatTextCombatLogPeriodicSpells", 1) --周期性傷害
	C_CVar.SetCVar("floatingCombatTextReactives", 1) --法術警示
	C_CVar.SetCVar("floatingCombatTextCombatState", 1) --進入/離開戰鬥文字提示
	C_CVar.SetCVar("floatingCombatTextLowManaHealth", 1) --低MP/低HP文字提示
	C_CVar.SetCVar("floatingCombatTextFriendlyHealers", 0) --友方治療者名稱
	C_CVar.SetCVar("floatingCombatTextCombatDamageDirectionalScale", 2) --伤害数字显示在血条上方,改数字0123456789

	--显示
	C_CVar.SetCVar("statusText",1) --状态文字 0：只在鼠标移到上方时显示状态数字 1：永远显示
	C_CVar.SetCVar("statusTextDisplay","BOTH")--头像状态文字形式："NUMERIC"数值"PERCENT"百分比"BOTH"同时显示
	C_CVar.SetCVar("noBuffDebuffFilterOnTarget", 1)--显示目标所有DEBUFF 1:开启 0:关闭
	C_CVar.SetCVar("weatherDensity", 3)--天气效果 1-3表示效果，0是关闭
	C_CVar.SetCVar("alwaysCompareItems", 1) --自动显示装备对比 1:开启 0:关闭
	--教程
	C_CVar.SetCVar("showTutorials",0)
	--社交
	C_CVar.SetCVar("profanityFilter",0) --语言过滤器
	C_CVar.SetCVar("spamFilter",0) --垃圾信息过滤
	C_CVar.SetCVar("guildMemberNotify",0) --公会成员提示
	C_CVar.SetCVar("showToastBroadcast",1) --通告更新
	C_CVar.SetCVar("showToastWindow",1) --显示浮窗
	C_CVar.SetCVar("chatStyle","classic") --输入框风格 classic/im
	C_CVar.SetCVar("showTimestamps","none") --聊天时间戳 [%H:%M:%S]
	--动作条
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_3", true)
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_4", true)
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_5", true)
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_6", true)
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_7", true)
	Settings.SetValue("PROXY_SHOW_ACTIONBAR_8", true)

	C_CVar.SetCVar("lockActionBars",1)--锁定动作条
	C_CVar.SetCVar("alwaysShowActionBars",0)--始终显示动作条
	C_CVar.SetCVar("countdownForCooldowns",1) --显示冷却时间
	--名字
	C_CVar.SetCVar("UnitNameOwn",0) --我的名字
	C_CVar.SetCVar("UnitNameFriendlySpecialNPCName", 1);
	C_CVar.SetCVar("UnitNameHostleNPC", 1);
	C_CVar.SetCVar("UnitNameInteractiveNPC", 1);
	C_CVar.SetCVar("UnitNameNPC", 0);
	C_CVar.SetCVar("ShowQuestUnitCircles", 1);
	C_CVar.SetCVar("UnitNameNonCombatCreatureName",0) --小动物小伙伴
	C_CVar.SetCVar("UnitNameFriendlyPlayerName",0) --友方玩家
	C_CVar.SetCVar("UnitNameFriendlyMinionName",0) --友方玩家仆从
	C_CVar.SetCVar("UnitNameEnemyPlayerName",1) --敌对玩家
	C_CVar.SetCVar("UnitNameEnemyMinionName",1) --敌对玩家仆从
	--姓名板
	C_CVar.SetCVar("nameplateShowFriends",0) --友方玩家血条
	C_CVar.SetCVar("nameplateShowFriendlyMinions",0) --友方玩家仆从血条
	C_CVar.SetCVar("nameplateShowEnemies",1) --敌对玩家血条
	C_CVar.SetCVar("nameplateShowEnemyMinions",1) --敌对玩家仆从血条
	C_CVar.SetCVar("nameplateShowEnemyMinus",1) --敌对玩家杂兵血条
	C_CVar.SetCVar("nameplateShowAll",1) --总是显示姓名板
	C_CVar.SetCVar("nameplateMotion", 0) --姓名板1堆叠 0重叠
	C_CVar.SetCVar("nameplateMotionSpeed", 0.035)
	C_CVar.SetCVar("nameplateOverlapH", 0.5)--横向分散--default is 0.8
	C_CVar.SetCVar("nameplateOverlapV", 0.6)--纵向分散--default is 1.1
	C_CVar.SetCVar("nameplatePersonalShowAlways", 1) --总是显示角色姓名板
	C_CVar.SetCVar("nameplatePersonalShowInCombat", 1)
	C_CVar.SetCVar("nameplatePersonalShowWithTarget", 0)
	C_CVar.SetCVar("nameplatePersonalHideDelaySeconds", 1) --姓名板渐隐时间
	C_CVar.SetCVar("nameplateMaxDistance", 41) --姓名板显示距离
	C_CVar.SetCVar("showVKeyCastbar", 1) --姓名板施法条
	C_CVar.SetCVar("showVKeyCastbarSpellName", 1) --姓名板施法条图标
	C_CVar.SetCVar("ShowClassColorInFriendlyNameplate", 1)--友方姓名板职业颜色 1:开启 0:关闭
	C_CVar.SetCVar("ShowClassColorInNameplate", 1) --敌方姓名板职业颜色
	-- C_NamePlate.SetNamePlateFriendlyClickThrough(false) --禁用点击
	-- C_NamePlate.SetNamePlateEnemyClickThrough(false) --禁用点击
	-- C_NamePlate.SetNamePlateSelfClickThrough(false) --禁用点击
	--姓名板大小
	C_CVar.SetCVar("nameplateSelfScale", 1.25) --角色姓名板缩放
	C_CVar.SetCVar("namePlateMinScale", 0.8) --非当前目标缩放 0.8
	C_CVar.SetCVar("namePlateMaxScale", 1) --选中目标缩放 1.0
	C_CVar.SetCVar("nameplateLargerScale", 1.2) --首领缩放 1.2
	C_CVar.SetCVar("NamePlateHorizontalScale", 1) --长度缩放 1
	C_CVar.SetCVar("NamePlateVerticalScale", 1) --高度缩放 1
	C_CVar.SetCVar("nameplateOtherAtBase", 0) --血条位置，预设0头上，1头上但离怪近，2脚下，
	C_CVar.SetCVar("nameplateMinAlpha", 0.8) --非当前目标透明度 --default is 0.8
	C_CVar.SetCVar("nameplateOccludedAlphaMult", 0.4) --障碍物后透明度 --default is 0.4 
	C_CVar.SetCVar("nameplateSimplifiedScale", 0.5)--简化姓名板缩放
	C_CVar.SetCVar("nameplateSize", 3)
	C_CVar.SetCVar("nameplateStyle", 5)
	C_CVar.SetCVar("nameplateAuraScale", 0.7)

	C_CVar.SetCVar("showSpenderFeedback", 1)	--能量资源浪费闪烁

	--镜头
	C_CVar.SetCVar("cameraSmoothStyle",0) --镜头跟随模式
	
	-- --团队界面配置
	-- if C_AddOns.IsAddOnLoaded("CRaidFrame") == true then
	-- C_AddOns.DisableAddOn("Blizzard_CUFProfiles")
	-- C_AddOns.DisableAddOn("Blizzard_CompactRaidFrames")
	-- else
	-- C_AddOns.EnableAddOn("Blizzard_CUFProfiles")
	-- C_AddOns.EnableAddOn("Blizzard_CompactRaidFrames")
	-- end

   end



   local function uicfg()

	   local t = tonumber(GetCVar("showTargetcastbar"))
	   local f = tonumber(GetCVar("enableFloatingCombatText"))
	   local ttc,tfc
	   if t == 1 then ttc ="|cff00ff00"..(L.on or "开").."|r" else ttc ="|cffff0000"..(L.off or "关").."|r" end
	   if f == 1 then tfc ="|cff00ff00"..(L.on or "开").."|r" else tfc ="|cffff0000"..(L.off or "关").."|r" end

	   print("|cffffff00>|r |cff00ff00\/tc|r "..(L.tgcb or "目标施法").."("..ttc..")")
	   print("|cffffff00>|r |cff00ff00\/fc|r "..(L.comif or "战斗信息").."("..tfc..")")

	   print("|cffffff00"..(L.tips or "提示").."!! |r|cff00ff00"..(L.itine or "如报错请重载界面").."!|r")
	   StaticPopup_Show("ui_cfg")
	   end

   StaticPopupDialogs["Reload_UI"] = {
	text = L.reload or "重置界面?",
	button1 = L.confirm or "确认",
	button2 = L.cancel or "取消",
	   OnAccept = function()
		   ReloadUI()
	   end,
	   timeout = 0,
	   whileDead = true,
	   hideOnEscape = true,
	   preferredIndex = 3
	   }

   StaticPopupDialogs["ui_cfg"] = {
		text = (L.uhset or "应用习惯设置").."|cffff0000["..(L.care or "慎用!").."]|r",
		button1 = L.confirm or "确认",
		button2 = L.cancel or "取消",
	   	OnAccept = function()
		   uiconfig()
		   StaticPopup_Show("Reload_UI")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}



   --界面自动化命令
   SlashCmdList["UICONFIG"] = function() uicfg() end
   print("|cffff0000>|r |cff00ff00\/Uicfg|r "..(L.uhset or "应用习惯设置").."!")
   SLASH_UICONFIG1 = "/uicfg"

   --目标施法条 战斗信息
   ----
   --[[ local t = tonumber(GetCVar("showTargetcastbar"))
   local f = tonumber(GetCVar("enableFloatingCombatText"))

   local function tcast()
	if t == 0 then
	C_CVar.SetCVar("showTargetcastbar", 1)
	print("|cff00ff00重载界面打开目标施法条!|r")
	elseif t == 1 then
	C_CVar.SetCVar("showTargetcastbar", 0)
	print("|cffff0000重载界面关闭目标施法条!|r")
	end
	StaticPopup_Show("Reload_UI")
   end
   local function fcomb()
	if f == 0 then
	C_CVar.SetCVar("enableFloatingCombatText", 1)
	print("|cff00ff00重载界面打开自带战斗信息!|r")
	elseif f == 1 then
	C_CVar.SetCVar("enableFloatingCombatText", 0)
	print("|cffff0000重载界面关闭自带战斗信息!|r")
	end
	StaticPopup_Show("Reload_UI")
   end ]]
   local function tcast()
   StaticPopup_Show("t_cast")
   end
   StaticPopupDialogs["t_cast"] = {
	text = L.targc or "目标施法条",
	button1 = L.on or "打开",
	button2 = L.off or "关闭",
	button3 = L.cancel or "放弃",
	   OnAccept = function()
		   C_CVar.SetCVar("showTargetcastbar", 1)
		   ReloadUI()
	   end,
	   OnCancel = function()
		   C_CVar.SetCVar("showTargetcastbar", 0)
		   ReloadUI()
	   end,
	   timeout = 0,
	   whileDead = true,
	   hideOnEscape = false,
	   preferredIndex = 3
	   }

   local function fcomb()
   StaticPopup_Show("f_comb")
   end
   StaticPopupDialogs["f_comb"] = {
	text = L.targc or "自带战斗信息",
	button1 = L.on or "打开",
	button2 = L.off or "关闭",
	button3 = L.cancel or "放弃",
	   OnAccept = function()
		   C_CVar.SetCVar("enableFloatingCombatText", 1)
		   ReloadUI()
	   end,
	   OnCancel = function()
		   C_CVar.SetCVar("enableFloatingCombatText", 0)
		   ReloadUI()
	   end,
	   timeout = 0,
	   whileDead = true,
	   hideOnEscape = false,
	   preferredIndex = 3
	   }

   SlashCmdList["TCAST"] = function() tcast() end
   SlashCmdList["FCOMB"] = function() fcomb() end
   SLASH_TCAST1 = "/tc"
   SLASH_FCOMB1 = "/fc"
	--local ttc,tfc
	--if t == 1 then ttc ="|cff00ff00开|r" else ttc ="|cffff0000关|r" end
	--if f == 1 then tfc ="|cff00ff00开|r" else tfc ="|cffff0000关|r" end
	--print("|cffff0000->|r |cff00ff00\/Tc,/Fc|r,目标施法条("..ttc.."),战斗信息("..tfc..")..开关!")
	--print("|cffff0000->|r |cff00ff00\/Tc,/Fc|r,目标施法条,战斗信息开关!")
   --]]
   --[[
   local function tcastt()

	C_CVar.SetCVar("showTargetcastbar", 1)
	print("|cff00ff00重载界面打开目标施法条!|r")
   end
   local function tcastf()
	C_CVar.SetCVar("showTargetcastbar", 0)
	print("|cffff0000重载界面关闭目标施法条!|r")
   end
   local function fcombt()
	C_CVar.SetCVar("enableFloatingCombatText", 1)
	print("|cff00ff00重载界面打开自带战斗信息!|r")
   end
   local function fcombf()
	C_CVar.SetCVar("enableFloatingCombatText", 0)
	print("|cffff0000重载界面关闭自带战斗信息!|r")
   end
   SlashCmdList["TCASTT"] = function() tcastt() end
   SlashCmdList["TCASTF"] = function() tcastf() end
   SlashCmdList["FCOMBT"] = function() fcombt() end
   SlashCmdList["FCOMBF"] = function() fcombf() end
   SLASH_TCASTT1 = "/tct"
   SLASH_TCASTF1 = "/tcf"
   SLASH_FCOMBT1 = "/fct"
   SLASH_FCOMBF1 = "/fcf"
   --print("|cffff0000->|r |cff00ff00\/Tct /Fct|r 打开-目标施法条,战斗信息!")
   --print("|cffff0000->|r |cff00ff00\/Tcf /Fcf|r 关闭-目标施法条,战斗信息!")
   --]]


   	--恢复姓名板默认设置
	local function NPDefault()

		C_CVar.SetCVar("NamePlateClassificationScale", 1)
		C_CVar.SetCVar("nameplateClassResourceTopInset", .03)
		C_CVar.SetCVar("nameplateGameObjectMaxDistance", 30)
		C_CVar.SetCVar("nameplateGlobalScale", 1)
		C_CVar.SetCVar("nameplateHideHealthAndPower", 0)
		C_CVar.SetCVar("NamePlateHorizontalScale", 1)
		C_CVar.SetCVar("NamePlateVerticalScale", 1)
		C_CVar.SetCVar("nameplateLargerBottomInset", 0.15)
		C_CVar.SetCVar("nameplateLargerScale", 1.2)
		C_CVar.SetCVar("nameplateLargerTopInset", 0.1)
		C_CVar.SetCVar("nameplateMaxAlpha", 1)
		C_CVar.SetCVar("nameplateMaxAlphaDistance", 40)
		C_CVar.SetCVar("nameplateMaxDistance", 60)
		C_CVar.SetCVar("NamePlateMaximunClassificationScale", 1)
		C_CVar.SetCVar("nameplateMinScale", 0.8)
		C_CVar.SetCVar("nameplateMaxScale", 1)
		C_CVar.SetCVar("nameplateMaxScaleDistance", 10)
		C_CVar.SetCVar("nameplateMinAlpha", 0.6)
		C_CVar.SetCVar("nameplateMinAlphaDistance", 10)
		C_CVar.SetCVar("nameplateMinScaleDistance", 10)
		C_CVar.SetCVar("nameplateMotion", 0)
		C_CVar.SetCVar("nameplateMotionSpeed", 0.02)
		C_CVar.SetCVar("nameplateOccludedAlphaMult", 0.4)
		C_CVar.SetCVar("nameplateOtherAtBase", 0)
		C_CVar.SetCVar("nameplateOtherBottomInset", 0.1)
		C_CVar.SetCVar("nameplateOtherTopInset", 0.08)
		C_CVar.SetCVar("nameplateOverlapH", 0.8)
		C_CVar.SetCVar("nameplateOverlapV", 1.1)
		C_CVar.SetCVar("NameplatePersonalClickThrough", 1)
		C_CVar.SetCVar("NameplatePersonalHideDelayAlpha", 0.45)
		C_CVar.SetCVar("NameplatePersonalHideDelaySeconds", 3)
		C_CVar.SetCVar("NameplatePersonalShowAlways", 0)
		C_CVar.SetCVar("NameplatePersonalShowInCombat", 1)
		C_CVar.SetCVar("NameplatePersonalShowWithTarget", 0)
		C_CVar.SetCVar("nameplatePlayerLargerScale", 1.8)
		C_CVar.SetCVar("nameplatePlayerMaxDistance", 60)
		C_CVar.SetCVar("nameplateResourceOnTarget", 0)
		C_CVar.SetCVar("nameplateSelectedAlpha", 1)
		C_CVar.SetCVar("nameplateSelectedScale", 1.1)
		C_CVar.SetCVar("nameplateSelfAlpha", 0.75)
		C_CVar.SetCVar("nameplateSelfBottomInset", 0.2)
		C_CVar.SetCVar("nameplateSelfScale", 1)
		C_CVar.SetCVar("nameplateSelfTopInset", 0.5)
		C_CVar.SetCVar("nameplateShowAll", 0)
		C_CVar.SetCVar("nameplateShowDebuffsOnFriendly", 1)
		C_CVar.SetCVar("nameplateShowEnemies", 1)
		C_CVar.SetCVar("nameplateShowEnemyGuardian", 0)
		C_CVar.SetCVar("nameplateShowEnemyMinions", 0)
		C_CVar.SetCVar("nameplateShowEnemyMinus", 1)
		C_CVar.SetCVar("nameplateShowEnemyPets", 0)
		C_CVar.SetCVar("nameplateShowEnemyTotems", 0)
		C_CVar.SetCVar("nameplateShowFriendlyBuffs", 0)
		C_CVar.SetCVar("nameplateShowFriendlyGuardian", 0)
		C_CVar.SetCVar("nameplateShowFriendlyMinions", 0)
		C_CVar.SetCVar("nameplateShowFriendlyNPC", 0)
		C_CVar.SetCVar("nameplateShowFriendlyPets", 0)
		C_CVar.SetCVar("nameplateShowFriendlyTotems", 0)
		C_CVar.SetCVar("nameplateShowFriends", 0)
		C_CVar.SetCVar("nameplateShowOnlyNames", 0)
		C_CVar.SetCVar("nameplateShowPersonalCooldowns", 0)
		C_CVar.SetCVar("nameplateShowSelf", 1)
		C_CVar.SetCVar("nameplateTargetBehindMaxDistance", 15)
		C_CVar.SetCVar("nameplateTargetRadialPosition", 0)
	end

   	StaticPopupDialogs["NPD_Spd"] = {
		text = L.nprd or "恢复姓名板默认设置?",
		button1 = L.confirm or "确认",
		button2 = L.cancel or "取消",
	   	OnAccept = function()
			NPDefault()
		   	-- StaticPopup_Show("Reload_UI")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	SlashCmdList["NPDMODE"] = function()
		StaticPopup_Show("NPD_Spd")
		end
	SLASH_NPDMODE1 = "/namepdef"
	SLASH_NPDMODE2 = "/npd"