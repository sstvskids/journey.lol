--[[

    journey.lol
    by @stav

    w-w-wait? a gui-less script!?!
]]

repeat task.wait() until game:isLoaded()

for _, v in {'journey.lol'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

return loadstring(getURL('main.lua'))()