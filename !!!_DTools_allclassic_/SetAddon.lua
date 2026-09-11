local _
local _, ns =...
local L = ns.L
--Skada中文单位
if (GetLocale() == "zhCN") then
	-- local Event = CreateFrame("Frame")
	-- Event:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- Event:SetScript("OnEvent", function(...)
	ns.event("PLAYER_ENTERING_WORLD", function()
		if Skada == nil then return end
		Skada.FormatNumber = function(self, number)
			if number then
				if number > 100000000 then
					return ("%02.2f亿"):format(number/100000000)
				elseif number > 100000 then
					return ("%.1f万"):format(number/10000)
				--elseif number > 10000 then
					--return ("%.2f万"):format(number/10000)
				else
					return ("%d"):format(number)
				end
			end
		end
	end)
end

--]]

--插件设置
local function seta()

--Skada设置
 if Skada ~= nil then
	Skada.db.profile.showself = true--总是显示自己
	Skada.db.profile.showtotals = true--显示总计
	Skada.db.profile.tentativecombatstart = true--杂兵战斗统计
	Skada.db.profile.reset.instance = 3--进入副本时数据重置, 1否2是3询问
	Skada.db.profile.setstokeep = 20--保留分段数量数量
	Skada.db.profile.icon.hide = false--隐藏小地图图标
	Skada.db.profile.icon.minimapPos = 193--小地图图标位置
	Skada.db.profile.modulesBlocked.Themes = true--禁用主题
	Skada.db.profile.updatefrequency = 1--刷新速度

	--第一个Skada定位
	if Skada:GetWindows()[1] ~= nil then
	Skada:GetWindows()[1].bargroup:ClearAllPoints()
	Skada:GetWindows()[1].bargroup:SetPoint("LEFT", UIParent, "LEFT", 4, 60)--位置
	Skada:GetWindows()[1].db.point = "LEFT"
	Skada:GetWindows()[1].db.y = 60
	Skada:GetWindows()[1].db.x = 4

	Skada:GetWindows()[1].db.barwidth = 270--skada框体的宽度
	Skada:GetWindows()[1].db.barslocked = true--是否锁定
	Skada:GetWindows()[1].db.barheight = 16
	Skada:GetWindows()[1].db.bartexture = "Blizzard Raid Bar"
	Skada:GetWindows()[1].db.barspacing = 1
	Skada:GetWindows()[1].db.barfontflags = "OUTLINE"
	Skada:GetWindows()[1].db.classcolorbars = false
	Skada:GetWindows()[1].db.classcolortext = true
	Skada:GetWindows()[1].db.background.color.a = 0
	Skada:GetWindows()[1].db.background.height = 137	--skada框体的高度	--136 160
	Skada:GetWindows()[1].db.background.bordertexture = "None"
	Skada:GetWindows()[1].db.background.texture = "None"
	Skada:GetWindows()[1].db.set = "current"
	Skada:GetWindows()[1].db.name = "1"

	Skada:GetWindows()[1].db.barbgcolor.a = 0.1
	Skada:GetWindows()[1].db.barbgcolor.r = 0
	Skada:GetWindows()[1].db.barbgcolor.g = 0
	Skada:GetWindows()[1].db.barbgcolor.b = 0
	Skada:GetWindows()[1].db.barcolor.a = 0.4
	Skada:GetWindows()[1].db.barcolor.r = 1
	Skada:GetWindows()[1].db.barcolor.g = 1
	Skada:GetWindows()[1].db.barcolor.b = 1
	Skada:GetWindows()[1].db.barfontsize = 13
	Skada:GetWindows()[1].db.title.color.a = 0
	Skada:GetWindows()[1].db.title.color.r = 0
	Skada:GetWindows()[1].db.title.color.g = 0
	Skada:GetWindows()[1].db.title.color.b = 0
	Skada:GetWindows()[1].db.title.fontsize = 18
	Skada:GetWindows()[1].db.title.height = 24
	Skada:GetWindows()[1].db.title.fontflags = "OUTLINE"
	Skada:GetWindows()[1].db.title.texture = "Blizzard Raid Bar"
	end

	--第二个Skada定位
	if Skada:GetWindows()[2] ~= nil then
	Skada:GetWindows()[2].bargroup:ClearAllPoints()
	Skada:GetWindows()[2].bargroup:SetPoint("LEFT", UIParent, "LEFT", 4, -100)--位置
	Skada:GetWindows()[2].db.point = "LEFT"
	Skada:GetWindows()[2].db.y =-100
	Skada:GetWindows()[2].db.x = 4

	Skada:GetWindows()[2].db.barwidth = 270--skada框体的宽度
	Skada:GetWindows()[2].db.barslocked = true--是否锁定
	Skada:GetWindows()[2].db.barheight = 16
	Skada:GetWindows()[2].db.bartexture = "Blizzard Raid Bar"
	Skada:GetWindows()[2].db.barspacing = 1
	Skada:GetWindows()[2].db.barfontflags = "OUTLINE"
	Skada:GetWindows()[2].db.classcolorbars = false
	Skada:GetWindows()[2].db.classcolortext = true
	Skada:GetWindows()[2].db.background.color.a = 0
	Skada:GetWindows()[2].db.background.height = 137	--skada框体的高度	--136 160
	Skada:GetWindows()[2].db.background.bordertexture = "None"
	Skada:GetWindows()[2].db.background.texture = "None"
	Skada:GetWindows()[2].db.set = "total"
	Skada:GetWindows()[2].db.name = "2"

	Skada:GetWindows()[2].db.barbgcolor.a = 0.1
	Skada:GetWindows()[2].db.barbgcolor.r = 0
	Skada:GetWindows()[2].db.barbgcolor.g = 0
	Skada:GetWindows()[2].db.barbgcolor.b = 0
	Skada:GetWindows()[2].db.barcolor.a = 0.4
	Skada:GetWindows()[2].db.barcolor.r = 1
	Skada:GetWindows()[2].db.barcolor.g = 1
	Skada:GetWindows()[2].db.barcolor.b = 1
	Skada:GetWindows()[2].db.barfontsize = 13
	Skada:GetWindows()[2].db.title.color.a = 0
	Skada:GetWindows()[2].db.title.color.r = 0
	Skada:GetWindows()[2].db.title.color.g = 0
	Skada:GetWindows()[2].db.title.color.b = 0
	Skada:GetWindows()[2].db.title.fontsize = 18
	Skada:GetWindows()[2].db.title.height = 24
	Skada:GetWindows()[2].db.title.fontflags = "OUTLINE"
	Skada:GetWindows()[2].db.title.texture = "Blizzard Raid Bar"

	-- Skada:GetWindows()[2].db.clamped = true
	-- Skada:GetWindows()[2].db.sticky = true
	end
 end
--DBM设置
 if DBM ~= nil then
	DBM_MinimapIcon.hide = true--小地图图标
	--DBM.Options.Default.RaidWarningSound = "Sound\\interface\\AlarmClockWarning3.ogg"--团队警报声音默认Sound\\Doodad\\BellTollNightElf.ogg
	DBT_AllPersistentOptions.Default.DBM.HugeBarsEnabled = true--大计时条开关
	DBT_AllPersistentOptions.Default.DBM.TimerPoint = "RIGHT"--小计时条位置
	DBT_AllPersistentOptions.Default.DBM.TimerX =-500
	DBT_AllPersistentOptions.Default.DBM.TimerY = 300
	DBT_AllPersistentOptions.Default.DBM.HugeTimerPoint = "CENTER"--大计时条位置
	DBT_AllPersistentOptions.Default.DBM.HugeTimerX = 10
	DBT_AllPersistentOptions.Default.DBM.HugeTimerY =-160
	DBT_AllPersistentOptions.Default.DBM.Scale = 1
	DBT_AllPersistentOptions.Default.DBM.HugeScale = 1.2
	DBT_AllPersistentOptions.Default.DBM.Width = 180
	DBT_AllPersistentOptions.Default.DBM.Height = 20
	DBT_AllPersistentOptions.Default.DBM.HugeWidth = 200
	DBT_AllPersistentOptions.Default.DBM.BarYOffset = 1
	DBT_AllPersistentOptions.Default.DBM.HugeBarYOffset = 1
	DBT_AllPersistentOptions.Default.DBM.Alpha = 1
	DBT_AllPersistentOptions.Default.DBM.HugeAlpha = 1
	DBT_AllPersistentOptions.Default.DBM.ExpandUpwards = false--向上增长
	DBT_AllPersistentOptions.Default.DBM.ExpandUpwardsLarge = false

	DBT_AllPersistentOptions.Default.DBM.FontSize = 13
	DBT_AllPersistentOptions.Default.DBM.FontFlag = "OUTLINE"
	DBT_AllPersistentOptions.Default.DBM.EnlargeBarTime = 8
	DBT_AllPersistentOptions.Default.DBM.EnlargeBarsPercent = 0.1
	DBT_AllPersistentOptions.Default.DBM.TDecimal = 5
	DBT_AllPersistentOptions.Default.DBM.Texture = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill"

	DBM_AllSavedOptions.Default.InfoFramePoint = "CENTER"--信息框架
	DBM_AllSavedOptions.Default.InfoFrameX = 340
	DBM_AllSavedOptions.Default.InfoFrameY = -180
	DBM_AllSavedOptions.Default.RangeFrameRadarPoint = "CENTER"--距离框架
	DBM_AllSavedOptions.Default.RangeFrameRadarX = 350
	DBM_AllSavedOptions.Default.RangeFrameRadarY = 100
	DBM_AllSavedOptions.Default.RangeFramePoint = "CENTER"
	DBM_AllSavedOptions.Default.RangeFrameX = 350
	DBM_AllSavedOptions.Default.RangeFrameY =250

	if IsAddOnLoaded("DBM-VPYike") == true
		then DBM.Options.ChosenVoicePack = "Yike"
	end
 end

 print("|cff00ff00"..(L.cdscr or "已更改DBM, Skada..设置, 重载界面应用更改!").."|r")

end

StaticPopupDialogs["SetAddon"] = {
	text = "DBM, Skada.."..(L.setup or "设置").."?",
	button1 = L.confirm or "确认",
	button2 = L.cancel or "取消",
	OnAccept = function()
		seta()
		StaticPopup_Show("Reload_UI")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
		}

StaticPopupDialogs["Reload_UI"] = {
	text = L.ritss or "重置界面保存设置",
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


SlashCmdList["SETA"] = function() StaticPopup_Show("SetAddon") end
print("|cffff0000>|r |cff00ff00\/Seta|r "..(L.setup or "设置").."DBM, Skada..!")
SLASH_SETA1 = "/seta"
--]]