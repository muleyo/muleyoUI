local Tabbinder = mUI:NewModule("mUI.Modules.Misc.Tabbinder", "AceHook-3.0")

function Tabbinder:OnInitialize()
    Tabbinder.frame = CreateFrame("Frame")

    function Tabbinder:Update(event, ...)
        if event == "CHAT_MSG_SYSTEM" then
            local chatMessage = ...
            if chatMessage == ERR_DUEL_REQUESTED then
                event = "DUEL_REQUESTED"
            end
        elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" or
            (event == "PLAYER_REGEN_ENABLED" and Tabbinder.Fail) or
            event == "DUEL_REQUESTED" or
            event == "DUEL_FINISHED"
        then
            local bindSet = GetCurrentBindingSet()
            local PVPType = C_PvP.GetZonePVPInfo()
            local _, zoneType = IsInInstance()

            Tabbinder.TargetKey = GetBindingKey("TARGETNEARESTENEMYPLAYER")
            if not Tabbinder.TargetKey then
                Tabbinder.TargetKey = GetBindingKey("TARGETNEARESTENEMY")
            end
            if (not Tabbinder.TargetKey) and Tabbinder.DefaultKey == true then
                Tabbinder.TargetKey = "TAB"
            end

            Tabbinder.LastTargetKey = GetBindingKey("TARGETPREVIOUSENEMYPLAYER")
            if not Tabbinder.LastTargetKey then
                Tabbinder.LastTargetKey = GetBindingKey("TARGETPREVIOUSENEMY")
            end
            if not Tabbinder.LastTargetKey and Tabbinder.DefaultKey == true then
                Tabbinder.LastTargetKey = "SHIFT-TAB"
            end

            if Tabbinder.TargetKey then
                Tabbinder.CurrentBind = GetBindingAction(Tabbinder.TargetKey)
            end

            if zoneType == "arena" or PVPType == "combat" or zoneType == "pvp" or event == "DUEL_REQUESTED" then
                if Tabbinder.CurrentBind ~= "TARGETNEARESTENEMYPLAYER" then
                    if not Tabbinder.TargetKey then
                        Tabbinder.Success = 1
                    else
                        Tabbinder.Success = SetBinding(Tabbinder.TargetKey, "TARGETNEARESTENEMYPLAYER")
                    end
                    if not Tabbinder.LastTargetKey then
                        SetBinding(Tabbinder.LastTargetKey, "TARGETPREVIOUSENEMYPLAYER")
                    end
                    if Tabbinder.Success == 1 then
                        SaveBindings(bindSet)
                        Tabbinder.Fail = false
                    else
                        Tabbinder.Fail = true
                    end
                end
            else
                if Tabbinder.CurrentBind ~= "TARGETNEARESTENEMY" then
                    if not Tabbinder.TargetKey then
                        Tabbinder.Success = 1
                    else
                        Tabbinder.Success = SetBinding(Tabbinder.TargetKey, "TARGETNEARESTENEMY")
                    end
                    if Tabbinder.LastTargetKey then
                        SetBinding(Tabbinder.LastTargetKey, "TARGETPREVIOUSENEMY")
                    end
                    if Tabbinder.Success == 1 then
                        SaveBindings(bindSet)
                        Tabbinder.Fail = false
                    else
                        Tabbinder.Fail = true
                    end
                end
            end
        end
    end
end

function Tabbinder:OnEnable()
    Tabbinder.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    Tabbinder.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    Tabbinder.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    Tabbinder.frame:RegisterEvent("DUEL_REQUESTED")
    Tabbinder.frame:RegisterEvent("DUEL_FINISHED")
    Tabbinder.frame:RegisterEvent("CHAT_MSG_SYSTEM")
    Tabbinder:HookScript(Tabbinder.frame, "OnEvent", Tabbinder.Update)
end

function Tabbinder:OnDisable()
    Tabbinder.frame:UnregisterAllEvents()
    Tabbinder:UnhookAll()
end
