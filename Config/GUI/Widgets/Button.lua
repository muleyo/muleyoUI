local mGUI = mUI.mGUI

function mGUI.Widgets.Button(parent)
    -- "MainMenuFrameButtonTemplate" doesn't exist at all on Classic Era
    -- (Vanilla) - confirmed via that client's own UI source, unlike
    -- Mainline/TBC/Mists which all define it (there it's just a thin
    -- wrapper around UIPanelButtonTemplate anyway, with fonts we already set
    -- explicitly below). Fall back to the plain, always-available
    -- UIPanelButtonTemplate on Vanilla to avoid a hard CreateFrame error.
    local buttonTemplate = mUI:GameVersion()["Vanilla"] and "UIPanelButtonTemplate" or "MainMenuFrameButtonTemplate"
    local button = CreateFrame("Button", nil, parent, buttonTemplate)
    button:SetSize(140, 28)
    button:SetNormalFontObject(GameFontHighlight)
    button:SetHighlightFontObject(GameFontHighlight)
    button:SetDisabledFontObject(GameFontDisable)
    mGUI:TintThreeSlice(button)

    button:SetScript("OnClick", function(self)
        if self.OnClick then
            self:OnClick()
        end
    end)

    function button:SetLabel(text)
        self:SetText(text or "")
        -- Button widgets are pooled/reused across EVERY execute-type option in
        -- the whole GUI (see Config/GUI/Renderer.lua). Only growing the width
        -- here (never shrinking) let a widget previously sized for a
        -- wider-labeled button (e.g. on another tab) leak its stale larger
        -- width into a later, shorter-labeled button (e.g. "Preview") after
        -- a Refresh() re-render - the button would visually grow and never
        -- shrink back. Always set the width explicitly to match this label.
        local width = self:GetFontString():GetStringWidth() + 40
        self:SetWidth(math.max(width, 140))
    end

    function button:SetWidgetEnabled(enabled)
        self:SetEnabled(enabled)
        -- Button widgets are pooled/reused across categories and tabs (see
        -- Config/GUI/Renderer.lua). mGUI:TintThreeSlice's re-tint only runs via
        -- a hook on UpdateButton, which Blizzard's template fires from the
        -- OnEnable/OnDisable scripts - those only fire on an actual state
        -- transition. A widget reused for a different option can already be
        -- sitting in the target enabled state (e.g. a disabled "Import"
        -- button recycled into an always-enabled "Reset Profile" button),
        -- so SetEnabled() here would be a no-op and the stale (desaturated)
        -- tint would stick. Force a re-tint unconditionally instead of
        -- relying on that transition.
        if self.UpdateButton then
            self:UpdateButton()
        end
    end

    return button
end
