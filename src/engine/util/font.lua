FontFace = class("FontFace")

function FontFace:initialize(source, defaultSize)
    self.source = source
    self.defaultSize = defaultSize or 16
    self._fonts = {}
end

function FontFace:getFont(size)
    size = size or self.defaultSize
    if not self._fonts[size] then
        if self.source then
            self._fonts[size] = love.graphics.newFont(self.source, size)
        else
            self._fonts[size] = love.graphics.newFont(size)
        end
    end
    return self._fonts[size]
end

function FontFace:set(size)
    love.graphics.setFont(self:getFont(size))
end

function FontFace:getDimensions(size, text)
    local font = self:getFont(size)
    return Vector:new(font:getWidth(text), font:getHeight())
end

FontFace.static.Default = FontFace:new()
