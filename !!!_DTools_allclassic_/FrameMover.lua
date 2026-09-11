local _, ns =...
DTools_Move_frame = {
	-- "DiabloPlayerFrame",
	-- -- "DiabloHealthOrb",
	-- "DiabloPowerOrb",
	-- -- "DiabloAddPower",
	-- "DruidManabar",
	-- "DiabloAngelFrame",
	-- "DiabloDemonFrame",
	-- "DiabloPetFrame",
	-- "DiabloPetTargetFrame",
	"InfoStrings1",
	"InfoStrings2",
	"InfoStrings3",
	"InfoStrings4",
	"InfoStrings5",
	"InfoStringsa",

	-- "QueueStatusButton",
	-- "TTFMFrame",

	"SecondaryResFrame",
	-- "ChatBarFrame",
	-- "MoveERBarFrame",

	"MoveExpBarFrame",
	"MoveRepBarFrame",
	"AACTBFrame",

	}


local function SetupMovableFrame(v)
	-- if InCombatLockdown() then return end
	local frame = _G[v]
	if not frame then return end
	local isDragging = false

	-- 设置可移动属性
	if v ~= "TTFMFrame" and frame:IsShown() then frame:EnableMouse(true) end
	frame:SetClampedToScreen(false)
	frame:RegisterForDrag("LeftButton")
	
	-- 拖动开始
	frame:HookScript("OnDragStart", function(self, button)
		-- if InCombatLockdown() then 
		-- 	print("|cffff0000!!!|r|cff00ff00>|rInCombatLockdown!") 
		-- else
			frame:SetMovable(true)
			if IsShiftKeyDown() then
				self:StartMoving()
			end
		-- end
		isDragging = true
	end)
	
	-- 拖动结束
	frame:HookScript("OnDragStop", function(self, button)
		-- if InCombatLockdown() then return end
		self:StopMovingOrSizing()
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
		if relativeTo and relativeTo:GetName() then relativeTo = relativeTo:GetName() end
		if point then
			-- 保存完整信息
			DToolsDB[v] = {
				point = point,
				relativeTo = relativeTo,
				relativePoint = relativePoint,
				xOfs = xOfs,
				yOfs = yOfs
			}
		end
		isDragging = false
	end)

	if isDragging then return end

	if DToolsDB and DToolsDB[v] then
		local pos = DToolsDB[v]
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

ns.event("PLAYER_LOGIN", function()
	for _, v in pairs(DTools_Move_frame) do
		SetupMovableFrame(v)
	end
end)

local function SetupFramePoints(v)
	local frame = _G[v]
	if not frame then return end
	local pos = DToolsDB[v]
	if not pos then return end
	local point = pos.point
	local relativeTo = pos.relativeTo
	local relativePoint = pos.relativePoint
	local xOfs = pos.xOfs
	local yOfs = pos.yOfs
	frame:ClearAllPoints()
	frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
end


function DToolsReset()

	-- DToolsDB.DiabloPlayerFrame = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = -360, yOfs = 0}
	-- -- DToolsDB.DiabloHealthOrb = {point = "CENTER", relativeTo = "DiabloPlayerFrame", relativePoint = "CENTER", xOfs = 0, yOfs = 0}
	-- DToolsDB.DiabloPowerOrb = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = 360, yOfs = 0}
	-- DToolsDB.DruidManabar = {point = "BOTTOM", relativeTo = "DiabloPowerOrb", relativePoint = "TOP", xOfs = 0, yOfs = 16}
	-- -- DToolsDB.DiabloAddPower = {point = "BOTTOM", relativeTo = "DiabloPowerOrb", relativePoint = "TOP", xOfs = 0, yOfs = 16}
	-- DToolsDB.DiabloAngelFrame = {point = "BOTTOMLEFT", relativeTo = "DiabloPowerOrb", relativePoint = "BOTTOMRIGHT", xOfs = 8, yOfs = 0}
	-- DToolsDB.DiabloDemonFrame = {point = "BOTTOMRIGHT", relativeTo = "DiabloHealthOrb", relativePoint = "BOTTOMLEFT", xOfs = -8, yOfs = 0}
	-- DToolsDB.DiabloPetFrame = {point = "BOTTOMRIGHT", relativeTo = "DiabloHealthOrb", relativePoint = "TOPLEFT", xOfs = 5, yOfs = -20}
	-- DToolsDB.DiabloPetTargetFrame = {point = "BOTTOM", relativeTo = "DiabloPetFrame", relativePoint = "TOP", xOfs = 0, yOfs = 20}

	DToolsDB.InfoStrings1 = {point = "BOTTOMRIGHT", relativeTo = "InfoStrings", relativePoint = "BOTTOM", xOfs = 0, yOfs = 1}
	DToolsDB.InfoStrings2 = {point = "BOTTOM", relativeTo = "InfoStrings1", relativePoint = "TOP", xOfs = 0, yOfs = 1}
	DToolsDB.InfoStrings3 = {point = "BOTTOM", relativeTo = "InfoStrings2", relativePoint = "TOP", xOfs = 0, yOfs = 1}
	DToolsDB.InfoStrings4 = {point = "BOTTOM", relativeTo = "InfoStrings3", relativePoint = "TOP", xOfs = 0, yOfs = 1}
	DToolsDB.InfoStrings5 = {point = "BOTTOM", relativeTo = "InfoStrings4", relativePoint = "TOP", xOfs = 0, yOfs = 1}
	if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
		DToolsDB.InfoStringsa = {point = "BOTTOMLEFT", relativeTo = "InfoStrings", relativePoint = "BOTTOM", xOfs = -230, yOfs = 0}
	elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
		DToolsDB.InfoStringsa = {point = "BOTTOMLEFT", relativeTo = "InfoStrings", relativePoint = "BOTTOM", xOfs = -235, yOfs = 0}
	elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
		DToolsDB.InfoStringsa = {point = "BOTTOMLEFT", relativeTo = "InfoStrings", relativePoint = "BOTTOM", xOfs = -260, yOfs = 0}
	elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		DToolsDB.InfoStringsa = {point = "BOTTOMLEFT", relativeTo = "InfoStrings", relativePoint = "BOTTOM", xOfs = -235, yOfs = 0}
	end


	-- DToolsDB.QueueStatusButton = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOMRIGHT", xOfs = -270, yOfs = 40}

	-- DToolsDB.TTFMFrame = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = -360, yOfs = 160}

	DToolsDB.SecondaryResFrame = {point = "CENTER", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = 0, yOfs = 270}
	
	DToolsDB.MoveExpBarFrame = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = -0.5, yOfs = 2}
	DToolsDB.MoveRepBarFrame = {point = "BOTTOM", relativeTo = "UIParent", relativePoint = "BOTTOM", xOfs = -0.5, yOfs = 14.5}

	DToolsDB.AACTBFrame = {point = "BOTTOM",relativeTo = "UIParent",relativePoint = "BOTTOM", xOfs = 0, yOfs = 220}

	for _, v in pairs(DTools_Move_frame) do
		SetupFramePoints(v)
	end

end

SlashCmdList["DTFR"] =  function() DToolsReset() end
SLASH_DTFR1 = "/dtr"