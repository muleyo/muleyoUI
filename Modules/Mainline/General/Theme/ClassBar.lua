local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
function Theme:ClassBar()
    -- Rogue
    if (playerClass == "ROGUE") then
        for _, child in pairs({RogueComboPointBarFrame:GetChildren()}) do
            mUI:Skin({child.BGActive, child.BGInactive, child.BGShadow}, true)
            if (child.isCharged) then
                mUI:Skin({child.ChargedFrameActive}, true)
            end
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.BGActive, child.BGInactive, child.BGShadow}, true)
                if (child.isCharged) then
                    mUI:Skin({child.ChargedFrameActive}, true)
                end
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.BGActive, child.BGInactive, child.BGShadow}, true)
                if (child.isCharged) then
                    mUI:Skin({child.ChargedFrameActive}, true)
                end
            end
        end
    elseif (playerClass == "MAGE") then
        -- Mage
        for _, child in pairs({MageArcaneChargesFrame:GetChildren()}) do
            mUI:Skin({child.ArcaneBG, child.ArcaneBGShadow}, true)
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.ArcaneBG, child.ArcaneBGShadow}, true)
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.ArcaneBG, child.ArcaneBGShadow}, true)
            end
        end
    elseif (playerClass == "WARLOCK") then
        -- Warlock
        for _, child in pairs({WarlockPowerFrame:GetChildren()}) do
            mUI:Skin({child.Background}, true)
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.Background}, true)
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.Background}, true)
            end
        end
    elseif (playerClass == "DRUID") then
        -- Druid
        for _, child in pairs({DruidComboPointBarFrame:GetChildren()}) do
            mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
            end
        end
    elseif (playerClass == "MONK") then
        -- Monk
        for _, child in pairs({MonkHarmonyBarFrame:GetChildren()}) do
            mUI:Skin({child.Chi_BG, child.Chi_BG_Active}, true)
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.Chi_BG, child.Chi_BG_Active}, true)
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.Chi_BG, child.Chi_BG_Active}, true)
            end
        end
    elseif (playerClass == "DEATHKNIGHT") then
        -- Death Knight
        for _, child in pairs({RuneFrame:GetChildren()}) do
            mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
            end
        end
    elseif (playerClass == "EVOKER") then
        -- Evoker
        for _, child in pairs({EssencePlayerFrame:GetChildren()}) do
            if not child.EssenceFillDone then
                return
            end
            mUI:Skin({child.EssenceFillDone.CircBG, child.EssenceFillDone.CircBGActive}, true)
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.EssenceFillDone.CircBG, child.EssenceFillDone.CircBGActive}, true)
            end
        else
            for _, child in pairs({prdClassFrame:GetChildren()}) do
                mUI:Skin({child.EssenceFillDone.CircBG, child.EssenceFillDone.CircBGActive}, true)
            end
        end
    elseif (playerClass == "PALADIN") then
        -- Paladin
        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                mUI:Skin({child.Background, child.ActiveTexture}, true)
            end
            mUI:Skin({PaladinPowerBarFrame.Background, PaladinPowerBarFrame.ActiveTexture}, true)
        else
            mUI:Skin({PaladinPowerBarFrame.Background, PaladinPowerBarFrame.ActiveTexture, prdClassFrame.Background, prdClassFrame.ActiveTexture},
                true)
        end
    end
    if (playerClass == "SHAMAN" or playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "DRUID" or playerClass == "MONK") then
        for totem, _ in TotemFrame.totemPool:EnumerateActive() do
            mUI:Skin({totem.Border}, true)
        end
    end
end
