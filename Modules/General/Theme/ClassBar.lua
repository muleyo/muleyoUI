local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
function Theme:ClassBar()
    -- Rogue
    if (playerClass == "ROGUE") then
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
    elseif (playerClass == "MAGE") then
        -- Mage
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
    elseif (playerClass == "WARLOCK") then
        -- Warlock
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
    elseif (playerClass == "DRUID") then
        -- Druid
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
    elseif (playerClass == "MONK") then
        -- Monk
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
    elseif (playerClass == "DEATHKNIGHT") then
        -- Death Knight
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
    elseif (playerClass == "EVOKER") then
        -- Evoker
        for _, child in pairs({ EssencePlayerFrame:GetChildren() }) do
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
    elseif (playerClass == "PALADIN") then
        -- Paladin
        mUI:Skin({
            PaladinPowerBarFrame.Background,
            PaladinPowerBarFrame.ActiveTexture,
            ClassNameplateBarPaladinFrame.Background,
            ClassNameplateBarPaladinFrame.ActiveTexture
        }, true)
    end
    if (playerClass == "SHAMAN" or playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "DRUID") then
        for totem, _ in TotemFrame.totemPool:EnumerateActive() do
            mUI:Skin({ totem.Border }, true)
        end
    end
end
