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
        flag = 'aura',

        section = 'left',
        enabled = false,

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
                if interface.connections.Aura then
                    interface.connections.Aura:Disconnect()
                end
            end
        end
    })
    tabs.Combat.create_slider({
        name = 'Range',
        flag = 'aurarange',

        section = 'left',

        value = 15,
        minimum_value = 1,
        maximum_value = 20,

        callback = function(value)
            Range = value
        end
    })
    tabs.Combat.create_toggle({
        name = 'TPAura',
        flag = 'tpaura',

        section = 'left',
        enabled = false,
        callback = function(callback)
            TPAura = callback
        end
    })
end)

local speed
local speedcall
run(function()
    tabs.Blatant.create_title({
        name = 'Speed',
        section = 'left'
    })

    tabs.Blatant.create_toggle({
        name = 'Speed',
        flag = 'speed',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.Speed = runService.PreSimulation:Connect(function()
                    if isAlive(lplr) then
                        lplr.Character.Humanoid.WalkSpeed = speed
                    end
                end)
            else
                if interface.connections.Speed then
                    interface.connections.Speed:Disconnect()
                end
                lplr.Character.Humanoid.WalkSpeed = 16
            end
        end
    })
    tabs.Blatant.create_slider({
        name = 'Speed',
        flag = 'speedslider',

        section = 'left',

        value = 35,
        minimum_value = 16,
        maximum_value = 100,

        callback = function(value)
            speedcall = value
        end
    })
end)

run(function()
    tabs.Settings.create_title({
        name = 'FPS',
        section = 'left'
    })

    local fps
    local fpscall
    local old = 60
    tabs.Settings.create_toggle({
        name = 'NoFPSLimit',
        flag = 'nofpslimit',

        section = 'left',
        enabled = false,

        callback = function(callback)
            fpscall = callback
            if callback then
                old = getfpscap and getfpscap() or 60
                setfpscap(fps)
            else
                setfpscap(old)
            end
        end
    })
    tabs.Settings.create_slider({
        name = 'FPS',
        flag = 'fpsslider',

        section = 'left',

        value = 999,
        minimum_value = 60,
        maximum_value = 999,

        callback = function(value)
            fps = value
            if fpscall then
                setfpscap(value)
            end
        end
    })
end)

run(function()
    tabs.Settings.create_title({
        name = 'Uninject',
        section = 'right'
    })

    tabs.Settings.create_toggle({
        name = 'Uninject',
        flag = 'uninject',

        section = 'right',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.Flags['uninject'] = false
				interface.save_flags()
                task.wait(0.5)
                Notifications.NewNotification(lplr, 'uninjected', 2, Color3.fromRGB(255,255,255), 'Yay!')
                interface:uninject()
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