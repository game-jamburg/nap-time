Rectangle = class("Rectangle", Drawable)

function Rectangle:initialize(name, size, color)
    Drawable.initialize(self, name)
    self.size  = size or Vector:new(100, 100)
    self.color = color or Color.White

    self:addProperty(Property.Vector:new(self, "size"))
    self:addProperty(Property.Color:new(self, "color"))
end

function Rectangle:onDraw()
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0)
    -- local rotation = self.entity and self.entity.transform.global.rotation or 0
    local scale    = self.entity and self.entity.transform.global.scale or Vector:new(1, 1)
    local size = self.size:permul(scale)

    Drawable.onDraw(self)

    self.color:set()
    love.graphics.rectangle("fill", position.x - size.x / 2, position.y - size.y / 2, size.x, size.y)
end
