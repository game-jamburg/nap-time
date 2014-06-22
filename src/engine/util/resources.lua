Resources = class("Resources")

function Resources:initialize()
    self.image = {}
    self.animation = {}
    self.font = {}
    self.sound = {}
    self.text = {}
end

function Resources:load(type, name, path, ...)
    local res = nil

    Log:debug("Loading " .. type .. " [" .. path .. "] as [" .. name .. "].")

    if type == Resources.Image then
        res = love.graphics.newImage(path)
    elseif type == Resources.Font then
        res = Font:new(path)
    elseif type == Resources.Sound then
        res = love.sound.newSoundData(path)
    elseif type == Resources.Text then
        res = love.filesystem.read(path)
    elseif type == Resources.Animation then
        local args = {...}
        res = {image=path, frameWidth=args[1], frameHeight=args[2], delay=args[3], frames=args[4], args=args[5] or {}}
    else
        print("Unknown resource type '" .. type .. "' for resource '" .. name .. "' at '" .. path .. "'.")
        return nil
    end

    self[type][name] = res
    return res
end

Resources.static.Image = "image"
Resources.static.Font = "font"
Resources.static.Sound = "sound"
Resources.static.Text = "text"
Resources.static.Animation = "animation"

-- function Resources:makeSound(name)
--     return love.audio.newSource(self.sounds[name])
-- end

-- function Resources:makeGradientImage(name, from, to, horizontal)
--     local data = love.image.newImageData(2, 2)
--     data:setPixel(0, 0, from[1], from[2], from[3], from[4] or 255)
--     data:setPixel(horizontal and 0 or 1, horizontal and 1 or 0, from[1], from[2], from[3], from[4] or 255)
--     data:setPixel(horizontal and 1 or 0, horizontal and 0 or 1, to[1], to[2], to[3], to[4] or 255)
--     data:setPixel(1, 1, to[1], to[2], to[3], to[4] or 255)
--     self.images[name] = love.graphics.newImage(data)
-- end
