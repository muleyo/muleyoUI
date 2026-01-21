local Import = mUI:NewModule("mUI.Modules.Profiles.Import", "AceSerializer-3.0")

function Import:OnInitialize()
    -- Load Libraries
    Import.LibDeflate = LibStub:GetLibrary("LibDeflate")

    function Import:ImportProfile(string)
        --LibDeflate decode
        local decoded_profile = Import.LibDeflate:DecodeForPrint(string)
        if decoded_profile == nil then
            mUI:Debug("< ERROR: Invalid Import String >")
            return
        end

        --LibDefalte uncompress
        local uncompressed_profile = Import.LibDeflate:DecompressZlib(decoded_profile)
        if uncompressed_profile == nil then
            mUI:Debug("< ERROR: Invalid Import String >")
            return
        end
        --AceSerialize
        --deserialize the profile and overwirte the current values
        local valid, imported_Profile = Import:Deserialize(uncompressed_profile)
        if valid and imported_Profile then
            for i, v in pairs(imported_Profile) do
                if type(v) == "table" then
                    mUI.db.profile[i] = CopyTable(v)
                else
                    local new_value = v
                    mUI.db.profile[i] = new_value
                end
            end

            mUI:GUI()
            mUI:Reload("Imported Profile")
        else
            mUI:Debug("< ERROR: Invalid Import String >")
            return
        end
    end
end
