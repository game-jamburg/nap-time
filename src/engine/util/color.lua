Color = class("Color")

function Color:initialize(r, g, b, a)
    r = r or 1
    g = g or 1
    b = b or 1
    a = a or 1

    if r > 1 or g > 1 or b > 1 or a > 1 then
        print("Warning: color values are in range 0..1, not (" .. r .. ", " .. g .. ", " .. b .. ", " .. a .. "). Clamping.")
    end

    self.r = math.clamp(r, 0, 1)
    self.g = math.clamp(g, 0, 1)
    self.b = math.clamp(b, 0, 1)
    self.a = math.clamp(a, 0, 1)
end

function Color:unpack(factor)
    local f = factor or 1
    return self.r * f, self.g * f, self.b * f, self.a * f
end

function Color:clone()
    return Color:new(self.r, self.g, self.b, self.a)
end

function Color:set()
    love.graphics.setColor(self:unpack(255))
end

-- Converts HSL to RGB (input range: 0..1)
function Color.static.fromHSL(h, s, l)
    local r, g, b = nil, nil, nil
    h = h % 1
 
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
 
    return Color:new(r, g, b)
end

function Color:serialize()
     return string.format("Color:new(%g, %g, %g, %g)", self.r, self.g, self.b, self.a)
end

Color.static.Red            = Color:new(1, 0, 0)
Color.static.Green          = Color:new(0, 1, 0)
Color.static.Blue           = Color:new(0, 0, 1)
Color.static.Yellow         = Color:new(1, 1, 0)
Color.static.Magenta        = Color:new(1, 0, 1)
Color.static.Cyan           = Color:new(0, 1, 1)
Color.static.White          = Color:new(1, 1, 1)
Color.static.Black          = Color:new(0, 0, 0)
Color.static.Transparent    = Color:new(1, 1, 1, 0)
