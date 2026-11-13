local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- The Personal Resource Display: its health, power and alternate power bars get the texture of the Unitframes (Healthbar / Powerbar),
-- the artwork behind the bars is skinned, and so are the points of the class resource (combo points, runes and so on).
local LSM = LibStub("LibSharedMedia-3.0")

local BAR_BACKGROUND_ATLAS = "ui-hud-cooldownmanager-bar-bg"

-- The textures behind the points of the class resource, their names differ per class
local POINT_BACKGROUNDS = {"BGActive", "BGInactive", "BGShadow", "BG_Active", "BG_Inactive", "BG_Shadow"}

-- The texture of the Unitframes, nothing when it is set to the default
local function GetTexturePath()
    local name = mUI.db.profile.unitframes.textures.unitframes
    if not name or name == "None" then
        return nil
    end

    return LSM:Fetch("statusbar", name, true)
end

-- What a texture was before it was changed, once
local function Remember(owner, texture)
    if owner.mUIRemembered or not texture then
        return
    end

    owner.mUIRemembered = true
    owner.mUIAtlas = texture:GetAtlas()
    owner.mUIFile = not owner.mUIAtlas and texture:GetTexture() or nil
end

local function Restore(owner, texture)
    if not (owner.mUIRemembered and texture) then
        return
    end

    if owner.mUIAtlas then
        texture:SetAtlas(owner.mUIAtlas)
    elseif owner.mUIFile then
        texture:SetTexture(owner.mUIFile)
    end
end

local function StyleBar(bar, path)
    if not bar or not bar.GetStatusBarTexture then
        return
    end

    Remember(bar, bar:GetStatusBarTexture())
    if path then
        bar:SetStatusBarTexture(path)
    else
        Restore(bar, bar:GetStatusBarTexture())
    end

    -- The alternate power bar of some classes sets its texture again whenever its art changes, from this
    if bar.barTextureAtlas ~= nil or bar == PersonalResourceDisplayFrame.AlternatePowerBar then
        bar.barTextureAtlas = path or bar.mUIAtlas
    end
end

-- The textures that are drawn along with a bar, in the same colors
local function StyleTexture(texture, path)
    if not texture then
        return
    end

    Remember(texture, texture)
    if path then
        texture:SetTexture(path)
    else
        Restore(texture, texture)
    end
end

-- The artwork behind a bar (the dark frame with the shadow)
local function SkinBarBackground(bar)
    if not bar then
        return
    end

    for _, region in pairs({bar:GetRegions()}) do
        if region.GetAtlas and (region:GetAtlas() or ""):lower() == BAR_BACKGROUND_ATLAS then
            mUI:Skin({region}, true)
        end
    end
end

function Theme:PersonalResourceBars()
    local frame = PersonalResourceDisplayFrame
    if not frame then
        return
    end

    local path = GetTexturePath()
    local health = frame.HealthBarsContainer and frame.HealthBarsContainer.healthBar
    local power = frame.PowerBar
    local alternate = frame.AlternatePowerBar

    StyleBar(health, path)
    StyleBar(power, path)
    StyleBar(alternate, path)

    if health then
        StyleTexture(health.myHealPrediction, path)
        StyleTexture(health.otherHealPrediction, path)
    end
    if power then
        StyleTexture(power.ManaCostPredictionBar, path)
    end

    SkinBarBackground(health)
    SkinBarBackground(power)
    SkinBarBackground(alternate)
end

-- The points of the class resource. Retail has a skin for the class resources of every class, the rest do the combo points.
function Theme:PersonalResourceClassBar()
    if Theme.ClassBar then
        Theme:ClassBar()
        return
    end

    local classFrame = PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.classFrame
    if not classFrame then
        return
    end

    for _, point in pairs({classFrame:GetChildren()}) do
        local textures = {}
        for _, key in ipairs(POINT_BACKGROUNDS) do
            textures[#textures + 1] = point[key]
        end
        if point.isCharged then
            textures[#textures + 1] = point.ChargedFrameActive
        end

        mUI:Skin(textures, true)
    end
end

-- The class frame is made when the display is set up, and its points whenever the maximum changes. Both end in UpdatePower.
local function HookClassFrame()
    local classFrame = PersonalResourceDisplayFrame.classFrame
    if classFrame and type(classFrame.UpdatePower) == "function" and not Theme:IsHooked(classFrame, "UpdatePower") then
        Theme:SecureHook(classFrame, "UpdatePower", function()
            Theme:PersonalResourceClassBar()
        end)
    end

    Theme:PersonalResourceClassBar()
end

function Theme:PersonalResource()
    local frame = PersonalResourceDisplayFrame
    if not frame then
        return
    end

    Theme:PersonalResourceBars()

    if not Theme:IsHooked(frame, "SetupClassBar") then
        Theme:SecureHook(frame, "SetupClassBar", HookClassFrame)
    end

    -- Some classes put their own texture on the alternate power bar when it is set up or shown
    for _, method in ipairs({"SetupAlternatePowerBar", "UpdateAlternatePowerBar"}) do
        if frame[method] and not Theme:IsHooked(frame, method) then
            Theme:SecureHook(frame, method, function()
                StyleBar(frame.AlternatePowerBar, GetTexturePath())
                SkinBarBackground(frame.AlternatePowerBar)
            end)
        end
    end

    HookClassFrame()
end
