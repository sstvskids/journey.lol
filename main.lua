--[[

    journey.lol
    by @stav

    w-w-wait? a gui-less script!?!
]]

local run = function(func)
    local suc, res = pcall(func)
    return suc == true and res or suc == false and ((writefile and writefile('journey.lol/consoleerr.txt', res)) or warn(res))
end
local cloneref = cloneref or function(obj)
    return obj
end

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local lplr = playersService.LocalPlayer

local function getURL(url)
	return game:HttpGet('https://raw.githubusercontent.com/sstvskids/journey.lol/'..httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/journey.lol/commits'))[1].sha..'/'..url, true)
end

local interface = loadstring(getURL('interface.lua'))()
local Notifications = loadstring(getURL('notif.lua'))()
shared.notifications = Notifications

local savetog, lastsave = true, os.clock()

if not shared.connections or not type(shared.connections) == 'table' then
    shared.connections = {}
end

local function isAlive(v)
    return (v.Character and v.Character.Humanoid and v.Character.PrimaryPart and v.Character.Humanoid.Health > 0) and true or false
end

local function getPart(v)
    if isAlive(v) then
        return v.Character.PrimaryPart
    end
end

local main = interface.new()
local tabs = {
    Combat = main.create_tab('Main'),
    Blatant = main.create_tab('Blatant'),
    Render = main.create_tab('Render'),
    Settings = main.create_tab('Settings')
}

run(function()
    tabs.Combat.create_title({
        name = 'Aura',
        section = 'left'
    })

    local TPAura
    local Range
    tabs.Combat.create_toggle({
        name = 'Aura',
        section = 'left',
        callback = function(callback)
            if callback then
                interface.connections.Aura = runService.PreSimulation:Connect(function()
                    task.spawn(function()
                        for _, v in playersService:GetPlayers() do
                            if v ~= lplr and isAlive(v) and (getPart(lplr).Position - getPart(v).Position).Magnitude <= 15 then
                                if TPAura then
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
    })
    tabs.Combat.create_slider({
        name = 'Range',
        section = 'left',
        callback = function(callback)
            Range = callback
        end
    })
    tabs.Combat.create_toggle({
        name = 'TPAura',
        section = 'left',
        callback = function(callback)
            TPAura = callback
        end
    })
end)

run(function()
    tabs.Settings.create_title({
        name = 'Uninject',
        section = 'left'
    })

    tabs.Settings.create_toggle({
        name = 'Uninject',
        section = 'left',
        callback = function(callback)
            if callback then
                Notifications.NewNotification(lplr, 'uninjected', 2, Color3.fromRGB(255,255,255), 'Yay!')
                interface:Uninject()
            end
        end
    })
end)

-- Features
--[[shared.Settings.Aura.Func = function(callback)
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
end]]

return Notifications.NewNotification(lplr, 'Script fully loaded :)', 4, Color3.fromRGB(255,255,255), 'Yay!')