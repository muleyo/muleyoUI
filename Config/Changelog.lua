local Changelog = mUI:NewModule("mUI.Config.Changelog")

-- Maintainer note: this window intentionally shows ONLY the latest update.
-- Keep this as a single entry and update it each release.
local CHANGELOG = {
    version = "4.1.20",
    affected = {"Mainline"},
    changes = {"Added option to highlight raidframes on mouseover", "Fixed an issue that would not update nameplates after a unit got mind-controlled"}
}

function Changelog:OnInitialize()
    Changelog.db = mUI.db.profile
    local currentVersion = C_AddOns.GetAddOnMetadata("mUI", "Version")

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

    if not CHANGELOG.version then
        return
    end

    Changelog:Show(currentVersion)
end

function Changelog:Show(currentVersion)
    local mGUI = mUI.mGUI

    if not Changelog.frame then
        local frame = CreateFrame("Frame", "mUIChangelog", UIParent, "BackdropTemplate")
        PixelUtil.SetSize(frame, 420, 380)
        PixelUtil.SetPoint(frame, "CENTER", UIParent, "CENTER", 0, 0)
        frame:SetFrameStrata("DIALOG")
        mGUI:ApplyBackdrop(frame, "bg", false)
        mGUI:ApplyQuadBorder(frame, mGUI.Colors.border)
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

        local boxFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        PixelUtil.SetPoint(boxFrame, "TOPLEFT", frame, "TOPLEFT", 16, -58)
        PixelUtil.SetPoint(boxFrame, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 46)
        mGUI:ApplyBackdrop(boxFrame, "bgWidget", "border")

        local topEdgeOverlay = CreateFrame("Frame", nil, boxFrame)
        topEdgeOverlay:SetAllPoints(boxFrame)
        topEdgeOverlay:SetFrameLevel(boxFrame:GetFrameLevel() + 50)
        topEdgeOverlay:SetFrameStrata("TOOLTIP")

        local topEdge = topEdgeOverlay:CreateTexture(nil, "OVERLAY")
        topEdge:SetColorTexture(unpack(mGUI.Colors.border))
        PixelUtil.SetPoint(topEdge, "TOPLEFT", topEdgeOverlay, "TOPLEFT", 0, 0)
        PixelUtil.SetPoint(topEdge, "TOPRIGHT", topEdgeOverlay, "TOPRIGHT", 0, 0)
        PixelUtil.SetHeight(topEdge, 1)
        mUI:DisablePixelSnap(topEdge)

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

    local gameVersion = mUI:GameVersion()
    local currentFlavor = "Unknown"
    if gameVersion.Mainline then
        currentFlavor = "Mainline"
    elseif gameVersion.Mists then
        currentFlavor = "Mists"
    elseif gameVersion.TBC then
        currentFlavor = "TBC"
    elseif gameVersion.Vanilla then
        currentFlavor = "Vanilla"
    end

    local affected = CHANGELOG.affected or {}
    local affectedList = #affected > 0 and table.concat(affected, ", ") or "All"
    local affectedMap = {}
    for _, flavor in ipairs(affected) do
        affectedMap[flavor] = true
    end
    local currentIsAffected = (#affected == 0) or affectedMap[currentFlavor]

    -- Show only the latest release notes by design.
    local lines = {}
    table.insert(lines, "|cff009cff" .. CHANGELOG.version .. "|r")
    table.insert(lines, "")
    table.insert(lines, "Affected game versions: " .. affectedList)
    if currentIsAffected then
        table.insert(lines, "This client (" .. currentFlavor .. ") is affected.")
    else
        table.insert(lines, "This client (" .. currentFlavor .. ") is not affected.")
    end
    table.insert(lines, "")
    for _, change in ipairs(CHANGELOG.changes or {}) do
        table.insert(lines, "  - " .. change)
    end

    Changelog.frame.versionText:SetText("Version " .. currentVersion)
    Changelog.frame.text:SetText(table.concat(lines, "\n"))
    local contentWidth = math.max(1, (Changelog.frame.body:GetParent():GetWidth() or 1) - 4)
    Changelog.frame.body:SetWidth(contentWidth)
    Changelog.frame.text:SetWidth(contentWidth)
    Changelog.frame.body:SetHeight(Changelog.frame.text:GetStringHeight() + 10)
    C_Timer.After(0.1, function()
        Changelog.frame:Show()
    end)
end
