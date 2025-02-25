local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
function Theme:ClassBar()
    -- Rogue
    if (playerClass == 'ROGUE') then
        for _, child in ipairs({ RogueComboPointBarFrame:GetChildren() }) do
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
        for _, child in ipairs({ ClassNameplateBarRogueFrame:GetChildren() }) do
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
    elseif (playerClass == 'MAGE') then
        -- Mage
        for _, child in ipairs({ MageArcaneChargesFrame:GetChildren() }) do
            mUI:Skin({
                child.ArcaneBG,
                child.ArcaneBGShadow
            }, true)
        end
        for _, child in ipairs({ ClassNameplateBarMageFrame:GetChildren() }) do
            mUI:Skin({
                child.ArcaneBG,
                child.ArcaneBGShadow
            }, true)
        end
    elseif (playerClass == 'WARLOCK') then
        -- Warlock
        for _, child in ipairs({ WarlockPowerFrame:GetChildren() }) do
            mUI:Skin({
                child.Background
            }, true)
        end
        for _, child in ipairs({ ClassNameplateBarWarlockFrame:GetChildren() }) do
            mUI:Skin({
                child.Background
            }, true)
        end
    elseif (playerClass == 'DRUID') then
        -- Druid
        for _, child in ipairs({ DruidComboPointBarFrame:GetChildren() }) do
            mUI:Skin({
                child.BG_Active,
                child.BG_Inactive,
                child.BG_Shadow
            }, true)
        end
        for _, child in ipairs({ ClassNameplateBarFeralDruidFrame:GetChildren() }) do
            mUI:Skin({
                child.BG_Active,
                child.BG_Inactive,
                child.BG_Shadow
            }, true)
        end
    elseif (playerClass == 'MONK') then
        -- Monk
        for _, child in ipairs({ MonkHarmonyBarFrame:GetChildren() }) do
            mUI:Skin({
                child.Chi_BG,
                child.Chi_BG_Active
            }, true)
        end
        for _, child in ipairs({ ClassNameplateBarWindwalkerMonkFrame:GetChildren() }) do
            mUI:Skin({
                child.Chi_BG,
                child.Chi_BG_Active
            }, true)
        end
    elseif (playerClass == 'DEATHKNIGHT') then
        -- Death Knight
        for _, child in ipairs({ RuneFrame:GetChildren() }) do
            mUI:Skin({
                child.BG_Active,
                child.BG_Inactive,
                child.BG_Shadow
            }, true)
        end
        for _, child in ipairs({ DeathKnightResourceOverlayFrame:GetChildren() }) do
            mUI:Skin({
                child.BG_Active,
                child.BG_Inactive,
                child.BG_Shadow
            }, true)
        end
    elseif (playerClass == 'EVOKER') then
        -- Evoker
        for _, child in ipairs({ EssencePlayerFrame:GetChildren() }) do
            mUI:Skin({
                child.EssenceFillDone.CircBG,
                child.EssenceFillDone.CircBGActive
            }, true)
        end

        for _, child in ipairs({ ClassNameplateBarDracthyrFrame:GetChildren() }) do
            mUI:Skin({
                child.EssenceFillDone.CircBG,
                child.EssenceFillDone.CircBGActive
            }, true)
        end
    elseif (playerClass == 'PALADIN') then
        -- Paladin
        mUI:Skin({
            PaladinPowerBarFrame.Background,
            PaladinPowerBarFrame.ActiveTexture,
            ClassNameplateBarPaladinFrame.Background,
            ClassNameplateBarPaladinFrame.ActiveTexture
        }, true)
    end
end
