local Icon = mUI:NewModule("mUI.Modules.Castbars.Icon")

function Icon:OnInitialize()
    -- Load Database
    Icon.db = mUI.db.profile.general

    if mUI:IsClassic() then
        C_Timer.After(0, function()
            if CastingBarFrame.mUIBorder then
                CastingBarFrame.mUIBorder:Hide()
            end
        end)
    else
        C_Timer.After(0, function()
            if PlayerCastingBarFrame.mUIBorder then
                PlayerCastingBarFrame.mUIBorder:Hide()
            end
        end)
    end
end

function Icon:OnEnable()
    if mUI:IsClassic() then
        CastingBarFrame.Icon:Show()
        CastingBarFrame.Icon:SetSize(20, 20)

        if Icon.db.theme ~= "Disabled" then
            C_Timer.After(0.1, function()
                if CastingBarFrame.mUIBorder then
                    CastingBarFrame.mUIBorder:Show()
                end
            end)
        end
    else
        PlayerCastingBarFrame.Icon:Show()
        PlayerCastingBarFrame.Icon:SetSize(20, 20)

        if Icon.db.theme ~= "Disabled" then
            C_Timer.After(0.1, function()
                if PlayerCastingBarFrame.mUIBorder then
                    PlayerCastingBarFrame.mUIBorder:Show()
                end
            end)
        end
    end
end

function Icon:OnDisable()
    if mUI:IsClassic() then
        CastingBarFrame.Icon:Hide()
        CastingBarFrame.Icon:SetSize(16, 16)

        CastingBarFrame.mUIBorder:Hide()
    else
        PlayerCastingBarFrame.Icon:Hide()
        PlayerCastingBarFrame.Icon:SetSize(16, 16)

        PlayerCastingBarFrame.mUIBorder:Hide()
    end
end
