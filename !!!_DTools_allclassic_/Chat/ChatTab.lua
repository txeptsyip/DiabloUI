-------------------------------------
--聊天框Tab键切換頻道
-------------------------------------
local _, ns = ...
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(...)


	-- if IsAddOnLoaded("ElvUI") == true then return end
	
	if DToolsDB.cfp == nil or DToolsDB.cfp == false then return end


	local IncludeKeywords = {
		"General", "Trade", "LookingForGroup",
		"综合", "交易", "组队", "大脚世界",
		"綜合", "交易", "組隊",
	}

	local function checkChannel(id)
		local chanId, chanName = GetChannelName(id)
		if (chanId < 1) then return false end
		if (#IncludeKeywords == 0) then return true end
		for _, word in ipairs(IncludeKeywords) do
			if (strfind(chanName,word)) then return true end
		end
	end

	local channel,_,_  = GetChannelName("大脚世界频道")
	local TabChannels = {
		{ TypeInfoKey = "SAY", check = false },
		{ TypeInfoKey = "GUILD", check = IsInGuild },					---公会频道
	--  { TypeInfoKey = "OFFICER", check = CanEditOfficerNote },		---公会官员频道
		{ TypeInfoKey = "PARTY", check = function() return IsInGroup(LE_PARTY_CATEGORY_HOME) end },
		{ TypeInfoKey = "RAID", check = function() return IsInRaid(LE_PARTY_CATEGORY_HOME) end },
		{ TypeInfoKey = "INSTANCE_CHAT", check = function() return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) end },
		{ TypeInfoKey = "CHANNEL"..channel.."", check = function() return checkChannel(channel) end },	--世界
	--	{ TypeInfoKey = "CHANNEL1", check = function() return checkChannel(1) end },
	--	{ TypeInfoKey = "CHANNEL2", check = function() return checkChannel(2) end },
	}

	local function MatchChannel(m, n)
		for i = m, n do
			if (not TabChannels[i].check or TabChannels[i].check()) then
				return i
			end
		end
	end

	hooksecurefunc("ChatEdit_CustomTabPressed", function(self)
		local attr = self:GetAttribute("chatType")
		local cid = self:GetAttribute("channelTarget")
		local pos = 0
		if (attr == "CHANNEL") then attr = attr..cid end
		for i, v in ipairs(TabChannels) do
			if (v.TypeInfoKey == attr) then pos = i end
		end
		local idx = MatchChannel(pos+1, #TabChannels)
		if (not idx) then
			idx = MatchChannel(1, pos-1)
		end
		if (idx) then
			local type = TabChannels[idx].TypeInfoKey
			local i, j = string.find(type, "CHANNEL")
			if (i) then
				self:SetAttribute("channelTarget", string.sub(type, j+1))
				type = string.sub(type, i, j)
			end
			self:SetAttribute("chatType", type)
			ChatEdit_UpdateHeader(self)
		end
	end)


end)