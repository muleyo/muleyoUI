local Style = mUI:GetModule("mUI.Modules.Chat.Style")

local _G = getfenv(0)
local t_insert = _G.table.insert
local t_remove = _G.table.remove
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

----------------------------------------------------------------
-- Pool of pre-initialised backdrops.
-- Created at load time (outside combat) with SetBackdrop already
-- applied so we never have to call SetBackdrop during combat.
----------------------------------------------------------------
local pool = {}
local POOL_SIZE = 20 -- enough for all chat tabs + editboxes + buttons + scroll buttons

local function CreatePooledBackdrop()
    local f = Mixin(CreateFrame("Frame", nil, UIParent, "BackdropTemplate"), backdrop_proto)
    f:Hide()
    f:SetSize(1, 1) -- explicit size so SetBackdrop succeeds
    f:SetBackdrop(BACKDROP_INFO)
    -- fix the Blizzard gap issue
    f.Center:ClearAllPoints()
    f.Center:SetPoint("TOPLEFT", f.TopLeftCorner, "BOTTOMRIGHT", 0, 0)
    f.Center:SetPoint("BOTTOMRIGHT", f.BottomRightCorner, "TOPLEFT", 0, 0)
    return f
end

-- Fill the pool immediately (at file load, always outside combat).
for _ = 1, POOL_SIZE do
    t_insert(pool, CreatePooledBackdrop())
end

local function AcquireBackdrop()
    local f = t_remove(pool)
    if not f then
        -- Pool exhausted (shouldn't happen normally) – create on the fly.
        -- If we're in combat this will need the deferred path, but with
        -- POOL_SIZE large enough this should never be reached.
        f = CreatePooledBackdrop()
    end
    return f
end

function Style:CreateBackdrop(parent, alpha, xOffset, yOffset)
    local backdrop = AcquireBackdrop()
    backdrop:SetParent(parent)
    backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
    backdrop:ClearAllPoints()
    backdrop:SetSize(0, 0) -- clear explicit size, let anchors drive dimensions
    backdrop:SetPoint("TOPLEFT", xOffset or 0, -(yOffset or 0))
    backdrop:SetPoint("BOTTOMRIGHT", -(xOffset or 0), yOffset or 0)
    backdrop:SetBackdropColor(0, 0, 0, alpha)
    backdrop:SetBackdropBorderColor(0, 0, 0, alpha)

    -- Show() triggers OnSizeChanged → SetupTextureCoordinates which does
    -- arithmetic on GetWidth().  If the parent's geometry is tainted (from
    -- addon code touching it during combat), that width is a secret even
    -- after combat ends.  Suppress the handler during Show(), then restore
    -- it; the layout engine will fire OnSizeChanged naturally on the next
    -- frame with resolved dimensions.
    local origOnSizeChanged = backdrop:GetScript("OnSizeChanged")
    backdrop:SetScript("OnSizeChanged", nil)
    backdrop:Show()
    backdrop:SetScript("OnSizeChanged", origOnSizeChanged)

    if InCombatLockdown() then
        -- Additionally defer a re-parent cycle after combat to fully
        -- break the taint chain so texture coords get clean values.
        backdrop:RegisterEvent("PLAYER_REGEN_ENABLED")
        backdrop:SetScript("OnEvent", function(self)
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            self:SetScript("OnEvent", nil)
            self:Hide()
            self:SetParent(UIParent)
            self:ClearAllPoints()
            self:SetSize(1, 1)
            self:SetParent(parent)
            self:SetFrameLevel(parent:GetFrameLevel() - 1)
            self:SetSize(0, 0)
            self:SetPoint("TOPLEFT", xOffset or 0, -(yOffset or 0))
            self:SetPoint("BOTTOMRIGHT", -(xOffset or 0), yOffset or 0)
            self:Show()
        end)
    end

    t_insert(backdrops, backdrop)

    return backdrop
end
