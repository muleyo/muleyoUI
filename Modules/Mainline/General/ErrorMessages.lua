local ErrorMessages = mUI:NewModule("mUI.Modules.General.ErrorMessages", "AceHook-3.0")

function ErrorMessages:OnInitialize()
    local colors = {
        UI_INFO_MESSAGE = { r = 1.0, g = 1.0, b = 0.0 },
        UI_ERROR_MESSAGE = { r = 1.0, g = 0.1, b = 0.1 },
    }

    local originalOnEvent = UIErrorsFrame:GetScript("OnEvent")
    function ErrorMessages:Update(data, event, ...)
        local messageType, message, r, g, b

        if event == "SYSMSG" then
            message, r, g, b = ...
            return originalOnEvent(data, event, ...)
        elseif event == "UI_INFO_MESSAGE" then
            messageType, message = ...
            return originalOnEvent(data, event, ...)
        end

        if event ~= "SYSMSG" then
            messageType, message = ...
            r, g, b = colors[event].r, colors[event].g, colors[event].b
            local _, soundKitID, voiceID = GetGameMessageInfo(messageType)
            if voiceID then
                C_Sound.PlayVocalErrorSound(voiceID)
            elseif soundKitID then
                PlaySound(soundKitID)
            end
        elseif event == "UI_INFO_MESSAGE" then
            messageType, message = ...
            return originalOnEvent(data, event, ...)
        end
    end
end

function ErrorMessages:OnEnable()
    ErrorMessages:RawHookScript(UIErrorsFrame, "OnEvent", function(data, event, ...)
        ErrorMessages:Update(data, event, ...)
    end)
end

function ErrorMessages:OnDisable()
    ErrorMessages:UnhookAll()
end
