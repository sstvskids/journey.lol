--[[
    to get the latest updates: always come here
]]

-- example of a config
shared.Settings = {
    DoubleXP = {
        Enabled = true,
        Config = {},
        Func = ''
    },
    Aura = {
        Enabled = true,
        Config = {
            Range = 15,
            TPPlr = false
        },
        Func = ''
    }
}

return loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/refs/heads/main/loader.lua'))()