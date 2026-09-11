
---------------------------------------------
--Diablo-panel
---------------------------------------------

--The config panel

--get the addon namespace
  local AddonName, ns =...
  local oUF = ns.oUF or oUF

  local db = ns.db
  local unpack = unpack
  local gsub = gsub
  local tinsert = tinsert
  local wipe = wipe
  local floor = floor
  local strmatch = strmatch
  local strlen = strlen
  local CF = CreateFrame
  local CPF = ColorPickerFrame
  local theEnd = function() end
---------------------------------------------

--object container
  local panel = CF("Frame", "DiabloUIConfigPanel", UIParent, "ButtonFrameTemplate")
  panel:SetFrameStrata("HIGH")
  AddonList:SetFrameStrata("DIALOG")
  panel:Hide()
  ns.panel = panel

---------------------------------------------
--PANEL SETUP FUNCTIONS
---------------------------------------------

--setup panel
  do
	--size/point
	panel:SetSize(560, 600)
	panel:SetPoint("CENTER")
	--title
	panel.title = _G["DiabloUIConfigPanelTitleText"]
	panel.title:SetText("Orb config panel         ")
	panel.title:SetScale(0.8)
	--icon
	local icon = panel:CreateTexture("$parentIcon", "OVERLAY", nil, -8)
	icon:SetSize(60, 60)
	icon:SetPoint("TOPLEFT", -5, 7)
	icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
	--SetPortraitTexture(icon, "player")
	icon:SetTexCoord(0, 1, 0, 1)
	panel.icon = icon
	--mouse/drag stuff
	panel:EnableMouse(true)
	panel:SetClampedToScreen(true)
	panel:SetMovable(true)
	panel:SetUserPlaced(true)
  end

--create panel drag frame
  local createPanelDragFrame = function()
	local frame = CF("Frame", "$parentDragFrame", panel)
	frame:SetHeight(22)
	frame:SetPoint("TOPLEFT", 60, 0)
	frame:SetPoint("TOPRIGHT", -30, 0)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
	--if InCombatLockdown() then return end
	  self:GetParent():StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
	--if InCombatLockdown() then return end
	  self:GetParent():StopMovingOrSizing()
	end)
	frame:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Drag me!", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return frame
  end

--create panel scroll frame
  local createPanelScrollFrame = function()
	local scrollFrame = CF("ScrollFrame", "$parentScrollFrame", panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 10, -65)
	scrollFrame:SetPoint("BOTTOMRIGHT", -10, 30)
	scrollFrame.ScrollBar:SetAlpha(0)
	--create panel scroll child
	local scrollChild = CF("Frame", nil, ScrollFrame)
	scrollChild:SetWidth(scrollFrame:GetWidth())
	--set scrollchild height
	scrollChild:SetHeight(1350)
	--left background behind health orb settings
	local t = scrollChild:CreateTexture(nil, "BACKGROUND", nil, -4)
	t:SetColorTexture(1, 1, 1)
	t:SetVertexColor(1, 0, 0)
	t:SetAlpha(0.1)
	t:SetPoint("TOPLEFT", 0, 0)
	t:SetPoint("BOTTOMLEFT")
	t:SetWidth(scrollFrame:GetWidth()/2-2)
	scrollChild.leftTexture = t
	--right background behind power settings
	local t = scrollChild:CreateTexture(nil, "BACKGROUND", nil, -4)
	t:SetColorTexture(1, 1, 1)
	t:SetVertexColor(0, 0, 1)
	t:SetAlpha(0.1)
	t:SetPoint("TOPRIGHT", 0, 0)
	t:SetPoint("BOTTOMRIGHT")
	t:SetWidth(scrollFrame:GetWidth()/2-2)
	scrollChild.rightTexture = t
	--set scrollchild
	scrollFrame:SetScrollChild(scrollChild)
	scrollFrame.scrollChild = scrollChild
	return scrollFrame
  end
--panel drag frame
  panel.dragFrame = createPanelDragFrame()
--the scroll frame
  panel.scrollFrame = createPanelScrollFrame()

---------------------------------------------
--CREATE UI PANEL ELEMENT FUNCTIONS
---------------------------------------------

--basic fontstring func
  local createBasicFontString = function(parent, name, layer, template, text)
	local fs = parent:CreateFontString(name, layer, template)
	fs:SetText(text)
	return fs
  end

  local createHeadlineBackground = function(parent, headline)
	local t = parent:CreateTexture(nil, "BACKGROUND", nil, -2)
	t:SetColorTexture(1, 1, 1)
	--t:SetVertexColor(0, 0, 0, 0.4)
	t:SetVertexColor(255, 255, 255, 0.05)
	t:SetPoint("TOP", headline, 0, 4)
	t:SetPoint("LEFT", headline, -20, 0)
	t:SetWidth(250)
	t:SetPoint("BOTTOM", headline, 0, -4)
	t:SetBlendMode("ADD")
  end

  local createTooltipButton = function(parent, pointParent, text)
	local button = CF("Button", nil, parent)
	button:SetAllPoints(pointParent)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine(text, 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
  end

  local backdrop = {
	bgFile = "",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = false,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

--basic button func
  local createBasicButton = function(parent, name, text, adjustWidth, adjustHeight)
	local button = CF("Button", name.."Button", parent, "UIPanelButtonTemplate")
	button.text = _G[button:GetName().."Text"]
	button.text:SetText(text)
	button:SetWidth(button.text:GetStringWidth()+(adjustWidth or 12))
	button:SetHeight(button.text:GetStringHeight()+(adjustHeight or 12))
	return button
  end

--basic slider func
  local createBasicSlider = function(parent, name, title, minVal, maxVal, valStep)
	local slider = CF("Slider", name, parent, "OptionsSliderTemplate")
	local editbox = CF("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
	slider:SetMinMaxValues(minVal, maxVal)
	--slider:SetValue(0)
	slider:SetValueStep(valStep)
	slider.text = _G[name.."Text"]
	slider.text:SetText(title)
	-- slider.text:ClearAllPoints()
	slider.text:SetPoint("TOPLEFT", slider, "TOPLEFT", 2, 16)
	slider.textLow = _G[name.."Low"]
	slider.textHigh = _G[name.."High"]
	slider.textLow:SetText(floor(minVal))
	slider.textHigh:SetText(floor(maxVal))
	slider.textLow:SetTextColor(0.4, 0.4, 0.4, 0)
	slider.textHigh:SetTextColor(0.4, 0.4, 0.4, 0)
	editbox:SetSize(50, 30)
	editbox:ClearAllPoints()
	editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
	editbox:SetText(slider:GetValue())
	editbox:SetAutoFocus(false)
	slider:SetScript("OnValueChanged", function(self, value)
	--self.editbox:SetText(string.format("%.2f", value))
	  self.editbox:SetText(ns.round(value))
	end)
	editbox:SetScript("OnTextChanged", function(self)
	  local val = self:GetText()
	  if tonumber(val) then
		 self:GetParent():SetValue(val)
	  end
	end)
	editbox:SetScript("OnEnterPressed", function(self)
	  local val = self:GetText()
	  if tonumber(val) then
		 self:GetParent():SetValue(val)
		 self:ClearFocus()
	  end
	end)
	slider.editbox = editbox
	return slider
  end

--basic checkbutton func
  local createBasicCheckButton = function(parent, name, title)
	local button = CF("CheckButton", name, parent, "OptionsBaseCheckButtonTemplate")
	button.text = _G[name.."Text"]
	button.text:SetText(title)
	button.text:SetTextColor(1, 1, 1)
	return button
  end

--basic color picker func
  local createBasicColorPicker = function(parent, name, title, width, height)
	local picker = CF("Button", name, parent, BackdropTemplateMixin and "BackdropTemplate")
	picker:SetSize(width, height)
	picker:SetBackdrop({ backdrop })
	picker:SetBackdropBorderColor(0.5, 0.5, 0.5)
	--texture
	local color = picker:CreateTexture(nil, "BACKGROUND", nil, -7)
	--color:SetAllPoints(picker)
	color:SetPoint("TOPLEFT", 4, -4)
	color:SetPoint("BOTTOMRIGHT", -4, 4)
	color:SetColorTexture(1, 1, 1)
	picker.color = color
	picker.text = createBasicFontString(picker, nil, nil, "GameFontNormal", title)
	picker.text:SetTextColor(1, 1, 1)
	picker.text:SetPoint("LEFT", picker, "RIGHT", 5, 0)
	picker.disabled = false
	--add a Disable() function to the colorpicker element
	function picker:Disable()
	  self.disabled = true
	  self.color:SetAlpha(0)
	  self.text:SetTextColor(0.5, 0.5, 0.5)
	end
	--add a Enable() function to the colorpicker element
	function picker:Enable()
	  self.disabled = false
	  self.color:SetAlpha(1)
	  self.text:SetTextColor(1, 1, 1)
	end
	--picker.show
	picker.show = function(r, g, b, a, callback)
	  CPF:SetColorRGB(r,g,b)
	  CPF.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
	  CPF.previousValues = { r, g, b, a }
	  CPF.swatchFunc, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback
	  CPF:Hide()--Need to run the OnShow handler.
	  CPF:Show()
	end
	picker.callback = function(color)
	  if picker.disabled then return end
	  local r, g, b
	  if color then r, g, b = unpack(color) else r, g, b = ColorPickerFrame:GetColorRGB() end
	  picker.color:SetVertexColor(r, g, b)
	  picker.click(r, g, b)
	end
	picker:SetScript("OnClick", function(self)
	  if self.disabled then return end
	--the colorpicker does not reset the callback function properly, so let's do it for him
	  CPF.swatchFunc, CPF.opacityFunc, CPF.cancelFunc = theEnd, theEnd, theEnd
	  local r, g, b = self.color:GetVertexColor()
	  self.show(r, g, b, nil, self.callback)
	end)
	return picker
  end

--basic dropdown menu func
  local createBasicDropDownMenu = function(parent, name, title, dataFunc, width, displayMode, dynamicList, headline)
	local dropdownMenu = CF("Frame", name, parent, "UIDropDownMenuTemplate")

	if headline then
	  dropdownMenu.headline = createBasicFontString(dropdownMenu, nil, nil, "GameFontNormal", headline)
	--dropdownMenu.headline:SetTextColor(1, 1, 1)
	  dropdownMenu.headline:SetPoint("BOTTOMLEFT", dropdownMenu, "TOPLEFT", 20, 5)
	end

	UIDropDownMenu_SetText(dropdownMenu, title)
	if width then UIDropDownMenu_SetWidth(dropdownMenu, width) end
	dropdownMenu.init = function(self, level)
	  self.info = self.info or {}
	  self.infos = self.infos or {}
	  wipe(self.infos)
	  if dynamicList then
		self.data = dataFunc()--load data on init
	  else
		self.data = self.data or dataFunc()--static list
	  end
	--level 1
	  if level == 1 then
		tinsert(self.infos, { text = title, isTitle = true, notCheckable = true, notClickable = true, })
		tinsert(self.infos, { text = "|cFF666666~~~~~~~~~~~~~~~|r", notCheckable = true, notClickable = true, })
		if #self.data == 0 then
		  tinsert(self.infos, { text = "|cFFFF0000No data found|r", notCheckable = true, notClickable = true, })
		end
		for index, data in pairs(self.data) do
		  tinsert(self.infos, {
			text = data.key,
			value = data.value,
			func = self.click,
			isTitle = data.isTitle or false,
			hasArrow = data.hasArrow or false,
			notClickable = data.notClickable or false,
			notCheckable = data.notCheckable or false,
			keepShownOnClick = data.keepShownOnClick or false,
		  })
		  if data.hasArrow then
			self.infos[#self.infos].func = nil--remove the function call on multilevel menu
		  end
		end
		tinsert(self.infos, { text = "|cFF666666~~~~~~~~~~~~~~~|r", notCheckable = true, notClickable = true, })
		tinsert(self.infos, { text = "|cFF3399FFClose menu|r", notCheckable = true, func = function() CloseDropDownMenus() end, })
	  end
	--level 2
	  if level == 2 then
		for index, data in pairs(self.data) do
		  if UIDROPDOWNMENU_MENU_VALUE == data.value then
			for index2, data2 in pairs(data.menuList) do
			  tinsert(self.infos, {
				text = data2.key,
				value = data2.value,
				func = self.click,
				isTitle = data2.isTitle or false,
				hasArrow = data2.hasArrow or false,
				notClickable = data2.notClickable or false,
				notCheckable = data2.notCheckable or false,
				keepShownOnClick = data2.keepShownOnClick or false,
			  })
			end
			break
		  end
		end
	  end
	--create buttons
	  for i=1, #self.infos do
		wipe(self.info)
		self.info.text = self.infos[i].text
		self.info.value = self.infos[i].value or nil
		self.info.isTitle = self.infos[i].isTitle or false
		self.info.hasArrow = self.infos[i].hasArrow or false
		self.info.keepShownOnClick = self.infos[i].keepShownOnClick or false
		self.info.notClickable = self.infos[i].notClickable or false
		self.info.notCheckable = self.infos[i].notCheckable or false
		self.info.func = self.infos[i].func or nil
		UIDropDownMenu_AddButton(self.info, level)
	  end
	end
	UIDropDownMenu_Initialize(dropdownMenu, dropdownMenu.init, displayMode)
	return dropdownMenu
  end

---------------------------------------------
--CREATE PANEL ELEMENT FUNCTIONS
---------------------------------------------

--create element  orb  scale
  local createSliderOrbScale = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelOrbScale", "AllOrb Scale", 0.01, 2, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--   slider.editbox:SetScale(1)
	  slider.editbox:SetSize(44, 30)
	  slider.editbox:ClearAllPoints()
	  slider.editbox:SetPoint("BOTTOMLEFT", slider, "BOTTOMRIGHT", -45, 10)
	--   slider.text:SetScale(1)
	--   slider.text:ClearAllPoints()
	  slider.text:SetPoint("TOPLEFT", slider, "TOPLEFT", 0, 16)
	--save value
	  panel.saveOrbScale(value)
	--update orb view
	  panel.updateOrbScale()
	end)
	return slider
  end

--create element health orb filling texture
  local createDropdownHealthOrbFillingTexture = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelHealthOrbFillingTexture", "Choose texture", db.getListFillingTexture, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.saveHealthOrbFillingTexture(self.value)
	--update orb view
	  panel.updateHealthOrbFillingTexture()
	end
	return dropdownMenu
  end

--create element power orb filling texture
  local createDropdownPowerOrbFillingTexture = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelPowerOrbFillingTexture", "Choose texture", db.getListFillingTexture_fh, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.savePowerOrbFillingTexture(self.value)
	--update orb view
	  panel.updatePowerOrbFillingTexture()
	end
	return dropdownMenu
  end

--create element health orb grid enable
  local createCheckButtonHealthOrbGridEnable = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelHealthOrbGridEnable", "OrbGrid")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.saveHealthOrbGridEnable(self:GetChecked())
	--update orb view
	  panel.updateHealthOrbGridEnable()
	--update the panel view, other panels need to be shown/hidden
	  panel.updateElementHealthOrbGridEnable()
	end)
	return button
  end

--create element power orb grid enable
  local createCheckButtonPowerOrbGridEnable = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelPowerOrbGridEnable", "OrbGrid")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.savePowerOrbGridEnable(self:GetChecked())
	--update orb view
	  panel.updatePowerOrbGridEnable()
	--update the panel view, other panels need to be shown/hidden
	  panel.updateElementPowerOrbGridEnable()
	end)
	return button
  end

--create element health orb color auto
  local createCheckButtonHealthOrbFillingColorAuto = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelHealthOrbFillingColorAuto", "Automatic classcoloring")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.saveHealthOrbFillingColorAuto(self:GetChecked())
	--update orb view
	  panel.updateHealthOrbFillingColorAuto()
	--normally we do not need to update the panel view but this enable/disable button has side effects on other panels, thus we need to run a panel update
	  panel.updateElementHealthOrbFillingColorAuto()
	end)
	return button
  end

--create element power orb color auto
  local createCheckButtonPowerOrbFillingColorAuto = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelPowerOrbFillingColorAuto", "Automatic powercoloring")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.savePowerOrbFillingColorAuto(self:GetChecked())
	--update orb view
	  panel.updatePowerOrbFillingColorAuto()
	--normally we do not need to update the panel view but this enable/disable button has side effects on other panels, thus we need to run a panel update
	  panel.updateElementPowerOrbFillingColorAuto()
	end)
	return button
  end

--create element health orb filling color
  local createPickerHealthOrbFillingColor = function(parent)
	local picker = createBasicColorPicker(parent, AddonName.."PanelHealthOrbFillingColor", "Filling texture color", 60, 25)
	picker.click = function(r, g, b)
	--save value
	  panel.saveHealthOrbFillingColor(r, g, b)
	--update orb view
	  panel.updateHealthOrbFillingColor()
	end
	return picker
  end

--create element power orb filling color
  local createPickerPowerOrbFillingColor = function(parent)
	local picker = createBasicColorPicker(parent, AddonName.."PanelPowerOrbFillingColor", "Filling texture color", 60, 25)
	picker.click = function(r, g, b)
	--save value
	  panel.savePowerOrbFillingColor(r, g, b)
	--update orb view
	  panel.updatePowerOrbFillingColor()
	end
	return picker
  end

--create element health orb filling alpha
  local createSliderHealthOrbFillingAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbFillingAlpha", "Filling alpha", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbFillingAlpha(value)
	--update orb view
	  panel.updateHealthOrbFillingAlpha()
	end)
	return slider
  end

--create element power orb filling alpha
  local createSliderPowerOrbFillingAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbFillingAlpha", "Filling alpha", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbFillingAlpha(value)
	--update orb view
	  panel.updatePowerOrbFillingAlpha()
	end)
	return slider
  end

--create element health textureframe size
  local createSliderHealthTextureFrameSize = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthTextureFrameSize", nil, 0, 400, 1)
	slider:HookScript("OnValueChanged", function(self, value)
	  self.editbox:SetText(string.format("%d", value))
	--save value
	  panel.saveHealthTextureFrameSize(value)
	--update orb view
	  panel.updateHealthTextureFrameSize()
	end)
	return slider
  end

--create element power textureframe size
  local createSliderPowerTextureFrameSize = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerTextureFrameSize", nil, 0, 400, 1)
	slider:HookScript("OnValueChanged", function(self, value)
	  self.editbox:SetText(string.format("%d", value))
	--save value
	  panel.savePowerTextureFrameSize(value)
	--update orb view
	  panel.updatePowerTextureFrameSize()
	end)
	return slider
  end

--create element health orb model enable
  local createCheckButtonHealthOrbModelEnable = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelHealthOrbModelEnable", "Enable")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.saveHealthOrbModelEnable(self:GetChecked())
	--update orb view
	  panel.updateHealthOrbModelEnable()
	--update the panel view, other panels need to be shown/hidden
	  panel.updateElementHealthOrbModelEnable()
	end)
	return button
  end

--create element power orb model enable
  local createCheckButtonPowerOrbModelEnable = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelPowerOrbModelEnable", "Enable")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.savePowerOrbModelEnable(self:GetChecked())
	--update orb view
	  panel.updatePowerOrbModelEnable()
	--update the panel view, other panels need to be shown/hidden
	  panel.updateElementPowerOrbModelEnable()
	end)
	return button
  end

  --create element health orb model animated
  local createCheckButtonHealthOrbModelAnimated = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelHealthOrbModelAnimated", "Animated")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.saveHealthOrbModelAnimated(self:GetChecked())
	--update orb view
	  panel.updateHealthOrbModelAnimated()
	--update the panel view, other panels need to be shown/hidden
	  panel.updateElementHealthOrbModelAnimated()
	end)
	return button
  end

--create element power orb model animated
  local createCheckButtonPowerOrbModelAnimated = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelPowerOrbModelAnimated", "Animated")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.savePowerOrbModelAnimated(self:GetChecked())
	--update orb view
	  panel.updatePowerOrbModelAnimated()
	--update the panel view, other panels need to be shown/hidden
	  panel.updateElementPowerOrbModelAnimated()
	end)
	return button
  end

--create element health orb model animation
  local createDropdownHealthOrbModelAnimation = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelHealthOrbModelAnimation", "Choose animation", db.getListModel, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.saveHealthOrbModelAnimation(self.value)
	--update orb view
	  panel.updateHealthOrbModelAnimation()
	end
	return dropdownMenu
  end

--create element power orb model animation
  local createDropdownPowerOrbModelAnimation = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelPowerOrbModelAnimation", "Choose animation", db.getListModel, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.savePowerOrbModelAnimation(self.value)
	--update orb view
	  panel.updatePowerOrbModelAnimation()
	end
	return dropdownMenu
  end

--create element health orb model alpha
  local createSliderHealthOrbModelAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbModelAlpha", "Alpha", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbModelAlpha(value)
	--update orb view
	  panel.updateHealthOrbModelAlpha()
	end)
	return slider
  end

--create element power orb model alpha
  local createSliderPowerOrbModelAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbModelAlpha", "Alpha", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbModelAlpha(value)
	--update orb view
	  panel.updatePowerOrbModelAlpha()
	end)
	return slider
  end

--create element health orb model camDistanceScale
  local createSliderHealthOrbModelCDS = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbModelCDS", "Cdscale", 0.001, 6, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbModelCDS(value)
	--update orb view
	  panel.updateHealthOrbModelCDS()
	end)
	return slider
  end

--create element power orb model camDistanceScale
  local createSliderPowerOrbModelCDS = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbModelCDS", "Cdscale", 0.001, 6, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbModelCDS(value)
	--update orb view
	  panel.updatePowerOrbModelCDS()
	end)
	return slider
  end

--create element health orb model pos x
  local createSliderHealthOrbModelPosX = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbModelPosX", "X-Axis", -5, 5, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbModelPosX(value)
	--update orb view
	  panel.updateHealthOrbModelPosX()
	end)
	return slider
  end

--create element power orb model pos x
  local createSliderPowerOrbModelPosX = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbModelPosX", "X-Axis", -5, 5, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbModelPosX(value)
	--update orb view
	  panel.updatePowerOrbModelPosX()
	end)
	return slider
  end

--create element health orb model pos y
  local createSliderHealthOrbModelPosY = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbModelPosY", "Y-Axis", -5, 5, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbModelPosY(value)
	--update orb view
	  panel.updateHealthOrbModelPosY()
	end)
	return slider
  end

--create element power orb model pos y
  local createSliderPowerOrbModelPosY = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbModelPosY", "Y-Axis", -5, 5, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbModelPosY(value)
	--update orb view
	  panel.updatePowerOrbModelPosY()
	end)
	return slider
  end

--create element health orb model rotation
  local createSliderHealthOrbModelRotation = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbModelRotation", "Rotation", -3.14, 3.14, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbModelRotation(value)
	--update orb view
	  panel.updateHealthOrbModelRotation()
	end)
	return slider
  end

--create element power orb model rotation
  local createSliderPowerOrbModelRotation = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbModelRotation", "Rotation", -3.14, 3.14, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbModelRotation(value)
	--update orb view
	  panel.updatePowerOrbModelRotation()
	end)
	return slider
  end

--create element health orb model zoom
  local createSliderHealthOrbModelZoom = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbModelZoom", "Portrait-Zoom", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbModelZoom(value)
	--update orb view
	  panel.updateHealthOrbModelZoom()
	end)
	return slider
  end

--create element power orb model zoom
  local createSliderPowerOrbModelZoom = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbModelZoom", "Portrait-Zoom", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbModelZoom(value)
	--update orb view
	  panel.updatePowerOrbModelZoom()
	end)
	return slider
  end

--create element health orb highlight alpha
  local createSliderHealthOrbHighlightAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbHighlightAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbHighlightAlpha(value)
	--update orb view
	  panel.updateHealthOrbHighlightAlpha()
	end)
	return slider
  end

--create element power orb highlight alpha
  local createSliderPowerOrbHighlightAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbHighlightAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbHighlightAlpha(value)
	--update orb view
	  panel.updatePowerOrbHighlightAlpha()
	end)
	return slider
  end

--create element health orb orbshadow alpha
  local createSliderHealthOrbOrbshadowAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbOrbshadowAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbOrbshadowAlpha(value)
	--update orb view
	  panel.updateHealthOrbOrbshadowAlpha()
	end)
	return slider
  end

--create element power orb orbshadow alpha
  local createSliderPowerOrbOrbshadowAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbOrbshadowAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbOrbshadowAlpha(value)
	--update orb view
	  panel.updatePowerOrbOrbshadowAlpha()
	end)
	return slider
  end

--create element health orb background alpha
  local createSliderHealthOrbBackgroundAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbBackgroundAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbBackgroundAlpha(value)
	--update orb view
	  panel.updateHealthOrbBackgroundAlpha()
	end)
	return slider
  end

--create element power orb background alpha
  local createSliderPowerOrbBackgroundAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbBackgroundAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbBackgroundAlpha(value)
	--update orb view
	  panel.updatePowerOrbBackgroundAlpha()
	end)
	return slider
  end

--create element health orb spark alpha
  local createSliderHealthOrbSparkAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbSparkAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbSparkAlpha(value)
	--update orb view
	  panel.updateHealthOrbSparkAlpha()
	end)
	return slider
  end

--create element power orb spark alpha
  local createSliderPowerOrbSparkAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbSparkAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbSparkAlpha(value)
	--update orb view
	  panel.updatePowerOrbSparkAlpha()
	end)
	return slider
  end

	--create element health orb bubbles alpha
   local createSliderHealthOrbBubblesAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbBubblesAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbBubblesAlpha(value)
	--update orb view
	  panel.updateHealthOrbBubblesAlpha()
	end)
	return slider
  end

--create element power orb bubbles alpha
  local createSliderPowerOrbBubblesAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbBubblesAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbBubblesAlpha(value)
	--update orb view
	  panel.updatePowerOrbBubblesAlpha()
	end)
	return slider
  end

	--create element health orb galaxies alpha
  local createSliderHealthOrbGalaxiesAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbGalaxiesAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbGalaxiesAlpha(value)
	--update orb view
	  panel.updateHealthOrbGalaxiesAlpha()
	end)
	return slider
  end

--create element power orb galaxies alpha
  local createSliderPowerOrbGalaxiesAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbGalaxiesAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbGalaxiesAlpha(value)
	--update orb view
	  panel.updatePowerOrbGalaxiesAlpha()
	end)
	return slider
  end

--create element health orb pic1s alpha
  local createSliderHealthOrbpic1sAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbpic1sAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbpic1sAlpha(value)
	--update orb view
	  panel.updateHealthOrbpic1sAlpha()
	end)
	return slider
  end

--create element power orb pic1s alpha
  local createSliderPowerOrbpic1sAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbpic1sAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbpic1sAlpha(value)
	--update orb view
	  panel.updatePowerOrbpic1sAlpha()
	end)
	return slider
  end

--create element health orb pic2s alpha
  local createSliderHealthOrbpic2sAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbpic2sAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbpic2sAlpha(value)
	--update orb view
	  panel.updateHealthOrbpic2sAlpha()
	end)
	return slider
  end

--create element power orb pic2s alpha
  local createSliderPowerOrbpic2sAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbpic2sAlpha", nil, 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbpic2sAlpha(value)
	--update orb view
	  panel.updatePowerOrbpic2sAlpha()
	end)
	return slider
  end

--create element health orb value hide empty
  local createCheckButtonHealthOrbValueHideEmpty = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelHealthOrbValueHideEmpty", "Hide on empty*")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.saveHealthOrbValueHideEmpty(self:GetChecked())
	end)
	return button
  end

--create element power orb value hide empty
  local createCheckButtonPowerOrbValueHideEmpty = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelPowerOrbValueHideEmpty", "Hide on empty*")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.savePowerOrbValueHideEmpty(self:GetChecked())
	end)
	return button
  end


--create element health orb value hide full
  local createCheckButtonHealthOrbValueHideFull = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelHealthOrbValueHideFull", "Hide on full*")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.saveHealthOrbValueHideFull(self:GetChecked())
	end)
	return button
  end

--create element power orb value hide full
  local createCheckButtonPowerOrbValueHideFull = function(parent)
	local button = createBasicCheckButton(parent, AddonName.."PanelPowerOrbValueHideFull", "Hide on full*")
	button:SetScript("OnClick", function(self, value)
	--save value
	  panel.savePowerOrbValueHideFull(self:GetChecked())
	end)
	return button
  end

--create element health orb value alpha
  local createSliderHealthOrbValueAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbValueAlpha", "Alpha", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbValueAlpha(value)
	--update orb view
	  panel.updateHealthOrbValueAlpha()
	end)
	return slider
  end

--create element power orb value alpha
  local createSliderPowerOrbValueAlpha = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbValueAlpha", "Alpha", 0, 1, 0.001)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbValueAlpha(value)
	--update orb view
	  panel.updatePowerOrbValueAlpha()
	end)
	return slider
  end

--create element health orb value top color
  local createPickerHealthOrbValueTopColor = function(parent)
	local picker = createBasicColorPicker(parent, AddonName.."PanelHealthOrbValueTopColor", "Text color", 60, 25)
	picker.click = function(r, g, b)
	--save value
	  panel.saveHealthOrbValueTopColor(r, g, b)
	--update orb view
	  panel.updateHealthOrbValueTopColor()
	end
	return picker
  end

--create element power orb value top color
  local createPickerPowerOrbValueTopColor = function(parent)
	local picker = createBasicColorPicker(parent, AddonName.."PanelPowerOrbValueTopColor", "Text color", 60, 25)
	picker.click = function(r, g, b)
	--save value
	  panel.savePowerOrbValueTopColor(r, g, b)
	--update orb view
	  panel.updatePowerOrbValueTopColor()
	end
	return picker
  end

--create element health orb value bottom color
  local createPickerHealthOrbValueBottomColor = function(parent)
	local picker = createBasicColorPicker(parent, AddonName.."PanelHealthOrbValueBottomColor", "Text color", 60, 25)
	picker.click = function(r, g, b)
	--save value
	  panel.saveHealthOrbValueBottomColor(r, g, b)
	--update orb view
	  panel.updateHealthOrbValueBottomColor()
	end
	return picker
  end

--create element power orb value bottom color
  local createPickerPowerOrbValueBottomColor = function(parent)
	local picker = createBasicColorPicker(parent, AddonName.."PanelPowerOrbValueBottomColor", "Text color", 60, 25)
	picker.click = function(r, g, b)
	--save value
	  panel.savePowerOrbValueBottomColor(r, g, b)
	--update orb view
	  panel.updatePowerOrbValueBottomColor()
	end
	return picker
  end

--create element health orb value top tag
  local createDropdownHealthOrbValueTopTag = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelHealthOrbValueTopTag", "Choose top health tag", db.getListTag, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.saveHealthOrbValueTopTag(self.value)
	--update orb view
	  panel.updateHealthOrbValueTopTag()
	end
	return dropdownMenu
  end

--create element power orb value top tag
  local createDropdownPowerOrbValueTopTag = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelPowerOrbValueTopTag", "Choose top power tag", db.getListTag, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.savePowerOrbValueTopTag(self.value)
	--update orb view
	  panel.updatePowerOrbValueTopTag()
	end
	return dropdownMenu
  end

--create element health orb value bottom tag
  local createDropdownHealthOrbValueBottomTag = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelHealthOrbValueBottomTag", "Choose bottom health tag", db.getListTag, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.saveHealthOrbValueBottomTag(self.value)
	--update orb view
	  panel.updateHealthOrbValueBottomTag()
	end
	return dropdownMenu
  end

--create element power orb value bottom tag
  local createDropdownPowerOrbValueBottomTag = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelPowerOrbValueBottomTag", "Choose bottom power tag", db.getListTag, 196)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	--save value
	  panel.savePowerOrbValueBottomTag(self.value)
	--update orb view
	  panel.updatePowerOrbValueBottomTag()
	end
	return dropdownMenu
  end


---new-------

  local createSliderHealthOrbValueTopScale = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbValueTopScale", "Text scale", 0.5, 2, 0.1)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbValueTopScale(value)
	--update orb view
	  panel.updateHealthOrbValueTopScale()
	end)
	return slider
  end

  local createSliderPowerOrbValueTopScale = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbValueTopScale", "Text scale", 0.5, 2, 0.1)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbValueTopScale(value)
	--update orb view
	  panel.updatePowerOrbValueTopScale()
	end)
	return slider
  end

  local createSliderHealthOrbValueBottomScale = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelHealthOrbValueBottomScale", "Text scale", 0.5, 2, 0.1)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.saveHealthOrbValueBottomScale(value)
	--update orb view
	  panel.updateHealthOrbValueBottomScale()
	end)
	return slider
  end

  local createSliderPowerOrbValueBottomScale = function(parent)
	local slider = createBasicSlider(parent, AddonName.."PanelPowerOrbValueBottomScale", "Text scale", 0.5, 2, 0.1)
	slider:HookScript("OnValueChanged", function(self, value)
	--save value
	  panel.savePowerOrbValueBottomScale(value)
	--update orb view
	  panel.updatePowerOrbValueBottomScale()
	end)
	return slider
  end


---------------------------------------------
--CREATE BOTTOM PANEL ELEMENT FUNCTIONS
---------------------------------------------

--createBottomButtonHealthOrbSave
  local createBottomButtonHealthOrbSave = function(parent)
	--the save button needs a popup with an editbox
	StaticPopupDialogs["Diablo_HEALTHORB_SAVE"] = {
	  text = "Enter a name for your template:",
	  button1 = ACCEPT,
	  button2 = CANCEL,
	  hasEditBox = 1,
	  maxLetters = 24,
	  OnAccept = function(self)
		local text = self.EditBox:GetText()
		text = text:gsub("", "")
		if strmatch(text, "%W") then
		  print("|c00FF0000ERROR: Template could not be saved.Non-alphanumerical values found!")
		elseif strlen(text) == 0 then
		  print("|c00FF0000ERROR: Template name is empty!")
		else
		  db.saveTemplate(text, "HEALTH")
		end
	  end,
	  EditBoxOnEnterPressed = function(self)
		local text = self:GetParent().EditBox:GetText()
		text = text:gsub("", "")
		if strmatch(text, "%W") then
		  print("|c00FF0000ERROR: Template could not be saved.Non-alphanumerical values found!")
		elseif strlen(text) == 0 then
		  print("|c00FF0000ERROR: Template name is empty!")
		else
		  db.saveTemplate(text, "HEALTH")
		  self:GetParent():Hide()
		end
	  end,
	  OnShow = function(self)
		self.EditBox:SetFocus()
		panel:SetAlpha(0.2)
	  end,
	  OnHide = function(self)
		ChatEdit_FocusActiveWindow()
		self.EditBox:SetText("")
		panel:SetAlpha(1)
	  end,
	  timeout = 0,
	  exclusive = 1,
	  whileDead = 1,
	  hideOnEscape = 1,
	  preferredIndex = 3,
	}
	local button = createBasicButton(parent, AddonName.."PanelBottomHealthOrbSave", " Save")
	button:HookScript("OnClick", function()
	  StaticPopup_Show("Diablo_HEALTHORB_SAVE")
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to save the current health orb settings as a template.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonHealthOrbLoad
  local createBottomButtonHealthOrbLoad = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelHealthOrbLoadTemplate", "Choose template", db.getListTemplate, nil, nil, true)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	  db.loadTemplate(self.value, "HEALTH")
	end
	local button = createBasicButton(parent, AddonName.."PanelBottomHealthOrbLoad", " Load")
	button:HookScript("OnClick", function()
	  ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", -80, -5)
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to load a template into your health orb.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonHealthOrbReset
  local createBottomButtonHealthOrbReset = function(parent)
	local button = createBasicButton(parent, AddonName.."PanelBottomHealthOrbReset", " Reset")
	button:HookScript("OnClick", function()
	  db.loadCharacterDataDefaults("HEALTH")
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to reset the healthorb to default.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonPowerOrbSave
  local createBottomButtonPowerOrbSave = function(parent)
	--the save button needs a popup with an editbox
	StaticPopupDialogs["Diablo_POWERORB_SAVE"] = {
	  text = "Enter a name for your template:",
	  button1 = ACCEPT,
	  button2 = CANCEL,
	  hasEditBox = 1,
	  maxLetters = 24,
	  OnAccept = function(self)
		local text = self.EditBox:GetText()
		text = text:gsub("", "")
		if strmatch(text, "%W") then
		  print("|c00FF0000ERROR: Template could not be saved.Non-alphanumerical values found!")
		elseif strlen(text) == 0 then
		  print("|c00FF0000ERROR: Template name is empty!")
		else
		  db.saveTemplate(text, "POWER")
		end
	  end,
	  EditBoxOnEnterPressed = function(self)
		local text = self:GetParent().EditBox:GetText()
		text = text:gsub("", "")
		if strmatch(text, "%W") then
		  print("|c00FF0000ERROR: Template could not be saved.Non-alphanumerical values found!")
		elseif strlen(text) == 0 then
		  print("|c00FF0000ERROR: Template name is empty!")
		else
		  db.saveTemplate(text, "POWER")
		  self:GetParent():Hide()
		end
	  end,
	  OnShow = function(self)
		self.EditBox:SetFocus()
		panel:SetAlpha(0.2)
	  end,
	  OnHide = function(self)
		ChatEdit_FocusActiveWindow()
		self.EditBox:SetText("")
		panel:SetAlpha(1)
	  end,
	  timeout = 0,
	  exclusive = 1,
	  whileDead = 1,
	  hideOnEscape = 1,
	  preferredIndex = 3,
	}
	local button = createBasicButton(parent, AddonName.."PanelBottomPowerOrbSave", " Save")
	button:HookScript("OnClick", function()
	  StaticPopup_Show("Diablo_POWERORB_SAVE")
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to save the current power orb settings as a template.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonPowerOrbLoad
  local createBottomButtonPowerOrbLoad = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelPowerOrbLoadTemplate", "Choose template", db.getListTemplate, nil, nil, true)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	  db.loadTemplate(self.value, "POWER")
	end
	local button = createBasicButton(parent, AddonName.."PanelBottomPowerOrbLoad", " Load")
	button:HookScript("OnClick", function()
	  ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", -80, -5)
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to load a template into your power orb.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonPowerOrbReset
  local createBottomButtonPowerOrbReset = function(parent)
	local button = createBasicButton(parent, AddonName.."PanelBottomPowerOrbReset", " Reset")
	button:HookScript("OnClick", function()
	  db.loadCharacterDataDefaults("POWER")
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to reset the powerorb to default.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonTemplateDelete
  local createBottomButtonTemplateDelete = function(parent)
	local dropdownMenu = createBasicDropDownMenu(parent, AddonName.."PanelBottomDeleteTemplate", "Choose template", db.getListTemplate, nil, nil, true)
	dropdownMenu.click = function(self)
	  UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
	  db.deleteTemplate(self.value)
	end
	local button = createBasicButton(parent, AddonName.."PanelBottomTemplateDelete", "Delete")
	button:HookScript("OnClick", function()
	  ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", -80, -5)
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to delete a template from the database.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonTemplateReload
  local createBottomButtonTemplateReload = function(parent)
	local button = createBasicButton(parent, AddonName.."PanelBottomTemplateReload", " RL")
	button:HookScript("OnClick", function()
	  db.char.reload = true
	  ReloadUI()
	end)
	button:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOP")
	  GameTooltip:AddLine("Click here to reload the user interface.", 0, 1, 0.5, 1, 1, 1)
	  GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
  end

--createBottomButtonTemplateReset
  local createBottomButtonTemplateReset = function(parent)
	local button = createBasicButton(parent, AddonName.."PanelBottomTemplateReset", " RE")
	--   button:SetWidth(32)
	--   button:SetHeight(21)
	button:HookScript("OnClick", function()
		DiabloReset()
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine("Click here to Reset All Position", 0, 1, 0.5, 1, 1, 1)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	return button
	end

---------------------------------------------
--SPAWN PANEL ELEMENTS
---------------------------------------------
--create master headline
  panel.elementHealthMasterHeadline = createBasicFontString(panel, nil, nil, "GameFontNormalLarge", "Health Orb")
  panel.elementPowerMasterHeadline = createBasicFontString(panel, nil, nil, "GameFontNormalLarge", "Power Orb")
--create Orb scale slider
  panel.elementOrbScale = createSliderOrbScale(panel)
--create filling headline
  panel.elementHealthFillingHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Filling Texture")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthFillingHeadline, "The following options allow you to edit the filling orb.")
  panel.elementPowerFillingHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Filling Texture")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerFillingHeadline, "The following options allow you to edit the filling orb.")
--create filling alpha slider
  panel.elementHealthOrbFillingAlpha = createSliderHealthOrbFillingAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingAlpha = createSliderPowerOrbFillingAlpha(panel.scrollFrame.scrollChild)
--create textureframe headline
  panel.elementHealthTextureFrameHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "TextureFrame Size")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthTextureFrameHeadline, "Resizing the demon model.")
  panel.elementPowerTextureFrameHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "TextureFrame Size")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerTextureFrameHeadline, "Resizing the angel model.")
--create textureframe scale slider
  panel.elementHealthTextureFrameSize = createSliderHealthTextureFrameSize(panel.scrollFrame.scrollChild)
  panel.elementPowerTextureFrameSize = createSliderPowerTextureFrameSize(panel.scrollFrame.scrollChild)
--create filling texture dropdowns
  panel.elementHealthOrbFillingTexture = createDropdownHealthOrbFillingTexture(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingTexture = createDropdownPowerOrbFillingTexture(panel.scrollFrame.scrollChild)
--create orbgrid enable checkbutton
  panel.elementHealthOrbGridEnable = createCheckButtonHealthOrbGridEnable(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbGridEnable = createCheckButtonPowerOrbGridEnable(panel.scrollFrame.scrollChild)
--create filling color auto checkbutton
  panel.elementHealthOrbFillingColorAuto = createCheckButtonHealthOrbFillingColorAuto(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingColorAuto = createCheckButtonPowerOrbFillingColorAuto(panel.scrollFrame.scrollChild)
--create filling color picker
  panel.elementHealthOrbFillingColor = createPickerHealthOrbFillingColor(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingColor = createPickerPowerOrbFillingColor(panel.scrollFrame.scrollChild)
--create model headline
  panel.elementHealthModelHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Model Animation")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthModelHeadline, "This feature is currently a WIP.Enable at your own risk.")
  panel.elementPowerModelHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Model Animation")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerModelHeadline, "This feature is currently a WIP.Enable at your own risk.")
--create model enable checkbutton
  panel.elementHealthOrbModelEnable = createCheckButtonHealthOrbModelEnable(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelEnable = createCheckButtonPowerOrbModelEnable(panel.scrollFrame.scrollChild)
--create model animated checkbutton
  panel.elementHealthOrbModelAnimated = createCheckButtonHealthOrbModelAnimated(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelAnimated = createCheckButtonPowerOrbModelAnimated(panel.scrollFrame.scrollChild)
--create model animation dropdown
  panel.elementHealthOrbModelAnimation = createDropdownHealthOrbModelAnimation(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelAnimation = createDropdownPowerOrbModelAnimation(panel.scrollFrame.scrollChild)
--create model alpha slider
  panel.elementHealthOrbModelAlpha = createSliderHealthOrbModelAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelAlpha = createSliderPowerOrbModelAlpha(panel.scrollFrame.scrollChild)
--create model scale slider
  panel.elementHealthOrbModelCDS = createSliderHealthOrbModelCDS(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelCDS = createSliderPowerOrbModelCDS(panel.scrollFrame.scrollChild)
--create model pos x slider
  panel.elementHealthOrbModelPosX = createSliderHealthOrbModelPosX(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelPosX = createSliderPowerOrbModelPosX(panel.scrollFrame.scrollChild)
--create model pos y slider
  panel.elementHealthOrbModelPosY = createSliderHealthOrbModelPosY(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelPosY = createSliderPowerOrbModelPosY(panel.scrollFrame.scrollChild)
--create model rotation slider
  panel.elementHealthOrbModelRotation = createSliderHealthOrbModelRotation(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelRotation = createSliderPowerOrbModelRotation(panel.scrollFrame.scrollChild)
--create model zoom slider
  panel.elementHealthOrbModelZoom = createSliderHealthOrbModelZoom(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelZoom = createSliderPowerOrbModelZoom(panel.scrollFrame.scrollChild)
--create highlight headline
  panel.elementHealthHighlightHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Highlight Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthHighlightHeadline, "The following option allows you to adjust the opacity of the highlight texture.")
  panel.elementPowerHighlightHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Highlight Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerHighlightHeadline, "The following option allows you to adjust the opacity of the highlight texture.")
--create highlight alpha slider
  panel.elementHealthOrbHighlightAlpha = createSliderHealthOrbHighlightAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbHighlightAlpha = createSliderPowerOrbHighlightAlpha(panel.scrollFrame.scrollChild)
--create orbshadow headline
  panel.elementHealthOrbshadowHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Orbshadow Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthOrbshadowHeadline, "The following option allows you to adjust the opacity of the orbshadow texture.")
  panel.elementPowerOrbshadowHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Orbshadow Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerOrbshadowHeadline, "The following option allows you to adjust the opacity of the orbshadow texture.")
--create orbshadow alpha slider
  panel.elementHealthOrbOrbshadowAlpha = createSliderHealthOrbOrbshadowAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbOrbshadowAlpha = createSliderPowerOrbOrbshadowAlpha(panel.scrollFrame.scrollChild)
--create background headline
  panel.elementHealthBackgroundHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Background Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthBackgroundHeadline, "The following option allows you to adjust the opacity of the background texture.")
  panel.elementPowerBackgroundHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Background Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerBackgroundHeadline, "The following option allows you to adjust the opacity of the background texture.")
--create background alpha slider
  panel.elementHealthOrbBackgroundAlpha = createSliderHealthOrbBackgroundAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbBackgroundAlpha = createSliderPowerOrbBackgroundAlpha(panel.scrollFrame.scrollChild)
--create bubbles headline
  panel.elementHealthBubblesHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "bubbles Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthBubblesHeadline, "The following option allows you to adjust the opacity of the rotating bubble textures.")
  panel.elementPowerBubblesHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "bubbles Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerBubblesHeadline, "The following option allows you to adjust the opacity of the rotating bubble textures.")
--create bubbles alpha slider
  panel.elementHealthOrbBubblesAlpha = createSliderHealthOrbBubblesAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbBubblesAlpha = createSliderPowerOrbBubblesAlpha(panel.scrollFrame.scrollChild)
--create galaxies headline
  panel.elementHealthGalaxiesHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "galaxies Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthGalaxiesHeadline, "The following option allows you to adjust the opacity of the rotating galaxy textures.")
  panel.elementPowerGalaxiesHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "galaxies Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerGalaxiesHeadline, "The following option allows you to adjust the opacity of the rotating galaxy textures.")
--create galaxies alpha slider
  panel.elementHealthOrbGalaxiesAlpha = createSliderHealthOrbGalaxiesAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbGalaxiesAlpha = createSliderPowerOrbGalaxiesAlpha(panel.scrollFrame.scrollChild)
--create pic1s headline
  panel.elementHealthpic1sHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "pic1s Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthpic1sHeadline, "The following option allows you to adjust the opacity of the rotating pics textures.")
  panel.elementPowerpic1sHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "pic1s Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerpic1sHeadline, "The following option allows you to adjust the opacity of the rotating pics textures.")
--create pic1s alpha slider
  panel.elementHealthOrbpic1sAlpha = createSliderHealthOrbpic1sAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbpic1sAlpha = createSliderPowerOrbpic1sAlpha(panel.scrollFrame.scrollChild)
--create pic2s headline
  panel.elementHealthpic2sHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "pic2s Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthpic2sHeadline, "The following option allows you to adjust the opacity of the rotating pics textures.")
  panel.elementPowerpic2sHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "pic2s Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerpic2sHeadline, "The following option allows you to adjust the opacity of the rotating pics textures.")
--create pic2s alpha slider
  panel.elementHealthOrbpic2sAlpha = createSliderHealthOrbpic2sAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbpic2sAlpha = createSliderPowerOrbpic2sAlpha(panel.scrollFrame.scrollChild)
--create spark headline
  panel.elementHealthSparkHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Spark Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthSparkHeadline, "The following option allows you to adjust the opacity of the spark texture.\n|cFFFFFFFFThe texture helps blending the filling texture.")
  panel.elementPowerSparkHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Spark Alpha")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerSparkHeadline, "The following option allows you to adjust the opacity of the spark texture.\n|cFFFFFFFFThe texture helps blending the filling texture.")
--create spark alpha slider
  panel.elementHealthOrbSparkAlpha = createSliderHealthOrbSparkAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbSparkAlpha = createSliderPowerOrbSparkAlpha(panel.scrollFrame.scrollChild)
--create value headline
  panel.elementHealthOrbValueHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Orb Value Visibility")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthOrbValueHeadline, "The following options allow you adjust the orb values.\n|cFFFFFFFF*Some changes will only become visible on config panel close otherwise it would be impossible to set up the orb values.")
  panel.elementPowerOrbValueHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Orb Value Visibility")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerOrbValueHeadline, "The following options allow you adjust the orb values.\n|cFFFFFFFF*Some changes will only become visible on config panel close otherwise it would be impossible to set up the orb values.")
--create element value hide empty checkbutton
  panel.elementHealthOrbValueHideEmpty = createCheckButtonHealthOrbValueHideEmpty(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueHideEmpty = createCheckButtonPowerOrbValueHideEmpty(panel.scrollFrame.scrollChild)
--create element value hide full checkbutton
  panel.elementHealthOrbValueHideFull = createCheckButtonHealthOrbValueHideFull(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueHideFull = createCheckButtonPowerOrbValueHideFull(panel.scrollFrame.scrollChild)
--create element value alpha slider
  panel.elementHealthOrbValueAlpha = createSliderHealthOrbValueAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueAlpha = createSliderPowerOrbValueAlpha(panel.scrollFrame.scrollChild)
--create value top headline
  panel.elementHealthOrbValueTopHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Top Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthOrbValueTopHeadline, "The following options allow you adjust color and tag of the top orb value.")
  panel.elementPowerOrbValueTopHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Top Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerOrbValueTopHeadline, "The following options allow you adjust color and tag of the top orb value.")
--create element value top tag dropdown
  panel.elementHealthOrbValueTopTag = createDropdownHealthOrbValueTopTag(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueTopTag = createDropdownPowerOrbValueTopTag(panel.scrollFrame.scrollChild)
--create element value top color picker
  panel.elementHealthOrbValueTopColor = createPickerHealthOrbValueTopColor(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueTopColor = createPickerPowerOrbValueTopColor(panel.scrollFrame.scrollChild)
--create value top headline
  panel.elementHealthOrbValueBottomHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Bottom Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementHealthOrbValueBottomHeadline, "The following options allow you adjust color and tag of the bottom orb value.")
  panel.elementPowerOrbValueBottomHeadline = createBasicFontString(panel.scrollFrame.scrollChild, nil, nil, "GameFontNormalLarge", "Bottom Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild, panel.elementPowerOrbValueBottomHeadline, "The following options allow you adjust color and tag of the bottom orb value.")
--create element value bottom tag dropdown
  panel.elementHealthOrbValueBottomTag = createDropdownHealthOrbValueBottomTag(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueBottomTag = createDropdownPowerOrbValueBottomTag(panel.scrollFrame.scrollChild)
--create element value bottom color picker
  panel.elementHealthOrbValueBottomColor = createPickerHealthOrbValueBottomColor(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueBottomColor = createPickerPowerOrbValueBottomColor(panel.scrollFrame.scrollChild)

---new-------
  panel.elementHealthOrbValueTopScale = createSliderHealthOrbValueTopScale(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueTopScale = createSliderPowerOrbValueTopScale(panel.scrollFrame.scrollChild)
  panel.elementHealthOrbValueBottomScale = createSliderHealthOrbValueBottomScale(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueBottomScale = createSliderPowerOrbValueBottomScale(panel.scrollFrame.scrollChild)

---------------------------------------------
--SPAWN HEADLINE BACKGROUNDS
---------------------------------------------

  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthFillingHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerFillingHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthTextureFrameHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerTextureFrameHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthModelHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerModelHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthHighlightHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerHighlightHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthOrbshadowHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerOrbshadowHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthBackgroundHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerBackgroundHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthpic1sHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerpic1sHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthpic2sHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerpic2sHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthGalaxiesHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerGalaxiesHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthBubblesHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerBubblesHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthSparkHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerSparkHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthOrbValueHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerOrbValueHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthOrbValueTopHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerOrbValueTopHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementHealthOrbValueBottomHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild, panel.elementPowerOrbValueBottomHeadline)

---------------------------------------------
--SPAWN BOTTOM PANEL BUTTONS
---------------------------------------------

--createBottomButtonHealthOrbSave
  panel.bottomElementHealthOrbSave = createBottomButtonHealthOrbSave(panel)
--createBottomButtonHealthOrbLoad
  panel.bottomElementHealthOrbLoad = createBottomButtonHealthOrbLoad(panel)
--createBottomButtonHealthOrbReset
  panel.bottomElementHealthOrbReset = createBottomButtonHealthOrbReset(panel)
--createBottomButtonPowerOrbSave
  panel.bottomElementPowerOrbSave = createBottomButtonPowerOrbSave(panel)
--createBottomButtonPowerOrbLoad
  panel.bottomElementPowerOrbLoad = createBottomButtonPowerOrbLoad(panel)
--createBottomButtonPowerOrbReset
  panel.bottomElementPowerOrbReset = createBottomButtonPowerOrbReset(panel)
--createBottomButtonTemplateDelete
  panel.bottomElementTemplateDelete = createBottomButtonTemplateDelete(panel)
--createBottomButtonTemplateReload
  panel.bottomElementTemplateReload = createBottomButtonTemplateReload(panel)
--createBottomButtonTemplateReset
  panel.bottomElementTemplateReset = createBottomButtonTemplateReset(panel)

---------------------------------------------
--POSITION PANEL ELEMENTS
---------------------------------------------
----position master headline
--panel.elementHealthMasterHeadline:SetPoint("TOPLEFT", panel, "TOPLEFT", 95, -35)
--panel.elementPowerMasterHeadline:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -113, -35)
--position master headline
  panel.elementHealthMasterHeadline:SetPoint("BOTTOM", panel.scrollFrame, "TOP", (-panel.scrollFrame:GetWidth()/2-2)/3-7, 7)
  panel.elementHealthMasterHeadline:SetScale(1.5)
  panel.elementPowerMasterHeadline:SetScale(1.5)
  panel.elementPowerMasterHeadline:SetPoint("BOTTOM", panel.scrollFrame, "TOP", (panel.scrollFrame:GetWidth()/2-2)/3+9, 7)
--position orb scale
  panel.elementOrbScale:SetPoint("TOP", panel.scrollFrame, 0, 21)
--position filling headline
  panel.elementHealthFillingHeadline:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild.leftTexture, 29, -10)
  panel.elementPowerFillingHeadline:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild.rightTexture, 29, -10)
--position filling texture dropdown
  panel.elementHealthOrbFillingTexture:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbFillingTexture:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -20, -10)
--position filling orbgrid checkbutton
  panel.elementHealthOrbGridEnable:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -4, -42)
  panel.elementPowerOrbGridEnable:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -4, -42)
--position filling color auto checkbutton
  panel.elementHealthOrbFillingColorAuto:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -4, -66)
  panel.elementPowerOrbFillingColorAuto:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -4, -66)
--position filling color picker
  panel.elementHealthOrbFillingColor:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -3, -90)
  panel.elementPowerOrbFillingColor:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -3, -90)
--position filling alpha slider
  panel.elementHealthOrbFillingAlpha:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", 0, -135)
  panel.elementPowerOrbFillingAlpha:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", 0, -135)
--position galaxies headline
  panel.elementHealthTextureFrameHeadline:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", 0, -165)
  panel.elementPowerTextureFrameHeadline:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", 0, -165)
--position textureframe Size slider
  panel.elementHealthTextureFrameSize:SetPoint("TOPLEFT", panel.elementHealthTextureFrameHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerTextureFrameSize:SetPoint("TOPLEFT", panel.elementPowerTextureFrameHeadline, "BOTTOMLEFT", 0, -10)
--position model headline
  panel.elementHealthModelHeadline:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", 0, -220)
  panel.elementPowerModelHeadline:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", 0, -220)
--position model enable checkbutton
  panel.elementHealthOrbModelEnable:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -4, -10)
  panel.elementPowerOrbModelEnable:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -4, -10)
--position model animated checkbutton
  panel.elementHealthOrbModelAnimated:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 116, -10)
  panel.elementPowerOrbModelAnimated:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 116, -10)
--position model animation dropdown
  panel.elementHealthOrbModelAnimation:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -20, -36)
  panel.elementPowerOrbModelAnimation:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -20, -36)
--position model alpha slider
  panel.elementHealthOrbModelAlpha:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -80)
  panel.elementPowerOrbModelAlpha:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -80)
--position model scale slider
  panel.elementHealthOrbModelCDS:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -110)
  panel.elementPowerOrbModelCDS:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -110)
--position model pos x slider
  panel.elementHealthOrbModelPosX:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -140)
  panel.elementPowerOrbModelPosX:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -140)
--position model pos y slider
  panel.elementHealthOrbModelPosY:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -170)
  panel.elementPowerOrbModelPosY:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -170)
--position model rotation slider
  panel.elementHealthOrbModelRotation:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -200)
  panel.elementPowerOrbModelRotation:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -200)
--position model zoom slider
  panel.elementHealthOrbModelZoom:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -230)
  panel.elementPowerOrbModelZoom:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -230)
--position highlight headline
  panel.elementHealthHighlightHeadline:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerHighlightHeadline:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -10)
--position highlight alpha slider
  panel.elementHealthOrbHighlightAlpha:SetPoint("TOPLEFT", panel.elementHealthHighlightHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbHighlightAlpha:SetPoint("TOPLEFT", panel.elementPowerHighlightHeadline, "BOTTOMLEFT", 0, -10)
--position orbshadow headline
  panel.elementHealthOrbshadowHeadline:SetPoint("TOPLEFT", panel.elementHealthHighlightHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerOrbshadowHeadline:SetPoint("TOPLEFT", panel.elementPowerHighlightHeadline, "BOTTOMLEFT", 0, -37)
--position orbshadow alpha slider
  panel.elementHealthOrbOrbshadowAlpha:SetPoint("TOPLEFT", panel.elementHealthOrbshadowHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbOrbshadowAlpha:SetPoint("TOPLEFT", panel.elementPowerOrbshadowHeadline, "BOTTOMLEFT", 0, -10)
--position background headline
  panel.elementHealthBackgroundHeadline:SetPoint("TOPLEFT", panel.elementHealthOrbshadowHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerBackgroundHeadline:SetPoint("TOPLEFT", panel.elementPowerOrbshadowHeadline, "BOTTOMLEFT", 0, -37)
--position background alpha slider
  panel.elementHealthOrbBackgroundAlpha:SetPoint("TOPLEFT", panel.elementHealthBackgroundHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbBackgroundAlpha:SetPoint("TOPLEFT", panel.elementPowerBackgroundHeadline, "BOTTOMLEFT", 0, -10)
--position bubbles headline
  panel.elementHealthBubblesHeadline:SetPoint("TOPLEFT", panel.elementHealthBackgroundHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerBubblesHeadline:SetPoint("TOPLEFT", panel.elementPowerBackgroundHeadline, "BOTTOMLEFT", 0, -37)
--position bubbles alpha slider
  panel.elementHealthOrbBubblesAlpha:SetPoint("TOPLEFT", panel.elementHealthBubblesHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbBubblesAlpha:SetPoint("TOPLEFT", panel.elementPowerBubblesHeadline, "BOTTOMLEFT", 0, -10)
--position galaxies headline
  panel.elementHealthGalaxiesHeadline:SetPoint("TOPLEFT", panel.elementHealthBubblesHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerGalaxiesHeadline:SetPoint("TOPLEFT", panel.elementPowerBubblesHeadline, "BOTTOMLEFT", 0, -37)
--position galaxies alpha slider
  panel.elementHealthOrbGalaxiesAlpha:SetPoint("TOPLEFT", panel.elementHealthGalaxiesHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbGalaxiesAlpha:SetPoint("TOPLEFT", panel.elementPowerGalaxiesHeadline, "BOTTOMLEFT", 0, -10)
--position pic1s headline
  panel.elementHealthpic1sHeadline:SetPoint("TOPLEFT", panel.elementHealthGalaxiesHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerpic1sHeadline:SetPoint("TOPLEFT", panel.elementPowerGalaxiesHeadline, "BOTTOMLEFT", 0, -37)
--position pic1s alpha slider
  panel.elementHealthOrbpic1sAlpha:SetPoint("TOPLEFT", panel.elementHealthpic1sHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbpic1sAlpha:SetPoint("TOPLEFT", panel.elementPowerpic1sHeadline, "BOTTOMLEFT", 0, -10)
--position pic2s headline
  panel.elementHealthpic2sHeadline:SetPoint("TOPLEFT", panel.elementHealthpic1sHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerpic2sHeadline:SetPoint("TOPLEFT", panel.elementPowerpic1sHeadline, "BOTTOMLEFT", 0, -37)
--position pic2s alpha slider
  panel.elementHealthOrbpic2sAlpha:SetPoint("TOPLEFT", panel.elementHealthpic2sHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbpic2sAlpha:SetPoint("TOPLEFT", panel.elementPowerpic2sHeadline, "BOTTOMLEFT", 0, -10)
--position spark headline
  panel.elementHealthSparkHeadline:SetPoint("TOPLEFT", panel.elementHealthpic2sHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerSparkHeadline:SetPoint("TOPLEFT", panel.elementPowerpic2sHeadline, "BOTTOMLEFT", 0, -37)
--position spark alpha slider
  panel.elementHealthOrbSparkAlpha:SetPoint("TOPLEFT", panel.elementHealthSparkHeadline, "BOTTOMLEFT", 0, -10)
  panel.elementPowerOrbSparkAlpha:SetPoint("TOPLEFT", panel.elementPowerSparkHeadline, "BOTTOMLEFT", 0, -10)
--position value headline
  panel.elementHealthOrbValueHeadline:SetPoint("TOPLEFT", panel.elementHealthSparkHeadline, "BOTTOMLEFT", 0, -37)
  panel.elementPowerOrbValueHeadline:SetPoint("TOPLEFT", panel.elementPowerSparkHeadline, "BOTTOMLEFT", 0, -37)
--position element value hide empty checkbutton
  panel.elementHealthOrbValueHideEmpty:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", -4, -10)
  panel.elementPowerOrbValueHideEmpty:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", -4, -10)
--position element value hide full checkbutton
  panel.elementHealthOrbValueHideFull:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", -4, -35)
  panel.elementPowerOrbValueHideFull:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", -4, -35)
--position element value alpha slider
  panel.elementHealthOrbValueAlpha:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", 0, -73)
  panel.elementPowerOrbValueAlpha:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", 0, -73)
--position element value top headline
  panel.elementHealthOrbValueTopHeadline:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", 0, -110)
  panel.elementPowerOrbValueTopHeadline:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", 0, -110)
--position element value top tag dropdown
  panel.elementHealthOrbValueTopTag:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbValueTopTag:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", -20, -10)
--position element value top color picker
  panel.elementHealthOrbValueTopColor:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", 0, -45)
  panel.elementPowerOrbValueTopColor:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", 0, -45)


---new-------
  panel.elementHealthOrbValueTopScale:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", 0, -88)
  panel.elementPowerOrbValueTopScale:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", 0, -88)


--position element value bottom headline
  panel.elementHealthOrbValueBottomHeadline:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", 0, -120)
  panel.elementPowerOrbValueBottomHeadline:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", 0, -120)
--position element value bottom tag dropdown
  panel.elementHealthOrbValueBottomTag:SetPoint("TOPLEFT", panel.elementHealthOrbValueBottomHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbValueBottomTag:SetPoint("TOPLEFT", panel.elementPowerOrbValueBottomHeadline, "BOTTOMLEFT", -20, -10)
--position element value bottom color picker
  panel.elementHealthOrbValueBottomColor:SetPoint("TOPLEFT", panel.elementHealthOrbValueBottomHeadline, "BOTTOMLEFT", 0, -45)
  panel.elementPowerOrbValueBottomColor:SetPoint("TOPLEFT", panel.elementPowerOrbValueBottomHeadline, "BOTTOMLEFT", 0, -45)


---new-------
  panel.elementHealthOrbValueBottomScale:SetPoint("TOPLEFT", panel.elementHealthOrbValueBottomHeadline, "BOTTOMLEFT", 0, -88)
  panel.elementPowerOrbValueBottomScale:SetPoint("TOPLEFT", panel.elementPowerOrbValueBottomHeadline, "BOTTOMLEFT", 0, -88)


---------------------------------------------
--POSITION BOTTOM PANEL BUTTONS
---------------------------------------------

--position the delete button
  panel.bottomElementTemplateDelete:SetPoint("BOTTOM", 0, 2)
--health orb reset/save/load
  panel.bottomElementHealthOrbReset:SetPoint("RIGHT", panel.bottomElementTemplateDelete, "LEFT", -80, 0)
  panel.bottomElementHealthOrbSave:SetPoint("RIGHT", panel.bottomElementHealthOrbReset, "LEFT", -2, 0)
  panel.bottomElementHealthOrbLoad:SetPoint("LEFT", panel.bottomElementHealthOrbReset, "RIGHT", 2, 0)
  panel.bottomElementHealthOrbReset:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  panel.bottomElementHealthOrbSave:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  panel.bottomElementHealthOrbLoad:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
--power orb reset/save/load
  panel.bottomElementPowerOrbReset:SetPoint("LEFT", panel.bottomElementTemplateDelete, "RIGHT", 80, 0)
  panel.bottomElementPowerOrbSave:SetPoint("LEFT", panel.bottomElementPowerOrbReset, "RIGHT", 2, 0)
  panel.bottomElementPowerOrbLoad:SetPoint("RIGHT", panel.bottomElementPowerOrbReset, "LEFT", -2, 0)
  panel.bottomElementPowerOrbReset:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  panel.bottomElementPowerOrbSave:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  panel.bottomElementPowerOrbLoad:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)

--position the reload ui button
  panel.bottomElementTemplateReload:SetPoint("BOTTOMRIGHT", -2, 2)

--position the Reset ui button
  panel.bottomElementTemplateReset:SetPoint("BOTTOMLEFT", 2, 2)	--("TOPRIGHT", -24, -0.5)
  panel.bottomElementTemplateReset:SetFrameLevel(panel.TitleContainer:GetFrameLevel()+2)

---------------------------------------------
--UPDATE ORB ELEMENTS
---------------------------------------------

--update health orb filling texture
  panel.updateHealthOrbFillingTexture = function()
	ns.HealthOrb.filling:SetStatusBarTexture(panel.loadHealthOrbFillingTexture())
	ns.HealthOrb.filling2:SetTexture(panel.loadHealthOrbFillingTexture())
  end

--update power orb filling texture
  panel.updatePowerOrbFillingTexture = function()
	ns.PowerOrb.filling:SetStatusBarTexture(panel.loadPowerOrbFillingTexture())
  end

--update OrbScale scale
  panel.updateOrbScale = function()
	if InCombatLockdown() then return end
	DiabloPlayerFrame:SetScale(panel.loadOrbScale())
  end

--update health orbgrid model enable
  panel.updateHealthOrbGridEnable = function()
	if panel.loadHealthOrbGridEnable() then
	  ns.HealthOrb.grid:SetAlpha(1)
	  ns.HealthOrb.grid:Show()
	else
	  ns.HealthOrb.grid:Hide()
	end
  end

--update power orbgrid model enable
  panel.updatePowerOrbGridEnable = function()
	if panel.loadPowerOrbGridEnable() then
	  ns.PowerOrb.grid:SetAlpha(1)
	  ns.PowerOrb.grid:Show()
	else
	  ns.PowerOrb.grid:Hide()
	end
  end

--update health orb filling color auto
  panel.updateHealthOrbFillingColorAuto = function()
	if panel.loadHealthOrbFillingColorAuto() then

		ns.HealthOrb.filling.colorClass = false
		ns.HealthOrb.filling.colorHealth = false
		local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass("player"))] or { r = 0.5, g = 0, b = 0, }
		ns.HealthOrb.filling:SetStatusBarColor(color.r,color.g,color.b)
		ns.HealthOrb.filling:ForceUpdate()
		panel.scrollFrame.scrollChild.leftTexture:SetVertexColor(color.r,color.g,color.b)
		panel.elementHealthMasterHeadline:SetTextColor(color.r,color.g,color.b)

	else
	  ns.HealthOrb.filling.colorClass = false
	  ns.HealthOrb.filling.colorHealth = false
	  local color = panel.loadHealthOrbFillingColor()
	  ns.HealthOrb.filling:SetStatusBarColor(color.r, color.g, color.b)
	  panel.scrollFrame.scrollChild.leftTexture:SetVertexColor(color.r, color.g, color.b)
	  panel.elementHealthMasterHeadline:SetTextColor(color.r, color.g, color.b)
	end
  end

--update power orb filling color auto
  panel.updatePowerOrbFillingColorAuto = function()
	if panel.loadPowerOrbFillingColorAuto() then

		ns.PowerOrb.filling.colorPower = false
		local powertype = select(2, UnitPowerType("player"))
		local color
		if not CUSTOM_POWER_COLORS and powertype == "MANA" then
			color = { r = 0, g = 0.4, b = 1, }
		else
			-- color = oUF.colors.power[select(2, UnitPowerType("player"))] or { r = 0, g = 0.4, b = 1, }
			color = (CUSTOM_POWER_COLORS or PowerBarColor)[select(2, UnitPowerType("player"))] or { r = 0, g = 0.4, b = 1, }
		end
		ns.PowerOrb.filling:SetStatusBarColor(color.r,color.g,color.b)
		-- ns.PowerOrb.filling:ForceUpdate()
		panel.scrollFrame.scrollChild.rightTexture:SetVertexColor(color.r,color.g,color.b)
		panel.elementPowerMasterHeadline:SetTextColor(color.r,color.g,color.b)

	else
	  ns.PowerOrb.filling.colorPower = false
	  local color = panel.loadPowerOrbFillingColor()
	  ns.PowerOrb.filling:SetStatusBarColor(color.r, color.g, color.b)
	  panel.scrollFrame.scrollChild.rightTexture:SetVertexColor(color.r, color.g, color.b)
	  panel.elementPowerMasterHeadline:SetTextColor(color.r, color.g, color.b)
	end
  end

--update health orb filling color
  panel.updateHealthOrbFillingColor = function()
	local color = panel.loadHealthOrbFillingColor()
	ns.HealthOrb.filling:SetStatusBarColor(color.r, color.g, color.b)
	panel.scrollFrame.scrollChild.leftTexture:SetVertexColor(color.r, color.g, color.b)
	panel.elementHealthMasterHeadline:SetTextColor(color.r, color.g, color.b)
  end

--update power orb filling color
  panel.updatePowerOrbFillingColor = function()
	local color = panel.loadPowerOrbFillingColor()
	ns.PowerOrb.filling:SetStatusBarColor(color.r, color.g, color.b)
	panel.scrollFrame.scrollChild.rightTexture:SetVertexColor(color.r, color.g, color.b)
	panel.elementPowerMasterHeadline:SetTextColor(color.r, color.g, color.b)
  end

--update health orb filling alpha
  panel.updateHealthOrbFillingAlpha = function()
	-- ns.HealthOrb.filling:SetAlpha(panel.loadHealthOrbFillingAlpha())
	ns.HealthOrb.filling2:SetAlpha(panel.loadHealthOrbFillingAlpha())
  end

--update power orb filling alpha
  panel.updatePowerOrbFillingAlpha = function()
	ns.PowerOrb.filling:SetAlpha(panel.loadPowerOrbFillingAlpha())
  end

--update health textureframe Size
  panel.updateHealthTextureFrameSize = function()
	ns.HealthOrb.textureframe:SetSize(panel.loadHealthTextureFrameSize()*2/3, panel.loadHealthTextureFrameSize()*2/3)
  end

--update power textureframe Size
  panel.updatePowerTextureFrameSize = function()
	ns.PowerOrb.textureframe:SetSize(panel.loadPowerTextureFrameSize()*2/3, panel.loadPowerTextureFrameSize()*2/3)
  end

--update health orb model enable
  panel.updateHealthOrbModelEnable = function()
	if panel.loadHealthOrbModelEnable() then
	  ns.HealthOrb.model:Show()
	else
	  ns.HealthOrb.model:Hide()
	end
  end

--update power orb model enable
  panel.updatePowerOrbModelEnable = function()
	if panel.loadPowerOrbModelEnable() then
	  ns.PowerOrb.model:Show()
	else
	  ns.PowerOrb.model:Hide()
	end
  end

--update health orb model animated
  panel.updateHealthOrbModelAnimated = function()
	ns.HealthOrb.model:Update()
  end

--update power orb model animated
  panel.updatePowerOrbModelAnimated = function()
	ns.PowerOrb.model:Update()
  end

--update health orb model animation
  panel.updateHealthOrbModelAnimation = function()
	ns.HealthOrb.model:Update()--update the full model with all values, displayId is not enough
  end

--update power orb model animation
  panel.updatePowerOrbModelAnimation = function()
	ns.PowerOrb.model:Update()--update the full model with all values, displayId is not enough
  end

--update health orb model alpha
  panel.updateHealthOrbModelAlpha = function()
	ns.HealthOrb.model:SetAlpha(panel.loadHealthOrbModelAlpha())
  end

--update power orb model alpha
  panel.updatePowerOrbModelAlpha = function()
	ns.PowerOrb.model:SetAlpha(panel.loadPowerOrbModelAlpha())
  end

--update health orb model camDistanceScale
  panel.updateHealthOrbModelCDS = function()
	ns.HealthOrb.model:SetCamDistanceScale(panel.loadHealthOrbModelCDS())
  end

--update power orb model camDistanceScale
  panel.updatePowerOrbModelCDS = function()
	ns.PowerOrb.model:SetCamDistanceScale(panel.loadPowerOrbModelCDS())
  end

--update health orb model pos x
  panel.updateHealthOrbModelPosX = function()
	local x, y = panel.loadHealthOrbModelPosX(), panel.loadHealthOrbModelPosY()
	ns.HealthOrb.model:SetPosition(0, x, y)
  end

--update power orb model pos x
  panel.updatePowerOrbModelPosX = function()
	local x, y = panel.loadPowerOrbModelPosX(), panel.loadPowerOrbModelPosY()
	ns.PowerOrb.model:SetPosition(0, x*-1, y)
  end

--update health orb model pos y
  panel.updateHealthOrbModelPosY = function()
	local x, y = panel.loadHealthOrbModelPosX(), panel.loadHealthOrbModelPosY()
	ns.HealthOrb.model:SetPosition(0, x, y)
  end

--update power orb model pos y
  panel.updatePowerOrbModelPosY = function()
	local x, y = panel.loadPowerOrbModelPosX(), panel.loadPowerOrbModelPosY()
	ns.PowerOrb.model:SetPosition(0, x*-1, y)
  end

--update health orb model rotation
  panel.updateHealthOrbModelRotation = function()
	ns.HealthOrb.model:SetRotation(panel.loadHealthOrbModelRotation())
  end

--update power orb model rotation
  panel.updatePowerOrbModelRotation = function()
	ns.PowerOrb.model:SetRotation(panel.loadPowerOrbModelRotation()*-1)
  end

--update health orb model zoom
  panel.updateHealthOrbModelZoom = function()
	ns.HealthOrb.model:SetPortraitZoom(panel.loadHealthOrbModelZoom())
  end

--update power orb model zoom
  panel.updatePowerOrbModelZoom = function()
	ns.PowerOrb.model:SetPortraitZoom(panel.loadPowerOrbModelZoom())
  end

--update health orb highlight alpha
  panel.updateHealthOrbHighlightAlpha = function()
	ns.HealthOrb.highlight:SetAlpha(panel.loadHealthOrbHighlightAlpha())
  end

--update power orb highlight alpha
  panel.updatePowerOrbHighlightAlpha = function()
	ns.PowerOrb.highlight:SetAlpha(panel.loadPowerOrbHighlightAlpha())
  end

--update health orb orbshadow alpha
  panel.updateHealthOrbOrbshadowAlpha = function()
	ns.HealthOrb.orbshadow:SetAlpha(panel.loadHealthOrbOrbshadowAlpha())
  end

--update power orb orbshadow alpha
  panel.updatePowerOrbOrbshadowAlpha = function()
	ns.PowerOrb.orbshadow:SetAlpha(panel.loadPowerOrbOrbshadowAlpha())
  end

--update health orb background alpha
  panel.updateHealthOrbBackgroundAlpha = function()
	ns.HealthOrb.background:SetAlpha(panel.loadHealthOrbBackgroundAlpha())
  end

--update power orb background alpha
  panel.updatePowerOrbBackgroundAlpha = function()
	ns.PowerOrb.background:SetAlpha(panel.loadPowerOrbBackgroundAlpha())
  end

--update health orb bubbles alpha
  panel.updateHealthOrbBubblesAlpha = function()
	if ns.HealthOrb.bubbles then
	  local alpha = panel.loadHealthOrbBubblesAlpha() or 0
	  for i, bubble in pairs(ns.HealthOrb.bubbles) do
		if bubble.ag:IsPlaying() and alpha == 0 then
		  bubble.ag:Stop()
		  bubble.aga:Stop()
		elseif not bubble.ag:IsPlaying() and alpha > 0 then
		  bubble.ag:Play()
		  bubble.aga:Play()
		end
		  bubble:SetAlpha(alpha)
		  bubble.aga.allow:SetFromAlpha(alpha)
		  bubble.aga.allow:SetToAlpha(0.3*alpha)
		  bubble.aga.alhigh:SetFromAlpha(0.3*alpha)
		  bubble.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update power orb bubbles alpha
  panel.updatePowerOrbBubblesAlpha = function()
	if ns.PowerOrb.bubbles then
	  local alpha = panel.loadPowerOrbBubblesAlpha() or 0
	  for i, bubble in pairs(ns.PowerOrb.bubbles) do
		if bubble.ag:IsPlaying() and alpha == 0 then
		  bubble.ag:Stop()
		  bubble.aga:Stop()
		elseif not bubble.ag:IsPlaying() and alpha > 0 then
		  bubble.ag:Play()
		  bubble.aga:Play()
		end
		bubble:SetAlpha(alpha)
		bubble.aga.allow:SetFromAlpha(alpha)
		bubble.aga.allow:SetToAlpha(0.3*alpha)
		bubble.aga.alhigh:SetFromAlpha(0.3*alpha)
		bubble.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update health orb galaxies alpha
  panel.updateHealthOrbGalaxiesAlpha = function()
	if ns.HealthOrb.galaxies then
	  local alpha = panel.loadHealthOrbGalaxiesAlpha() or 0
	  for i, galaxy in pairs(ns.HealthOrb.galaxies) do
		if galaxy.ag:IsPlaying() and alpha == 0 then
		  galaxy.ag:Stop()
		  galaxy.aga:Stop()
		elseif not galaxy.ag:IsPlaying() and alpha > 0 then
		  galaxy.ag:Play()
		  galaxy.aga:Play()
		end
		galaxy:SetAlpha(alpha)
		galaxy.aga.allow:SetFromAlpha(alpha)
		galaxy.aga.allow:SetToAlpha(0.3*alpha)
		galaxy.aga.alhigh:SetFromAlpha(0.3*alpha)
		galaxy.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update power orb galaxies alpha
  panel.updatePowerOrbGalaxiesAlpha = function()
	if ns.PowerOrb.galaxies then
	  local alpha = panel.loadPowerOrbGalaxiesAlpha() or 0
	  for i, galaxy in pairs(ns.PowerOrb.galaxies) do
		if galaxy.ag:IsPlaying() and alpha == 0 then
		  galaxy.ag:Stop()
		  galaxy.aga:Stop()
		elseif not galaxy.ag:IsPlaying() and alpha > 0 then
		  galaxy.ag:Play()
		  galaxy.aga:Play()
		end
		galaxy:SetAlpha(alpha)
		galaxy.aga.allow:SetFromAlpha(alpha)
		galaxy.aga.allow:SetToAlpha(0.3*alpha)
		galaxy.aga.alhigh:SetFromAlpha(0.3*alpha)
		galaxy.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update health orb pic1s alpha
  panel.updateHealthOrbpic1sAlpha = function()
	if ns.HealthOrb.pic1s then
	  local alpha = panel.loadHealthOrbpic1sAlpha() or 0
	  for i, pic1 in pairs(ns.HealthOrb.pic1s) do
		if pic1.ag:IsPlaying() and alpha == 0 then
		  pic1.ag:Stop()
		  pic1.aga:Stop()
		elseif not pic1.ag:IsPlaying() and alpha > 0 then
		  pic1.ag:Play()
		  pic1.aga:Play()
		end
		pic1:SetAlpha(alpha)
		pic1.aga.allow:SetFromAlpha(alpha)
		pic1.aga.allow:SetToAlpha(0.3*alpha)
		pic1.aga.alhigh:SetFromAlpha(0.3*alpha)
		pic1.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update power orb pic1s alpha
  panel.updatePowerOrbpic1sAlpha = function()
	if ns.PowerOrb.pic1s then
	  local alpha = panel.loadPowerOrbpic1sAlpha() or 0
	  for i, pic1 in pairs(ns.PowerOrb.pic1s) do
		if pic1.ag:IsPlaying() and alpha == 0 then
		  pic1.ag:Stop()
		  pic1.aga:Stop()
		elseif not pic1.ag:IsPlaying() and alpha > 0 then
		  pic1.ag:Play()
		  pic1.aga:Play()
		end
		pic1:SetAlpha(alpha)
		pic1.aga.allow:SetFromAlpha(alpha)
		pic1.aga.allow:SetToAlpha(0.3*alpha)
		pic1.aga.alhigh:SetFromAlpha(0.3*alpha)
		pic1.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update health orb pic2s alpha
  panel.updateHealthOrbpic2sAlpha = function()
	if ns.HealthOrb.pic2s then
	  local alpha = panel.loadHealthOrbpic2sAlpha() or 0
	  for i, pic2 in pairs(ns.HealthOrb.pic2s) do
		if pic2.ag:IsPlaying() and alpha == 0 then
		  pic2.ag:Stop()
		  pic2.aga:Stop()
		elseif not pic2.ag:IsPlaying() and alpha > 0 then
		  pic2.ag:Play()
		  pic2.aga:Play()
		end
		pic2:SetAlpha(alpha)
		pic2.aga.allow:SetFromAlpha(alpha)
		pic2.aga.allow:SetToAlpha(0.3*alpha)
		pic2.aga.alhigh:SetFromAlpha(0.3*alpha)
		pic2.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update power orb pic2s alpha
  panel.updatePowerOrbpic2sAlpha = function()
	if ns.PowerOrb.pic2s then
	  local alpha = panel.loadPowerOrbpic2sAlpha() or 0
	  for i, pic2 in pairs(ns.PowerOrb.pic2s) do
		if pic2.ag:IsPlaying() and alpha == 0 then
		  pic2.ag:Stop()
		  pic2.aga:Stop()
		elseif not pic2.ag:IsPlaying() and alpha > 0 then
		  pic2.ag:Play()
		  pic2.aga:Play()
		end
		pic2:SetAlpha(alpha)
		pic2.aga.allow:SetFromAlpha(alpha)
		pic2.aga.allow:SetToAlpha(0.3*alpha)
		pic2.aga.alhigh:SetFromAlpha(0.3*alpha)
		pic2.aga.alhigh:SetToAlpha(alpha)
	  end
	end
  end

--update health orb spark alpha
  panel.updateHealthOrbSparkAlpha = function()
	ns.HealthOrb.spark:SetAlpha(panel.loadHealthOrbSparkAlpha())
  end

--update power orb spark alpha
  panel.updatePowerOrbSparkAlpha = function()
	ns.PowerOrb.spark:SetAlpha(panel.loadPowerOrbSparkAlpha())
  end

--update health orb value alpha
  panel.updateHealthOrbValueAlpha = function()
	ns.HealthOrb.values:SetAlpha(panel.loadHealthOrbValueAlpha())
  end

--update power orb value alpha
  panel.updatePowerOrbValueAlpha = function()
	ns.PowerOrb.values:SetAlpha(panel.loadPowerOrbValueAlpha())
  end

--update health orb value top color
  panel.updateHealthOrbValueTopColor = function()
	local color = panel.loadHealthOrbValueTopColor()
	ns.HealthOrb.values.top:SetTextColor(color.r, color.g, color.b)
  end

--update power orb value top color
  panel.updatePowerOrbValueTopColor = function()
	local color = panel.loadPowerOrbValueTopColor()
	ns.PowerOrb.values.top:SetTextColor(color.r, color.g, color.b)
  end

--update health orb value bottom color
  panel.updateHealthOrbValueBottomColor = function()
	local color = panel.loadHealthOrbValueBottomColor()
	ns.HealthOrb.values.bottom:SetTextColor(color.r, color.g, color.b)
  end

--update power orb value bottom color
  panel.updatePowerOrbValueBottomColor = function()
	local color = panel.loadPowerOrbValueBottomColor()
	ns.PowerOrb.values.bottom:SetTextColor(color.r, color.g, color.b)
  end

--update health orb value top tag
  panel.updateHealthOrbValueTopTag = function()
	ns.HealthOrb.values.top:SetText(oUF.Tags.Methods["diablo:HealthOrbTop"](ns.unit.player.unit))
  end

--update power orb value top tag
  panel.updatePowerOrbValueTopTag = function()
	ns.PowerOrb.values.top:SetText(oUF.Tags.Methods["diablo:PowerOrbTop"](ns.unit.player.unit))
  end

--update health orb value bottom Tag
  panel.updateHealthOrbValueBottomTag = function()
	ns.HealthOrb.values.bottom:SetText(oUF.Tags.Methods["diablo:HealthOrbBottom"](ns.unit.player.unit))
  end

--update power orb value bottom tag
  panel.updatePowerOrbValueBottomTag = function()
	ns.PowerOrb.values.bottom:SetText(oUF.Tags.Methods["diablo:PowerOrbBottom"](ns.unit.player.unit))
  end


---new-------

  panel.updateHealthOrbValueTopScale = function()
	ns.HealthOrb.values.top:SetScale(panel.loadHealthOrbValueTopScale())
  end

  panel.updatePowerOrbValueTopScale = function()
	ns.PowerOrb.values.top:SetScale(panel.loadPowerOrbValueTopScale())
  end

  panel.updateHealthOrbValueBottomScale = function()
	ns.HealthOrb.values.bottom:SetScale(panel.loadHealthOrbValueBottomScale())
  end

  panel.updatePowerOrbValueBottomScale = function()
	ns.PowerOrb.values.bottom:SetScale(panel.loadPowerOrbValueBottomScale())
  end



---------------------------------------------
--UPDATE PANEL ELEMENTS
---------------------------------------------

--update element health orb texture filling
  panel.updateElementHealthOrbTextureFilling = function()
	UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbFillingTexture, panel.loadHealthOrbFillingTexture())
  end

--update element power orb texture filling
  panel.updateElementPowerOrbTextureFilling = function()
	UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbFillingTexture, panel.loadPowerOrbFillingTexture())
  end

--update element Orb Scale
  panel.updateElementOrbScale = function()
	panel.elementOrbScale:SetValue(panel.loadOrbScale())
  end

--update element health orb Grid enable
  panel.updateElementHealthOrbGridEnable = function()
	local value = panel.loadHealthOrbGridEnable()
	panel.elementHealthOrbGridEnable:SetChecked(value)
  end

--update element power orb Grid enable
  panel.updateElementPowerOrbGridEnable = function()
	local value = panel.loadPowerOrbGridEnable()
	panel.elementPowerOrbGridEnable:SetChecked(value)
  end

--update element health orb filling color auto
  panel.updateElementHealthOrbFillingColorAuto = function()
	local value = panel.loadHealthOrbFillingColorAuto()
	panel.elementHealthOrbFillingColorAuto:SetChecked(value)
	--depending on color auto option we want to enable/disable the texture color picker
	if value then
	  panel.elementHealthOrbFillingColor:Disable()
	else
	  panel.elementHealthOrbFillingColor:Enable()
	end
  end

--update element power orb filling color auto
  panel.updateElementPowerOrbFillingColorAuto = function()
	local value = panel.loadPowerOrbFillingColorAuto()
	panel.elementPowerOrbFillingColorAuto:SetChecked(value)
	--depending on color auto option we want to enable/disable the texture color picker
	if value then
	  panel.elementPowerOrbFillingColor:Disable()
	else
	  panel.elementPowerOrbFillingColor:Enable()
	end
  end

--update element health orb texture color
  panel.updateElementHealthOrbTextureColor = function()
	local color = panel.loadHealthOrbFillingColor()
	panel.elementHealthOrbFillingColor.color:SetVertexColor(color.r, color.g, color.b)
  end

--update element power orb texture color
  panel.updateElementPowerOrbTextureColor = function()
	local color = panel.loadPowerOrbFillingColor()
	panel.elementPowerOrbFillingColor.color:SetVertexColor(color.r, color.g, color.b)
  end

--update element health orb filling alpha
  panel.updateElementHealthOrbFillingAlpha = function()
	panel.elementHealthOrbFillingAlpha:SetValue(panel.loadHealthOrbFillingAlpha())
  end

--update element power orb filling alpha
  panel.updateElementPowerOrbFillingAlpha = function()
	panel.elementPowerOrbFillingAlpha:SetValue(panel.loadPowerOrbFillingAlpha())
  end

--update element health textureframe size
  panel.updateElementHealthTextureFrameSize = function()
	panel.elementHealthTextureFrameSize:SetValue(panel.loadHealthTextureFrameSize())
  end

--update element power textureframe size
  panel.updateElementPowerTextureFrameSize = function()
	panel.elementPowerTextureFrameSize:SetValue(panel.loadPowerTextureFrameSize())
  end

--update element health orb model enable
  panel.updateElementHealthOrbModelEnable = function()
	local value = panel.loadHealthOrbModelEnable()
	panel.elementHealthOrbModelEnable:SetChecked(value)
	if value then
	  panel.elementHealthOrbModelAnimated:Show()
	  panel.elementHealthOrbModelAnimation:Show()
	  panel.elementHealthOrbModelAlpha:Show()
	  panel.elementHealthOrbModelCDS:Show()
	  panel.elementHealthOrbModelPosX:Show()
	  panel.elementHealthOrbModelPosY:Show()
	  panel.elementHealthOrbModelRotation:Show()
	  panel.elementHealthOrbModelZoom:Show()
	  panel.elementHealthHighlightHeadline:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -255)
	else
	  panel.elementHealthOrbModelAnimated:Hide()
	  panel.elementHealthOrbModelAnimation:Hide()
	  panel.elementHealthOrbModelAlpha:Hide()
	  panel.elementHealthOrbModelCDS:Hide()
	  panel.elementHealthOrbModelPosX:Hide()
	  panel.elementHealthOrbModelPosY:Hide()
	  panel.elementHealthOrbModelRotation:Hide()
	  panel.elementHealthOrbModelZoom:Hide()
	  panel.elementHealthHighlightHeadline:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -45)
	end
  end

--update element power orb model enable
  panel.updateElementPowerOrbModelEnable = function()
	local value = panel.loadPowerOrbModelEnable()
	panel.elementPowerOrbModelEnable:SetChecked(value)
	if value then
  	  panel.elementPowerOrbModelAnimated:Show()
	  panel.elementPowerOrbModelAnimation:Show()
	  panel.elementPowerOrbModelAlpha:Show()
	  panel.elementPowerOrbModelCDS:Show()
	  panel.elementPowerOrbModelPosX:Show()
	  panel.elementPowerOrbModelPosY:Show()
	  panel.elementPowerOrbModelRotation:Show()
	  panel.elementPowerOrbModelZoom:Show()
	  panel.elementPowerHighlightHeadline:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -255)
	else
  	  panel.elementPowerOrbModelAnimated:Hide()
	  panel.elementPowerOrbModelAnimation:Hide()
	  panel.elementPowerOrbModelAlpha:Hide()
	  panel.elementPowerOrbModelCDS:Hide()
	  panel.elementPowerOrbModelPosX:Hide()
	  panel.elementPowerOrbModelPosY:Hide()
	  panel.elementPowerOrbModelRotation:Hide()
	  panel.elementPowerOrbModelZoom:Hide()
	  panel.elementPowerHighlightHeadline:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -45)
	end
  end

--update element health orb model animated
  panel.updateElementHealthOrbModelAnimated = function()
	panel.elementHealthOrbModelAnimated:SetChecked(panel.loadHealthOrbModelAnimated())
  end

--update element power orb model animated
  panel.updateElementPowerOrbModelAnimated = function()
	panel.elementPowerOrbModelAnimated:SetChecked(panel.loadPowerOrbModelAnimated())
  end

--update element health orb model animation
  panel.updateElementHealthOrbModelAnimation = function()
	UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbModelAnimation, panel.loadHealthOrbModelAnimation())
  end

--update element power orb model animation
  panel.updateElementPowerOrbModelAnimation = function()
	UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbModelAnimation, panel.loadPowerOrbModelAnimation())
  end

--update element health orb model alpha
  panel.updateElementHealthOrbModelAlpha = function()
	panel.elementHealthOrbModelAlpha:SetValue(panel.loadHealthOrbModelAlpha())
  end

--update element power orb model alpha
  panel.updateElementPowerOrbModelAlpha = function()
	panel.elementPowerOrbModelAlpha:SetValue(panel.loadPowerOrbModelAlpha())
  end

--update element health orb model camDistanceScale
  panel.updateElementHealthOrbModelCDS = function()
	panel.elementHealthOrbModelCDS:SetValue(panel.loadHealthOrbModelCDS())
  end

--update element power orb model camDistanceScale
  panel.updateElementPowerOrbModelCDS = function()
	panel.elementPowerOrbModelCDS:SetValue(panel.loadPowerOrbModelCDS())
  end

--update element health orb model pos x
  panel.updateElementHealthOrbModelPosX = function()
	panel.elementHealthOrbModelPosX:SetValue(panel.loadHealthOrbModelPosX())
  end

--update element power orb model pos x
  panel.updateElementPowerOrbModelPosX = function()
	panel.elementPowerOrbModelPosX:SetValue(panel.loadPowerOrbModelPosX())
  end

--update element health orb model pos y
  panel.updateElementHealthOrbModelPosY = function()
	panel.elementHealthOrbModelPosY:SetValue(panel.loadHealthOrbModelPosY())
  end

--update element power orb model pos y
  panel.updateElementPowerOrbModelPosY = function()
	panel.elementPowerOrbModelPosY:SetValue(panel.loadPowerOrbModelPosY())
  end

--update element health orb model rotation
  panel.updateElementHealthOrbModelRotation = function()
	panel.elementHealthOrbModelRotation:SetValue(panel.loadHealthOrbModelRotation())
  end

--update element power orb model rotation
  panel.updateElementPowerOrbModelRotation = function()
	panel.elementPowerOrbModelRotation:SetValue(panel.loadPowerOrbModelRotation())
  end

--update element health orb model zoom
  panel.updateElementHealthOrbModelZoom = function()
	panel.elementHealthOrbModelZoom:SetValue(panel.loadHealthOrbModelZoom())
  end

--update element power orb model zoom
  panel.updateElementPowerOrbModelZoom = function()
	panel.elementPowerOrbModelZoom:SetValue(panel.loadPowerOrbModelZoom())
  end

--update element health orb highlight alpha
  panel.updateElementHealthOrbHighlightAlpha = function()
	panel.elementHealthOrbHighlightAlpha:SetValue(panel.loadHealthOrbHighlightAlpha())
  end

--update element power orb highlight alpha
  panel.updateElementPowerOrbHighlightAlpha = function()
	panel.elementPowerOrbHighlightAlpha:SetValue(panel.loadPowerOrbHighlightAlpha())
  end

--update element health orb orbshadow alpha
  panel.updateElementHealthOrbOrbshadowAlpha = function()
	panel.elementHealthOrbOrbshadowAlpha:SetValue(panel.loadHealthOrbOrbshadowAlpha())
  end

--update element power orb orbshadow alpha
  panel.updateElementPowerOrbOrbshadowAlpha = function()
	panel.elementPowerOrbOrbshadowAlpha:SetValue(panel.loadPowerOrbOrbshadowAlpha())
  end

--update element health orb background alpha
  panel.updateElementHealthOrbBackgroundAlpha = function()
	panel.elementHealthOrbBackgroundAlpha:SetValue(panel.loadHealthOrbBackgroundAlpha())
  end

--update element power orb background alpha
  panel.updateElementPowerOrbBackgroundAlpha = function()
	panel.elementPowerOrbBackgroundAlpha:SetValue(panel.loadPowerOrbBackgroundAlpha())
  end

--update element health orb galxies alpha
  panel.updateElementHealthOrbpic1sAlpha = function()
	panel.elementHealthOrbpic1sAlpha:SetValue(panel.loadHealthOrbpic1sAlpha() or 0)
  end

--update element power orb galxies alpha
  panel.updateElementPowerOrbpic1sAlpha = function()
	panel.elementPowerOrbpic1sAlpha:SetValue(panel.loadPowerOrbpic1sAlpha() or 0)
  end

--update element health orb galxies alpha
  panel.updateElementHealthOrbpic2sAlpha = function()
	panel.elementHealthOrbpic2sAlpha:SetValue(panel.loadHealthOrbpic2sAlpha() or 0)
  end

--update element power orb galxies alpha
  panel.updateElementPowerOrbpic2sAlpha = function()
	panel.elementPowerOrbpic2sAlpha:SetValue(panel.loadPowerOrbpic2sAlpha() or 0)
  end

	--update element health orb galxies alpha
  panel.updateElementHealthOrbGalaxiesAlpha = function()
	panel.elementHealthOrbGalaxiesAlpha:SetValue(panel.loadHealthOrbGalaxiesAlpha() or 0)
  end

--update element power orb galxies alpha
  panel.updateElementPowerOrbGalaxiesAlpha = function()
	panel.elementPowerOrbGalaxiesAlpha:SetValue(panel.loadPowerOrbGalaxiesAlpha() or 0)
  end

	--update element health orb bubbles alpha
  panel.updateElementHealthOrbBubblesAlpha = function()
	panel.elementHealthOrbBubblesAlpha:SetValue(panel.loadHealthOrbBubblesAlpha() or 0)
  end

--update element power orb bubbles alpha
  panel.updateElementPowerOrbBubblesAlpha = function()
	panel.elementPowerOrbBubblesAlpha:SetValue(panel.loadPowerOrbBubblesAlpha() or 0)
  end

--update element health orb spark alpha
  panel.updateElementHealthOrbSparkAlpha = function()
	panel.elementHealthOrbSparkAlpha:SetValue(panel.loadHealthOrbSparkAlpha())
  end

--update element power orb spark alpha
  panel.updateElementPowerOrbSparkAlpha = function()
	panel.elementPowerOrbSparkAlpha:SetValue(panel.loadPowerOrbSparkAlpha())
  end

--update element health orb value hideOnEmpty
  panel.updateElementHealthOrbValueHideEmpty = function()
	panel.elementHealthOrbValueHideEmpty:SetChecked(panel.loadHealthOrbValueHideEmpty())
  end

--update element power orb value hideOnEmpty
  panel.updateElementPowerOrbValueHideEmpty = function()
	panel.elementPowerOrbValueHideEmpty:SetChecked(panel.loadPowerOrbValueHideEmpty())
  end

--update element health orb value hideOnFull
  panel.updateElementHealthOrbValueHideFull = function()
	panel.elementHealthOrbValueHideFull:SetChecked(panel.loadHealthOrbValueHideFull())
  end

--update element power orb value hideOnFull
  panel.updateElementPowerOrbValueHideFull = function()
	panel.elementPowerOrbValueHideFull:SetChecked(panel.loadPowerOrbValueHideFull())
  end

--update element health orb value alpha
  panel.updateElementHealthOrbValueAlpha = function()
	panel.elementHealthOrbValueAlpha:SetValue(panel.loadHealthOrbValueAlpha())
  end

--update element power orb value alpha
  panel.updateElementPowerOrbValueAlpha = function()
	panel.elementPowerOrbValueAlpha:SetValue(panel.loadPowerOrbValueAlpha())
  end

--update element health orb value top color
  panel.updateElementHealthOrbValueTopColor = function()
	local color = panel.loadHealthOrbValueTopColor()
	panel.elementHealthOrbValueTopColor.color:SetVertexColor(color.r, color.g, color.b)
  end

--update element power orb value top color
  panel.updateElementPowerOrbValueTopColor = function()
	local color = panel.loadPowerOrbValueTopColor()
	panel.elementPowerOrbValueTopColor.color:SetVertexColor(color.r, color.g, color.b)
  end

--update element health orb value bottom color
  panel.updateElementHealthOrbValueBottomColor = function()
	local color = panel.loadHealthOrbValueBottomColor()
	panel.elementHealthOrbValueBottomColor.color:SetVertexColor(color.r, color.g, color.b)
  end

--update element power orb value bottom color
  panel.updateElementPowerOrbValueBottomColor = function()
	local color = panel.loadPowerOrbValueBottomColor()
	panel.elementPowerOrbValueBottomColor.color:SetVertexColor(color.r, color.g, color.b)
  end

--update element health orb value top tag
  panel.updateElementHealthOrbValueTopTag = function()
	UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbValueTopTag, panel.loadHealthOrbValueTopTag())
  end

--update element power orb value top tag
  panel.updateElementPowerOrbValueTopTag = function()
	UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbValueTopTag, panel.loadPowerOrbValueTopTag())
  end

--update element health orb value bottom tag
  panel.updateElementHealthOrbValueBottomTag = function()
	UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbValueBottomTag, panel.loadHealthOrbValueBottomTag())
  end

--update element power orb value bottom tag
  panel.updateElementPowerOrbValueBottomTag = function()
	UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbValueBottomTag, panel.loadPowerOrbValueBottomTag())
  end


---new-------

  panel.updateElementHealthOrbValueTopScale = function()
	panel.elementHealthOrbValueTopScale:SetValue(panel.loadHealthOrbValueTopScale())
  end
  panel.updateElementPowerOrbValueTopScale = function()
	panel.elementPowerOrbValueTopScale:SetValue(panel.loadPowerOrbValueTopScale())
  end
  panel.updateElementHealthOrbValueBottomScale = function()
	panel.elementHealthOrbValueBottomScale:SetValue(panel.loadHealthOrbValueBottomScale())
  end
  panel.updateElementPowerOrbValueBottomScale = function()
	panel.elementPowerOrbValueBottomScale:SetValue(panel.loadPowerOrbValueBottomScale())
  end


---------------------------------------------
--SAVE DATA TO DATABASE
---------------------------------------------

--save health orb filling texture
  panel.saveHealthOrbFillingTexture = function(value)
	db.char["HEALTH"].filling.texture = value
  end

--save power orb filling texture
  panel.savePowerOrbFillingTexture = function(value)
	db.char["POWER"].filling.texture = value
  end

--save orb scale
  panel.saveOrbScale = function(value)
   db.char.scale = value
  end

--save health orbgrid model enable
  panel.saveHealthOrbGridEnable = function(value)
	db.char["HEALTH"].filling.grid = value
  end

--save power orbgrid model enable
  panel.savePowerOrbGridEnable = function(value)
	db.char["POWER"].filling.grid = value
  end

--save health orb filling color auto
  panel.saveHealthOrbFillingColorAuto = function(value)
	db.char["HEALTH"].filling.colorAuto = value
  end

--save power orb filling color auto
  panel.savePowerOrbFillingColorAuto = function(value)
	db.char["POWER"].filling.colorAuto = value
  end

--save health orb filling color
  panel.saveHealthOrbFillingColor = function(r, g, b)
	db.char["HEALTH"].filling.color.r = r
	db.char["HEALTH"].filling.color.g = g
	db.char["HEALTH"].filling.color.b = b
  end

--save power orb filling color
  panel.savePowerOrbFillingColor = function(r, g, b)
	db.char["POWER"].filling.color.r = r
	db.char["POWER"].filling.color.g = g
	db.char["POWER"].filling.color.b = b
  end

--save health orb filling alpha
  panel.saveHealthOrbFillingAlpha = function(value)
	db.char["HEALTH"].filling.alpha = value
  end

--save power orb filling alpha
  panel.savePowerOrbFillingAlpha = function(value)
	db.char["POWER"].filling.alpha = value
  end

--save health textureframe size
  panel.saveHealthTextureFrameSize = function(value)
	db.char["HEALTH"].textureframe.size = value
  end

--save power textureframe size
  panel.savePowerTextureFrameSize = function(value)
	db.char["POWER"].textureframe.size = value
  end

--save health orb model enable
  panel.saveHealthOrbModelEnable = function(value)
	db.char["HEALTH"].model.enable = value
  end

--save power orb model enable
  panel.savePowerOrbModelEnable = function(value)
	db.char["POWER"].model.enable = value
  end

--save health orb model animated
  panel.saveHealthOrbModelAnimated = function(value)
	db.char["HEALTH"].model.animated = value
  end

--save power orb model animated
  panel.savePowerOrbModelAnimated = function(value)
	db.char["POWER"].model.animated = value
  end

--save health orb model animation
  panel.saveHealthOrbModelAnimation = function(value)
	db.char["HEALTH"].model.displayInfo = value
  end

--save power orb model animation
  panel.savePowerOrbModelAnimation = function(value)
	db.char["POWER"].model.displayInfo = value
  end

--save health orb model alpha
  panel.saveHealthOrbModelAlpha = function(value)
	db.char["HEALTH"].model.alpha = value
  end

--save power orb model alpha
  panel.savePowerOrbModelAlpha = function(value)
	db.char["POWER"].model.alpha = value
  end

--save health orb model camDistanceScale
  panel.saveHealthOrbModelCDS = function(value)
	db.char["HEALTH"].model.camDistanceScale = value
  end

--save power orb model camDistanceScale
  panel.savePowerOrbModelCDS = function(value)
	db.char["POWER"].model.camDistanceScale = value
  end

--save health orb model pos x
  panel.saveHealthOrbModelPosX = function(value)
	db.char["HEALTH"].model.pos_x = value
  end

--save power orb model pos x
  panel.savePowerOrbModelPosX = function(value)
	db.char["POWER"].model.pos_x = value
  end

--save health orb model pos y
  panel.saveHealthOrbModelPosY = function(value)
	db.char["HEALTH"].model.pos_y = value
  end

--save power orb model pos y
  panel.savePowerOrbModelPosY = function(value)
	db.char["POWER"].model.pos_y = value
  end

--save health orb model rotation
  panel.saveHealthOrbModelRotation = function(value)
	db.char["HEALTH"].model.rotation = value
  end

--save power orb model rotation
  panel.savePowerOrbModelRotation = function(value)
	db.char["POWER"].model.rotation = value
  end

--save health orb model zoom
  panel.saveHealthOrbModelZoom = function(value)
	db.char["HEALTH"].model.portraitZoom = value
  end

--save power orb model zoom
  panel.savePowerOrbModelZoom = function(value)
	db.char["POWER"].model.portraitZoom = value
  end

--save health orb highlight alpha
  panel.saveHealthOrbHighlightAlpha = function(value)
	db.char["HEALTH"].highlight.alpha = value
  end

--save power orb highlight alpha
  panel.savePowerOrbHighlightAlpha = function(value)
	db.char["POWER"].highlight.alpha = value
  end

--save health orb orbshadow alpha
  panel.saveHealthOrbOrbshadowAlpha = function(value)
	db.char["HEALTH"].orbshadow.alpha = value
  end

--save power orb orbshadow alpha
  panel.savePowerOrbOrbshadowAlpha = function(value)
	db.char["POWER"].orbshadow.alpha = value
  end

--save health orb background alpha
  panel.saveHealthOrbBackgroundAlpha = function(value)
	db.char["HEALTH"].background.alpha = value
  end

--save power orb background alpha
  panel.savePowerOrbBackgroundAlpha = function(value)
	db.char["POWER"].background.alpha = value
  end

--save health orb bubbles alpha
  panel.saveHealthOrbBubblesAlpha = function(value)
	db.char["HEALTH"].bubbles.alpha = value
  end

--save power orb bubbles alpha
  panel.savePowerOrbBubblesAlpha = function(value)
	db.char["POWER"].bubbles.alpha = value
  end

--save health orb galaxies alpha
  panel.saveHealthOrbGalaxiesAlpha = function(value)
	db.char["HEALTH"].galaxies.alpha = value
  end

--save power orb galaxies alpha
  panel.savePowerOrbGalaxiesAlpha = function(value)
	db.char["POWER"].galaxies.alpha = value
  end

--save health orb pic1s alpha
  panel.saveHealthOrbpic1sAlpha = function(value)
	db.char["HEALTH"].pic1s.alpha = value
  end

--save power orb pic1s alpha
  panel.savePowerOrbpic1sAlpha = function(value)
	db.char["POWER"].pic1s.alpha = value
  end

--save health orb pic2s alpha
  panel.saveHealthOrbpic2sAlpha = function(value)
	db.char["HEALTH"].pic2s.alpha = value
  end

--save power orb pic2s alpha
  panel.savePowerOrbpic2sAlpha = function(value)
	db.char["POWER"].pic2s.alpha = value
  end

--save health orb spark alpha
  panel.saveHealthOrbSparkAlpha = function(value)
	db.char["HEALTH"].spark.alpha = value
  end

--save power orb spark alpha
  panel.savePowerOrbSparkAlpha = function(value)
	db.char["POWER"].spark.alpha = value
  end

--save health orb value hideOnEmpty
  panel.saveHealthOrbValueHideEmpty = function(value)
	db.char["HEALTH"].value.hideOnEmpty = value
  end

--save power orb value hideOnEmpty
  panel.savePowerOrbValueHideEmpty = function(value)
	db.char["POWER"].value.hideOnEmpty = value
  end

--save health orb value hideOnFull
  panel.saveHealthOrbValueHideFull = function(value)
	db.char["HEALTH"].value.hideOnFull = value
  end

--save power orb value hideOnFull
  panel.savePowerOrbValueHideFull = function(value)
	db.char["POWER"].value.hideOnFull = value
  end

--save health orb value alpha
  panel.saveHealthOrbValueAlpha = function(value)
	db.char["HEALTH"].value.alpha = value
  end

--save power orb value alpha
  panel.savePowerOrbValueAlpha = function(value)
	db.char["POWER"].value.alpha = value
  end

--save health orb value top color
  panel.saveHealthOrbValueTopColor = function(r, g, b)
	db.char["HEALTH"].value.top.color.r = r
	db.char["HEALTH"].value.top.color.g = g
	db.char["HEALTH"].value.top.color.b = b
  end

--save power orb value top color
  panel.savePowerOrbValueTopColor = function(r, g, b)
	db.char["POWER"].value.top.color.r = r
	db.char["POWER"].value.top.color.g = g
	db.char["POWER"].value.top.color.b = b
  end

--save health orb value bottom color
  panel.saveHealthOrbValueBottomColor = function(r, g, b)
	db.char["HEALTH"].value.bottom.color.r = r
	db.char["HEALTH"].value.bottom.color.g = g
	db.char["HEALTH"].value.bottom.color.b = b
  end

--save power orb value bottom color
  panel.savePowerOrbValueBottomColor = function(r, g, b)
	db.char["POWER"].value.bottom.color.r = r
	db.char["POWER"].value.bottom.color.g = g
	db.char["POWER"].value.bottom.color.b = b
  end

--save health orb value top tag
  panel.saveHealthOrbValueTopTag = function(value)
	db.char["HEALTH"].value.top.tag = value
  end

--save power orb value top tag
  panel.savePowerOrbValueTopTag = function(value)
	db.char["POWER"].value.top.tag = value
  end

--save health orb value bottom tag
  panel.saveHealthOrbValueBottomTag = function(value)
	db.char["HEALTH"].value.bottom.tag = value
  end

--save power orb value bottom tag
  panel.savePowerOrbValueBottomTag = function(value)
	db.char["POWER"].value.bottom.tag = value
  end


---new-------

  panel.saveHealthOrbValueTopScale = function(value)
	db.char["HEALTH"].value.top.scale = value
  end
  panel.savePowerOrbValueTopScale = function(value)
	db.char["POWER"].value.top.scale = value
  end
  panel.saveHealthOrbValueBottomScale = function(value)
	db.char["HEALTH"].value.bottom.scale = value
  end
  panel.savePowerOrbValueBottomScale = function(value)
	db.char["POWER"].value.bottom.scale = value
  end


---------------------------------------------
--LOAD DATA FROM DATABASE
---------------------------------------------

--load health orb filling texture
  panel.loadHealthOrbFillingTexture = function()
	return db.char["HEALTH"].filling.texture
  end

--load power orb filling texture
  panel.loadPowerOrbFillingTexture = function()
	return db.char["POWER"].filling.texture
  end

--load orb scale
  panel.loadOrbScale = function()
	return db.char.scale
  end

--load health orbgrid model enable
  panel.loadHealthOrbGridEnable = function()
	return db.char["HEALTH"].filling.grid
  end

--load power orbgrid model enable
  panel.loadPowerOrbGridEnable = function()
	return db.char["POWER"].filling.grid
  end

--load health orb filling color auto
  panel.loadHealthOrbFillingColorAuto = function()
	return db.char["HEALTH"].filling.colorAuto
  end

--load power orb filling color auto
  panel.loadPowerOrbFillingColorAuto = function()
	return db.char["POWER"].filling.colorAuto
  end

--load health orb filling color
  panel.loadHealthOrbFillingColor = function()
	return db.char["HEALTH"].filling.color
  end

--load power orb filling color
  panel.loadPowerOrbFillingColor = function()
	return db.char["POWER"].filling.color
  end

--load health orb filling alpha
  panel.loadHealthOrbFillingAlpha = function()
	return db.char["HEALTH"].filling.alpha
  end

--load power orb filling alpha
  panel.loadPowerOrbFillingAlpha = function()
	return db.char["POWER"].filling.alpha
  end

--load health textureframe size
  panel.loadHealthTextureFrameSize = function()
	return db.char["HEALTH"].textureframe.size
  end

--load power textureframe size
  panel.loadPowerTextureFrameSize = function()
	return db.char["POWER"].textureframe.size
  end

--load health orb model enable
  panel.loadHealthOrbModelEnable = function()
	return db.char["HEALTH"].model.enable
  end

--load power orb model enable
  panel.loadPowerOrbModelEnable = function()
	return db.char["POWER"].model.enable
  end

--load health orb model animated
  panel.loadHealthOrbModelAnimated = function()
	return db.char["HEALTH"].model.animated
  end

--load power orb model animated
  panel.loadPowerOrbModelAnimated = function()
	return db.char["POWER"].model.animated
  end

--load health orb model animation
  panel.loadHealthOrbModelAnimation = function()
	return db.char["HEALTH"].model.displayInfo
  end

--load power orb model animation
  panel.loadPowerOrbModelAnimation = function()
	return db.char["POWER"].model.displayInfo
  end

--load health orb model alpha
  panel.loadHealthOrbModelAlpha = function()
	return db.char["HEALTH"].model.alpha
  end

--load power orb model alpha
  panel.loadPowerOrbModelAlpha = function()
	return db.char["POWER"].model.alpha
  end

--load health orb model camDistanceScale
  panel.loadHealthOrbModelCDS = function()
	return db.char["HEALTH"].model.camDistanceScale
  end

--load power orb model camDistanceScale
  panel.loadPowerOrbModelCDS = function()
	return db.char["POWER"].model.camDistanceScale
  end

--load health orb model pos x
  panel.loadHealthOrbModelPosX = function()
	return db.char["HEALTH"].model.pos_x
  end

--load power orb model pos x
  panel.loadPowerOrbModelPosX = function()
	return db.char["POWER"].model.pos_x
  end

--load health orb model pos y
  panel.loadHealthOrbModelPosY = function()
	return db.char["HEALTH"].model.pos_y
  end

--load power orb model pos y
  panel.loadPowerOrbModelPosY = function()
	return db.char["POWER"].model.pos_y
  end

--load health orb model rotation
  panel.loadHealthOrbModelRotation = function()
	return db.char["HEALTH"].model.rotation
  end

--load power orb model rotation
  panel.loadPowerOrbModelRotation = function()
	return db.char["POWER"].model.rotation
  end

--load health orb model zoom
  panel.loadHealthOrbModelZoom = function()
	return db.char["HEALTH"].model.portraitZoom
  end

--load power orb model zoom
  panel.loadPowerOrbModelZoom = function()
	return db.char["POWER"].model.portraitZoom
  end

--load health orb highlight alpha
  panel.loadHealthOrbHighlightAlpha = function()
	return db.char["HEALTH"].highlight.alpha
  end

--load power orb highlight alpha
  panel.loadPowerOrbHighlightAlpha = function()
	return db.char["POWER"].highlight.alpha
  end

--load health orb orbshadow alpha
  panel.loadHealthOrbOrbshadowAlpha = function()
	return db.char["HEALTH"].orbshadow.alpha
  end

--load power orb orbshadow alpha
  panel.loadPowerOrbOrbshadowAlpha = function()
	return db.char["POWER"].orbshadow.alpha
  end

--load health orb background alpha
  panel.loadHealthOrbBackgroundAlpha = function()
	return db.char["HEALTH"].background.alpha
  end

--load power orb background alpha
  panel.loadPowerOrbBackgroundAlpha = function()
	return db.char["POWER"].background.alpha
  end

--load health orb bubbles alpha
  panel.loadHealthOrbBubblesAlpha = function()
	return db.char["HEALTH"].bubbles.alpha or 0
  end

--load power orb bubbles alpha
  panel.loadPowerOrbBubblesAlpha = function()
	return db.char["POWER"].bubbles.alpha or 0
  end

--load health orb galaxies alpha
  panel.loadHealthOrbGalaxiesAlpha = function()
	return db.char["HEALTH"].galaxies.alpha or 0
  end

--load power orb galaxies alpha
  panel.loadPowerOrbGalaxiesAlpha = function()
	return db.char["POWER"].galaxies.alpha or 0
  end

--load health orb pic1s alpha
  panel.loadHealthOrbpic1sAlpha = function()
	return db.char["HEALTH"].pic1s.alpha or 0
  end

--load power orb pic1s alpha
  panel.loadPowerOrbpic1sAlpha = function()
	return db.char["POWER"].pic1s.alpha or 0
  end

--load health orb pic2s alpha
  panel.loadHealthOrbpic2sAlpha = function()
	return db.char["HEALTH"].pic2s.alpha or 0
  end

--load power orb pic2s alpha
  panel.loadPowerOrbpic2sAlpha = function()
	return db.char["POWER"].pic2s.alpha or 0
  end

--load health orb spark alpha
  panel.loadHealthOrbSparkAlpha = function()
	return db.char["HEALTH"].spark.alpha
  end

--load power orb spark alpha
  panel.loadPowerOrbSparkAlpha = function()
	return db.char["POWER"].spark.alpha
  end

--load health orb value hideOnEmpty
  panel.loadHealthOrbValueHideEmpty = function()
	return db.char["HEALTH"].value.hideOnEmpty
  end

--load power orb value hideOnEmpty
  panel.loadPowerOrbValueHideEmpty = function()
	return db.char["POWER"].value.hideOnEmpty
  end

--load health orb value hideOnFull
  panel.loadHealthOrbValueHideFull = function()
	return db.char["HEALTH"].value.hideOnFull
  end

--load power orb value hideOnFull
  panel.loadPowerOrbValueHideFull = function()
	return db.char["POWER"].value.hideOnFull
  end

--load health orb value alpha
  panel.loadHealthOrbValueAlpha = function()
	return db.char["HEALTH"].value.alpha
  end

--load power orb value alpha
  panel.loadPowerOrbValueAlpha = function()
	return db.char["POWER"].value.alpha
  end

--load health orb value top color
  panel.loadHealthOrbValueTopColor = function()
	return db.char["HEALTH"].value.top.color
  end

--load power orb value top color
  panel.loadPowerOrbValueTopColor = function()
	return db.char["POWER"].value.top.color
  end

--load health orb value bottom color
  panel.loadHealthOrbValueBottomColor = function()
	return db.char["HEALTH"].value.bottom.color
  end

--load power orb value bottom color
  panel.loadPowerOrbValueBottomColor = function()
	return db.char["POWER"].value.bottom.color
  end

--load health orb value top tag
  panel.loadHealthOrbValueTopTag = function()
	return db.char["HEALTH"].value.top.tag
  end

--load power orb value top tag
  panel.loadPowerOrbValueTopTag = function()
	return db.char["POWER"].value.top.tag
  end

--load health orb value bottom tag
  panel.loadHealthOrbValueBottomTag = function()
	return db.char["HEALTH"].value.bottom.tag
  end

--load power orb value bottom tag
  panel.loadPowerOrbValueBottomTag = function()
	return db.char["POWER"].value.bottom.tag
  end


---new-------

  panel.loadHealthOrbValueTopScale = function()
	return db.char["HEALTH"].value.top.scale
  end

  panel.loadPowerOrbValueTopScale = function()
	return db.char["POWER"].value.top.scale
  end

  panel.loadHealthOrbValueBottomScale = function()
	return db.char["HEALTH"].value.bottom.scale
  end

  panel.loadPowerOrbValueBottomScale = function()
	return db.char["POWER"].value.bottom.scale
  end


---------------------------------------------
--UPDATE PANEL VIEW
---------------------------------------------

  panel.updatePanelView = function()

	--if InCombatLockdown() then return end

	--update element health orb texture filling
	panel.updateElementHealthOrbTextureFilling()
	--update element power orb texture filling
	panel.updateElementPowerOrbTextureFilling()
	--update element orb scale
	panel.updateElementOrbScale()
	--update element health orb grid enable
	panel.updateElementHealthOrbGridEnable()
	--update element power orb grid enable
	panel.updateElementPowerOrbGridEnable()
	--update element health orb filling color auto
	panel.updateElementHealthOrbFillingColorAuto()
	--update element power orb filling color auto
	panel.updateElementPowerOrbFillingColorAuto()
	--update element health orb texture color
	panel.updateElementHealthOrbTextureColor()
	--update element power orb texture color
	panel.updateElementPowerOrbTextureColor()
	--update element health orb filling alpha
	panel.updateElementHealthOrbFillingAlpha()
	--update element power orb filling alpha
	panel.updateElementPowerOrbFillingAlpha()
	--update element health textureframe scale
	panel.updateElementHealthTextureFrameSize()
	--update element power textureframe scale
	panel.updateElementPowerTextureFrameSize()
	--update element health orb model enable
	panel.updateElementHealthOrbModelEnable()
	--update element power orb model enable
	panel.updateElementPowerOrbModelEnable()
	--update element health orb model animated
	panel.updateElementHealthOrbModelAnimated()
	--update element power orb model animated
	panel.updateElementPowerOrbModelAnimated()
	--update element health orb model animation
	panel.updateElementHealthOrbModelAnimation()
	--update element power orb model animation
	panel.updateElementPowerOrbModelAnimation()
	--update element health orb model alpha
	panel.updateElementHealthOrbModelAlpha()
	--update element power orb model alpha
	panel.updateElementPowerOrbModelAlpha()
	--update element health orb model camDistanceScale
	panel.updateElementHealthOrbModelCDS()
	--update element power orb model camDistanceScale
	panel.updateElementPowerOrbModelCDS()
	--update element health orb model pos x
	panel.updateElementHealthOrbModelPosX()
	--update element power orb model pos x
	panel.updateElementPowerOrbModelPosX()
	--update element health orb model pos y
	panel.updateElementHealthOrbModelPosY()
	--update element power orb model pos y
	panel.updateElementPowerOrbModelPosY()
	--update element health orb model rotation
	panel.updateElementHealthOrbModelRotation()
	--update element power orb model rotation
	panel.updateElementPowerOrbModelRotation()
	--update element health orb model zoom
	panel.updateElementHealthOrbModelZoom()
	--update element power orb model zoom
	panel.updateElementPowerOrbModelZoom()
	--update element health orb highlight alpha
	panel.updateElementHealthOrbHighlightAlpha()
	--update element power orb highlight alpha
	panel.updateElementPowerOrbHighlightAlpha()
	--update element health orb orbshadow alpha
	panel.updateElementHealthOrbOrbshadowAlpha()
	--update element power orb orbshadow alpha
	panel.updateElementPowerOrbOrbshadowAlpha()
	--update element health orb background alpha
	panel.updateElementHealthOrbBackgroundAlpha()
	--update element power orb background alpha
	panel.updateElementPowerOrbBackgroundAlpha()
		--update element health orb bubbles alpha
	panel.updateElementHealthOrbBubblesAlpha()
	--update element power orb bubbles alpha
	panel.updateElementPowerOrbBubblesAlpha()
		--update element health orb galaxies alpha
	panel.updateElementHealthOrbGalaxiesAlpha()
	--update element power orb galaxies alpha
	panel.updateElementPowerOrbGalaxiesAlpha()
	--update element health orb pic1s alpha
	panel.updateElementHealthOrbpic1sAlpha()
	--update element power orb pic1s alpha
	panel.updateElementPowerOrbpic1sAlpha()
	--update element health orb pic2s alpha
	panel.updateElementHealthOrbpic2sAlpha()
	--update element power orb pic2s alpha
	panel.updateElementPowerOrbpic2sAlpha()
	--update element health orb spark alpha
	panel.updateElementHealthOrbSparkAlpha()
	--update element power orb spark alpha
	panel.updateElementPowerOrbSparkAlpha()
	--update element health orb value hideOnEmpty
	panel.updateElementHealthOrbValueHideEmpty()
	--update element power orb value hideOnEmpty
	panel.updateElementPowerOrbValueHideEmpty()
	--update element health orb value hideOnFull
	panel.updateElementHealthOrbValueHideFull()
	--update element power orb value hideOnFull
	panel.updateElementPowerOrbValueHideFull()
	--update element health orb value alpha
	panel.updateElementHealthOrbValueAlpha()
	--update element power orb value alpha
	panel.updateElementPowerOrbValueAlpha()
	--update element health orb value top color
	panel.updateElementHealthOrbValueTopColor()
	--update element power orb value top color
	panel.updateElementPowerOrbValueTopColor()
	--update element health orb value bottom color
	panel.updateElementHealthOrbValueBottomColor()
	--update element power orb value bottom color
	panel.updateElementPowerOrbValueBottomColor()
	--update element health orb value top tag
	panel.updateElementHealthOrbValueTopTag()
	--update element power orb value top tag
	panel.updateElementPowerOrbValueTopTag()
	--update element health orb value bottom tag
	panel.updateElementHealthOrbValueBottomTag()
	--update element power orb value bottom tag
	panel.updateElementPowerOrbValueBottomTag()

---new-------
	panel.updateElementHealthOrbValueTopScale()
	panel.updateElementPowerOrbValueTopScale()
	panel.updateElementHealthOrbValueBottomScale()
	panel.updateElementPowerOrbValueBottomScale()

  end

---------------------------------------------
--UPDATE ORB VIEW
---------------------------------------------

  panel.updateOrbView = function()

	--if InCombatLockdown() then return end

	--update health orb filling texture
	panel.updateHealthOrbFillingTexture()
	--update power orb filling texture
	panel.updatePowerOrbFillingTexture()
	--update orb scale
	panel.updateOrbScale()
	--update health orbgrid model enable
	panel.updateHealthOrbGridEnable()
	--update power orbgrid model enable
	panel.updatePowerOrbGridEnable()
	--update health orb filling color
	panel.updateHealthOrbFillingColor()
	--update power orb filling color
	panel.updatePowerOrbFillingColor()
	--important! since auto coloring rewrites the color it has to be called after filling color
	--update health orb filling color auto
	panel.updateHealthOrbFillingColorAuto()
	--update power orb filling color auto
	panel.updatePowerOrbFillingColorAuto()
	--update health orb filling alpha
	panel.updateHealthOrbFillingAlpha()
	--update power orb filling alpha
	panel.updatePowerOrbFillingAlpha()
	--update health textureframe scale
	panel.updateHealthTextureFrameSize()
	--update power textureframe scale
	panel.updatePowerTextureFrameSize()
	--update health orb model enable
	panel.updateHealthOrbModelEnable()
	--update power orb model enable
	panel.updatePowerOrbModelEnable()
	--update health orb model animated
	panel.updateHealthOrbModelAnimated()
	--update power orb model animated
	panel.updatePowerOrbModelAnimated()
	--update health orb model animation
	panel.updateHealthOrbModelAnimation()
	--update power orb model animation
	panel.updatePowerOrbModelAnimation()
	--update health orb model alpha
	panel.updateHealthOrbModelAlpha()
	--update power orb model alpha
	panel.updatePowerOrbModelAlpha()
	--update health orb model camDistanceScale
	panel.updateHealthOrbModelCDS()
	--update power orb model camDistanceScale
	panel.updatePowerOrbModelCDS()
	--update health orb model pos x
	panel.updateHealthOrbModelPosX()
	--update power orb model pos x
	panel.updatePowerOrbModelPosX()
	--update health orb model pos y
	panel.updateHealthOrbModelPosY()
	--update power orb model pos y
	panel.updatePowerOrbModelPosY()
	--update health orb model rotation
	panel.updateHealthOrbModelRotation()
	--update power orb model rotation
	panel.updatePowerOrbModelRotation()
	--update health orb model zoom
	panel.updateHealthOrbModelZoom()
	--update power orb model zoom
	panel.updatePowerOrbModelZoom()
	--update health orb highlight alpha
	panel.updateHealthOrbHighlightAlpha()
	--update power orb highlight alpha
	panel.updatePowerOrbHighlightAlpha()
	--update health orb orbshadow alpha
	panel.updateHealthOrbOrbshadowAlpha()
	--update power orb orbshadow alpha
	panel.updatePowerOrbOrbshadowAlpha()
	--update health orb background alpha
	panel.updateHealthOrbBackgroundAlpha()
	--update power orb background alpha
	panel.updatePowerOrbBackgroundAlpha()
		--update health orb bubbles alpha
	panel.updateHealthOrbBubblesAlpha()
	--update power orb bubbles alpha
	panel.updatePowerOrbBubblesAlpha()
		--update health orb galaxies alpha
	panel.updateHealthOrbGalaxiesAlpha()
	--update power orb galaxies alpha
	panel.updatePowerOrbGalaxiesAlpha()
	--update health orb pic1s alpha
	panel.updateHealthOrbpic1sAlpha()
	--update power orb pic1s alpha
	panel.updatePowerOrbpic1sAlpha()
	--update health orb pic2s alpha
	panel.updateHealthOrbpic2sAlpha()
	--update power orb pic2s alpha
	panel.updatePowerOrbpic2sAlpha()
	--update health orb spark alpha
	panel.updateHealthOrbSparkAlpha()
	--update power orb spark alpha
	panel.updatePowerOrbSparkAlpha()
	--update health orb value alpha
	panel.updateHealthOrbValueAlpha()
	--update power orb value alpha
	panel.updatePowerOrbValueAlpha()
	--update health orb value top color
	panel.updateHealthOrbValueTopColor()
	--update power orb value top color
	panel.updatePowerOrbValueTopColor()
	--update health orb value bottom color
	panel.updateHealthOrbValueBottomColor()
	--update power orb value bottom color
	panel.updatePowerOrbValueBottomColor()
	--update health orb value top tag
	panel.updateHealthOrbValueTopTag()
	--update power orb value top tag
	panel.updatePowerOrbValueTopTag()
	--update health orb value bottom Tag
	panel.updateHealthOrbValueBottomTag()
	--update power orb value bottom tag
	panel.updatePowerOrbValueBottomTag()


	--update panel view
	panel.updatePanelView()

	---new-------
	panel.updateHealthOrbValueTopScale()
	panel.updatePowerOrbValueTopScale()
	panel.updateHealthOrbValueBottomScale()
	panel.updatePowerOrbValueBottomScale()

  end

---------------------------------------------
--FIX THE ORB DISPLAY ON NON-FULLY-FILLED ORBS
---------------------------------------------

--I want to use the orbs as a preview medium while in the config
--some orbs are empty (rage)
--empty orbs display nothing so we make sure all orbs are fillinged on config loadup
--forceUpdate on close makes sure they reset properly

  function panel:Enable()
	--register some stuff
	self.eventHelper:RegisterUnitEvent("UNIT_HEALTH", "player")
	self.eventHelper:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	self.eventHelper:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	self.eventHelper:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
	self.eventHelper:SetScript("OnEvent", function(self) self:SetOrbsToMax() end)
	self.eventHelper:SetOrbsToMax()
  end

  function panel:Disable()
	self.eventHelper:UnregisterEvent("UNIT_HEALTH", "player")
	self.eventHelper:UnregisterEvent("UNIT_POWER_UPDATE", "player")
	self.eventHelper:UnregisterEvent("UNIT_POWER_FREQUENT", "player")
	self.eventHelper:UnregisterEvent("UNIT_DISPLAYPOWER", "player")
	self.eventHelper:SetScript("OnEvent", nil)
	self.eventHelper:SetOrbsToDefault()
	--reset the focus to the last active chatwindow
	ChatEdit_FocusActiveWindow()--nice function
  end

  do
	local eventHelper = CF("Frame")
	function eventHelper:SetOrbsToMax()
	  local hbar, pbar = ns.HealthOrb.filling, ns.PowerOrb.filling
	  local hval, pval = ns.HealthOrb.values, ns.PowerOrb.values
	  local hmin, hmax = hbar:GetMinMaxValues()
	  local pmin, pmax = pbar:GetMinMaxValues()
	  local skull, lowHP = ns.HealthOrb.skull, ns.HealthOrb.lowHP
	  hbar:SetValue(hmax*0.9)
	  pbar:SetValue(pmax*0.9)
	  hval:Show()
	  pval:Show()
	  skull:Hide()
	  lowHP:Hide()
	end
	function eventHelper:SetOrbsToDefault()
	  local hbar, pbar = ns.HealthOrb.filling, ns.PowerOrb.filling
	  local hval, pval = ns.HealthOrb.values, ns.PowerOrb.values
	  hbar:ForceUpdate()
	  pbar:ForceUpdate()
	end
	panel.eventHelper = eventHelper
	panel:HookScript("OnShow", function(self) self:Enable() end)
	panel:HookScript("OnHide", function(self) self:Disable() end)
  end

  local Event = CreateFrame("Frame")
	Event:RegisterEvent("PLAYER_LOGIN")
	-- Event:RegisterEvent("UNIT_POWER_UPDATE", "player")
	-- Event:RegisterEvent("UNIT_HEALTH", "player")
	-- Event:RegisterEvent("UNIT_POWER_FREQUENT", "player")
	Event:RegisterEvent("UNIT_DISPLAYPOWER", "player")
	-- Event:RegisterEvent("UNIT_FORM_CHANGED", "player");
	-- Event:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "player");
	Event:SetScript("OnEvent", function(...)
		if event == "PLAYER_LOGIN" then 
			panel.updateHealthOrbFillingColorAuto()
			panel.updatePowerOrbFillingColorAuto()
		else
			panel.updatePowerOrbFillingColorAuto()
		end
	end)


  function DcSlashCmd()
	--if InCombatLockdown() then return end
		if panel:IsShown() then
		panel:Hide()
		else
		panel:Show()
		print("|cffff0000!!!|r |cff00ff00\/Dr|r to reset all frames position")
		print("|cffff0000!!!|r |cff00ff00\/Dcrt|r, to delete and reset templates")
		end
  end

  SlashCmdList["DC"] =  function() DcSlashCmd() end
  print("|cffff0000>|r |cff00ff00\/Dc|r to open the DiabloUI panel")
  SLASH_DC1 = "/dc"

  local function DcrtSlashCmd()
	ns.db.resetTemplates()
  end

  SlashCmdList["DCRT"] =  function() DcrtSlashCmd() end
  SLASH_DCRT1 = "/dcrt"