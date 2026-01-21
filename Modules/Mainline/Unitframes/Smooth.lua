local SmoothHealth = mUI:NewModule("mUI.Modules.Unitframes.SmoothHealth", "AceHook-3.0")

function SmoothHealth:OnInitialize()
    SmoothHealth.frame = CreateFrame("Frame")
    SmoothHealth.bars = {}

    function SmoothHealth:UnitFrame(frame)
        if not (frame and frame.unit) or frame:IsForbidden() then
            return
        end

        if frame.healthBar then
            frame.healthBar:SetValue(UnitHealth(frame.unit), 1)
        end
    end
end

function SmoothHealth:OnEnable()
    SmoothHealth:SecureHook("CompactUnitFrame_UpdateHealth", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        local name = frame:GetName()

        if name and name:match("^Compact") then
            SmoothHealth:UnitFrame(frame)
        end
    end)
end

function SmoothHealth:OnDisable()
    SmoothHealth:UnhookAll()
end
