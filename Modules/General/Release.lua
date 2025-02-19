local Release = mUI:NewModule("mUI.Modules.General.Release")

function Release:OnInitialize()
    self.release = CreateFrame("Frame")
    self.release:SetScript("OnEvent", function(_, event)
        if not event == "PLAYER_DEAD" then return end
        RepopMe()
    end)
end

function Release:OnEnable()
    self.release:RegisterEvent("PLAYER_DEAD")
end

function Release:OnDisable()
    self.release:UnregisterEvent("PLAYER_DEAD")
end
