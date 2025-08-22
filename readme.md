# journey.lol
## undetected script

Script
```lua
local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

loadstring(getURL('loader.lua'))()
```

by @stav