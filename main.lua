--[[

    journey.lol
    by @stav

    w-w-wait? a gui-less script!?!
]]

local cloneref = cloneref or function(obj)
    return obj
end

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..scripturl, true)
end

local Notifications = loadstring(getURL('notif.lua'))()
local savetog, lastsave = true, os.clock()

if not shared.connections or not type(shared.connections) == 'table' then
    shared.connections = {}
end

local function save()
    if savetog == true and os.clock() - lastsave >= 5 then
        lastsave = os.clock()
        writefile('journey.lol/config.lua', shared.Config)
    end
end

local function isAlive(v)
    return (v.Character and v.Character.Humanoid and v.Character.PrimaryPart and v.Character.Humanoid.Health > 0) and true or false
end

local function getPart(v)
    if isAlive(v) then
        return v.Character.PrimaryPart
    end
end


-- Core Functions
shared.disconnect = function()
    for i,v in shared.connections do
        if v and type(v) == 'RBXScriptConnection' then
            v:Disconnect()
            v = nil
        end
    end
end

shared.uninject = function()
    task.spawn(function()
        save()
        savetog = false
    end)

    for i,v in shared.Settings do
        v.Enabled = false
    end

    shared.Settings = nil
    shared.disconnect()

    shared.disconnect = nil
    Notifications.NewNotification(lplr, 'Uninjected :(', 4, Color3.fromRGB(255,255,255), 'Yay!')
end

-- Features
shared.Settings.Aura.Func = function(callback)
    if callback then
        shared.connections.Aura = runService.PreSimulation:Connect(function()
            task.spawn(function()
                for _, v in playersService:GetPlayers() do
                    if v ~= lplr and isAlive(v) and (getPart(lplr).Position - getPart(v).Position).Magnitude <= shared.Settings.Aura.Config.Range then
                        if shared.Settings.Aura.Config.TPPlr == true then
                            getPart(lplr).CFrame = getPart(v).CFrame + Vector3.new(0, 1, 0)
                        end

                        workspace.CombatSystemFolder.PannelFolder.Remotes.PunchRemote:FireServer('LeftPunch', {}, 0)
                        workspace.CombatSystemFolder.PannelFolder.Remotes.PunchRemote:FireServer('RightPunch', {}, 0)
                    end
                end
            end)
        end)
    else
        if shared.connections.Aura then
            shared.connections.Aura:Disconnect()
        end
    end
end

-- Init :)
for i,v in shared.Settings do
    if type(v.Func) == 'string' then continue end
    
    v.Func(v.Enabled)
end

shared.connections.cfgs = runService.PreSimulation:Connect(save)
return Notifications.NewNotification(lplr, 'Script fully loaded :)', 4, Color3.fromRGB(255,255,255), 'Yay!')