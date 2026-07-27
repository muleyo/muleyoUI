local mGUI = {}
mUI.mGUI = mGUI

mGUI.Widgets = {}

mGUI.EnableKeys = {
    enable = true,
    enabled = true
}

-- Returns a category's module-toggle option (and its key), or nil
function mGUI:GetEnableOption(category)
    local args = category and category.options and category.options.args
    if not args then
        return nil
    end
    for key in pairs(self.EnableKeys) do
        if args[key] then
            return args[key], key
        end
    end
    return nil
end

-- Central dark/blue theme — every widget pulls colors from here
mGUI.Colors = {
    bg = {0.05, 0.05, 0.05, 0.95}, -- main window backdrop
    bgAlt = {0.02, 0.02, 0.02, 1}, -- header / sidebar
    bgWidget = {0.08, 0.08, 0.08, 0.9}, -- rows, editbox fills
    bgHover = {0.12, 0.12, 0.12, 1}, -- hovered rows
    border = {0.2, 0.55, 0.9, 1}, -- 1px window/widget borders (bright enough to read)
    accent = {0, 0.61, 1}, -- #009cff: ticks, radio dots, selection
    accentDim = {0, 0.42, 0.7}, -- pressed/secondary accent
    buttonTint = {0.45, 0.65, 0.95}, -- vertex color for desaturated 128-RedButton slices
    text = {0.9, 0.9, 0.9},
    textDim = {0.6, 0.6, 0.6},
    version = {0.6, 0.6, 0.6} -- grey, matches the "UI" part of the logo text
}

local BLANK = "Interface\\ChatFrame\\ChatFrameBackground"

-- Current LSM font, resolved lazily (db is not ready at file-load time)
function mGUI:GetFont()
    local LSM = LibStub("LibSharedMedia-3.0")
    return LSM:Fetch("font", mUI.db.profile.general.font)
end

function mGUI:SetFont(fontString, size, flags)
    fontString:SetFont(self:GetFont(), size or 12, flags or "OUTLINE")
end

-- Solid background + pixel-perfect 1px border in theme colors.
function mGUI:ApplyBackdrop(frame, colorKey, borderKey, alphaOverride, thickness)
    local bg = self.Colors[colorKey or "bg"]
    local edge = borderKey ~= false and self.Colors[borderKey or "border"]

    frame:SetBackdrop({
        bgFile = BLANK
    })
    for _, region in next, {frame:GetRegions()} do
        if region and region.IsObjectType and region:IsObjectType("Texture") then
            mUI:DisablePixelSnap(region)
        end
    end
    frame:SetBackdropColor(bg[1], bg[2], bg[3], alphaOverride or bg[4])

    if edge then
        self:ApplyEdgeBorder(frame, edge, thickness)
    elseif frame.mGUIBorderFrame then
        frame.mGUIBorderFrame:Hide()
    end
end

function mGUI:ApplyEdgeBorder(frame, color, thickness)
    local border = frame.mGUIBorderFrame
    if not border then
        border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        PixelUtil.SetPoint(border, "TOPLEFT", frame, "TOPLEFT", 0, 0)
        PixelUtil.SetPoint(border, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        border:SetFrameLevel(frame:GetFrameLevel() + 50)
        border:SetFrameStrata("TOOLTIP")
        frame.mGUIBorderFrame = border
    end
    border:Show()

    local size = thickness or mUI:Scale(1)

    border:SetBackdrop({
        edgeFile = BLANK,
        edgeSize = size,
        insets = {
            left = size,
            right = size,
            top = size,
            bottom = size
        }
    })
    for _, region in next, {border:GetRegions()} do
        if region and region.IsObjectType then
            mUI:DisablePixelSnap(region)
        end
    end
    border:SetBackdropBorderColor(color[1], color[2], color[3], color[4])
end

function mGUI:ApplyQuadBorder(frame, color, thickness)
    local size = thickness or mUI:Scale(1)

    local overlay = frame.mGUIQuadOverlay
    if not overlay then
        overlay = CreateFrame("Frame", nil, frame)
        PixelUtil.SetPoint(overlay, "TOPLEFT", frame, "TOPLEFT", 0, 0)
        PixelUtil.SetPoint(overlay, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        overlay:SetFrameLevel(frame:GetFrameLevel() + 50)
        overlay:SetFrameStrata("TOOLTIP")
        frame.mGUIQuadOverlay = overlay
    end
    overlay:Show()

    local function Edge(key, p1, rel1, ox1, oy1, p2, rel2, ox2, oy2)
        local t = overlay[key]
        if not t then
            t = overlay:CreateTexture(nil, "OVERLAY")
            overlay[key] = t
        end
        t:ClearAllPoints()
        t:SetColorTexture(color[1], color[2], color[3], color[4])
        PixelUtil.SetPoint(t, p1, overlay, rel1, ox1, oy1)
        PixelUtil.SetPoint(t, p2, overlay, rel2, ox2, oy2)
    end

    Edge("top", "TOPLEFT", "TOPLEFT", 0, 0, "BOTTOMRIGHT", "TOPRIGHT", 0, -size)
    Edge("bottom", "TOPLEFT", "BOTTOMLEFT", 0, size, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0)
    Edge("left", "TOPLEFT", "TOPLEFT", 0, 0, "BOTTOMRIGHT", "BOTTOMLEFT", size, 0)
    Edge("right", "TOPLEFT", "TOPRIGHT", -size, 0, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0)
end

function mGUI:TintThreeSlice(button)
    if button.mGUITinted then
        return
    end
    button.mGUITinted = true

    local function Retint(btn)
        local color = btn:IsEnabled() and mGUI.Colors.buttonTint or mGUI.Colors.textDim
        for _, slice in next, {btn.Left, btn.Center, btn.Middle, btn.Right} do
            if slice then
                slice:SetDesaturated(true)
                slice:SetVertexColor(unpack(color))
            end
        end
        local highlight = btn:GetHighlightTexture()
        if highlight then
            highlight:SetDesaturated(true)
            highlight:SetVertexColor(unpack(mGUI.Colors.accent))
        end
    end

    if button.UpdateButton then
        hooksecurefunc(button, "UpdateButton", Retint)
    end
    Retint(button)
end

function mGUI:TintIconButton(button)
    local normal = button:GetNormalTexture()
    if normal then
        normal:SetDesaturated(true)
        normal:SetVertexColor(unpack(self.Colors.buttonTint))
    end

    local pushed = button:GetPushedTexture()
    if pushed then
        pushed:SetDesaturated(true)
        pushed:SetVertexColor(unpack(self.Colors.buttonTint))
    end

    local disabled = button:GetDisabledTexture()
    if disabled then
        disabled:SetDesaturated(true)
        disabled:SetVertexColor(unpack(self.Colors.textDim))
    end

    local highlight = button:GetHighlightTexture()
    if highlight then
        highlight:SetDesaturated(true)
        highlight:SetVertexColor(unpack(self.Colors.accent))
    end
end

function mGUI:ApplyWindowArt(frame, glowHeight)
    local px = PixelUtil.GetNearestPixelSize(1, frame:GetEffectiveScale())

    if C_Texture.GetAtlasInfo("shop-card-wide-bg-blue") then
        local bgArt = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
        bgArt:SetPoint("TOPLEFT", px, -px)
        bgArt:SetPoint("BOTTOMRIGHT", -px, px)
        bgArt:SetAtlas("shop-card-wide-bg-blue")
        bgArt:SetAlpha(0.55)
        bgArt:SetVertexColor(0.7, 0.8, 1)
    end

    local topGlow = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
    topGlow:SetPoint("TOPLEFT", px, -px)
    topGlow:SetPoint("TOPRIGHT", -px, -px)
    topGlow:SetHeight(glowHeight or 90)
    topGlow:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    topGlow:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(self.Colors.accent[1], self.Colors.accent[2], self.Colors.accent[3], 0.15))
end

-- Fades a frame in from alpha 0 (no-op if already shown).
function mGUI:FadeShow(frame, duration)
    if frame:IsShown() then
        return
    end
    frame:SetAlpha(0)
    frame:Show()
    UIFrameFadeIn(frame, duration or 0.2, 0, 1)
end

-- Fades a frame out, then hides it (no-op if already hidden).
function mGUI:FadeHide(frame, duration)
    if not frame:IsShown() then
        return
    end
    UIFrameFade(frame, {
        mode = "OUT",
        timeToFade = duration or 0.2,
        finishedFunc = function()
            frame:Hide()
        end
    })
end

function mGUI:CreateThreeSlice(frame, atlasName)
    atlasName = atlasName or "128-RedButton"

    local left = frame:CreateTexture(nil, "BACKGROUND")
    left:SetPoint("TOPLEFT")
    local right = frame:CreateTexture(nil, "BACKGROUND")
    right:SetPoint("TOPRIGHT")
    local center = frame:CreateTexture(nil, "BACKGROUND")
    center:SetPoint("TOPLEFT", left, "TOPRIGHT")
    center:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")

    local slices = {
        Left = left,
        Center = center,
        Right = right
    }

    local controller = {}

    function controller.SetState(_, state)
        controller.state = state
        local postfix = state == "Pressed" and "-Pressed" or state == "Disabled" and "-Disabled" or ""
        local height = frame:GetHeight()
        local color = state == "Disabled" and mGUI.Colors.textDim or mGUI.Colors.buttonTint

        for key, tex in pairs(slices) do
            local atlas = key == "Center" and ("_" .. atlasName .. "-Center" .. postfix) or (atlasName .. "-" .. key .. postfix)
            tex:SetAtlas(atlas)
            if key ~= "Center" then
                local info = C_Texture.GetAtlasInfo(atlas)
                if info and info.height > 0 then
                    tex:SetSize(height * (info.width / info.height), height)
                end
            end
            tex:SetDesaturated(true)
            tex:SetVertexColor(unpack(color))
        end
    end

    frame:HookScript("OnSizeChanged", function()
        controller:SetState(controller.state or "Normal")
    end)

    controller:SetState("Normal")
    return controller
end

function mGUI:EnableSmoothScroll(scrollFrame)
    local target
    local SPEED = 12 -- interpolation factor per second
    local WHEEL_STEP = 100 -- pixels per wheel notch

    local function Stop(frame)
        frame:SetScript("OnUpdate", nil)
        target = nil
    end

    local function OnUpdate(frame, elapsed)
        local current = frame:GetVerticalScroll()
        local diff = target - current
        if math.abs(diff) < 0.5 then
            frame:SetVerticalScroll(target)
            Stop(frame)
        else
            frame:SetVerticalScroll(current + diff * math.min(elapsed * SPEED, 1))
        end
    end

    scrollFrame:SetScript("OnMouseWheel", function(frame, delta)
        local child = frame:GetScrollChild()
        local range = math.max(0, child:GetHeight() - frame:GetHeight())
        local from = target or frame:GetVerticalScroll()
        target = math.max(0, math.min(range, from - delta * WHEEL_STEP))
        frame:SetScript("OnUpdate", OnUpdate)
    end)

    scrollFrame.StopSmoothScroll = Stop
end

function mGUI:AttachTooltip(widget, titleFn, textFn, titleColorFn)
    local function OnEnter(frame)
        local title = type(titleFn) == "function" and titleFn() or titleFn
        local text = type(textFn) == "function" and textFn() or textFn
        if not text or text == "" then
            return
        end
        local color = type(titleColorFn) == "function" and titleColorFn() or titleColorFn
        local r, g, b = unpack(color or {1, 1, 1})
        GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
        if title and title ~= "" then
            GameTooltip:AddLine(title, r, g, b)
        end
        GameTooltip:AddLine(text, nil, nil, nil, true)
        GameTooltip:Show()
    end
    local function OnLeave()
        GameTooltip:Hide()
    end

    if not widget.mGUITooltipFrameOnly then
        widget:HookScript("OnEnter", OnEnter)
        widget:HookScript("OnLeave", OnLeave)
    end
    if widget.mGUITooltipFrame then
        widget.mGUITooltipFrame:HookScript("OnEnter", OnEnter)
        widget.mGUITooltipFrame:HookScript("OnLeave", OnLeave)
    end
end
