local Cinematic = mUI:NewModule("mUI.Modules.General.Cinematic", "AceHook-3.0")

function Cinematic:OnInitialize()
    Cinematic.cinematic = CreateFrame("Frame")
    function Cinematic:Update(event, id)
        if event == "CINEMATIC_START" then
            CinematicFrame_CancelCinematic()
        elseif event == "PLAY_MOVIE" then
            MovieFrame:StopMovie(id)
        end
    end
end

function Cinematic:OnEnable()
    Cinematic.cinematic:RegisterEvent("CINEMATIC_START")
    Cinematic.cinematic:RegisterEvent("PLAY_MOVIE")
    Cinematic:RawHookScript(Cinematic.cinematic, "OnEvent", function(_, event, id)
        Cinematic:Update(event, id)
    end)
end

function Cinematic:OnDisable()
    Cinematic:UnhookAll()
    Cinematic.cinematic:UnregisterAllEvents()
end
