--[[

    journey.lol
    by @stav

    Atonium, but undetected ahh script
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

local function isAlive(v)
    if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character:FindFirstChild('HumanoidRootPart') and v.Character.Humanoid.Health > 0 then
        return true
    end

    return false
end

local function getPart(v)
    if isAlive(v) then
        return v.Character.PrimaryPart
    end
end

local main = interface.new()
local tabs = {
    Combat = main.create_tab('Combat'),
    Blatant = main.create_tab('Blatant'),
    Render = main.create_tab('Render'),
    Settings = main.create_tab('Settings')
}

local speed = 16
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
            speedcall = callback
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
            speed = value
        end
    })
end)

run(function()
    tabs.Settings.create_title({
        name = 'FPS',
        section = 'left'
    })

    local fps = 60
    local fpscall
    tabs.Settings.create_toggle({
        name = 'NoFPSLimit',
        flag = 'nofpslimit',

        section = 'left',
        enabled = false,

        callback = function(callback)
            fpscall = callback
            if callback then
                setfpscap(fps)
            else
                setfpscap(60)
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