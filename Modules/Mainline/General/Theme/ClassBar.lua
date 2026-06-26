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

        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            for _, subchild in pairs({child:GetChildren()}) do
                mUI:Skin({subchild.BGActive, subchild.BGInactive, subchild.BGShadow}, true)
                if (subchild.isCharged) then
                    mUI:Skin({subchild.ChargedFrameActive}, true)
                end
            end
        end
    elseif (playerClass == "MAGE") then
        -- Mage
        for _, child in pairs({MageArcaneChargesFrame:GetChildren()}) do
            mUI:Skin({child.ArcaneBG, child.ArcaneBGShadow}, true)
        end

        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            for _, subchild in pairs({child:GetChildren()}) do
                mUI:Skin({subchild.ArcaneBG, subchild.ArcaneBGShadow}, true)
            end
        end
    elseif (playerClass == "WARLOCK") then
        -- Warlock
        for _, child in pairs({WarlockPowerFrame:GetChildren()}) do
            mUI:Skin({child.Background}, true)
        end

        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            for _, subchild in pairs({child:GetChildren()}) do
                mUI:Skin({subchild.Background}, true)
            end
        end
    elseif (playerClass == "DRUID") then
        -- Druid
        for _, child in pairs({DruidComboPointBarFrame:GetChildren()}) do
            mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
        end

        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            for _, subchild in pairs({child:GetChildren()}) do
                mUI:Skin({subchild.BG_Active, subchild.BG_Inactive, subchild.BG_Shadow}, true)
            end
        end
    elseif (playerClass == "MONK") then
        -- Monk
        for _, child in pairs({MonkHarmonyBarFrame:GetChildren()}) do
            mUI:Skin({child.Chi_BG, child.Chi_BG_Active}, true)
        end

        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            for _, subchild in pairs({child:GetChildren()}) do
                mUI:Skin({subchild.Chi_BG, subchild.Chi_BG_Active}, true)
            end
        end
    elseif (playerClass == "DEATHKNIGHT") then
        -- Death Knight
        for _, child in pairs({RuneFrame:GetChildren()}) do
            mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
        end
        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            mUI:Skin({child.BG_Active, child.BG_Inactive, child.BG_Shadow}, true)
        end
    elseif (playerClass == "EVOKER") then
        for _, child in pairs({EssencePlayerFrame:GetChildren()}) do
            if not child.EssenceFillDone then
                return
            end
            if not child.mUI_skinned then
                mUI:Skin({child.EssenceFillDone.CircBG, child.EssenceFillDone.CircBGActive}, true)
                child.mUI_skinned = true
            end
        end

        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.ClassFrameContainer then
            for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
                for _, subchild in pairs({child:GetChildren()}) do
                    if subchild.EssenceFillDone and not subchild.mUI_skinned then
                        mUI:Skin({subchild.EssenceFillDone.CircBG, subchild.EssenceFillDone.CircBGActive}, true)
                        subchild.mUI_skinned = true
                    end
                end
            end
        end
    elseif (playerClass == "PALADIN") then
        -- Paladin
        for _, child in pairs({PersonalResourceDisplayFrame.ClassFrameContainer:GetChildren()}) do
            mUI:Skin({child.Background, child.ActiveTexture}, true)
        end
        mUI:Skin({PaladinPowerBarFrame.Background, PaladinPowerBarFrame.ActiveTexture}, true)
    end
    if (playerClass == "SHAMAN" or playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "DRUID" or playerClass == "MONK") then
        if not Theme:IsHooked(TotemFrame, "Update") then
            Theme:SecureHook(TotemFrame, "Update", function()
                for totem, _ in TotemFrame.totemPool:EnumerateActive() do
                    mUI:Skin({totem.Border}, true)
                end
            end)
        end

        for totem, _ in TotemFrame.totemPool:EnumerateActive() do
            mUI:Skin({totem.Border}, true)
        end
    end
end
