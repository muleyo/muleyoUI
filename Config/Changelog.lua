local Changelog = mUI:NewModule("mUI.Config.Changelog")

-- The changes of this release, written from the commits when the release is built (Config/ChangelogData.lua, made by
-- .github/scripts/generate_changelog.py). Without it, in a copy that isn't a release, there is no changelog.
local CHANGELOG = mUI.ChangelogData or {}

local function GetFlavor()
    local gameVersion = mUI:GameVersion()
    if gameVersion.Mainline then
        return "Mainline"
    elseif gameVersion.Forever then
        return "Forever"
    end

    return nil
end

-- The changes that are for this game version: the ones without a list of game versions are for all of them
local function GetChanges()
    local flavor = GetFlavor()
    local changes = {}

    for _, change in ipairs(CHANGELOG.changes or {}) do
        local flavors = change.flavors
        local included = not flavors or #flavors == 0

        for _, name in ipairs(flavors or {}) do
            if name == flavor then
                included = true
                break
            end
        end

        if included then
            changes[#changes + 1] = change
        end
    end

    return changes
end

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

    -- Nothing to tell about this release, or nothing for this game version
    if not CHANGELOG.version or #GetChanges() == 0 then
        return
    end

    Changelog:Show(currentVersion)
end

-- The changelog of this release again, for /mui changelog
function Changelog:Open()
    if not CHANGELOG.version then
        print("|cff009cffm|r|cffffd100UI|r: There is no changelog in this version")
        return
    end

    Changelog:Show(C_AddOns.GetAddOnMetadata("mUI", "Version"))
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

    -- Show only the latest release notes by design, and only what is for this game version.
    local lines = {}
    table.insert(lines, "|cff009cff" .. CHANGELOG.version .. "|r")
    table.insert(lines, "")
    table.insert(lines, "Changes for your game version (" .. (GetFlavor() or "Unknown") .. "):")
    table.insert(lines, "")
    for _, change in ipairs(GetChanges()) do
        table.insert(lines, "  - " .. change.text)
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
