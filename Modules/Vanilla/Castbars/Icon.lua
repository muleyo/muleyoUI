local Icon = mUI:NewModule("mUI.Modules.Castbars.Icon")

function Icon:OnInitialize()
    -- Load Database
    Icon.db = mUI.db.profile.general

    C_Timer.After(0, function()
        if CastingBarFrame.mUIBorder then
            CastingBarFrame.mUIBorder:Hide()
        end
    end)
end

function Icon:OnEnable()
    CastingBarFrame.Icon:Show()
    CastingBarFrame.Icon:SetSize(20, 20)

    if Icon.db.theme ~= "Disabled" then
        C_Timer.After(0.1, function()
            if CastingBarFrame.mUIBorder then
                CastingBarFrame.mUIBorder:Show()
            end
        end)
    end
end

function Icon:OnDisable()
    CastingBarFrame.Icon:Hide()
    CastingBarFrame.Icon:SetSize(16, 16)
    CastingBarFrame.mUIBorder:Hide()
end
