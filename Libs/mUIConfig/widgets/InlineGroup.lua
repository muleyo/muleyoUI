local Type, Version = "mUI_InlineGroup", 22
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then
    return
end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self:SetWidth(300)
        self:SetHeight(100)
        self:SetTitle("")
    end,

    -- ["OnRelease"] = nil,

    ["SetTitle"] = function(self, title)
        self.titletext:SetText(title)
    end,

    ["LayoutFinished"] = function(self, width, height)
        if self.noAutoHeight then
            return
        end
        self:SetHeight((height or 0) + 40)
    end,

    ["OnWidthSet"] = function(self, width)
        local content = self.content
        local contentwidth = width - 20
        if contentwidth < 0 then
            contentwidth = 0
        end
        content:SetWidth(contentwidth)
        content.width = contentwidth
    end,

    ["OnHeightSet"] = function(self, height)
        local content = self.content
        local contentheight = height - 20
        if contentheight < 0 then
            contentheight = 0
        end
        content:SetHeight(contentheight)
        content.height = contentheight
    end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]

local function Constructor()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetFrameStrata("FULLSCREEN_DIALOG")

    local titletext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titletext:SetPoint("TOPLEFT", 14, 0)
    titletext:SetPoint("TOPRIGHT", -14, 0)
    titletext:SetJustifyH("LEFT")
    titletext:SetHeight(18)

    local border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    border:SetPoint("TOPLEFT", 0, -17)
    border:SetPoint("BOTTOMRIGHT", -1, 3)

    local pixel = mUI:Scale(1)

    local PaneBackdrop = {
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = pixel,
        insets = {
            left = pixel,
            right = pixel,
            top = pixel,
            bottom = pixel
        }
    }

    border:SetBackdrop(PaneBackdrop)
    -- Disable pixel snapping on border textures
    for _, region in next, {border:GetRegions()} do
        if region and region.IsObjectType then
            mUI:DisablePixelSnap(region)
        end
    end
    border:SetBackdropBorderColor(0, 0.6, 1, 1)

    -- Container Support
    local content = CreateFrame("Frame", nil, border)
    content:SetPoint("TOPLEFT", 10, -10)
    content:SetPoint("BOTTOMRIGHT", -10, 10)

    local widget = {
        frame = frame,
        content = content,
        titletext = titletext,
        type = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end

    return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
