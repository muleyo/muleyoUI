local Media = mUI:NewModule("mUI.Media")

function Media:OnInitialize()
    local LSM = LibStub("LibSharedMedia-3.0")

    -- Background

    -- Border

    -- Font
    LSM:Register("font", "None", [[None]])
    LSM:Register("font", "Arial Bold", [[Interface\Addons\mUI\Media\Fonts\ArialBold.ttf]])
    LSM:Register("font", "Avant Garde", [[Interface\Addons\mUI\Media\Fonts\AvantGarde.ttf]])
    LSM:Register("font", "Doris P Bold", [[Interface\Addons\mUI\Media\Fonts\DorisPBold.ttf]])
    LSM:Register("font", "Exo2 Bold", [[Interface\Addons\mUI\Media\Fonts\Exo2Bold.ttf]])
    LSM:Register("font", "Expressway", [[Interface\Addons\mUI\Media\Fonts\Expressway.ttf]])
    LSM:Register("font", "Gotham Narrow Black", [[Interface\Addons\mUI\Media\Fonts\GothamNarrow-Black.ttf]])
    LSM:Register("font", "Inter Bold", [[Interface\Addons\mUI\Media\Fonts\InterBold.ttf]])
    LSM:Register("font", "Magistral TT Bold", [[Interface\Addons\mUI\Media\Fonts\MagistralTTBold.ttf]])
    LSM:Register("font", "Myriad Web Bold", [[Interface\Addons\mUI\Media\Fonts\MyriadWebBold.ttf]])
    LSM:Register("font", "Prototype", [[Interface\Addons\mUI\Media\Fonts\Prototype.ttf]])

    -- Status
    LSM:Register("statusbar", "None", [[Interface\AddOns\None]])
    LSM:Register("statusbar", "Ace", [[Interface\Addons\mUI\Media\Textures\Status\Ace.blp]])
    LSM:Register("statusbar", "Aluminium", [[Interface\Addons\mUI\Media\Textures\Status\Aluminium.tga]])
    LSM:Register("statusbar", "Banto", [[Interface\Addons\mUI\Media\Textures\Status\Banto.tga]])
    LSM:Register("statusbar", "Charcoal", [[Interface\Addons\mUI\Media\Textures\Status\Charcoal.tga]])
    LSM:Register("statusbar", "Dragonflight", [[Interface\Addons\mUI\Media\Textures\Status\DragonflightTexture.tga]])
    LSM:Register("statusbar", "Flat", [[Interface\Addons\mUI\Media\Textures\Status\Flat.tga]])
    LSM:Register("statusbar", "Glaze", [[Interface\Addons\mUI\Media\Textures\Status\Glaze.blp]])
    LSM:Register("statusbar", "LiteStep", [[Interface\Addons\mUI\Media\Textures\Status\LiteStep.tga]])
    LSM:Register("statusbar", "Melli", [[Interface\Addons\mUI\Media\Textures\Status\Melli.tga]])
    LSM:Register("statusbar", "Melli 6px", [[Interface\Addons\mUI\Media\Textures\Status\Melli6px.tga]])
    LSM:Register("statusbar", "Melli Dark", [[Interface\Addons\mUI\Media\Textures\Status\MelliDark.tga]])
    LSM:Register("statusbar", "Melli Dark Rough", [[Interface\Addons\mUI\Media\Textures\Status\MelliDarkRough.tga]])
    LSM:Register("statusbar", "Miniamlist", [[Interface\Addons\mUI\Media\Textures\Status\Minimalist.tga]])
    LSM:Register("statusbar", "Otravi", [[Interface\Addons\mUI\Media\Textures\Status\Otravi.tga]])
    LSM:Register("statusbar", "Perl", [[Interface\Addons\mUI\Media\Textures\Status\Perl.tga]])
    LSM:Register("statusbar", "Smooth", [[Interface\Addons\mUI\Media\Textures\Status\Smooth.tga]])
    LSM:Register("statusbar", "Smooth v2", [[Interface\Addons\mUI\Media\Textures\Status\Smoothv2.tga]])
    LSM:Register("statusbar", "Striped", [[Interface\Addons\mUI\Media\Textures\Status\Striped.tga]])
    LSM:Register("statusbar", "Swag", [[Interface\Addons\mUI\Media\Textures\Status\Swag.tga]])
end
