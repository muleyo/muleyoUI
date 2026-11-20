local Style = mUI:NewModule("mUI.Modules.Unitframes.Style", "AceHook-3.0")

local TARGET_FRAMES = { "TargetFrame", "FocusFrame" }
local USE_ATLAS_SIZE = TextureKitConstants and TextureKitConstants.UseAtlasSize

local function PlayerMain()
    return PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
end

local function TargetMain(frame)
    return frame.TargetFrameContent.TargetFrameContentMain
end

local function InVehicle()
    return PlayerFrame.unit == "vehicle"
end

local function OutOfCombat(func)
    if InCombatLockdown() then
        Style.pendingApply = true
        return
    end
    func()
end

local function KeepHidden(region)
    region:Hide()
    if not Style:IsHooked(region, "Show") then
        Style:SecureHook(region, "Show", region.Hide)
        Style:SecureHook(region, "SetShown", region.Hide)
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Player Frame
-- ---------------------------------------------------------------------------------------------------------------------------------

local function PlayerNameAnchor()
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", PlayerMain(), "TOPLEFT", InVehicle() and 96 or 88, -27)
end

local function PlayerLevelColor()
    if UnitExists("player") and UnitEffectiveLevel("player") == UnitLevel("player") then
        PlayerLevelText:SetVertexColor(1, 0.82, 0, 1)
    end
end

local function PlayerRegions()
    PlayerName:SetJustifyH("LEFT")
    PlayerName:SetWidth(96)

    PlayerLevelText:SetFontObject(GameNormalNumberFont)
    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint("TOPRIGHT", PlayerMain(), "TOPRIGHT", -24.5, -28)
    KeepHidden(PlayerMain().LevelBackgroundCircle)

    local reputation = PlayerMain().ReputationColor
    if reputation then
        reputation:SetSize(136, 20)
        reputation:ClearAllPoints()
        reputation:SetPoint("TOPRIGHT", PlayerMain(), "TOPRIGHT", -21, -25)
    end

    PlayerNameAnchor()
    PlayerLevelColor()
end

local ROLE_ATLASES = {
    TANK = "roleicon-tiny-tank",
    HEALER = "roleicon-tiny-healer",
    DAMAGER = "roleicon-tiny-dps"
}

local function PlayerRole()
    local roleIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon
    local _, instanceType = GetInstanceInfo()
    local atlas = instanceType ~= "none" and ROLE_ATLASES[UnitGroupRolesAssigned("player")]

    if atlas then
        roleIcon:SetAtlas(atlas, TextureKitConstants and TextureKitConstants.IgnoreAtlasSize)
    end
    roleIcon:SetShown(atlas and true or false)
    PlayerLevelText:SetShown(not atlas)
end

local function PlayerHealth()
    local container = PlayerFrame_GetHealthBarContainer()
    local bar = PlayerFrame_GetHealthBar()
    local mask = container.HealthBarMask

    if InVehicle() then
        mask:SetPoint("TOPLEFT", container, "TOPLEFT", -8, 6)
    else
        mask:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 6)
        mask:SetAtlas("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Mask")
        mask:SetHeight(31)
    end

    OutOfCombat(function()
        if InVehicle() then
            container:SetWidth(118)
            container:SetHeight(20)
            container:SetPoint("TOPLEFT", 91, -40)
            bar:SetHeight(20)
        else
            container:SetWidth(124)
            container:SetHeight(19)
            container:SetPoint("TOPLEFT", 85, -41)
            bar:SetHeight(19)
        end

        bar:ClearAllPoints()
        bar:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    end)
end

local function PlayerMana()
    local bar = PlayerFrame_GetManaBar()
    local mask = bar.ManaBarMask
    local normalMask = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Mask"

    if InVehicle() then
        mask:SetWidth(121)
        mask:SetAtlas(normalMask)
    else
        mask:SetWidth(128)
        mask:SetAtlas(normalMask, USE_ATLAS_SIZE)
    end

    OutOfCombat(function()
        bar:SetHeight(10)
        if InVehicle() then
            bar:SetWidth(118)
            bar:SetPoint("TOPLEFT", 91, -61)
        else
            bar:SetWidth(124)
            bar:SetPoint("TOPLEFT", 85, -61)
        end
    end)
end

local function PlayerFlash()
    local flash = PlayerFrame.PlayerFrameContainer.FrameFlash
    local parent = flash:GetParent()

    if InVehicle() then
        flash:SetAtlas("UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-InCombat", USE_ATLAS_SIZE)
        flash:SetPoint("CENTER", parent, "CENTER", -3.5, 1)
        return
    end

    local DruidMana = mUI:GetModule("mUI.Modules.Unitframes.DruidMana", true)
    local alternate = PlayerFrame_GetAlternatePowerBar() ~= nil or
        (DruidMana and DruidMana.bar and DruidMana.bar:IsShown())
    flash:SetPoint("CENTER", parent, "CENTER", alternate and -2 or -1.5, alternate and 0.5 or 1)
end

local function PlayerStatus()
    local status = PlayerMain().StatusTexture
    local parent = PlayerFrame.PlayerFrameContainer.FrameFlash:GetParent()

    if InVehicle() then
        status:SetAtlas("UI-HUD-UnitFrame-Player-PortraitOn-Vehicle-Status", USE_ATLAS_SIZE)
        status:SetPoint("TOPLEFT", parent, "TOPLEFT", 11, -8)
    else
        status:SetPoint("TOPLEFT", parent, "TOPLEFT", 18, -14)
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Target/Focus Frame
-- ---------------------------------------------------------------------------------------------------------------------------------

local function TargetRegions(frame)
    local main = TargetMain(frame)
    local contextual = frame.TargetFrameContent.TargetFrameContentContextual
    local reputation = main.ReputationColor

    reputation:ClearAllPoints()
    reputation:SetPoint("TOPRIGHT", main, "TOPRIGHT", -75, -25)

    main.Name:SetJustifyH("LEFT")
    main.Name:SetWidth(90)
    main.Name:ClearAllPoints()
    main.Name:SetPoint("TOPLEFT", reputation, "TOPRIGHT", -106, -1)

    KeepHidden(main.LevelBackgroundCircle)
    main.LevelText:SetFontObject(GameNormalNumberFont)
    main.LevelText:SetJustifyH("CENTER")
    main.LevelText:ClearAllPoints()
    main.LevelText:SetPoint("TOPLEFT", reputation, "TOPRIGHT", -133, -2)

    contextual.HighLevelTexture:ClearAllPoints()
    contextual.HighLevelTexture:SetPoint("TOPLEFT", main.LevelText, "TOPLEFT", 4, 2)

    local flash = frame.TargetFrameContainer.Flash
    flash:ClearAllPoints()
    flash:SetPoint("CENTER", frame.TargetFrameContainer, "CENTER", 0, 2)

    local mana = main.ManaBar
    mana.LeftText:ClearAllPoints()
    mana.LeftText:SetPoint("LEFT", mana, "LEFT", 2, 0)
    mana.RightText:ClearAllPoints()
    mana.RightText:SetPoint("RIGHT", mana, "RIGHT", -13, 0)
    mana.ManaBarText:ClearAllPoints()
    mana.ManaBarText:SetPoint("CENTER", mana, "CENTER", -4, 0)
end

local function TargetHealth(frame, classification)
    local main = TargetMain(frame)
    local container = main.HealthBarsContainer
    local bar = container.HealthBar
    local mask = container.HealthBarMask

    if classification == "minus" then
        mask:SetAtlas("UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-Bar-Health-Mask", USE_ATLAS_SIZE)
        mask:SetPoint("TOPLEFT", -1, 2)
    else
        mask:SetPoint("TOPLEFT", -1, 6)
    end
    container.RightText:ClearAllPoints()
    container.RightText:SetPoint("RIGHT", container, "RIGHT", -5, 0)

    OutOfCombat(function()
        if classification == "minus" then
            container:SetHeight(12)
            container:SetWidth(125)
            container:SetPoint("BOTTOMRIGHT", frame.TargetFrameContainer, "LEFT", 148, -1)
        else
            container:SetHeight(20)
            container:SetWidth(126)
            container:SetPoint("BOTTOMRIGHT", frame.TargetFrameContainer, "LEFT", 149, -10)
        end

        bar:ClearAllPoints()
        bar:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)

        local mana = main.ManaBar
        mana:SetWidth(134)
        mana:ClearAllPoints()
        mana:SetPoint("TOPRIGHT", container, "BOTTOMRIGHT", 8, -1)
    end)
end

local function CurrentClassification(frame)
    return UnitExists(frame.unit) and UnitClassification(frame.unit) or nil
end

local function Capture(region, what)
    local saved = { region = region }
    if what.points then
        saved.points = {}
        for i = 1, region:GetNumPoints() do
            saved.points[i] = { region:GetPoint(i) }
        end
    end
    if what.width then
        saved.width = region:GetWidth()
    end
    if what.height then
        saved.height = region:GetHeight()
    end
    if what.font then
        saved.font = region:GetFontObject()
    end
    if what.justify then
        saved.justify = region:GetJustifyH()
    end
    if what.shown then
        saved.shown = region:IsShown()
    end
    return saved
end

local function Restore(saved)
    local region = saved.region
    if saved.points then
        region:ClearAllPoints()
        for _, point in ipairs(saved.points) do
            region:SetPoint(unpack(point))
        end
    end
    if saved.width then
        region:SetWidth(saved.width)
    end
    if saved.height then
        region:SetHeight(saved.height)
    end
    if saved.font then
        region:SetFontObject(saved.font)
    end
    if saved.justify then
        region:SetJustifyH(saved.justify)
    end
    if saved.shown ~= nil then
        region:SetShown(saved.shown)
    end
end

local function CaptureAll()
    local saved = {}
    local function Add(region, what)
        saved[#saved + 1] = Capture(region, what)
    end

    Add(PlayerName, { width = true, justify = true })
    Add(PlayerLevelText, { points = true, font = true })
    Add(PlayerMain().LevelBackgroundCircle, { shown = true })
    if PlayerMain().ReputationColor then
        Add(PlayerMain().ReputationColor, { points = true, width = true, height = true })
    end

    for _, name in ipairs(TARGET_FRAMES) do
        local frame = _G[name]
        local main = TargetMain(frame)
        local mana = main.ManaBar

        Add(main.ReputationColor, { points = true })
        Add(main.Name, { points = true, width = true, justify = true })
        Add(main.LevelText, { points = true, font = true, justify = true })
        Add(main.LevelBackgroundCircle, { shown = true })
        Add(frame.TargetFrameContent.TargetFrameContentContextual.HighLevelTexture, { points = true })
        Add(frame.TargetFrameContainer.Flash, { points = true })
        Add(mana, { points = true, width = true })
        Add(mana.LeftText, { points = true })
        Add(mana.RightText, { points = true })
        Add(mana.ManaBarText, { points = true })
        Add(main.HealthBarsContainer.RightText, { points = true })
    end

    return saved
end

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Retail frame art
-- ---------------------------------------------------------------------------------------------------------------------------------

local tracked = {}

local StyleArt

local function RetailArt(texture, atlas, useAtlasSize, flip)
    StyleArt = StyleArt or mUI:GetModule("mUI.Modules.Unitframes.StyleArt")
    local name = atlas and atlas:lower()
    local art = name and StyleArt.atlases[name]
    if not art then
        return
    end

    local file = StyleArt.path .. name .. ".png"
    if texture:IsObjectType("MaskTexture") then
        texture:SetTexture(file, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    else
        texture:SetTexture(file)
        texture:SetTexCoord(flip and 1 or 0, flip and 0 or 1, 0, 1)
    end
    if useAtlasSize then
        texture:SetSize(art[1], art[2])
    end
end

local function OnSetAtlas(texture, atlas, useAtlasSize)
    local entry = tracked[texture]
    if entry then
        entry.atlas = atlas
        RetailArt(texture, atlas, useAtlasSize == true, entry.flip)
    end
end

local function Track(texture, size, flip)
    if not texture or tracked[texture] then
        return
    end

    local atlas = texture:GetAtlas()
    if not atlas then
        return
    end

    tracked[texture] = { atlas = atlas, size = size, flip = flip }
    Style:SecureHook(texture, "SetAtlas", OnSetAtlas)
    RetailArt(texture, atlas, size, flip)
end

local function TrackAll()
    local container = PlayerFrame.PlayerFrameContainer
    Track(container.FrameTexture, true)
    Track(container.VehicleFrameTexture, true)
    Track(container.AlternatePowerFrameTexture, true)
    Track(container.FrameFlash, true)
    Track(container.PlayerPortraitMask, false)
    Track(PlayerMain().StatusTexture, true)
    Track(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon, true)
    Track(PlayerMain().ReputationColor, false, true)
    Track(PlayerFrame_GetHealthBarContainer().HealthBarMask, true)
    Track(PlayerFrame_GetManaBar().ManaBarMask, true)

    local DruidMana = mUI:GetModule("mUI.Modules.Unitframes.DruidMana", true)
    if DruidMana and DruidMana.bar then
        Track(DruidMana.bar.PowerBarMask, true)
    end

    for _, name in ipairs(TARGET_FRAMES) do
        local frame = _G[name]
        local main = TargetMain(frame)
        Track(frame.TargetFrameContainer.FrameTexture, true)
        Track(frame.TargetFrameContainer.Flash, true)
        Track(main.ReputationColor, true)
        Track(main.HealthBarsContainer.HealthBarMask, true)
        Track(main.ManaBar.ManaBarMask, true)
    end
end

local function UntrackAll()
    for texture, entry in pairs(tracked) do
        texture:SetAtlas(entry.atlas, entry.size)
        if entry.flip then
            texture:SetTexCoord(1, 0, 0, 1)
        end
    end
    wipe(tracked)
end

function Style:UpdateArt()
    if Style.active then
        TrackAll()
    end
end

function Style:Apply()
    TrackAll()
    PlayerRegions()
    PlayerFlash()
    PlayerStatus()
    PlayerRole()
    for _, name in ipairs(TARGET_FRAMES) do
        TargetRegions(_G[name])
    end

    OutOfCombat(function()
        PlayerHealth()
        PlayerMana()
        for _, name in ipairs(TARGET_FRAMES) do
            local frame = _G[name]
            TargetHealth(frame, CurrentClassification(frame))
        end
    end)
end

function Style:UpdatePlayerFlash()
    if Style.active then
        PlayerFlash()
    end
end

function Style:Restore()
    if InCombatLockdown() then
        Style.pendingRestore = true
        return
    end

    for _, saved in ipairs(Style.saved or {}) do
        Restore(saved)
    end
    Style.saved = nil

    PlayerFrame_UpdateHealthBarVisuals()
    PlayerFrame_UpdateManaBarVisuals()
    PlayerFrame_UpdateFlashTextureVisuals()
    PlayerFrame_UpdateStatusTextureVisuals()
    PlayerFrame_UpdatePlayerNameTextAnchor()
    PlayerFrame_UpdateLevel()
    PlayerFrame_UpdateRolesAssigned()
    for _, name in ipairs(TARGET_FRAMES) do
        local frame = _G[name]
        frame:UpdateHealthBarVisuals(CurrentClassification(frame))
    end

    local DruidMana = mUI:GetModule("mUI.Modules.Unitframes.DruidMana", true)
    if DruidMana and DruidMana.bar then
        DruidMana:UpdatePosition()
        DruidMana:SyncArt()
    end
end

function Style:OnInitialize()
    local watcher = CreateFrame("Frame")
    watcher:RegisterEvent("PLAYER_REGEN_ENABLED")
    watcher:SetScript("OnEvent", function()
        if Style.pendingRestore then
            Style.pendingRestore = nil
            Style.pendingApply = nil
            Style:Restore()
        elseif Style.pendingApply and Style.active then
            Style.pendingApply = nil
            Style:Apply()
        end
    end)
end

function Style:OnEnable()
    Style.active = true
    Style.pendingRestore = nil
    Style.saved = Style.saved or CaptureAll()

    Style:SecureHook("PlayerFrame_UpdateHealthBarVisuals", PlayerHealth)
    Style:SecureHook("PlayerFrame_UpdateManaBarVisuals", PlayerMana)
    Style:SecureHook("PlayerFrame_UpdateFlashTextureVisuals", PlayerFlash)
    Style:SecureHook("PlayerFrame_UpdateStatusTextureVisuals", PlayerStatus)
    Style:SecureHook("PlayerFrame_UpdatePlayerNameTextAnchor", PlayerNameAnchor)
    Style:SecureHook("PlayerFrame_UpdateLevel", PlayerLevelColor)
    Style:SecureHook("PlayerFrame_UpdateRolesAssigned", PlayerRole)

    for _, name in ipairs(TARGET_FRAMES) do
        local frame = _G[name]
        Style:SecureHook(frame, "UpdateHealthBarVisuals", TargetHealth)
    end

    Style:Apply()

    local DruidMana = mUI:GetModule("mUI.Modules.Unitframes.DruidMana", true)
    if DruidMana and DruidMana.bar then
        DruidMana:UpdatePosition()
    end
end

function Style:OnDisable()
    Style.active = false
    Style:UnhookAll()
    UntrackAll()
    Style:Restore()
end
