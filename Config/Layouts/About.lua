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
            spacer1 = {
                name = " ",
                type = "description",
                width = "full",
                order = 2
            },
            spacer2 = {
                name = " ",
                type = "description",
                width = "full",
                order = 3
            },
            spacer3 = {
                name = " ",
                type = "description",
                width = "full",
                order = 4
            },
            spacer4 = {
                name = " ",
                type = "description",
                width = "full",
                order = 5
            },
            spacer5 = {
                name = " ",
                type = "description",
                width = "full",
                order = 6
            },
            spacer6 = {
                name = " ",
                type = "description",
                width = "full",
                order = 7
            },
            spacer7 = {
                name = " ",
                type = "description",
                width = "full",
                order = 8
            },
            spacer8 = {
                name = " ",
                type = "description",
                width = "full",
                order = 9
            },
            spacer9 = {
                name = " ",
                type = "description",
                width = "full",
                order = 10
            },
            spacer10 = {
                name = "",
                type = "description",
                width = 1.75,
                order = 11
            },
            description = {
                name = "Thank you for using |cff009cffmuleyo|r|cffffd100UI|r!",
                type = "description",
                fontSize = "large",
                width = 2,
                order = 12
            },
            spacer11 = {
                name = " ",
                type = "description",
                width = "full",
                order = 13
            },
            spacer12 = {
                name = " ",
                type = "description",
                width = 0.6,
                order = 14
            },
            subtext = {
                name =
                "If you have any questions, suggestions, or issues, please visit the GitHub page or join the Discord Server.",
                type = "description",
                fontSize = "medium",
                width = 4,
                order = 15
            },
            spacer13 = {
                name = " ",
                type = "description",
                width = "full",
                order = 16
            },
            spacer14 = {
                name = " ",
                type = "description",
                width = "full",
                order = 17
            },
            spacer15 = {
                name = " ",
                type = "description",
                width = 1,
                order = 18
            },
            twitch = {
                name = "Twitch",
                type = "execute",
                func = function()
                    mUI:Link("https://twitch.tv/muleyo")
                end,
                width = 1,
                order = 19
            },
            discord = {
                name = "Discord",
                type = "execute",
                func = function()
                    mUI:Link("https://discord.gg/gE5g43mZqy")
                end,
                width = 1,
                order = 20
            },
            github = {
                name = "GitHub",
                type = "execute",
                func = function()
                    mUI:Link("https://github.com/muleyo/muleyoUI")
                end,
                width = 1,
                order = 21
            }
        }
    }

    function About:GetOptions()
        return About.layout
    end
end
