local Classcolor = mUI:NewModule("mUI.Modules.Unitframes.Color", "AceHook-3.0")

function Classcolor:OnInitialize()
    -- Load Database
    Classcolor.db = mUI.db.profile.unitframes

    -- Create Frame
    Classcolor.classcolor = CreateFrame("Frame")
    Classcolor.classcolor:RegisterEvent("PLAYER_ENTERING_WORLD")
    Classcolor.classcolor:RegisterEvent("UNIT_HEALTH")
    Classcolor.classcolor:RegisterEvent("UNIT_TARGET")
    Classcolor.classcolor:RegisterEvent("UNIT_FACTION")
    Classcolor.classcolor:RegisterEvent("PLAYER_TARGET_CHANGED")
    Classcolor.classcolor:RegisterEvent("PLAYER_FOCUS_CHANGED")
    Classcolor.classcolor:RegisterEvent("GROUP_ROSTER_UPDATE")
    Classcolor.classcolor:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    Classcolor.classcolor:RegisterEvent("UNIT_TARGETABLE_CHANGED")

    -- Create Tables
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

    function Classcolor:SetColor(frame, unit)
        local unitframe = Classcolor.frames[unit]
        local tex = frame:GetStatusBarTexture()
        if not tex then
            return
        end
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
            local _, class = UnitClass(unit)
            -- C_ClassColor.GetClassColor is secret-safe (SecretArguments = AllowedWhenTainted),
            -- so it takes the secret class token on 12.1.x without the "index table with secret
            -- key" crash - but it MayReturnNothing, so nil-guard before reading the color.
            local color = C_ClassColor.GetClassColor(class)
            if color then
                tex:SetDesaturated(true)
                tex:SetVertexColor(color.r, color.g, color.b)
                if unitframe and unitframe.ReputationColor then
                    unitframe.ReputationColor:SetVertexColor(color.r, color.g, color.b)
                end
            end
        elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
            tex:SetDesaturated(true)
            tex:SetVertexColor(0.5, 0.5, 0.5)
            if unitframe and unitframe.ReputationColor then
                unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
            end
        else
            if UnitExists(unit) then
                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                    tex:SetDesaturated(true)
                    tex:SetVertexColor(0.5, 0.5, 0.5)
                    if unitframe and unitframe.ReputationColor then
                        unitframe.ReputationColor:SetVertexColor(0.5, 0.5, 0.5)
                    end
                elseif (not UnitIsTapDenied(unit)) then
                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
                    if reaction then
                        tex:SetDesaturated(true)
                        tex:SetVertexColor(reaction.r, reaction.g, reaction.b)

                        if unitframe and unitframe.ReputationColor then
                            unitframe.ReputationColor:SetVertexColor(reaction.r, reaction.g, reaction.b)
                        end
                    end
                end
            end
        end
    end

    function Classcolor:Update()
        for _, frame in pairs(Classcolor.unitframes) do
            Classcolor:SetColor(frame.healthbar, frame.unit)
        end
    end
end

function Classcolor:OnEnable()
    -- Hook Frame
    Classcolor:SecureHookScript(Classcolor.classcolor, "OnEvent", Classcolor.Update)

    -- Update PlayerFrame HealthColor
    local _, playerClass = UnitClass("player")
    local color = C_ClassColor.GetClassColor(playerClass)
    Classcolor.playerFrame.ReputationColor:SetVertexColor(color.r, color.g, color.b)
    local playerTex = Classcolor.playerFrame.HealthBarsContainer.HealthBar:GetStatusBarTexture()
    if playerTex then
        playerTex:SetDesaturated(true)
        playerTex:SetVertexColor(color.r, color.g, color.b)
    end
end

function Classcolor:OnDisable()
    -- Unhook
    Classcolor:UnhookAll()

    -- Reset Colors
    Classcolor.playerFrame.ReputationColor:SetVertexColor(0, 0, 1)
    if Classcolor.db.textures.unitframes == "None" then
        for _, frame in pairs(Classcolor.frames) do
            local tex = frame.HealthBarsContainer.HealthBar:GetStatusBarTexture()
            if tex then
                tex:SetDesaturated(false)
                tex:SetVertexColor(1, 1, 1)
            end
        end
    else
        for _, frame in pairs(Classcolor.frames) do
            local tex = frame.HealthBarsContainer.HealthBar.unitFrame.healthbar:GetStatusBarTexture()
            if tex then
                tex:SetVertexColor(0, 1, 0)
            end
        end
    end
end
