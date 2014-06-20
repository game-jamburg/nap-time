function pack(...)
    return {...}
end

-- random floats
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

-- Converts HSL to RGB (input and output range: 0 - 255)
function hsl2rgb(h, s, l)
    local r, g, b = nil, nil, nil
 
    if s == 0 then
        r, g, b = l, l ,l -- achromatic
    else
        local hue2rgb = function(p, q, t)
            if t < 0 then 
                t = t + 1 
            end
            if t > 1 then
                t = t - 1
            end
            if t < 1/6 then
                return p + (q - p) * 6 * t
            end
            if t < 1/2 then 
                return q
            end
            if t < 2/3 then 
                return p + (q - p) * (2/3 - t) * 6
            end
            return p
        end
 
        local q = nil
        if l < 0.5 then
            q = l * (1 + s)
        else 
            q = l + s - l * s
        end
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end
 
    return r * 255, g * 255, b * 255
end

function table.removeValue(table, value)
    for k,v in pairs(table) do
        if v == value then
            table[k] = nil
        end
    end
end

function math.floorTo(k, t)
    return math.floor(k / t) * t
end

function math.round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- love.touch stuff
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

