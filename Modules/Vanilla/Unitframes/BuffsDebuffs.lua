local BuffsDebuffs = mUI:NewModule("mUI.Modules.Unitframes.BuffsDebuffs", "AceHook-3.0")

function BuffsDebuffs:OnInitialize()
    -- Load Database
    BuffsDebuffs.db = {
        buffsdebuffs = mUI.db.profile.unitframes.buffsdebuffs,
        general = mUI.db.profile.general
    }

    BuffsDebuffs.LSM = LibStub("LibSharedMedia-3.0")
    BuffsDebuffs.font = BuffsDebuffs.LSM:Fetch('font', BuffsDebuffs.db.general.font)

    -- Update Buff/Debuff Size
    function BuffsDebuffs:UpdateSize(aura, type)
        if type == "buff" then
            aura:SetSize(BuffsDebuffs.db.buffsdebuffs.buffsize, BuffsDebuffs.db.buffsdebuffs.buffsize)
        elseif type == "debuff" then
            aura:SetSize(BuffsDebuffs.db.buffsdebuffs.debuffsize, BuffsDebuffs.db.buffsdebuffs.debuffsize)
        end

        if aura.Count then
            aura.Count:SetFont(BuffsDebuffs.font, 10, "OUTLINE")
            aura.Count:ClearAllPoints()
            aura.Count:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 2, 0)
        end
    end
end

function BuffsDebuffs:OnEnable()
    BuffsDebuffs:SecureHook(TargetFrame, "UpdateAuraPositions", function(_, type, numAuras)
        for i = 1, numAuras do
            if type == "TargetFrameBuff" or type == "FocusFrameBuff" then
                BuffsDebuffs:UpdateSize(_G[type .. i], "buff")
            elseif type == "TargetFrameDebuff" or type == "FocusFrameDebuff" then
                BuffsDebuffs:UpdateSize(_G[type .. i], "debuff")
            end
        end
    end)

    BuffsDebuffs:SecureHook(FocusFrame, "UpdateAuraPositions", function(_, type, numAuras)
        for i = 1, numAuras do
            if type == "TargetFrameBuff" or type == "FocusFrameBuff" then
                BuffsDebuffs:UpdateSize(_G[type .. i], "buff")
            elseif type == "TargetFrameDebuff" or type == "FocusFrameDebuff" then
                BuffsDebuffs:UpdateSize(_G[type .. i], "debuff")
            end
        end
    end)
end

function BuffsDebuffs:OnDisable()
    BuffsDebuffs:UnhookAll()
end
