local About = mUI:NewModule("mUI.Config.Layouts.About")

function About:OnInitialize()
    -- Initialize Layout
    About.layout = {
        type = "group",
        args = {
            header = {
                name = "About",
                type = "header",
                order = 1
            },
            description = {
                name = "Thank you for using |cff009cffmuleyo|r|cffffd100UI|r!",
                type = "description",
                fontSize = "large",
                width = "full",
                order = 2
            },
            subtext = {
                name = "If you have any questions, suggestions, or issues, please visit the GitHub page or join the Discord Server.",
                type = "description",
                fontSize = "medium",
                width = "full",
                order = 3
            },
            spacer1 = {
                name = " ",
                type = "description",
                width = "full",
                order = 4
            },
            twitch = {
                name = "Twitch",
                type = "execute",
                func = function()
                    mUI:Link("https://twitch.tv/muleyo")
                end,
                width = 1,
                order = 5
            },
            discord = {
                name = "Discord",
                type = "execute",
                func = function()
                    mUI:Link("https://discord.gg/gE5g43mZqy")
                end,
                width = 1,
                order = 6
            },
            donate = {
                name = "Donate",
                type = "execute",
                func = function()
                    mUI:Link("https://pay.muleyo.dev/?donation=true")
                end,
                width = 1,
                order = 7
            },
            spacer2 = {
                name = " ",
                type = "description",
                width = "full",
                order = 8
            },
            creditsHeader = {
                name = "Credits",
                type = "header",
                order = 9
            },
            credits = {
                name = "- mMediaTag Textures by Blinkii",
                type = "description",
                fontSize = "medium",
                width = "full",
                order = 10
            }
        }
    }

    function About:GetOptions()
        return About.layout
    end
end
