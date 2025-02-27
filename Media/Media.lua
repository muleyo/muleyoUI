local Media = mUI:NewModule("mUI.Media")

function Media:OnInitialize()
    Media.LSM = LibStub("LibSharedMedia-3.0")

    -- Background

    -- Border

    -- Font
    Media.LSM:Register("font", "None", STANDARD_TEXT_FONT)
    Media.LSM:Register("font", "Arial Bold", [[Interface\Addons\mUI\Media\Fonts\ArialBold.ttf]])
    Media.LSM:Register("font", "Avant Garde", [[Interface\Addons\mUI\Media\Fonts\AvantGarde.ttf]])
    Media.LSM:Register("font", "Doris P Bold", [[Interface\Addons\mUI\Media\Fonts\DorisPBold.ttf]])
    Media.LSM:Register("font", "Exo2 Bold", [[Interface\Addons\mUI\Media\Fonts\Exo2Bold.ttf]])
    Media.LSM:Register("font", "Expressway", [[Interface\Addons\mUI\Media\Fonts\Expressway.ttf]])
    Media.LSM:Register("font", "Gotham Narrow Black", [[Interface\Addons\mUI\Media\Fonts\GothamNarrow-Black.ttf]])
    Media.LSM:Register("font", "Inter Bold", [[Interface\Addons\mUI\Media\Fonts\InterBold.ttf]])
    Media.LSM:Register("font", "Magistral TT Bold", [[Interface\Addons\mUI\Media\Fonts\MagistralTTBold.ttf]])
    Media.LSM:Register("font", "Myriad Web Bold", [[Interface\Addons\mUI\Media\Fonts\MyriadWebBold.ttf]])
    Media.LSM:Register("font", "Prototype", [[Interface\Addons\mUI\Media\Fonts\Prototype.ttf]])

    -- Status
    Media.LSM:Register("statusbar", "None", [[Interface\AddOns\None]])
    Media.LSM:Register("statusbar", "Ace", [[Interface\Addons\mUI\Media\Textures\Status\Ace.blp]])
    Media.LSM:Register("statusbar", "Aluminium", [[Interface\Addons\mUI\Media\Textures\Status\Aluminium.tga]])
    Media.LSM:Register("statusbar", "Banto", [[Interface\Addons\mUI\Media\Textures\Status\Banto.tga]])
    Media.LSM:Register("statusbar", "Charcoal", [[Interface\Addons\mUI\Media\Textures\Status\Charcoal.tga]])
    Media.LSM:Register("statusbar", "Dragonflight",
        [[Interface\Addons\mUI\Media\Textures\Status\DragonflightTexture.tga]])
    Media.LSM:Register("statusbar", "Flat", [[Interface\Addons\mUI\Media\Textures\Status\Flat.tga]])
    Media.LSM:Register("statusbar", "Glaze", [[Interface\Addons\mUI\Media\Textures\Status\Glaze.blp]])
    Media.LSM:Register("statusbar", "LiteStep", [[Interface\Addons\mUI\Media\Textures\Status\LiteStep.tga]])
    Media.LSM:Register("statusbar", "Melli", [[Interface\Addons\mUI\Media\Textures\Status\Melli.tga]])
    Media.LSM:Register("statusbar", "Melli 6px", [[Interface\Addons\mUI\Media\Textures\Status\Melli6px.tga]])
    Media.LSM:Register("statusbar", "Melli Dark", [[Interface\Addons\mUI\Media\Textures\Status\MelliDark.tga]])
    Media.LSM:Register("statusbar", "Melli Dark Rough", [[Interface\Addons\mUI\Media\Textures\Status\MelliDarkRough.tga]])
    Media.LSM:Register("statusbar", "Miniamlist", [[Interface\Addons\mUI\Media\Textures\Status\Minimalist.tga]])
    Media.LSM:Register("statusbar", "Otravi", [[Interface\Addons\mUI\Media\Textures\Status\Otravi.tga]])
    Media.LSM:Register("statusbar", "Perl", [[Interface\Addons\mUI\Media\Textures\Status\Perl.tga]])
    Media.LSM:Register("statusbar", "Smooth", [[Interface\Addons\mUI\Media\Textures\Status\Smooth.tga]])
    Media.LSM:Register("statusbar", "Smooth v2", [[Interface\Addons\mUI\Media\Textures\Status\Smoothv2.tga]])
    Media.LSM:Register("statusbar", "Striped", [[Interface\Addons\mUI\Media\Textures\Status\Striped.tga]])
    Media.LSM:Register("statusbar", "Swag", [[Interface\Addons\mUI\Media\Textures\Status\Swag.tga]])
end
