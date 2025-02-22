local BuffsDebuffs = mUI:NewModule("mUI.Modules.Unitframes.BuffsDebuffs")

function BuffsDebuffs:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.unitframes.buffsdebuffs

    -- Update Buff/Debuff Size
    function self:UpdateSize(aura, type)
        if type == "buff" then
            aura:SetSize(self.db.buffsize, self.db.buffsize)
        elseif type == "debuff" then
            aura:SetSize(self.db.debuffsize, self.db.debuffsize)
        end

        if aura.Count then
            aura.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            aura.Count:ClearAllPoints()
            aura.Count:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 2, 0)
        end
    end
end

function BuffsDebuffs:OnEnable()
    mUI:SecureHook("TargetFrame_UpdateBuffAnchor", function(_, aura)
        self:UpdateSize(aura, "buff")
    end)

    mUI:SecureHook("TargetFrame_UpdateDebuffAnchor", function(_, aura)
        self:UpdateSize(aura, "debuff")
    end)
end

function BuffsDebuffs:OnDisable()
    mUI:Unhook("TargetFrame_UpdateBuffAnchor")
    mUI:Unhook("TargetFrame_UpdateDebuffAnchor")
end
