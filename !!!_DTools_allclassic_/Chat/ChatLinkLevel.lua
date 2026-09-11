----------------------------------------------
--聊天超鏈接增加物品等級
--@Author:M
----------------------------------------------
local _, ns = ...
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(...)


	-- if IsAddOnLoaded("ElvUI") == true then return end
    
	if DToolsDB.cfp == nil or DToolsDB.cfp == false then return end


local Caches = {}

local function ChatItemLevel(Hyperlink)
    if (Caches[Hyperlink]) then
        return Caches[Hyperlink]
    end
    local link = string.match(Hyperlink, "|H(.-)|h")
    local count, level, name, _, quality, _, _, class, subclass, _, equipSlot = LibItemInfo:GetItemInfo(link)
    if (tonumber(level) and level > 0) then
        if (equipSlot == "INVTYPE_CLOAK" or equipSlot == "INVTYPE_TRINKET" or equipSlot == "INVTYPE_FINGER" or equipSlot == "INVTYPE_NECK") then
            level = format("%s(%s)", level, _G[equipSlot] or equipSlot)
        elseif (equipSlot and string.find(equipSlot, "INVTYPE_")) then
            level = format("%s(%s-%s)", level, subclass or "", _G[equipSlot] or equipSlot)
        elseif (class == ARMOR) then
            level = format("%s(%s-%s)", level, subclass or "", class)
        elseif (subclass and string.find(subclass, RELICSLOT)) then
            level = format("%s(%s)", level, RELICSLOT)
        else
            level = nil
        end
        if (level) then
            local n, stats = 0, GetItemStats(link)
            for key, num in pairs(stats) do
                if (string.find(key, "EMPTY_SOCKET_")) then
                    n = n + num
                end
            end
            local gem = string.rep("|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t", n)
            if (quality == 6 and class == WEAPON) then gem = "" end
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..level..":"..name.."]|h"..gem)
        end
        Caches[Hyperlink] = Hyperlink
    elseif (subclass and subclass == MOUNTS) then
        Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[("..subclass..")%1]|h")
        Caches[Hyperlink] = Hyperlink
    elseif (count == 0) then
        Caches[Hyperlink] = Hyperlink
    end
    return Hyperlink
end

local function filter(self, event, msg, ...)
    if not IsAddOnLoaded("TinyInspect") then
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", ChatItemLevel)
    end
    return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)


end)