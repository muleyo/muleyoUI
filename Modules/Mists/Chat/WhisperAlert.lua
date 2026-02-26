local WhisperAlert = mUI:NewModule("mUI.Modules.Chat.WhisperAlert", "AceHook-3.0")

function WhisperAlert:OnInitialize()
    WhisperAlert.frame = CreateFrame("Frame")
    WhisperAlert.frame:RegisterEvent("CHAT_MSG_WHISPER")
    WhisperAlert.frame:RegisterEvent("CHAT_MSG_BN_WHISPER")

    function WhisperAlert:Sound()
        PlaySoundFile([[Interface\AddOns\mUI\Media\Sounds\whisper.ogg]], "Master")
    end
end

function WhisperAlert:OnEnable()
    WhisperAlert:SecureHookScript(WhisperAlert.frame, "OnEvent", WhisperAlert.Sound)
end

function WhisperAlert:OnDisable()
    WhisperAlert:UnhookAll()
end
