local Overshields = mUI:NewModule("mUI.Modules.Unitframes.Overshields", "AceHook-3.0")

function Overshields:OnInitialize()
    function Overshields:Update(frame)
        if frame and frame:IsForbidden() then
            return
        end

        if frame and frame:GetName() then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                -- frame.healthBar:SetFrameLevel(frame.healthBar:GetFrameLevel() - 2)
                frame.healthBar:Hide()
                frame.totalAbsorb:SetDrawLayer("OVERLAY", 7)
                frame.totalAbsorbOverlay:SetDrawLayer("OVERLAY", 7)
            end
        end
    end
end

function Overshields:OnEnable()
    Overshields:SecureHook("CompactUnitFrame_UpdateHealPrediction", function(frame)
        Overshields:Update(frame)
    end)
end

function Overshields:OnDisable()
    Overshields:UnhookAll()
end
