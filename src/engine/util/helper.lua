-- helpers for lua coding

function stringify(...)
    local s = ""
    for k, v in ipairs({...}) do
        s = s .. tostring(v) .. "\t"
    end
    return s
end

if SDL and SDL.log then
    print = function(...)
        SDL.log(stringify(...))
    end
end

function wait(time, callback)
    tween(time, {}, {}, nil, callback)
end

function table.merge(...)
    local result = {}
    for i,t in pairs({...}) do
        for k, v in pairs(t) do
            result[k] = v
        end
    end
    return result
end

function pack(...)
    return {...}
end

function randf(from, to)
    if from then
        if to then
            return from + math.random() * (to - from)
        else
            return from * math.random()
        end
    else
        return randf(0, 1)
    end
end

function table.shuffle(array)
    local arrayCount = #array
    for i = arrayCount, 2, -1 do
        local j = math.random(1, i)
        array[i], array[j] = array[j], array[i]
    end
    return array
end

function table.removeValue(table, value)
    for k,v in pairs(table) do
        if v == value then
            table[k] = nil
        end
    end
end

function table.size(table)
    local i = 0
    for _, _ in pairs(table) do
        i = i + 1
    end
end

function math.floorTo(k, t)
    return math.floor(k / t) * t
end

function math.roundTo(k, t)
    return math.round(k / t) * t
end

function math.round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function getTouches()
    local function _getTouches()
        local touches = {}
        for i=1,love.touch.getTouchCount() do
            local id, x, y, p = love.touch.getTouch(i)
            local touch = {}
            touch.id = id
            touch.x = x * love.graphics.getWidth()
            touch.y = y * love.graphics.getHeight()
            touch.p = p
            table.insert(touches, touch)
        end
        return touches
    end

    local e, r = pcall(_getTouches)
    return e and r or {}
end

function math.clamp(value, a, b)
    if b < a then a, b = b, a end
    return math.min(b, math.max(a, value))
end

function math.mix(from, to, ratio)
    return from * (1 - ratio) + to * ratio
end

function recursive_set(obj, key, value)
    first = key:match("([^%.]+)%.([^%.]+)") or key
    if first == key then
        obj[key] = value
    else
        local new_key = key:sub(string.len(first) + 2)
        recursive_set(obj[first], new_key, value)
    end
end

function recursive_get(obj, key)
    first = key:match("([^%.]+)%..*") or key
    if first == key then
        return obj[key]
    else
        local new_key = key:sub(string.len(first) + 2)
        return recursive_get(obj[first], new_key)
    end
end

function table.indexOf(t, object)
    local result = nil
    if "table" == type( t ) then
        for i=1,#t do
            if object == t[i] then
                result = i
                break
            end
        end
    end
    return result
end

function love.graphics.printBorder(text, c1, c2, x, y, ...)
    c1:set()
    love.graphics.print(text, x+1, y, ...)
    love.graphics.print(text, x-1, y, ...)
    love.graphics.print(text, x, y+1, ...)
    love.graphics.print(text, x, y-1, ...)
    c2:set()
    love.graphics.print(text, x, y, ...)
end

BLEND_MODES = {
    {"additive", "Add"},
    {"alpha", "Alpha blend"}, 
    {"subtractive", "Subtract"},
    {"multiplicative", "Multiply"}, 
    {"premultiplied", "Premultiplied"}, 
    {"replace", "Replace"}
}

ALIGNS_HORIZONTAL = {
    {"left", "Left"},
    {"center", "Center"},
    {"right", "Right"},
}

ALIGNS_VERTICAL = {
    {"top", "Top"},
    {"center", "Middle"},
    {"bottom", "Bottom"},
}
