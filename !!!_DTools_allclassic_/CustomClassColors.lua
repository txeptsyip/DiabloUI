local _,ns = ...

local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(...)

	----自定义职业颜色
	if DToolsDB.unc == true then

		CUSTOM_CLASS_COLORS = {

			["WARRIOR"] = { r = 1.0, g = 0.68, b = 0.45, },
			["MAGE"] = { r = 0.0, g = 0.85, b = 1.0, },
			["ROGUE"] = { r = 1.0, g = 1.0, b = 0.0, },
			["DRUID"] = { r = 1.0, g = 0.35, b = 0.0, },
			["HUNTER"] = { r = 0.1, g = 0.65, b = 0.0, },
			["SHAMAN"] = { r = 0.0, g = 0.4, b = 1.0, },
			["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, },
			["WARLOCK"] = { r = 0.65, g = 0.46, b = 0.85, },
			["PALADIN"] = { r = 1.0, g = 0.6, b = 0.8, },
			["DEATHKNIGHT"] = { r = 0.85, g = 0.02, b = 0.06, },
			["MONK"] = { r = 0.0, g = 1.0, b = 0.59, },
			["DEMONHUNTER"] = { r = 0.9, g = 0.0, b = 1.0, },
			["EVOKER"] = { r = 0.0, g = 0.7, b = 0.7, },

			--新颜色方案
			-- ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, },
			-- ["MAGE"] = { r = 0.25, g = 0.78, b = 0.92, },
			-- ["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, },
			-- ["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, },
			-- ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, },
			-- ["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, },
			-- ["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, },
			-- ["WARLOCK"] = { r = 0.78, g = 0.61, b = 0.43, },
			-- ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, },
			-- ["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23, },
			-- ["MONK"] = { r = 0.0, g = 0.1, b = 0.59, },
			-- ["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79, },
			-- ["EVOKER"] = { r = 0,	g = 0.25, b = 0.75, },

			--默认颜色方案
			-- ["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
			-- ["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
			-- ["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
			-- ["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
			-- ["MAGE"] = { r = 0, g = 0.76, b = 1 },
			-- ["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
			-- ["ROGUE"] = { r = 1, g = 0.94, b = 0.2 },
			-- ["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
			-- ["SHAMAN"] = { r = 0, g = 0.25, b = 0.75 };
			-- ["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
			-- ["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
			-- ["DEMONHUNTER"] = { r = 0.8, g = 0.12 , b = 1.0 },
			-- ["EVOKER"] = { r = 0.0, g = 0.6 , b = 0.6 },

		}

		local classes = {
			"WARRIOR",
			"MAGE",
			"ROGUE",
			"DRUID",
			"HUNTER",
			"SHAMAN",
			"PRIEST",
			"WARLOCK",
			"PALADIN",
			"DEATHKNIGHT",
			"MONK",
			"DEMONHUNTER",
			"EVOKER",

		}

		for i, className in ipairs(classes) do
			local color = CUSTOM_CLASS_COLORS[className]

			color.colorStr = format("ff%02x%02x%02x", color.r*255, color.g*255, color.b*255)
		end


		local meta = {}
		local callbacks = {}
		local numCallbacks = 0

		function meta:RegisterCallback(method, handler)
			assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
			if type(method) == "string" then
				assert(type(handler) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
				assert(type(handler[method]) == "function", "Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
				method = handler[method]
			end
			-- assert(not callbacks[method] "Callback already registered!")
			callbacks[method] = handler or true
			numCallbacks = numCallbacks + 1
		end

		function meta:UnregisterCallback(method, handler)
			assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
			if type(method) == "string" then
				assert(type(handler) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
				assert(type(handler[method]) == "function", "Bad argument #1 to :UnregisterCallback (method \"" .. method .. "\" not found)")
				method = handler[method]
			end
			-- assert(callbacks[method], "Callback not registered!")
			callbacks[method] = nil
			numCallbacks = numCallbacks - 1
		end

		local function DispatchCallbacks()
			if numCallbacks < 1 then return end
			--print("CUSTOM_CLASS_COLORS: DispatchCallbacks")
			for method, handler in pairs(callbacks) do
				local ok, err = pcall(method, handler ~= true and handler or nil)
				if not ok then
					print("ERROR:", err)
				end
			end
		end

		setmetatable(CUSTOM_CLASS_COLORS, { __index = meta })



		CUSTOM_POWER_COLORS = {

			["MANA"] = { r = 0.00, g = 0.4, b = 1.00,},
			["RAGE"] = { r = 1.00, g = 0.00, b = 0.00,},
			["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25,},
			["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00,},
			["COMBO_POINTS"] = { r = 1.00, g = 0.96, b = 0.41 },
			["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 },
			["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00,},
			["SOUL_SHARDS"] = { r = 0.50, g = 0.32, b = 0.55 },
			["LUNAR_POWER"] = { r = 0.30, g = 0.52, b = 0.90,},
			["HOLY_POWER"] = { r = 0.95, g = 0.90, b = 0.60 },
			["MAELSTROM"] = { r = 0.00, g = 0.50, b = 1.00,},
			["INSANITY"] = { r = 0.40, g = 0.00, b = 0.80,},
			["CHI"] = { r = 0.71, g = 1.00, b = 0.92 },
			["ARCANE_CHARGES"] = { r = 0.10, g = 0.10, b = 0.98 },
			["FURY"] = { r = 0.788, g = 0.259, b = 0.992,},
			["PAIN"] = { r = 255/255, g = 156/255, b = 0,},
			-- vehicle colors
			["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 },
			["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 },
			-- alternate power bar colors
			["EBON_MIGHT"] = { r = 0.9, g = 0.55, b = 0.3,},

			--报错
			-- ["STAGGER"] = {
			--	green = { r = 0.52, g = 1.0, b = 0.52, atlas = "Unit_Monk_Stagger_Fill_Green" },
			--	yellow = { r = 1.0, g = 0.98, b = 0.72, atlas = "Unit_Monk_Stagger_Fill_Yellow" },
			--	red = { r = 1.0, g = 0.42, b = 0.42, atlas = "Unit_Monk_Stagger_Fill_Red" },
			--	spark = { atlas = "Unit_Monk_Stagger_EndCap", barHeight = 10, xOffset = 1, showAtMax = true },
			-- },

		}

		local powers = {

			"MANA",
			"RAGE",
			"FOCUS",
			"ENERGY",
			"COMBO_POINTS",
			"RUNES",
			"RUNIC_POWER",
			"SOUL_SHARDS",
			"LUNAR_POWER",
			"HOLY_POWER",
			"MAELSTROM",
			"INSANITY",
			"CHI",
			"ARCANE_CHARGES",
			"FURY",
			"PAIN",
			-- vehicle colors
			"AMMOSLOT",
			"FUEL",
			-- alternate power bar colors
			"EBON_MIGHT",

			--报错
			-- "STAGGER",

		}

		for i, powerType in ipairs(powers) do
			local color = CUSTOM_POWER_COLORS[powerType]

			color.colorStr = format("ff%02x%02x%02x", color.r*255, color.g*255, color.b*255)
		end

	-- 	local meta = {}
	-- 	local callbacks = {}
	-- 	local numCallbacks = 0

	-- 	function meta:RegisterCallback(method, handler)
	-- 		assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
	-- 		if type(method) == "string" then
	-- 			assert(type(handler) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
	-- 			assert(type(handler[method]) == "function", "Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
	-- 			method = handler[method]
	-- 		end
	-- 		-- assert(not callbacks[method] "Callback already registered!")
	-- 		callbacks[method] = handler or true
	-- 		numCallbacks = numCallbacks + 1
	-- 	end

	-- 	function meta:UnregisterCallback(method, handler)
	-- 		assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
	-- 		if type(method) == "string" then
	-- 			assert(type(handler) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
	-- 			assert(type(handler[method]) == "function", "Bad argument #1 to :UnregisterCallback (method \"" .. method .. "\" not found)")
	-- 			method = handler[method]
	-- 		end
	-- 		-- assert(callbacks[method], "Callback not registered!")
	-- 		callbacks[method] = nil
	-- 		numCallbacks = numCallbacks - 1
	-- 	end

	-- 	local function DispatchCallbacks()
	-- 		if numCallbacks < 1 then return end
	-- 		--print("CUSTOM_CLASS_COLORS: DispatchCallbacks")
	-- 		for method, handler in pairs(callbacks) do
	-- 			local ok, err = pcall(method, handler ~= true and handler or nil)
	-- 			if not ok then
	-- 				print("ERROR:", err)
	-- 			end
	-- 		end
	-- 	end

	-- 	setmetatable(CUSTOM_POWER_COLORS, { __index = meta })
	
	end
	--]]--


end)