local Safequeue = mUI:NewModule("mUI.Modules.Misc.Safequeue", "AceHook-3.0")

function Safequeue:OnInitialize()
    -- Create Frame
    Safequeue.frame = CreateFrame("Frame")
    Safequeue.queues = {}
    Safequeue.ticker = nil

    -- Tables
    Safequeue.colors = {
        green = "20ff20",
        yellow = "ffff00",
        red = "ff0000"
    }

    -- Functions
    function Safequeue:SetExpiresText()
        if not Safequeue.battlefieldID then
            return
        end

        if GetBattlefieldStatus(Safequeue.battlefieldID) ~= "confirm" then
            Safequeue:StopTimer()
            return
        end

        local text
        local time = GetBattlefieldPortExpiration(Safequeue.battlefieldID)

        if time <= 0 then
            time = 1
        end
        if time > 20 then
            text = "Queue expires in |cff" .. Safequeue.colors.green .. SecondsToTime(time) .. "|r"
        elseif time > 10 then
            text = "Queue expires in |cff" .. Safequeue.colors.yellow .. SecondsToTime(time) .. "|r"
        else
            text = "Queue expires in |cff" .. Safequeue.colors.red .. SecondsToTime(time) .. "|r"
        end

        if PVPReadyDialog then
            PVPReadyDialog.label:SetText(text)
        end
    end

    function Safequeue:StartTimer()
        if Safequeue.ticker then
            return
        end

        Safequeue:SetExpiresText()
        Safequeue.ticker = C_Timer.NewTicker(1, function()
            Safequeue:SetExpiresText()
        end)
    end

    function Safequeue:StopTimer()
        if Safequeue.ticker then
            Safequeue.ticker:Cancel()
            Safequeue.ticker = nil
        end
        Safequeue.battlefieldID = nil
    end

    function Safequeue:ReadyDialog(id)
        if PVPReadyDialog.hideButton then
            PVPReadyDialog.hideButton:Hide()
        end
        if PVPReadyDialog.leaveButton then
            PVPReadyDialog.leaveButton:Hide()
        end

        PVPReadyDialog.enterButton:ClearAllPoints()
        PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)
        Safequeue.battlefieldID = id

        Safequeue:StartTimer()
    end

    function Safequeue:Popped()
        for i = 1, GetMaxBattlefieldID() do
            local status = GetBattlefieldStatus(i)
            if status == "queued" then
                Safequeue.queues[i] = Safequeue.queues[i] or GetTime() - (GetBattlefieldTimeWaited(i) / 1000)
            elseif status == "confirm" then
                if Safequeue.queues[i] then
                    local secs = GetTime() - Safequeue.queues[i]
                    if secs < 1 then
                        mUI:Debug("Queue popped instantly!")
                    else
                        mUI:Debug("Queue popped after " .. SecondsToTime(secs))
                    end

                    Safequeue.queues[i] = nil
                end
            end
        end
    end
end

function Safequeue:OnEnable()
    PVPReadyDialog.label:SetWidth(250)

    Safequeue:SecureHook("PVPReadyDialog_Display", function(_, id)
        Safequeue:ReadyDialog(id)
    end)

    Safequeue.frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
    Safequeue.frame:SetScript("OnEvent", function()
        Safequeue:Popped()
    end)
end

function Safequeue:OnDisable()
    PVPReadyDialog.label:SetWidth(200)
    Safequeue:StopTimer()
    Safequeue.frame:UnregisterAllEvents()
    Safequeue:UnhookAll()
end
