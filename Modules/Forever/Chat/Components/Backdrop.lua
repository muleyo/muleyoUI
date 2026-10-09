local Style = mUI:GetModule("mUI.Modules.Chat.Style")

local _G = getfenv(0)
local t_insert = _G.table.insert
local t_remove = _G.table.remove
local pcall = _G.pcall
local backdrops = {}
local backdrop_proto = {}

function backdrop_proto:UpdateAlpha(a)
    self:SetBackdropColor(0, 0, 0, a)
    self:SetBackdropBorderColor(0, 0, 0, a)
end

-- A backdrop definition shared by every instance.
local BACKDROP_INFO = {
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\AddOns\\mUI\\Media\\Textures\\Chat\\border",
    tile = true,
    tileEdge = true,
    tileSize = 8,
    edgeSize = 8
}

local pool = {}
local POOL_SIZE = 20

local function CreatePooledBackdrop()
    local f = Mixin(CreateFrame("Frame", nil, UIParent, "BackdropTemplate"), backdrop_proto)
    f:Hide()
    f:SetBackdrop(BACKDROP_INFO)
    -- fix the Blizzard gap issue
    f.Center:ClearAllPoints()
    f.Center:SetPoint("TOPLEFT", f.TopLeftCorner, "BOTTOMRIGHT", 0, 0)
    f.Center:SetPoint("BOTTOMRIGHT", f.BottomRightCorner, "TOPLEFT", 0, 0)

    local origSetupTC = f.SetupTextureCoordinates
    f.SetupTextureCoordinates = function(self, ...)
        pcall(origSetupTC, self, ...)
    end

    return f
end

for _ = 1, POOL_SIZE do
    t_insert(pool, CreatePooledBackdrop())
end

local function AcquireBackdrop()
    local f = t_remove(pool)
    if not f then
        f = CreatePooledBackdrop()
    end
    return f
end

function Style:CreateBackdrop(parent, alpha, xOffset, yOffset)
    local backdrop = AcquireBackdrop()
    backdrop:SetParent(parent)
    backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
    backdrop:SetPoint("TOPLEFT", xOffset or 0, -(yOffset or 0))
    backdrop:SetPoint("BOTTOMRIGHT", -(xOffset or 0), yOffset or 0)
    backdrop:SetBackdropColor(0, 0, 0, alpha)
    backdrop:SetBackdropBorderColor(0, 0, 0, alpha)
    backdrop:Show()

    t_insert(backdrops, backdrop)

    return backdrop
end
