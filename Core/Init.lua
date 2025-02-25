mUI = LibStub("AceAddon-3.0"):NewAddon("mUI", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceComm-3.0",
    "AceSerializer-3.0", "AceHook-3.0")

-- Set Modules Default State
mUI:SetDefaultModuleState(false)

-- Register Slash Commands
function mUI:OnInitialize()
    self:RegisterChatCommand("mui", "SlashCommand")
    self:RegisterChatCommand("rl", ReloadUI)
    self:RegisterChatCommand("fs", function()
        UIParentLoadAddOn("Blizzard_DebugTools");
        local showHiddenArg, showRegionsArg, showAnchorsArg;
        local pattern = "^%s*(%S+)(.*)$";
        showHiddenArg, msg = string.match(msg or "", pattern);
        showRegionsArg, msg = string.match(msg or "", pattern);
        showAnchorsArg, msg = string.match(msg or "", pattern);
        -- If no parameters are passed the defaults specified by these cvars are used instead.
        local showHiddenDefault = FrameStackTooltip_IsShowHiddenEnabled();
        local showRegionsDefault = FrameStackTooltip_IsShowRegionsEnabled();
        local showAnchorsDefault = FrameStackTooltip_IsShowAnchorsEnabled();
        local showHidden = StringToBoolean(showHiddenArg or "", showHiddenDefault);
        local showRegions = StringToBoolean(showRegionsArg or "", showRegionsDefault);
        local showAnchors = StringToBoolean(showAnchorsArg or "", showAnchorsDefault);
        FrameStackTooltip_Toggle(showHidden, showRegions, showAnchors);
    end)

    -- Slash Command
    function self:SlashCommand()
        self:GUI()
    end

    -- Open/Close GUI with smooth fade-in/out
    function self:GUI(toggle)
        if (toggle) then
            return function()
                if (mUIOptions:IsVisible()) then
                    local fadeInfo = {}
                    fadeInfo.mode = "OUT"
                    fadeInfo.timeToFade = 0.2
                    fadeInfo.finishedFunc = function()
                        mUIOptions:Hide()
                    end
                    UIFrameFade(mUIOptions, fadeInfo)
                    ToggleGameMenu()
                else
                    local fadeInfo = {}
                    fadeInfo.mode = "IN"
                    fadeInfo.timeToFade = 0.2
                    fadeInfo.finishedFunc = function()
                        mUIOptions:Show()
                    end
                    UIFrameFade(mUIOptions, fadeInfo)
                    ToggleGameMenu()
                end
            end
        else
            if (mUIOptions:IsVisible()) then
                local fadeInfo = {}
                fadeInfo.mode = "OUT"
                fadeInfo.timeToFade = 0.2
                fadeInfo.finishedFunc = function()
                    mUIOptions:Hide()
                end
                UIFrameFade(mUIOptions, fadeInfo)
            else
                local fadeInfo = {}
                fadeInfo.mode = "IN"
                fadeInfo.timeToFade = 0.2
                fadeInfo.finishedFunc = function()
                    mUIOptions:Show()
                end
                UIFrameFade(mUIOptions, fadeInfo)
            end
        end
    end

    -- Minimap AddOns Option
    _G.mUI_Options = function()
        mUI:GUI()
    end
end
