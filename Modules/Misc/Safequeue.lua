local Safequeue = mUI:NewModule("mUI.Modules.Misc.Safequeue", "AceHook-3.0")

function Safequeue:OnInitialize()
    -- Create Frame
    Safequeue.frame = CreateFrame("Frame")
    Safequeue.timer = TOOLTIP_UPDATE_TIME

    -- Tables
    Safequeue.colors = {
        green = "20ff20",
        yellow = "ffff00",
        red = "ff0000"
    }

    -- Functions
    function Safequeue:SetExpiresText()
        if not Safequeue.battlefieldID then return end

        local text
        local time = GetBattlefieldPortExpiration(Safequeue.battlefieldID)

        if time <= 0 then time = 1 end
        if time > 20 then
            text = "SafeQueue expires in |cff" .. Safequeue.colors.green .. SecondsToTime(time) .. "|r"
        elseif time > 10 then
            text = "SafeQueue expires in |cff" .. Safequeue.colors.yellow .. SecondsToTime(time) .. "|r"
        else
            text = "SafeQueue expires in |cff" .. Safequeue.colors.red .. SecondsToTime(time) .. "|r"
        end

        if PVPReadyDialog then
            PVPReadyDialog.label:SetText(text)
        end
    end

    function Safequeue:Update()
        if not Safequeue.battlefieldID then return end

        Safequeue.timer = Safequeue.timer - elapsed
        if Safequeue.timer <= 0 then
            if GetBattlefieldStatus(Safequeue.battlefieldID) ~= "confirm" then
                Safequeue.battlefieldID = nil
                return
            end

            Safequeue:SetExpiresText()
        end
    end

    function Safequeue:ReadyDialog(id)
        if PVPReadyDialog.hideButton then PVPReadyDialog.hideButton:Hide() end
        if PVPReadyDialog.leaveButton then PVPReadyDialog.leaveButton:Hide() end

        PVPReadyDialog.enterButton:ClearAllPoints()
        PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)
        Safequeue.battlefieldID = id

        Safequeue:SetExpiresText()
    end
end

function Safequeue:OnEnable()
    PVPReadyDialog.label:SetWidth(250)

    Safequeue:HookScript(Safequeue.frame, "OnEvent", function(_, elapsed)
        Safequeue:SetExpiresText(_, elapsed)
    end)

    Safequeue:SecureHook("PVPReadyDialog_Display", function(id)
        Safequeue.ReadyDialog(id)
    end)
end

function Safequeue:OnDisable()
    PVPReadyDialog.label:SetWidth(200)

    Safequeue:UnhookAll()
end
