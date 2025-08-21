--[[

    journey.lol
    by @stav

    w-w-wait? a gui-less script!?!
]]

repeat task.wait() until game:isLoaded()

if not shared.Config then return end
if shared.uninject then
    shared.uninject()
end

for _, v in {'journey.lol'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

return ''