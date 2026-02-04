local SmoothHealth = mUI:NewModule("mUI.Modules.Unitframes.SmoothHealth", "AceHook-3.0")

function SmoothHealth:OnInitialize()
    self.updating = {}

    function SmoothHealth:Raidframes(frame)
        if not (frame and frame.unit) or frame:IsForbidden() then
            return
        end

        if frame.healthBar and not self.updating[frame.healthBar] then
            self.updating[frame.healthBar] = true
            frame.healthBar:SetValue(UnitHealth(frame.unit), 1)
            self.updating[frame.healthBar] = nil
        end
    end

    function SmoothHealth:Unitframes(frame)
        if not (frame and frame.unit) or frame:IsForbidden() then
            return
        end

        if frame.healthbar and not self.updating[frame.healthbar] then
            self.updating[frame.healthbar] = true
            frame.healthbar:SetValue(UnitHealth(frame.unit), 1)
            self.updating[frame.healthbar] = nil
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
            SmoothHealth:Raidframes(frame)
        end
    end)

    SmoothHealth:SecureHook(PlayerFrame.healthbar, "SetValue", function()
        SmoothHealth:Unitframes(PlayerFrame)
    end)

    SmoothHealth:SecureHook(TargetFrame.healthbar, "SetValue", function()
        SmoothHealth:Unitframes(TargetFrame)
    end)

    SmoothHealth:SecureHook(FocusFrame.healthbar, "SetValue", function()
        SmoothHealth:Unitframes(FocusFrame)
    end)
end

function SmoothHealth:OnDisable()
    SmoothHealth:UnhookAll()
end
