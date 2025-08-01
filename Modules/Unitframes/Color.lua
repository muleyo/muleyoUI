local Classcolor = mUI:NewModule("mUI.Modules.Unitframes.Color", "AceHook-3.0")

function Classcolor:OnInitialize()
    -- Load Database
    Classcolor.db = mUI.db.profile.unitframes

    -- Create Frame
    Classcolor.classcolor = CreateFrame("Frame")

    -- Create Tables
    if mUI:IsClassic() then
        Classcolor.healthbars = {
            player = PlayerFrame.healthbar,
            pet = PetFrame.healthbar,
            target = TargetFrame.healthbar,
            focus = FocusFrame.healthbar,
            targettarget = TargetFrameToT.healthbar,
            focustarget = FocusFrameToT.healthbar,
            boss1 = Boss1TargetFrame.healthbar,
            boss2 = Boss2TargetFrame.healthbar,
            boss3 = Boss3TargetFrame.healthbar,
            boss4 = Boss4TargetFrame.healthbar,
            boss5 = Boss5TargetFrame.healthbar,
            party1 = PartyMemberFrame1.healthbar,
            party2 = PartyMemberFrame2.healthbar,
            party3 = PartyMemberFrame3.healthbar,
            party4 = PartyMemberFrame4.healthbar
        }
    else
        -- Variables
        Classcolor.playerFrame = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
        Classcolor.originalTexture = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health"

        -- Create Tables
        Classcolor.frames = {
            player = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain,
            target = TargetFrame.TargetFrameContent.TargetFrameContentMain,
            focus = FocusFrame.TargetFrameContent.TargetFrameContentMain,
            boss1 = Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain,
            boss2 = Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain,
            boss3 = Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain,
            boss4 = Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain,
            boss5 = Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain
        }

        Classcolor.unitframes = {
            player = PlayerFrame,
            pet = PetFrame,
            target = TargetFrame,
            focus = FocusFrame,
            targettarget = TargetFrameToT,
            focustarget = FocusFrameToT,
            boss1 = Boss1TargetFrame,
            boss2 = Boss2TargetFrame,
            boss3 = Boss3TargetFrame,
            boss4 = Boss4TargetFrame,
            boss5 = Boss5TargetFrame,
            party1 = PartyFrame.MemberFrame1,
            party2 = PartyFrame.MemberFrame2,
            party3 = PartyFrame.MemberFrame3,
            party4 = PartyFrame.MemberFrame4
        }
    end

    if mUI:IsClassic() then
        function Classcolor:SetColor(healthbar, unit)
            if mUI:IsClassic() then
                healthbar.lockColor = true
                if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
                    local _, class = UnitClass(unit)
                    local color = RAID_CLASS_COLORS[class]
                    healthbar:SetStatusBarColor(color.r, color.g, color.b)
                elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
                    healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
                else
                    if UnitExists(unit) then
                        if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                            healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
                        elseif (not UnitIsTapDenied(unit)) then
                            local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                            if reaction then
                                healthbar:SetStatusBarColor(reaction.r, reaction.g, reaction.b)
                            end
                        end
                    end
                end
            else
                local unitframe = Classcolor.frames[unit]
                if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
                    local _, class = UnitClass(unit)
                    local color = RAID_CLASS_COLORS[class]
                    frame:SetStatusBarDesaturated(true)
                    frame:SetStatusBarColor(color.r, color.g, color.b)
                    if unitframe and unitframe.ReputationColor then
                        unitframe.ReputationColor:SetVertexColor(color.r, color.g, color.b)
                    end
                elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
                    frame:SetStatusBarDesaturated(true)
                    frame:SetStatusBarColor(0.5, 0.5, 0.5)
                    if unitframe and unitframe.ReputationColor then
                        unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
                    end
                else
                    if UnitExists(unit) then
                        if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                            frame:SetStatusBarDesaturated(true)
                            frame:SetStatusBarColor(0.5, 0.5, 0.5)
                            if unitframe and unitframe.ReputationColor then
                                unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
                            end
                        elseif (not UnitIsTapDenied(unit)) then
                            local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                            if reaction then
                                frame:SetStatusBarDesaturated(true)
                                frame:SetStatusBarColor(reaction.r, reaction.g, reaction.b)

                                if unitframe and unitframe.ReputationColor then
                                    unitframe.ReputationColor:SetVertexColor(reaction.r, reaction.g, reaction.b)
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        function Classcolor:SetColor(frame, unit)
            local unitframe = Classcolor.frames[unit]
            if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
                local _, class = UnitClass(unit)
                local color = RAID_CLASS_COLORS[class]
                frame:SetStatusBarDesaturated(true)
                frame:SetStatusBarColor(color.r, color.g, color.b)
                if unitframe and unitframe.ReputationColor then
                    unitframe.ReputationColor:SetVertexColor(color.r, color.g, color.b)
                end
            elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
                frame:SetStatusBarDesaturated(true)
                frame:SetStatusBarColor(0.5, 0.5, 0.5)
                if unitframe and unitframe.ReputationColor then
                    unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
                end
            else
                if UnitExists(unit) then
                    if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                        frame:SetStatusBarDesaturated(true)
                        frame:SetStatusBarColor(0.5, 0.5, 0.5)
                        if unitframe and unitframe.ReputationColor then
                            unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
                        end
                    elseif (not UnitIsTapDenied(unit)) then
                        local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                        if reaction then
                            frame:SetStatusBarDesaturated(true)
                            frame:SetStatusBarColor(reaction.r, reaction.g, reaction.b)

                            if unitframe and unitframe.ReputationColor then
                                unitframe.ReputationColor:SetVertexColor(reaction.r, reaction.g, reaction.b)
                            end
                        end
                    end
                end
            end
        end
    end

    function Classcolor:Update()
        if mUI:IsClassic() then
            for unit, healthbar in pairs(Classcolor.healthbars) do
                Classcolor:SetColor(healthbar, unit)
            end

            TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0.5)
            FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0.5)
        else
            for _, frame in pairs(Classcolor.unitframes) do
                Classcolor:SetColor(frame.healthbar, frame.unit)
            end
        end
    end
end

function Classcolor:OnEnable()
    -- Hook Frame
    Classcolor:SecureHookScript(Classcolor.classcolor, "OnUpdate", function()
        Classcolor:Update()
    end)

    if not mUI:IsClassic() then
        -- Update PlayerFrame HealthColor
        local _, playerClass = UnitClass("player")
        local color = RAID_CLASS_COLORS[playerClass]
        Classcolor.playerFrame.ReputationColor:SetVertexColor(color.r, color.g, color.b)
        Classcolor.playerFrame.HealthBarsContainer.HealthBar:SetStatusBarDesaturated(true)
        Classcolor.playerFrame.HealthBarsContainer.HealthBar:SetStatusBarColor(color.r, color.g, color.b)
    end
end

function Classcolor:OnDisable()
    -- Unhook
    Classcolor:UnhookAll()

    -- Reset Colors
    if mUI:IsClassic() then
        for _, healthbar in pairs(Classcolor.healthbars) do
            healthbar:SetStatusBarColor(0, 1, 0)
        end
    else
        Classcolor.playerFrame.ReputationColor:SetVertexColor(0, 0, 1)
        if Classcolor.db.textures.unitframes == "None" then
            for _, frame in pairs(Classcolor.frames) do
                frame.HealthBarsContainer.HealthBar:SetStatusBarDesaturated(false)
                frame.HealthBarsContainer.HealthBar:SetStatusBarColor(1, 1, 1)
            end
        else
            for _, frame in pairs(Classcolor.frames) do
                frame.HealthBarsContainer.HealthBar.unitFrame.healthbar:SetStatusBarColor(0, 1, 0)
            end
        end
    end
end
