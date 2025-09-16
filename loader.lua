local cloneref = cloneref or function(obj)
    return obj
end

local httpService = cloneref(game:GetService('HttpService'))

local function getURL(url)
    return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

loadstring(getURL('main.lua'))()