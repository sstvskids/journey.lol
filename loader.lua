--[[
    to get the latest updates: always come here
]]

repeat task.wait() until game:isLoaded()

local cloneref = cloneref or function(obj)
    return obj
end

local userInputService = cloneref(game:GetService('UserInputService'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

if userInputService.TouchEnabled then
    return warn('Not supported on mobile; computer only')
end

if not shared.Settings then
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
end

if shared.uninject then
    setclipboard('https://github.com/sstvskids/journey.lol')
    return shared.Notifications.NewNotification(lplr, 'Documentation on how to config has been copied to your clipboard', 4, Color3.fromRGB(255,255,255), 'Yay!')
end

for _, v in {'journey.lol'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

return loadstring(getURL('main.lua'))()