local BuffsDebuffs = mUI:NewModule("mUI.Modules.Unitframes.BuffsDebuffs", "AceHook-3.0")

function BuffsDebuffs:OnInitialize()
    -- Load Database
    BuffsDebuffs.db = mUI.db.profile.unitframes.buffsdebuffs

    -- Update Buff/Debuff Size
    function BuffsDebuffs:UpdateSize(aura, type)
        if type == "buff" then
            aura:SetSize(BuffsDebuffs.db.buffsize, BuffsDebuffs.db.buffsize)
        elseif type == "debuff" then
            aura:SetSize(BuffsDebuffs.db.debuffsize, BuffsDebuffs.db.debuffsize)
        end

        if aura.Count then
            aura.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            aura.Count:ClearAllPoints()
            aura.Count:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 2, 0)
        end
    end
end

function BuffsDebuffs:OnEnable()
    BuffsDebuffs:SecureHook("TargetFrame_UpdateBuffAnchor", function(_, aura)
        self:UpdateSize(aura, "buff")
    end)

    BuffsDebuffs:SecureHook("TargetFrame_UpdateDebuffAnchor", function(_, aura)
        BuffsDebuffs:UpdateSize(aura, "debuff")
    end)
end

function BuffsDebuffs:OnDisable()
    BuffsDebuffs:UnhookAll()
end
