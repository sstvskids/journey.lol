--[[
    to get the latest updates: always come here
]]

repeat task.wait() until game:isLoaded()

if shared.uninject then
    warn('reinject ur script pls')
    return shared.uninject()
end

local cloneref = cloneref or function(obj)
    return obj
end
local httpService = cloneref(game:GetService('HttpService'))

shared.Settings = isfile('journey.lol/cfg.lua') and loadstring(httpService:JSONDecode(readfile('journey.lol/cfg.lua')))() or {
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

for _, v in {'journey.lol'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

return loadstring(getURL('main.lua'))()