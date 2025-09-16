--[[

    journey.lol
    by @stav

    Atonium, but undetected ahh script
]]

repeat task.wait() until game:isLoaded()

local cloneref = cloneref or function(obj)
    return obj
end

local httpService = cloneref(game:GetService('HttpService'))

for _, v in {'journey.lol'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

local games = {
    [17813692689] = 'games/17813692689.lua'
}

for i,v in games do
    if i == game.PlaceId then
        return loadstring(getURL(v))()
    end
end

return loadstring(getURL('games/universal.lua'))()