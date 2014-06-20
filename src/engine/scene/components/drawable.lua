Drawable = class("Drawable", Component)

function Drawable:initialize(name)
    Component.initialize(self, name)
    self.blendMode = "alpha"
    self.order = 0
    self:addProperty(Property.Enum:new(self, "blendMode", BLEND_MODES))
    self:addProperty(Property.Integer:new(self, "order"))
end

function Drawable:onUpdate(dt)
    engine.renderer:queue(self, self.order)
end

function Drawable:onDraw()
    love.graphics.setBlendMode(self.blendMode)
end
