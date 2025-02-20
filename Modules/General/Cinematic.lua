local Cinematic = mUI:NewModule("mUI.Modules.General.Cinematic")

function Cinematic:OnInitialize()
    self.cinematic = CreateFrame("Frame")
    function self:Update(event, id)
        if event == "CINEMATIC_START" then
            CinematicFrame_CancelCinematic()
        elseif event == "PLAY_MOVIE" then
            MovieFrame:StopMovie(id)
        end
    end
end

function Cinematic:OnEnable()
    self.cinematic:RegisterEvent("CINEMATIC_START")
    self.cinematic:RegisterEvent("PLAY_MOVIE")
    mUI:RawHookScript(self.cinematic, "OnEvent", function(_, event, id)
        self:Update(event, id)
    end)
end

function Cinematic:OnDisable()
    mUI:Unhook(self.cinematic, "OnEvent")
    self.cinematic:UnregisterAllEvents()
end
