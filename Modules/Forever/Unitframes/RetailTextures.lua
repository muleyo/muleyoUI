-- Retail Textures (WoW Forever): retail-style frame art for Player, Target and
-- Focus, with the health and mana bars laid into the art's own bar slots.
--
-- Ported from BetterBlizzFrames by Bodify: forever/modules/retailTextures.lua
-- (art coordinates, bar slots, slot fitting and masks). The base art is the
-- retail unit frame sheet that ships with the game client (file 4642466); the
-- Big Healthbar variants and the bar masks are BBF's own PNGs, copied to
-- Media\Textures\RetailFrames.
--
-- This file holds the art and the slot geometry (mUI.UFRetail). Laying the
-- frames out is done by BigHealthbar.lua (mUI.UFLayout), which handles every
-- combination of the two options, since both change the same bars.

local RetailTextures = mUI:NewModule("mUI.Modules.Unitframes.RetailTextures")

local MEDIA = "Interface\\AddOns\\mUI\\Media\\Textures\\RetailFrames\\"
local SHEET = 4642466

-- [key] = { width, height, left, right, top, bottom } on the retail sheet.
local ART = {
    ["Player-PortraitOn"] = { 198, 71, 0.0004882812, 0.1938476562, 0.1669921875, 0.3056640625 },
    ["Player-PortraitOn-ClassResource"] = { 198, 74, 0.7846679688, 0.9780273438, 0.0009765625, 0.1455078125 },
    ["Player-PortraitOn-InCombat"] = { 192, 71, 0.5756835938, 0.7631835938, 0.1669921875, 0.3056640625 },
    ["Player-PortraitOn-ClassResource-InCombat"] = { 192, 71, 0.3872070312, 0.5747070312, 0.1669921875, 0.3056640625 },
    ["Player-PortraitOn-Status"] = { 196, 71, 0.1948242188, 0.3862304688, 0.1669921875, 0.3056640625 },
    ["Target-PortraitOn"] = { 192, 67, 0.0004882812, 0.1879882812, 0.4404296875, 0.5712890625 },
    ["Target-Rare-PortraitOn"] = { 192, 67, 0.0004882812, 0.1879882812, 0.5732421875, 0.7041015625 },
    ["Target-MinusMob-PortraitOn"] = { 192, 67, 0.0004882812, 0.1879882812, 0.3076171875, 0.4384765625 },
    ["Target-PortraitOn-InCombat"] = { 188, 67, 0.0004882812, 0.1840820312, 0.8388671875, 0.9697265625 },
    ["Target-MinusMob-PortraitOn-InCombat"] = { 188, 67, 0.0004882812, 0.1840820312, 0.7060546875, 0.8369140625 },
    ["Target-MinusMob-PortraitOn-Status"] = { 193, 69, 0.7641601562, 0.9526367188, 0.1669921875, 0.3017578125 },
    ["Target-PortraitOn-Type"] = { 135, 18, 0.4331054688, 0.5649414062, 0.4501953125, 0.4853515625 },
}

-- Bar slots per art: { x, y, width, height } on the art at its native size.
-- strip = { x, y }: centre of the name strip on the Big Healthbar arts
-- (measured on the PNGs: the dark band above the bar, left of the portrait).
local SLOTS = {
    ["Player"] = { width = 198, height = 71, health = { 68, 26, 124, 20 }, mana = { 68, 47, 124, 10 },
        masks = { health = "base\\Player-HM", mana = "base\\Player-MM" } },
    ["Player-ClassResource"] = { width = 198, height = 74, health = { 68, 26, 124, 20 }, mana = { 68, 47, 124, 10 }, power = { 63.5, 58, 128.5, 10 },
        masks = { health = "base\\Player-ClassResource-HM", mana = "base\\Player-ClassResource-MM", power = "base\\Player-ClassResource-PM" } },
    ["Target"] = { width = 192, height = 67, health = { 2.5, 23.5, 126, 20 }, mana = { 2.5, 44.5, 134, 10 },
        masks = { health = "base\\Target-HM", healthF = "base\\Target-HMF", mana = "base\\Target-MM", manaF = "base\\Target-MMF" } },
    ["Target-MinusMob"] = { width = 192, height = 67, health = { 3, 23, 123.5, 11.5 }, mana = { 3, 35.5, 125.5, 10 },
        masks = { health = "base\\Target-MinusMob-HM", healthF = "base\\Target-MinusMob-HMF", mana = "base\\Target-MinusMob-MM", manaF = "base\\Target-MinusMob-MMF" } },
    ["Player-BigHealthbar-Reduced"] = { width = 198, height = 71, health = { 63.5, 18, 128.5, 28 }, mana = { 68, 47, 124, 10 }, strip = { 129, 10 },
        masks = { health = "Player-BigHealthbar-Reduced-HM", mana = "base\\Player-MM" } },
    ["Player-ClassResource-BigHealthbar-Reduced"] = { width = 198, height = 74, health = { 63.5, 18, 128.5, 28 }, mana = { 68, 47, 124, 10 }, power = { 63.5, 58, 128.5, 10 }, strip = { 129, 10 },
        masks = { health = "Player-ClassResource-BigHealthbar-Reduced-HM", mana = "base\\Player-ClassResource-MM", power = "base\\Player-ClassResource-PM" } },
    ["Target-BigHealthbar-Reduced"] = { width = 192, height = 67, health = { 2.5, 16, 128, 27.5 }, mana = { 2.5, 44.5, 134, 10 }, strip = { 68, 8 },
        masks = { health = "Target-BigHealthbar-Reduced-HM", healthF = "Target-BigHealthbar-Reduced-HMF", mana = "base\\Target-MM", manaF = "base\\Target-MMF" } },
    -- Symmetric Player Frame with a class resource bar: arts drawn already
    -- mirrored (portrait on the left), so they are used unflipped.
    ["Target-BigHealthbar-Reduced-Alt"] = { width = 192, height = 67, health = { 61.5, 16, 128, 27.5 }, mana = { 55.5, 44.5, 134, 10 }, power = { 57.5, 55.5, 132, 8 }, strip = { 124, 8 },
        masks = { health = "Target-BigHealthbar-Reduced-HMF", mana = "base\\Target-MMF", power = "base\\Target-BigHealthbar-Alt-PM" } },
    ["UI-HUD-UnitFrame-Target-PortraitOn-Alt"] = { width = 192, height = 67, health = { 63, 23.5, 126.5, 20 }, mana = { 55.5, 44.5, 134, 10 }, power = { 57.5, 55.5, 132, 8 },
        masks = { health = "base\\Target-HMF", mana = "base\\Target-MMF", power = "base\\Target-BigHealthbar-Alt-PM" } },
}

local SHEET_SLOTS = {
    ["Player-PortraitOn"] = "Player",
    ["Player-PortraitOn-ClassResource"] = "Player-ClassResource",
    ["Target-PortraitOn"] = "Target",
    ["Target-Rare-PortraitOn"] = "Target",
    ["Target-MinusMob-PortraitOn"] = "Target-MinusMob",
}

-- Mana bars on the stock retail slots sit a little wider than the slot, on
-- the art's parent (BBF's measured values).
local DEFAULT_MANA = {
    { rect = { 68, 47, 124, 10 }, x = 83, y = 61, w = 128, h = 11, maskX = -3, maskW = 3.5 },
    { rect = { 2.5, 44.5, 134, 10 }, x = 15, y = 60.5, w = 149, h = 11 },
}

-- Health masks on the stock retail slots reach a pixel or two past the art.
local HEALTH_MASKS = {
    { rect = { 68, 26, 124, 20 }, x = -2, w = 2 },
    { rect = { 2.5, 23.5, 126, 20 }, x = 0, w = 1 },
}

local function SameRect(a, b)
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

-------------------------------------------------------------------------------
-- API used by BigHealthbar.lua
-------------------------------------------------------------------------------
local R = {}
mUI.UFRetail = R

function R.File(name)
    return MEDIA .. name .. ".png"
end

-- A piece of the game's retail sheet. width false keeps the current size.
function R.SetSheet(tex, key, flip, width, height)
    local info = tex and ART[key]
    if not info then return false end
    tex:SetTexture(SHEET)
    local left, right = info[3], info[4]
    if flip then left, right = right, left end
    tex:SetTexCoord(left, right, info[5], info[6])
    if width ~= false then
        tex:SetSize(width or info[1], height or info[2])
    end
    tex.mUIRetailKey, tex.mUIRetailFile, tex.mUIRetailFlip = key, nil, flip or nil
    return true
end

-- One of the copied PNGs (Big Healthbar art). width false keeps the size.
function R.SetFile(tex, name, flip, width, height)
    if not tex then return false end
    tex:SetTexture(R.File(name))
    if flip then
        tex:SetTexCoord(1, 0, 0, 1)
    else
        tex:SetTexCoord(0, 1, 0, 1)
    end
    if width ~= false and width then
        tex:SetSize(width, height)
    end
    tex.mUIRetailKey, tex.mUIRetailFile, tex.mUIRetailFlip = nil, name, flip or nil
    return true
end

-- Drops the slot info once Blizzard's own art is back on the texture.
function R.Forget(tex)
    if tex then
        tex.mUIRetailKey, tex.mUIRetailFile, tex.mUIRetailFlip = nil, nil, nil
    end
end

function R.SlotInfo(tex)
    if not tex then return end
    local name = tex.mUIRetailKey and SHEET_SLOTS[tex.mUIRetailKey] or tex.mUIRetailFile
    return name and SLOTS[name], tex.mUIRetailFlip
end

local function SlotRect(tex, slot)
    local info, flip = R.SlotInfo(tex)
    local r = info and info[slot]
    if not r then return end
    local x = r[1]
    if flip then
        x = info.width - r[1] - r[3]
    end
    local tw, th = tex:GetWidth(), tex:GetHeight()
    if not tw or tw <= 0 or not th or th <= 0 then
        tw, th = info.width, info.height
    end
    local sx, sy = tw / info.width, th / info.height
    return x * sx, r[2] * sy, r[3] * sx, r[4] * sy
end

-- Offset of the art inside its parent, for regions that must not be
-- anchored to the art itself (protected frames).
local function ArtOffset(tex)
    local parent = tex:GetParent()
    local left, top, parentLeft, parentTop = tex:GetLeft(), tex:GetTop(), parent:GetLeft(), parent:GetTop()
    if left and top and parentLeft and parentTop then
        return parent, left - parentLeft, top - parentTop
    end
    local point, relativeTo, relativePoint, x, y = tex:GetPoint(1)
    if relativeTo ~= nil and relativeTo ~= parent then return end
    if point == "CENTER" and relativePoint == "CENTER" then
        return parent, (parent:GetWidth() - tex:GetWidth()) / 2 + x, (tex:GetHeight() - parent:GetHeight()) / 2 + y
    end
    if point == "TOPLEFT" and relativePoint == "TOPLEFT" then
        return parent, x, y
    end
end

-- Mirrored target art on the player frame (Symmetric Player Frame).
local SYMMETRIC_MANA = { rect = { 2.5, 44.5, 134, 10 }, x = 74, y = 60, w = 138, h = 12 }

local function DefaultManaSlot(tex, slot)
    if slot ~= "mana" then return end
    local info, flip = R.SlotInfo(tex)
    local r = info and info.mana
    if not r then return end
    if flip then
        if tex == PlayerFrame.PlayerFrameContainer.FrameTexture and SameRect(r, SYMMETRIC_MANA.rect) then
            return SYMMETRIC_MANA
        end
        return
    end
    for _, entry in ipairs(DEFAULT_MANA) do
        if SameRect(r, entry.rect) then return entry end
    end
end

local function HealthMask(tex, slot)
    if slot ~= "health" then return end
    local info, flip = R.SlotInfo(tex)
    local r = info and info.health
    if not r or flip then return end
    for _, entry in ipairs(HEALTH_MASKS) do
        if SameRect(r, entry.rect) then return entry end
    end
end

-- Puts `region` on the art's bar slot ("health", "mana" or "power").
function R.FitSlot(region, tex, slot)
    local x, y, w, h = SlotRect(tex, slot)
    if not x or not region then return false end
    local anchor, dx, dy = tex, 0, 0
    local custom = DefaultManaSlot(tex, slot)
    if custom then
        anchor, x, y, w, h = tex:GetParent(), custom.x, custom.y, custom.w, custom.h
        if anchor == region then return false end
    elseif region.IsProtected and region:IsProtected() then
        anchor, dx, dy = ArtOffset(tex)
        if not anchor or anchor == region then return false end
    end
    region:ClearAllPoints()
    region:SetPoint("TOPLEFT", anchor, "TOPLEFT", dx + x, dy - y)
    region:SetSize(w, h)
    return true
end

-- Centre of the art's name strip, from the art's top left, or nil.
function R.NameStrip(tex)
    local info, flip = R.SlotInfo(tex)
    local s = info and info.strip
    if not s then return end
    local tw, th = tex:GetWidth(), tex:GetHeight()
    if not tw or tw <= 0 or not th or th <= 0 then
        tw, th = info.width, info.height
    end
    local x = flip and (info.width - s[1]) or s[1]
    return x * tw / info.width, s[2] * th / info.height
end

-- The slot as a layout point relative to the art (mirror bars).
function R.SlotPoint(tex, slot)
    local x, y, w, h = SlotRect(tex, slot)
    if not x then return end
    return { "TOPLEFT", "TOPLEFT", x, -y }, w, h
end

-- Gives `mask` the slot's mask shape.
function R.MaskSlot(mask, tex, slot)
    local info, flip = R.SlotInfo(tex)
    local path = info and info.masks[slot .. (flip and "F" or "")]
    if not path or not mask then return false end
    mask:SetTexture(R.File(path), "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:ClearAllPoints()
    local custom = DefaultManaSlot(tex, slot)
    local health = HealthMask(tex, slot)
    if custom and custom.maskX then
        mask:SetPoint("TOPLEFT", tex, "TOPLEFT", custom.maskX, 0)
        mask:SetPoint("BOTTOMRIGHT", tex, "BOTTOMRIGHT", custom.maskX + (custom.maskW or 0), 0)
    elseif health then
        mask:SetPoint("TOPLEFT", tex, "TOPLEFT", health.x, 0)
        mask:SetPoint("BOTTOMRIGHT", tex, "BOTTOMRIGHT", health.x + health.w, 0)
    else
        mask:SetAllPoints(tex)
    end
    return true
end

function R.FitBars(tex, healthRegion, healthMask, manaBar, manaMask)
    if not R.SlotInfo(tex) or not R.FitSlot(healthRegion, tex, "health") then return false end
    R.MaskSlot(healthMask, tex, "health")
    if manaBar and R.FitSlot(manaBar, tex, "mana") then
        R.MaskSlot(manaMask, tex, "mana")
    end
    return true
end

-------------------------------------------------------------------------------
-- Module
-------------------------------------------------------------------------------
function RetailTextures:OnEnable()
    if mUI.UFLayout then mUI.UFLayout.SetRetail(true) end
end

function RetailTextures:OnDisable()
    if mUI.UFLayout then mUI.UFLayout.SetRetail(false) end
end
