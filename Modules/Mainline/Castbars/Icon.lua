local Icon = mUI:NewModule("mUI.Modules.Castbars.Icon")

function Icon:OnInitialize()
    -- Load Database
    Icon.db = mUI.db.profile.general

    C_Timer.After(0, function()
        if PlayerCastingBarFrame.mUIBorder then
            PlayerCastingBarFrame.mUIBorder:Hide()
        end
        if OverlayPlayerCastingBarFrame.mUIBorder then
            OverlayPlayerCastingBarFrame.mUIBorder:Hide()
        end
    end)
end

function Icon:OnEnable()
    PlayerCastingBarFrame.Icon:Show()
    PlayerCastingBarFrame.Icon:SetSize(20, 20)

    -- OverlayPlayerCastingBarFrame is a SEPARATE frame Blizzard swaps in over
    -- the real PlayerCastingBarFrame for the "Activating Specialization"
    -- cast shown while switching talents/specs (Blizzard_SharedTalentFrame's
    -- StartReplacingPlayerBarAt). Its Icon is force-hidden by Blizzard's own
    -- OverlayPlayerCastingBarMixin:OnLoad and never re-shown for this bar's
    -- "OVERLAY" look, so without this it stays hidden/blank. Mirror the same
    -- treatment here.
    OverlayPlayerCastingBarFrame.Icon:Show()
    OverlayPlayerCastingBarFrame.Icon:SetSize(20, 20)

    C_Timer.After(0.1, function()
        if PlayerCastingBarFrame.mUIBorder then
            PlayerCastingBarFrame.mUIBorder:Show()
        end
        if OverlayPlayerCastingBarFrame.mUIBorder then
            OverlayPlayerCastingBarFrame.mUIBorder:Show()
        end
    end)
end

function Icon:OnDisable()
    PlayerCastingBarFrame.Icon:Hide()
    PlayerCastingBarFrame.Icon:SetSize(16, 16)
    PlayerCastingBarFrame.mUIBorder:Hide()

    OverlayPlayerCastingBarFrame.Icon:Hide()
    OverlayPlayerCastingBarFrame.Icon:SetSize(16, 16)
    OverlayPlayerCastingBarFrame.mUIBorder:Hide()
end
