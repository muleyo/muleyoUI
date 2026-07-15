local Changelog = mUI:NewModule("mUI.Config.Changelog")

-- Maintainer note: add a NEW entry to the TOP of this list for every release
-- that should surface a "What's New" popup to existing users (newest first).
-- Entries are purely informational text - this list is NOT compared against
-- the game's version number in any semantic way, it's just shown in full
-- whenever the installed addon version changes from what a user last saw.
local CHANGELOG = {{
    version = "1.0.0",
    changes = {"Added a \"What's New\" window that shows this changelog once per update."}
}}

function Changelog:OnInitialize()
    Changelog.db = mUI.db.profile
    local currentVersion = C_AddOns.GetAddOnMetadata("mUI", "Version")

    -- Brand-new installs already see Install.lua's welcome screen - just
    -- record the current version so they don't ALSO get a changelog popup
    -- the moment they finish first-time setup.
    if not Changelog.db.install then
        Changelog.db.changelogVersion = currentVersion
        return
    end

    -- Already shown for this exact version.
    if Changelog.db.changelogVersion == currentVersion then
        return
    end

    -- Mark as seen right away (shown = seen) so a user who never manually
    -- closes the window isn't re-prompted on every subsequent login.
    Changelog.db.changelogVersion = currentVersion

    if not CHANGELOG[1] then
        return
    end

    Changelog:Show(currentVersion)
end

function Changelog:Show(currentVersion)
    local mGUI = mUI.mGUI

    if not Changelog.frame then
        local frame = CreateFrame("Frame", "mUIChangelog", UIParent, "BackdropTemplate")
        frame:SetSize(420, 380)
        frame:SetPoint("CENTER")
        frame:SetFrameStrata("DIALOG")
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        mGUI:ApplyBackdrop(frame, "bg", "border")
        table.insert(UISpecialFrames, "mUIChangelog")
        Changelog.frame = frame

        -- Title
        local title = frame:CreateFontString(nil, "OVERLAY")
        title:SetPoint("TOP", frame, "TOP", 0, -14)
        mGUI:SetFont(title, 16, "OUTLINE")
        title:SetText("|cff009cffmuleyo|r|cffffd100UI|r - What's New")

        local versionText = frame:CreateFontString(nil, "OVERLAY")
        versionText:SetPoint("TOP", title, "BOTTOM", 0, -4)
        mGUI:SetFont(versionText, 12)
        versionText:SetTextColor(unpack(mGUI.Colors.version))
        frame.versionText = versionText

        -- Scrollable body (same ScrollFrameTemplate + MinimalScrollBar
        -- technique used by Gui.lua/MultiLineEditBox.lua, so the scrollbar
        -- art is consistent across Mainline/Mists/TBC/Vanilla).
        local boxFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        boxFrame:SetPoint("TOPLEFT", 16, -58)
        boxFrame:SetPoint("BOTTOMRIGHT", -16, 46)
        mGUI:ApplyBackdrop(boxFrame, "bgWidget", "border")

        local scroll = CreateFrame("ScrollFrame", nil, boxFrame, "ScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 8, -8)
        scroll:SetPoint("BOTTOMRIGHT", -26, 8)

        if scroll.ScrollBar then
            scroll.ScrollBar:Hide()
            scroll.ScrollBar:ClearAllPoints()
        end
        local scrollBar = CreateFrame("EventFrame", nil, scroll, "MinimalScrollBar")
        scrollBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 6, 2)
        scrollBar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 6, 5)
        scroll.ScrollBar = scrollBar
        ScrollUtil.InitScrollFrameWithScrollBar(scroll, scrollBar)
        scrollBar:Show()
        scrollBar:SetHideIfUnscrollable(true)
        scrollBar:SetHideTrackIfThumbExceedsTrack(true)

        local body = CreateFrame("Frame", nil, scroll)
        body:SetSize(1, 1)
        scroll:SetScrollChild(body)

        local text = body:CreateFontString(nil, "OVERLAY")
        text:SetPoint("TOPLEFT")
        text:SetPoint("TOPRIGHT")
        mGUI:SetFont(text, 12)
        text:SetTextColor(unpack(mGUI.Colors.text))
        text:SetJustifyH("LEFT")
        text:SetJustifyV("TOP")
        text:SetWordWrap(true)
        text:SetNonSpaceWrap(true)
        frame.text = text
        frame.body = body

        -- Close button
        local closeButton = mGUI.Widgets.Button(frame)
        closeButton:SetPoint("BOTTOM", 0, 14)
        closeButton:SetLabel(CLOSE)
        closeButton.OnClick = function()
            frame:Hide()
        end
        frame.closeButton = closeButton
    end

    -- Show every entry (newest first, per the maintainer-ordered list above)
    -- rather than trying to figure out which ones are "new" - version
    -- strings aren't reliably comparable/sortable at runtime.
    local lines = {}
    for _, entry in ipairs(CHANGELOG) do
        table.insert(lines, "|cff009cffv" .. entry.version .. "|r")
        for _, change in ipairs(entry.changes) do
            table.insert(lines, "  - " .. change)
        end
        table.insert(lines, "")
    end

    Changelog.frame.versionText:SetText("Version " .. currentVersion)
    Changelog.frame.text:SetText(table.concat(lines, "\n"))
    Changelog.frame.body:SetHeight(Changelog.frame.text:GetStringHeight() + 10)
    Changelog.frame:Show()
end
