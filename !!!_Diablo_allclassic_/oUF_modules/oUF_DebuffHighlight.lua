local A, L =...
local oUF = L.oUF or oUF
if not oUF then return end

--config/variables

local playerClass = select(2, UnitClass("player"))
local canDispel = {
 PRIEST = { Magic = true, Disease = true, },
 SHAMAN = { Poison = true, Disease = true, },
 PALADIN = { Magic = true, Poison = true, Disease = true, },
 MAGE = { Curse = true, },
 DRUID = { Curse = true, Poison = true, },
 }
local blackList = {
	-- [6136] 	= true, -- Chilled (Frost Armor) -- 冰冻 (Frost Armor)
	-- [7321] 	= true, -- Chilled (Ice Armor)	 -- 冰冻 (冰甲术)
	-- [12579]	= true, -- Winter's Chill		 -- 深冬之寒
}
local DispelList = canDispel[playerClass] or {}


local function GetDebuffType(unit, filter)
	if (not unit) or (not UnitCanAssist('player', unit)) then return end

	for i = 1, 40 do
		local name, _, _, debuffType, _, _, _, _, _, spellID = UnitAura(unit, i, 'HARMFUL')
		if (not name) then break end

		if (debuffType and not filter) or ((filter and DispelList[debuffType]) and not (blackList[spellID])) then
			return debuffType
		end
	end
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	local element = self.DebuffHighlight
	local debuffType = GetDebuffType(unit, element.Filter)

	if debuffType then
		local dispelIndex = oUF.Enum.DispelType[debuffType]
		local color = dispelIndex and oUF.colors.dispel[dispelIndex]

		if color then
			if element:IsObjectType('Texture') then
				element:SetVertexColor(color.r, color.g, color.b)
			else
				element:SetBackdropBorderColor(color.r, color.g, color.b)
			end

			element:Show()
		else
			element:Hide()
		end
	else
		element:Hide()
	end
end

local function Enable(self)
	local element = self.DebuffHighlight
	if(element) then
		-- if we're filtering highlights and we're not of the dispelling type, return
		if element.Filter and (not DispelList) then
			return
		end

		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	local element = self.DebuffHighlight
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('DebuffHighlight', Update, Enable, Disable)
