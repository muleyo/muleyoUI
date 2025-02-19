local Cinematic = mUI:NewModule("mUI.Modules.General.Cinematic")

function Cinematic:OnInitialize()
    self.cinematic = CreateFrame("Frame")
    self.cinematic:SetScript("OnEvent", function(_, event, id)
        if event == "CINEMATIC_START" then
            CinematicFrame_CancelCinematic()
        elseif event == "PLAY_MOVIE" then
            MovieFrame:StopMovie(id)
        end
    end)
end

function Cinematic:OnEnable()
    self.cinematic:RegisterEvent("CINEMATIC_START")
    self.cinematic:RegisterEvent("PLAY_MOVIE")
end

function Cinematic:OnDisable()
    self.cinematic:UnregisterAllEvents()
end
