local Style = mUI:GetModule("mUI.Modules.Chat.Style")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next

local _, class = UnitClass("player")
local color = RAID_CLASS_COLORS[class]

local function chatTab_SetPoint(self, _, anchor, _, _, _, shouldIgnore)
	if anchor == GeneralDockManager.scrollFrame.child and not shouldIgnore then
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, 0, true)

		if mUI:IsClassic() then
			if GeneralDockManager.overflowButton and GeneralDockManager.overflowButton:IsShown() then
				local point, relativeTo, relativePoint, xOffset = GeneralDockManager.overflowButton:GetPoint()
				GeneralDockManager.overflowButton:ClearAllPoints()
				GeneralDockManager.overflowButton:SetPoint(point, relativeTo, relativePoint, xOffset, 0)
			end
		end
	end
end

local function chatTab_OnDragStart(self)
	local frame = Style:GetSlidingFrameForChatFrame(_G["ChatFrame" .. self:GetID()])
	if frame then
		frame.isDragging = true
	end
end

local function chatTabText_SetPoint(self, p, anchor, rP, x, y, shouldIgnore)
	if not shouldIgnore then
		if mUI:IsClassic() then
			if anchor.conversationIcon then
				self:SetPoint(p, _G[anchor:GetName() .. "Left"], rP, p == "LEFT" and 10 or x, 5, true)
			else
				self:SetPoint(p, _G[anchor:GetName() .. "Left"], rP, p == "LEFT" and 0 or x, 5, true)
			end
		else
			self:SetPoint(p, anchor, rP, p == "LEFT" and 8 or x, p == "CENTER" and 0 or y, true)
		end
	end
end

local function chatTabText_SetTextColor(self, r, g, b)
	if r == NORMAL_FONT_COLOR.r and g == NORMAL_FONT_COLOR.g and b == NORMAL_FONT_COLOR.b then
		self:SetTextColor(color.r, color.g, color.b)
	end
end

local handledTabs = {}

local TAB_TEXTURES
if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
	TAB_TEXTURES = {
		"leftTexture",
		"middleTexture",
		"rightTexture",

		-- "ActiveLeft",
		-- "ActiveMiddle",
		-- "ActiveRight",

		-- "HighlightLeft",
		-- "HighlightMiddle",
		-- "HighlightRight",
	}
else
	TAB_TEXTURES = {
		"Left",
		"Middle",
		"Right",

		-- "ActiveLeft",
		-- "ActiveMiddle",
		-- "ActiveRight",

		-- "HighlightLeft",
		-- "HighlightMiddle",
		-- "HighlightRight",
	}
end

function Style:HandleChatTab(frame)
	if not handledTabs[frame] then
		frame.Backdrop = Style:CreateBackdrop(frame, Style.db.dock.alpha)

		Style:SecureHook(frame, "SetPoint", chatTab_SetPoint)
		Style:SecureHookScript(frame, "OnDragStart", chatTab_OnDragStart)

		if mUI:IsClassic() then
			Style:SecureHook(frame.Text, "SetPoint", function(textframe, p, anchor, rP, x, y, shouldIgnore)
				chatTabText_SetPoint(textframe, p, frame, rP, x, y, shouldIgnore)
			end)
		else
			Style:SecureHook(frame.Text, "SetPoint", chatTabText_SetPoint)
		end
		Style:SecureHook(frame.Text, "SetTextColor", chatTabText_SetTextColor)

		handledTabs[frame] = true
	end

	for _, texture in next, TAB_TEXTURES do
		frame[texture]:SetTexture(0)
	end

	frame:SetHeight(20)

	frame.glow:ClearAllPoints()
	frame.glow:SetPoint("BOTTOMLEFT", 8, 2)
	frame.glow:SetPoint("BOTTOMRIGHT", -8, 2)

	if mUI:IsClassic() then
		frame.leftSelectedTexture:ClearAllPoints()
		frame.leftSelectedTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		frame.leftSelectedTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.leftSelectedTexture:SetTexCoord(0, 1, 0.5, 1)
		frame.leftSelectedTexture:SetSize(8, 8)

		frame.rightSelectedTexture:ClearAllPoints()
		frame.rightSelectedTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		frame.rightSelectedTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.rightSelectedTexture:SetTexCoord(1, 0, 0.5, 1)
		frame.rightSelectedTexture:SetSize(8, 8)

		frame.middleSelectedTexture:ClearAllPoints()
		frame.middleSelectedTexture:SetPoint("TOPLEFT", frame.leftSelectedTexture, "TOPRIGHT", 0, 0)
		frame.middleSelectedTexture:SetPoint("TOPRIGHT", frame.rightSelectedTexture, "TOPLEFT", 0, 0)
		frame.middleSelectedTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.middleSelectedTexture:SetTexCoord(0, 1, 0, 0.5)
		frame.middleSelectedTexture:SetSize(8, 8)

		frame.leftHighlightTexture:ClearAllPoints()
		frame.leftHighlightTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		frame.leftHighlightTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.leftHighlightTexture:SetTexCoord(0, 1, 0.5, 1)
		frame.leftHighlightTexture:SetSize(8, 8)

		frame.rightHighlightTexture:ClearAllPoints()
		frame.rightHighlightTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		frame.rightHighlightTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.rightHighlightTexture:SetTexCoord(1, 0, 0.5, 1)
		frame.rightHighlightTexture:SetSize(8, 8)

		frame.middleHighlightTexture:ClearAllPoints()
		frame.middleHighlightTexture:SetPoint("TOPLEFT", frame.leftHighlightTexture, "TOPRIGHT", 0, 0)
		frame.middleHighlightTexture:SetPoint("TOPRIGHT", frame.rightHighlightTexture, "TOPLEFT", 0, 0)
		frame.middleHighlightTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.middleHighlightTexture:SetTexCoord(0, 1, 0, 0.5)
		frame.middleHighlightTexture:SetSize(8, 8)
	else
		frame.ActiveLeft:ClearAllPoints()
		frame.ActiveLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		frame.ActiveLeft:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.ActiveLeft:SetTexCoord(0, 1, 0.5, 1)
		frame.ActiveLeft:SetSize(8, 8)

		frame.ActiveRight:ClearAllPoints()
		frame.ActiveRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		frame.ActiveRight:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.ActiveRight:SetTexCoord(1, 0, 0.5, 1)
		frame.ActiveRight:SetSize(8, 8)

		frame.ActiveMiddle:ClearAllPoints()
		frame.ActiveMiddle:SetPoint("TOPLEFT", frame.HighlightLeft, "TOPRIGHT", 0, 0)
		frame.ActiveMiddle:SetPoint("TOPRIGHT", frame.HighlightRight, "TOPLEFT", 0, 0)
		frame.ActiveMiddle:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.ActiveMiddle:SetTexCoord(0, 1, 0, 0.5)
		frame.ActiveMiddle:SetSize(8, 8)

		frame.HighlightLeft:ClearAllPoints()
		frame.HighlightLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		frame.HighlightLeft:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.HighlightLeft:SetTexCoord(0, 1, 0.5, 1)
		frame.HighlightLeft:SetSize(8, 8)

		frame.HighlightRight:ClearAllPoints()
		frame.HighlightRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		frame.HighlightRight:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.HighlightRight:SetTexCoord(1, 0, 0.5, 1)
		frame.HighlightRight:SetSize(8, 8)

		frame.HighlightMiddle:ClearAllPoints()
		frame.HighlightMiddle:SetPoint("TOPLEFT", frame.HighlightLeft, "TOPRIGHT", 0, 0)
		frame.HighlightMiddle:SetPoint("TOPRIGHT", frame.HighlightRight, "TOPLEFT", 0, 0)
		frame.HighlightMiddle:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.HighlightMiddle:SetTexCoord(0, 1, 0, 0.5)
		frame.HighlightMiddle:SetSize(8, 8)
	end


	if frame.conversationIcon then
		if mUI:IsClassic() then
			frame.conversationIcon:SetPoint("RIGHT", _G[frame:GetName() .. "Left"], "LEFT", 25, 6)
		else
			frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
		end
	end

	-- reset the tab
	frame:SetPoint(frame:GetPoint(1))


	if not frame.selectedColorTable then
		frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	-- it can be "CENTER" or "LEFT", so just use the index
	frame.Text:SetPoint(frame.Text:GetPoint(1))
end

local handledMiniTabs = {}

local MINI_TAB_TEXTURES
if WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
	MINI_TAB_TEXTURES = {
		"leftTexture",
		"middleTexture",
		"rightTexture",

		-- "ActiveLeft",
		-- "ActiveMiddle",
		-- "ActiveRight",

		-- "HighlightLeft",
		-- "HighlightMiddle",
		-- "HighlightRight",
	}
else
	MINI_TAB_TEXTURES = {
		"Left",
		"Middle",
		"Right",

		-- "ActiveLeft",
		-- "ActiveMiddle",
		-- "ActiveRight",

		-- "HighlightLeft",
		-- "HighlightMiddle",
		-- "HighlightRight",
	}
end

function Style:HandleMinimizedTab(frame)
	if not handledMiniTabs[frame] then
		frame.Backdrop = Style:CreateBackdrop(frame, Style.db.dock.alpha)

		Style:HandleMaximizeButton(_G[frame:GetName() .. "MaximizeButton"])

		Style:SecureHook(frame.Text, "SetTextColor", chatTabText_SetTextColor)

		handledMiniTabs[frame] = true
	end

	for _, texture in next, MINI_TAB_TEXTURES do
		frame[texture]:SetTexture(0)
	end

	frame:SetHeight(20)

	frame.glow:ClearAllPoints()
	frame.glow:SetPoint("BOTTOMLEFT", 8, 2)
	frame.glow:SetPoint("BOTTOMRIGHT", -24, 2)

	if mUI:IsClassic() then
		frame.leftHighlightTexture:ClearAllPoints()
		frame.leftHighlightTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		frame.leftHighlightTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.leftHighlightTexture:SetTexCoord(0, 1, 0.5, 1)
		frame.leftHighlightTexture:SetSize(8, 8)

		frame.rightHighlightTexture:ClearAllPoints()
		frame.rightHighlightTexture:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		frame.rightHighlightTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.rightHighlightTexture:SetTexCoord(1, 0, 0.5, 1)
		frame.rightHighlightTexture:SetSize(8, 8)

		frame.middleHighlightTexture:ClearAllPoints()
		frame.middleHighlightTexture:SetPoint("TOPLEFT", frame.leftHighlightTexture, "TOPRIGHT", 0, 0)
		frame.middleHighlightTexture:SetPoint("TOPRIGHT", frame.rightHighlightTexture, "TOPLEFT", 0, 0)
		frame.middleHighlightTexture:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.middleHighlightTexture:SetTexCoord(0, 1, 0, 0.5)
		frame.middleHighlightTexture:SetSize(8, 8)
	else
		frame.HighlightLeft:ClearAllPoints()
		frame.HighlightLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		frame.HighlightLeft:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.HighlightLeft:SetTexCoord(0, 1, 0.5, 1)
		frame.HighlightLeft:SetSize(8, 8)

		frame.HighlightRight:ClearAllPoints()
		frame.HighlightRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		frame.HighlightRight:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.HighlightRight:SetTexCoord(1, 0, 0.5, 1)
		frame.HighlightRight:SetSize(8, 8)

		frame.HighlightMiddle:ClearAllPoints()
		frame.HighlightMiddle:SetPoint("TOPLEFT", frame.HighlightLeft, "TOPRIGHT", 0, 0)
		frame.HighlightMiddle:SetPoint("TOPRIGHT", frame.HighlightRight, "TOPLEFT", 0, 0)
		frame.HighlightMiddle:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border-highlight")
		frame.HighlightMiddle:SetTexCoord(0, 1, 0, 0.5)
		frame.HighlightMiddle:SetSize(8, 8)
	end

	-- reset the tab
	if not frame.selectedColorTable then
		frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	if mUI:IsClassic() then
		frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 5, 0)
	else
		frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
	end
end

function Style:UpdateTabAlpha()
	local alpha = Style.db.dock.alpha

	for tab in next, handledTabs do
		tab.Backdrop:UpdateAlpha(alpha)
	end
end

function Style:EnableDragHook()
	Style:SecureHook("FCFTab_OnDragStop", function(self)
		local frame = Style:GetSlidingFrameForChatFrame(_G["ChatFrame" .. self:GetID()])
		if frame then
			if frame.isMouseOver then
				frame.isMouseOver = nil
			end

			frame.isDragging = nil
		end
	end)
end
