local RF_ExtraMouseButtons = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_ExtraMouseButtons", "AceHook-3.0", "AceEvent-3.0")

-- Mouse4/Mouse5 on Blizzard raid/party frames.
-- The compact frames are secure buttons that consume every mouse click, so keybinds on BUTTON4/BUTTON5 never fire while hovering them.
-- Instead, the frames forward those clicks to the action button the binding points at (mouseover macros then resolve to the hovered frame).
function RF_ExtraMouseButtons:OnInitialize()
    -- Variables
    RF_ExtraMouseButtons.frames = {}
    RF_ExtraMouseButtons.pending = false

    -- Tables
    RF_ExtraMouseButtons.multiBars = {
        MULTIACTIONBAR1BUTTON = "MultiBarBottomLeftButton",
        MULTIACTIONBAR2BUTTON = "MultiBarBottomRightButton",
        MULTIACTIONBAR3BUTTON = "MultiBarRightButton",
        MULTIACTIONBAR4BUTTON = "MultiBarLeftButton",
        MULTIACTIONBAR5BUTTON = "MultiBar5Button",
        MULTIACTIONBAR6BUTTON = "MultiBar6Button",
        MULTIACTIONBAR7BUTTON = "MultiBar7Button"
    }
    RF_ExtraMouseButtons.modifiers = {"", "ALT-", "CTRL-", "SHIFT-", "ALT-CTRL-", "ALT-SHIFT-", "CTRL-SHIFT-", "ALT-CTRL-SHIFT-"}

    function RF_ExtraMouseButtons:ResolveButton(action)
        if not action or action == "" then
            return nil
        end
        local n = action:match("^ACTIONBUTTON(%d+)$")
        if n then
            return _G["ActionButton" .. n]
        end
        local bar, index = action:match("^(MULTIACTIONBAR%dBUTTON)(%d+)$")
        if bar and RF_ExtraMouseButtons.multiBars[bar] then
            return _G[RF_ExtraMouseButtons.multiBars[bar] .. index]
        end
        local name = action:match("^CLICK ([^:]+):")
        return name and _G[name] or nil
    end

    function RF_ExtraMouseButtons:ApplyBindings(frame)
        for _, mod in ipairs(RF_ExtraMouseButtons.modifiers) do
            local prefix = mod:lower()
            for i = 4, 5 do
                local button = RF_ExtraMouseButtons:ResolveButton(GetBindingAction(mod .. "BUTTON" .. i, true))
                frame:SetAttribute(prefix .. "type" .. i, button and "click" or nil)
                frame:SetAttribute(prefix .. "clickbutton" .. i, button)
            end
        end
    end

    -- The forwarded click bypasses ActionButtonDown/Up, so mirror their pressed-state visual
    function RF_ExtraMouseButtons:SetPressed(frame, button, state)
        local i = button == "Button4" and 4 or button == "Button5" and 5
        if not i then
            return
        end
        local prefix = (IsAltKeyDown() and "alt-" or "") .. (IsControlKeyDown() and "ctrl-" or "") .. (IsShiftKeyDown() and "shift-" or "")
        local target = frame:GetAttribute(prefix .. "clickbutton" .. i)
        if target and target.SetButtonState then
            target:SetButtonState(state)
            -- The Flash module hooks ActionButtonDown/MultiActionButtonDown, which the forwarded click never calls
            if state == "PUSHED" and target:GetEffectiveAlpha() == 1 then
                local flash = mUI:GetModule("mUI.Modules.Actionbars.Flash", true)
                if flash and flash:IsEnabled() then
                    flash:AnimateButton(target)
                end
            end
        end
    end

    function RF_ExtraMouseButtons:FixFrame(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        RF_ExtraMouseButtons.frames[frame] = true
        if not frame.mUIExtraMouseHooked then
            frame.mUIExtraMouseHooked = true
            -- PostClick, not OnMouseDown: the forwarded Click() pushes and releases the action button itself, which would undo this
            frame:HookScript("PostClick", function(self, button, down)
                if RF_ExtraMouseButtons:IsEnabled() and down then
                    RF_ExtraMouseButtons:SetPressed(self, button, "PUSHED")
                end
            end)
            frame:HookScript("OnMouseUp", function(self, button)
                if RF_ExtraMouseButtons:IsEnabled() then
                    RF_ExtraMouseButtons:SetPressed(self, button, "NORMAL")
                end
            end)
        end
        if InCombatLockdown() then
            RF_ExtraMouseButtons.pending = true -- attributes/click registration are protected on secure frames in combat
            return
        end
        -- Mouse4/5 fire on press like keybinds do, everything else keeps Blizzard's on-release behavior
        frame:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Down", "Button5Down")
        RF_ExtraMouseButtons:ApplyBindings(frame)
    end

    function RF_ExtraMouseButtons:IsCompactFrame(frame)
        -- Nameplate unit frames are forbidden to addons and also go through CompactUnitFrame_SetUnit
        if not frame or frame:IsForbidden() then
            return false
        end
        return frame.unit and (frame:GetName() or ""):match("^Compact")
    end

    function RF_ExtraMouseButtons:Update()
        RF_ExtraMouseButtons.pending = false
        for frame in pairs(RF_ExtraMouseButtons.frames) do
            RF_ExtraMouseButtons:FixFrame(frame)
        end
    end

    function RF_ExtraMouseButtons:Restore()
        if InCombatLockdown() then
            return
        end
        for frame in pairs(RF_ExtraMouseButtons.frames) do
            frame:RegisterForClicks("AnyUp")
            for _, mod in ipairs(RF_ExtraMouseButtons.modifiers) do
                local prefix = mod:lower()
                for i = 4, 5 do
                    frame:SetAttribute(prefix .. "type" .. i, nil)
                    frame:SetAttribute(prefix .. "clickbutton" .. i, nil)
                end
            end
        end
    end
end

function RF_ExtraMouseButtons:OnEnable()
    -- SetUnit re-runs SecureUnitButton_OnLoad, which resets the click registration, so hook after it
    RF_ExtraMouseButtons:SecureHook("CompactUnitFrame_SetUnit", function(frame)
        if RF_ExtraMouseButtons:IsCompactFrame(frame) then
            RF_ExtraMouseButtons:FixFrame(frame)
        end
    end)

    RF_ExtraMouseButtons:RegisterEvent("UPDATE_BINDINGS", "Update")
    RF_ExtraMouseButtons:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        if RF_ExtraMouseButtons.pending then
            RF_ExtraMouseButtons:Update()
        end
    end)

    -- Frames created before the hook existed
    local frame = EnumerateFrames()
    while frame do
        if frame.unit and frame.GetName and RF_ExtraMouseButtons:IsCompactFrame(frame) then
            RF_ExtraMouseButtons:FixFrame(frame)
        end
        frame = EnumerateFrames(frame)
    end
end

function RF_ExtraMouseButtons:OnDisable()
    RF_ExtraMouseButtons:UnhookAll()
    RF_ExtraMouseButtons:UnregisterAllEvents()
    RF_ExtraMouseButtons:Restore()
end
