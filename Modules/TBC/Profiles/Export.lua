local Export = mUI:NewModule("mUI.Modules.Profiles.Export", "AceSerializer-3.0")

function Export:OnInitialize()
    -- Load Libraries
    Export.LibDeflate = LibStub:GetLibrary("LibDeflate")

    function Export:ExportProfile()
        --AceSerialize
        local serialized_profile = Export:Serialize(mUI.db.profile)

        --LibDeflate
        local compressed_profile = Export.LibDeflate:CompressZlib(serialized_profile)
        local encoded_profile    = Export.LibDeflate:EncodeForPrint(compressed_profile)
        return encoded_profile
    end
end
