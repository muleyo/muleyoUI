local Offset = mUI:NewModule("mUI.Modules.Castbars.Offset", "AceHook-3.0")

-- Per frame: the setting, and the "Castbar on top" module that places the bar when that is enabled
local FRAMES = {
    { name = "TargetFrame", key = "targety", onTop = "mUI.Modules.Castbars.Targetpos" },
    { name = "FocusFrame", key = "focusy", onTop = "mUI.Modules.Castbars.Focuspos" }
}

function Offset:OnInitialize()
    Offset.db = mUI.db.profile.castbars
end

-- Blizzard hangs the bar off the frame itself, put it there again with the offset
function Offset:Place(frame)
    local bar = _G[frame:GetName() .. "SpellBar"]
    if not bar or frame.mUI_castbarOnTop then
        return
    end

    -- a bar hanging off an aura container is moved through the container (Theme)
    local _, relativeTo = bar:GetPoint(1)
    if relativeTo == frame then
        mUI:GetModule("mUI.Modules.General.Theme"):AnchorSpellbarToFrame(frame, bar)
    end
end

-- The frames carry the value, the aura theme and "Castbar on top" read it from there
function Offset:Refresh(active)
    local Theme = mUI:GetModule("mUI.Modules.General.Theme")

    for _, info in ipairs(FRAMES) do
        local frame = _G[info.name]
        frame.mUI_castbarOffset = active and Offset.db[info.key] or nil

        if frame.mUI_castbarOnTop then
            mUI:GetModule(info.onTop):Update()
        else
            Offset:Place(frame)
            Theme:AnchorSpellbarToContainer(frame)
        end
    end
end

function Offset:OnEnable()
    for _, info in ipairs(FRAMES) do
        local frame = _G[info.name]
        Offset:SecureHook(_G[info.name .. "SpellBar"], "AdjustPosition", function()
            Offset:Place(frame)
        end)
    end

    Offset:Refresh(true)
end

function Offset:OnDisable()
    Offset:UnhookAll()
    Offset:Refresh(false)
end
