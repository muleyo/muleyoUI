local RF_Auras = mUI:NewModule("mUI.Modules.Unitframes.RF_Auras", "AceHook-3.0")

function RF_Auras:OnInitialize()
    local ICON_GAP = 2
    local MAX_SLOTS = 3

    function RF_Auras:GetIconSize()
        return (mUI.db and mUI.db.profile.unitframes.raidframes.dispelIconSize) or 36
    end

    function RF_Auras:GlowEnabled()
        return not mUI.db or mUI.db.profile.unitframes.raidframes.dispelGlow ~= false
    end

    function RF_Auras:IconsEnabled()
        return not mUI.db or mUI.db.profile.unitframes.raidframes.dispelIcons ~= false
    end

    local BORDER_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\border.png]]
    local MASK_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\mask.png]]

    local LCG = LibStub("LibCustomGlow-1.0")
    local GLOW_KEY = "mUI_RF_Dispel"

    local LSM = LibStub("LibSharedMedia-3.0")
    local function GetCountFont()
        local fontName = mUI.db and mUI.db.profile.general and mUI.db.profile.general.font
        return (fontName and LSM:Fetch("font", fontName)) or STANDARD_TEXT_FONT
    end

    function RF_Auras:CreateIcon(parent, size)
        local f = CreateFrame("Frame", nil, parent)
        f:SetSize(size, size)

        local icon = f:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        f.icon = icon

        local cd = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
        cd:SetAllPoints(icon)
        cd:SetDrawBling(false)
        cd:SetDrawEdge(false)
        cd:SetSwipeTexture(MASK_TEX)
        cd:SetSwipeColor(0.2, 0.2, 0.2, 0.75)
        f.cooldown = cd

        local border = f:CreateTexture(nil, "OVERLAY", nil, 7)
        border:SetTexture(BORDER_TEX)
        border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
        f.border = border

        local mask = f:CreateMaskTexture()
        mask:SetTexture(MASK_TEX, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(icon)
        icon:AddMaskTexture(mask)

        local count = f:CreateFontString(nil, "OVERLAY")
        count:SetFont(GetCountFont(), math.max(10, math.floor(size * 0.35)), "OUTLINE")
        count:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, 0)
        f.count = count

        f:Hide()
        return f
    end

    function RF_Auras:EnsureIcons(frame)
        local size = RF_Auras:GetIconSize()
        if frame.mUI_dispelIcons then
            -- Re-apply size so slider changes take effect without a /reload.
            local fontSize = math.max(10, math.floor(size * 0.35))
            for i = 1, MAX_SLOTS do
                local f = frame.mUI_dispelIcons[i]
                f:SetSize(size, size)
                if f.count then
                    f.count:SetFont(GetCountFont(), fontSize, "OUTLINE")
                end
            end
            return
        end
        frame.mUI_dispelIcons = {}
        for i = 1, MAX_SLOTS do
            local f = RF_Auras:CreateIcon(frame, size)
            if i == 1 then
                f:SetPoint("RIGHT", frame, "LEFT", -ICON_GAP, 0)
            else
                f:SetPoint("RIGHT", frame.mUI_dispelIcons[i - 1], "LEFT", -ICON_GAP, 0)
            end
            frame.mUI_dispelIcons[i] = f
        end
    end

    -- Party (5-man) frames only; this module is intentionally scoped to
    -- Mythic+ / 5-man content and does not touch CompactRaidFrame* globals.
    function RF_Auras:ForEachCompactFrame(func)
        for m = 1, 5 do
            local frame = _G["CompactPartyFrameMember" .. m]
            if frame and not frame:IsForbidden() and frame.unit then
                func(frame)
            end
        end
    end

    function RF_Auras:UpdateFrame(frame)
        if not frame or frame:IsForbidden() or not frame.unit then
            return
        end
        RF_Auras:EnsureIcons(frame)

        local slots = frame.mUI_dispelIcons

        local unit = frame.displayedUnit or frame.unit

        local colorCurve = RF_Auras.Theme and RF_Auras.Theme.colorCurve
        local showIcons = RF_Auras:IconsEnabled()
        local idx = 0
        local glowR, glowG, glowB

        if unit then
            AuraUtil.ForEachAura(unit, "HARMFUL|RAID_PLAYER_DISPELLABLE", nil, function(aura)
                idx = idx + 1

                if idx > MAX_SLOTS or not showIcons then
                    if idx == 1 and colorCurve then
                        local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorCurve)
                        if color then
                            glowR, glowG, glowB = color.r, color.g, color.b
                        end
                    end
                    if not showIcons then
                        return true
                    end
                    return idx > MAX_SLOTS
                end
                local slot = slots[idx]
                slot.icon:SetTexture(aura.icon)

                local stacks = aura.applications or aura.charges
                if stacks then
                    slot.count:SetText(stacks)
                    slot.count:Show()
                else
                    slot.count:SetText("")
                    slot.count:Hide()
                end

                local durObj = C_UnitAuras.GetAuraDuration(unit, aura.auraInstanceID)
                if durObj then
                    slot.cooldown:SetCooldownFromDurationObject(durObj:Copy())
                else
                    slot.cooldown:Clear()
                end

                if colorCurve then
                    local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorCurve)
                    if color then
                        slot.border:SetVertexColor(color.r, color.g, color.b, 1)
                        if idx == 1 then
                            glowR, glowG, glowB = color.r, color.g, color.b
                        end
                    else
                        slot.border:SetVertexColor(0.15, 0.15, 0.15, 1)
                    end
                end

                slot:Show()
            end, true)
        end

        local firstHidden = showIcons and (idx + 1) or 1
        for i = firstHidden, MAX_SLOTS do
            slots[i]:Hide()
        end

        if idx > 0 and glowR and RF_Auras:GlowEnabled() then
            LCG.PixelGlow_Start(frame, {glowR, glowG, glowB, 1}, 8, 0.25, nil, 2, 0, 0, false, GLOW_KEY)
        else
            LCG.PixelGlow_Stop(frame, GLOW_KEY)
        end
    end

    function RF_Auras:UpdateFrameForUnit(unit)
        RF_Auras:ForEachCompactFrame(function(frame)
            if frame.unit == unit or frame.displayedUnit == unit then
                RF_Auras:UpdateFrame(frame)
            end
        end)
    end

    function RF_Auras:UpdateAllFrames()
        RF_Auras:ForEachCompactFrame(function(frame)
            RF_Auras:UpdateFrame(frame)
        end)
    end
end

function RF_Auras:OnEnable()
    RF_Auras.Theme = mUI:GetModule("mUI.Modules.General.Theme", true)

    RF_Auras:SecureHook("DefaultCompactUnitFrameSetup", function(frame)
        RF_Auras:UpdateFrame(frame)
    end)

    if not RF_Auras.eventFrame then
        RF_Auras.eventFrame = CreateFrame("Frame")
        RF_Auras.eventFrame:SetScript("OnEvent", function(_, event, unit)
            if event == "UNIT_AURA" then
                RF_Auras:UpdateFrameForUnit(unit)
            else
                C_Timer.After(0, function()
                    RF_Auras:UpdateAllFrames()
                end)
            end
        end)
    end

    RF_Auras.eventFrame:RegisterEvent("UNIT_AURA")
    RF_Auras.eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    RF_Auras.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    C_Timer.After(0, function()
        RF_Auras:UpdateAllFrames()
    end)
end

function RF_Auras:OnDisable()
    RF_Auras:UnhookAll()
    if RF_Auras.eventFrame then
        RF_Auras.eventFrame:UnregisterAllEvents()
    end
end
