local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
function Theme:ClassBar()
    -- Rogue
    if (playerClass == "ROGUE") then
        if not mUI:IsClassic() then
            for _, child in pairs({ RogueComboPointBarFrame:GetChildren() }) do
                mUI:Skin({
                    child.BGActive,
                    child.BGInactive,
                    child.BGShadow
                }, true)
                if (child.isCharged) then
                    mUI:Skin({
                        child.ChargedFrameActive
                    }, true)
                end
            end
            for _, child in pairs({ ClassNameplateBarRogueFrame:GetChildren() }) do
                mUI:Skin({
                    child.BGActive,
                    child.BGInactive,
                    child.BGShadow
                }, true)
                if (child.isCharged) then
                    mUI:Skin({
                        child.ChargedFrameActive
                    }, true)
                end
            end
        end
    elseif (playerClass == "MAGE") then
        -- Mage
        if not mUI:IsClassic() then
            for _, child in pairs({ MageArcaneChargesFrame:GetChildren() }) do
                mUI:Skin({
                    child.ArcaneBG,
                    child.ArcaneBGShadow
                }, true)
            end
            for _, child in pairs({ ClassNameplateBarMageFrame:GetChildren() }) do
                mUI:Skin({
                    child.ArcaneBG,
                    child.ArcaneBGShadow
                }, true)
            end
        end
    elseif (playerClass == "WARLOCK") then
        -- Warlock
        if mUI:IsClassic() then
            -- Destruction Warlock
            mUI:Skin({
                select(1, BurningEmbersBarFrameEmber1:GetRegions()),
                select(1, BurningEmbersBarFrameEmber2:GetRegions()),
                select(1, BurningEmbersBarFrameEmber3:GetRegions()),
                select(1, BurningEmbersBarFrameEmber4:GetRegions()),
                BurningEmbersBarFrame.background
            }, true)

            -- Affliction
            mUI:Skin({
                select(1, select(5, ShardBarFrameShard1:GetRegions())),
                select(1, select(5, ShardBarFrameShard2:GetRegions())),
                select(1, select(5, ShardBarFrameShard3:GetRegions())),
                select(1, select(5, ShardBarFrameShard4:GetRegions()))
            }, true)

            -- Demonology
            mUI:Skin({
                select(3, DemonicFuryBarFrame:GetRegions())
            }, true)
        else
            for _, child in pairs({ WarlockPowerFrame:GetChildren() }) do
                mUI:Skin({
                    child.Background
                }, true)
            end
            for _, child in pairs({ ClassNameplateBarWarlockFrame:GetChildren() }) do
                mUI:Skin({
                    child.Background
                }, true)
            end
        end
    elseif (playerClass == "DRUID") then
        -- Druid
        if not mUI:IsClassic() then
            for _, child in pairs({ DruidComboPointBarFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
            for _, child in pairs({ ClassNameplateBarFeralDruidFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
        end
    elseif (playerClass == "MONK") then
        -- Monk
        if mUI:IsClassic() then
            mUI:Skin({
                select(2, MonkHarmonyBar:GetRegions()),
                select(6, MonkStaggerBar:GetRegions())
            }, true)
        else
            for _, child in pairs({ MonkHarmonyBarFrame:GetChildren() }) do
                mUI:Skin({
                    child.Chi_BG,
                    child.Chi_BG_Active
                }, true)
            end
            for _, child in pairs({ ClassNameplateBarWindwalkerMonkFrame:GetChildren() }) do
                mUI:Skin({
                    child.Chi_BG,
                    child.Chi_BG_Active
                }, true)
            end
        end
    elseif (playerClass == "DEATHKNIGHT") then
        -- Death Knight
        if mUI:IsClassic() then
            mUI:Skin({
                Rune1BorderTexture,
                Rune2BorderTexture,
                Rune3BorderTexture,
                Rune4BorderTexture,
                Rune5BorderTexture,
                Rune6BorderTexture
            }, true)
        else
            for _, child in pairs({ RuneFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
            for _, child in pairs({ DeathKnightResourceOverlayFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
        end
    elseif (playerClass == "EVOKER") then
        -- Evoker
        if not mUI:IsClassic() then
            for _, child in pairs({ EssencePlayerFrame:GetChildren() }) do
                if not child.EssenceFillDone then return end
                mUI:Skin({
                    child.EssenceFillDone.CircBG,
                    child.EssenceFillDone.CircBGActive
                }, true)
            end

            for _, child in pairs({ ClassNameplateBarDracthyrFrame:GetChildren() }) do
                mUI:Skin({
                    child.EssenceFillDone.CircBG,
                    child.EssenceFillDone.CircBGActive
                }, true)
            end
        end
    elseif (playerClass == "PALADIN") then
        -- Paladin
        if mUI:IsClassic() then
            mUI:Skin(PaladinPowerBar)
        else
            mUI:Skin({
                PaladinPowerBarFrame.Background,
                PaladinPowerBarFrame.ActiveTexture,
                ClassNameplateBarPaladinFrame.Background,
                ClassNameplateBarPaladinFrame.ActiveTexture
            }, true)
        end
    elseif (playerClass == "PRIEST") then
        if mUI:IsClassic() then
            mUI:Skin({ select(1, PriestBarFrame:GetRegions()) }, true)
        end
    end
    if (playerClass == "SHAMAN" or playerClass == "PALADIN" or (playerClass == "PRIEST" and not mUI:IsClassic()) or playerClass == "DRUID") then
        if mUI:IsClassic() then
        else
            for totem, _ in TotemFrame.totemPool:EnumerateActive() do
                mUI:Skin({ totem.Border }, true)
            end
        end
    end
end
