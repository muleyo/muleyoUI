local Texture = mUI:NewModule("mUI.Modules.Castbars.Texture")

function Texture:OnInitialize()
    -- Load Database
    Texture.db = mUI.db.profile.castbars

    -- Get LibSharedMedia
    Texture.LSM = LibStub("LibSharedMedia-3.0")

    -- Tables
    Texture.castbars = {
        player = "CastingBarFrame",
        target = "TargetFrameSpellBar",
        boss1 = "Boss1TargetFrameSpellBar",
        boss2 = "Boss2TargetFrameSpellBar",
        boss3 = "Boss3TargetFrameSpellBar",
        boss4 = "Boss4TargetFrameSpellBar",
        boss5 = "Boss5TargetFrameSpellBar"
    }

    function Texture:Update(default)
        local texture = Texture.LSM:Fetch('statusbar', Texture.db.texture)

        -- Update the texture for all castbars
        for _, castbar in pairs(Texture.castbars) do
            if default then
                _G[castbar]:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
            else
                _G[castbar]:SetStatusBarTexture(texture)
            end
        end
    end
end

function Texture:OnEnable()
    Texture:Update()
end

function Texture:OnDisable()
    Texture:Update(true)
end
