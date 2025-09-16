local instproxy, proxyinst = setmetatable({}, {__mode = 'k'}), setmetatable({}, {__mode = 'k'})

local function cloneref(inst)
    if typeof(inst) ~= 'Instance' then
        error('Expected instance, got: '..typeof(inst))
    end

    if instproxy[inst] then
        return instproxy[inst]
    end

    local ud = newproxy(true)
    local mt = getmetatable(ud)

    proxyinst[ud] = inst
    instproxy[inst] = ud

    mt.__index = function(_, k)
        local val = inst[k]
        if type(val) == 'function' then
            return function(_, ...)
                return val(inst, ...)
            end
        end
        return val
    end

    mt.__newindex = function(_, k, v)
        inst[k] = v
    end

    mt.__tostring = function()
        return tostring(inst)
    end

    mt.__eq = function(a, b)
        return (proxyinst[a] or a) == (proxyinst[b] or b)
    end

    mt.__metatable = 'The metatable is locked'

    if pcall(function() return typeof(inst.Invoke) == 'function' end) then
        meta.__call = function(_, ...)
            return inst(...)
        end
    end

    return ud
end