Resources = class("Resources")

function Resources:initialize()
    self.image = {}
    self.font = {}
    self.sound = {}
end

function Resources:load(type, name, path)
    local res = nil

    Log:debug("Loading " .. type .. " [" .. path .. "] as [" .. name .. "].")

    if type == Resources.Image then
        res = love.graphics.newImage(path)
    elseif type == Resources.Font then
        res = Font:new(path)
    elseif type == Resources.Sound then
        res = love.sound.newSoundData(path)
    else
        print("Unknown resource type '" .. type .. "' for resource '" .. name .. "' at '" .. path .. "'.")
        return nil
    end

    self[type][name] = res
    return res
end

function Resources:loadList(list)
    -- load stuff from a file list
end

Resources.static.Image = "image"
Resources.static.Font = "font"
Resources.static.Sound = "sound"

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
