-- Symmetric Player Frame (WoW Forever): with Retail Textures on, the player
-- frame uses the target art mirrored, so the portrait sits in a round ring
-- like the target's, without the retail player art's square corner.
--
-- Ported from BetterBlizzFrames by Bodify (BBF.SymmetricPlayerFrame in
-- forever/modules/retailTextures.lua). The layout itself is done by
-- BigHealthbar.lua (mUI.UFLayout); this module only switches it on and off.

local SymmetricPlayer = mUI:NewModule("mUI.Modules.Unitframes.SymmetricPlayer")

function SymmetricPlayer:OnEnable()
    if mUI.UFLayout then mUI.UFLayout.SetSymmetric(true) end
end

function SymmetricPlayer:OnDisable()
    if mUI.UFLayout then mUI.UFLayout.SetSymmetric(false) end
end
