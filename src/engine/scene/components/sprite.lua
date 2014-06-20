Sprite = class("Sprite", Drawable)

function Sprite:initialize(name, image, order, origin)
    Drawable.initialize(self, name)
    self.image  = image  or nil
    self.order  = order  or 0
    self.origin = origin or Vector(0.5, 0.5)
    self.scaleFactor = 1
    self.color = Color.White

    self:addProperty(Property.Vector:new(self, "origin"))
    self:addProperty(Property.String:new(self, "image"))
    self:addProperty(Property.Number:new(self, "scaleFactor", 0, nil, 2))
    self:addProperty(Property.Color:new(self, "color"))
end

function Sprite:onDraw()
    local img = engine.resources.image[self.image]

    if not img then return end

    local origin   = self.origin:permul(Vector:new(img:getDimensions()))
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0)
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local scale    = self.entity and self.entity.transform.global.scale or Vector:new(1, 1)
    scale = scale * self.scaleFactor

    Drawable.onDraw(self)

    self.color:set()
    love.graphics.draw(img, position.x, position.y, rotation, scale.x, scale.y, origin.x, origin.y)
end
