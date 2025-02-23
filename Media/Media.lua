local Media = mUI:NewModule("mUI.Media")

function Media:OnInitialize()
    self.LSM = LibStub("LibSharedMedia-3.0")

    -- Background

    -- Border

    -- Font
    self.LSM:Register("font", "None", [[None]])
    self.LSM:Register("font", "Arial Bold", [[Interface\Addons\mUI\Media\Fonts\ArialBold.ttf]])
    self.LSM:Register("font", "Avant Garde", [[Interface\Addons\mUI\Media\Fonts\AvantGarde.ttf]])
    self.LSM:Register("font", "Doris P Bold", [[Interface\Addons\mUI\Media\Fonts\DorisPBold.ttf]])
    self.LSM:Register("font", "Exo2 Bold", [[Interface\Addons\mUI\Media\Fonts\Exo2Bold.ttf]])
    self.LSM:Register("font", "Expressway", [[Interface\Addons\mUI\Media\Fonts\Expressway.ttf]])
    self.LSM:Register("font", "Gotham Narrow Black", [[Interface\Addons\mUI\Media\Fonts\GothamNarrow-Black.ttf]])
    self.LSM:Register("font", "Inter Bold", [[Interface\Addons\mUI\Media\Fonts\InterBold.ttf]])
    self.LSM:Register("font", "Magistral TT Bold", [[Interface\Addons\mUI\Media\Fonts\MagistralTTBold.ttf]])
    self.LSM:Register("font", "Myriad Web Bold", [[Interface\Addons\mUI\Media\Fonts\MyriadWebBold.ttf]])
    self.LSM:Register("font", "Prototype", [[Interface\Addons\mUI\Media\Fonts\Prototype.ttf]])

    -- Status
    self.LSM:Register("statusbar", "None", [[Interface\AddOns\None]])
    self.LSM:Register("statusbar", "Ace", [[Interface\Addons\mUI\Media\Textures\Status\Ace.blp]])
    self.LSM:Register("statusbar", "Aluminium", [[Interface\Addons\mUI\Media\Textures\Status\Aluminium.tga]])
    self.LSM:Register("statusbar", "Banto", [[Interface\Addons\mUI\Media\Textures\Status\Banto.tga]])
    self.LSM:Register("statusbar", "Charcoal", [[Interface\Addons\mUI\Media\Textures\Status\Charcoal.tga]])
    self.LSM:Register("statusbar", "Dragonflight", [[Interface\Addons\mUI\Media\Textures\Status\DragonflightTexture.tga]])
    self.LSM:Register("statusbar", "Flat", [[Interface\Addons\mUI\Media\Textures\Status\Flat.tga]])
    self.LSM:Register("statusbar", "Glaze", [[Interface\Addons\mUI\Media\Textures\Status\Glaze.blp]])
    self.LSM:Register("statusbar", "LiteStep", [[Interface\Addons\mUI\Media\Textures\Status\LiteStep.tga]])
    self.LSM:Register("statusbar", "Melli", [[Interface\Addons\mUI\Media\Textures\Status\Melli.tga]])
    self.LSM:Register("statusbar", "Melli 6px", [[Interface\Addons\mUI\Media\Textures\Status\Melli6px.tga]])
    self.LSM:Register("statusbar", "Melli Dark", [[Interface\Addons\mUI\Media\Textures\Status\MelliDark.tga]])
    self.LSM:Register("statusbar", "Melli Dark Rough", [[Interface\Addons\mUI\Media\Textures\Status\MelliDarkRough.tga]])
    self.LSM:Register("statusbar", "Miniamlist", [[Interface\Addons\mUI\Media\Textures\Status\Minimalist.tga]])
    self.LSM:Register("statusbar", "Otravi", [[Interface\Addons\mUI\Media\Textures\Status\Otravi.tga]])
    self.LSM:Register("statusbar", "Perl", [[Interface\Addons\mUI\Media\Textures\Status\Perl.tga]])
    self.LSM:Register("statusbar", "Smooth", [[Interface\Addons\mUI\Media\Textures\Status\Smooth.tga]])
    self.LSM:Register("statusbar", "Smooth v2", [[Interface\Addons\mUI\Media\Textures\Status\Smoothv2.tga]])
    self.LSM:Register("statusbar", "Striped", [[Interface\Addons\mUI\Media\Textures\Status\Striped.tga]])
    self.LSM:Register("statusbar", "Swag", [[Interface\Addons\mUI\Media\Textures\Status\Swag.tga]])
end
