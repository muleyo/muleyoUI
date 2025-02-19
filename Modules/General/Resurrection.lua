local Resurrection = mUI:NewModule("mUI.Modules.General.Resurrection")

function Resurrection:OnInitialize()
    self.resurrection = CreateFrame("Frame")
    self.resurrection:SetScript("OnEvent", function(_, event, name)
        if not event == "RESURRECT_REQUEST" then return end
        if not UnitAffectingCombat(name) then
            AcceptResurrect()
            StaticPopup_Hide("RESURRECT_NO_TIMER")
        end
    end)
end

function Resurrection:OnEnable()
    self.resurrection:RegisterEvent("RESURRECT_REQUEST")
end

function Resurrection:OnDisable()
    self.resurrection:UnregisterEvent("RESURRECT_REQUEST")
end
