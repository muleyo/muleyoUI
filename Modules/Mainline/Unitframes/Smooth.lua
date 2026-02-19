local SmoothHealth = mUI:NewModule("mUI.Modules.Unitframes.SmoothHealth", "AceHook-3.0")

function SmoothHealth:OnInitialize()
    self.updating = {}

    function SmoothHealth:Raidframes_Health(frame)
        if frame.healthBar then
            frame.healthBar:SetValue(UnitHealth(frame.unit), 1)
        end
    end

    function SmoothHealth:Raidframes_Power(frame)
        if frame.powerBar then
            frame.powerBar:SetValue(UnitPower(frame.unit), 1)
        end
    end

    function SmoothHealth:Unitframes_Health(frame)
        if frame.healthbar and not self.updating[frame.healthbar] then
            self.updating[frame.healthbar] = true
            frame.healthbar:SetValue(UnitHealth(frame.unit), 1)
            self.updating[frame.healthbar] = nil
        end
    end

    function SmoothHealth:Unitframes_Power(frame)
        if frame.manabar and not self.updating[frame.manabar] then
            self.updating[frame.manabar] = true
            frame.manabar:SetValue(UnitPower(frame.unit), 1)
            self.updating[frame.manabar] = nil
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
            SmoothHealth:Raidframes_Health(frame)
        end
    end)

    SmoothHealth:SecureHook("CompactUnitFrame_UpdatePower", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        local name = frame:GetName()

        if name and name:match("^Compact") then
            SmoothHealth:Raidframes_Power(frame)
        end
    end)
end

function SmoothHealth:OnDisable()
    SmoothHealth:UnhookAll()
end
