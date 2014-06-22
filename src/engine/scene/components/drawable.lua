Drawable = class("Drawable", Component)

function Drawable:initialize(name, renderer)
    Component.initialize(self, name)
    self.blendMode = "alpha"
    self.order = 0
    self:addProperty(Property.Enum:new(self, "blendMode", BLEND_MODES))
    self:addProperty(Property.Integer:new(self, "order"))
    self.renderer = renderer or engine.renderer
end

function Drawable:onUpdate(dt)
    self.renderer:queue(self, self.order)
end

function Drawable:onDraw()
    love.graphics.setBlendMode(self.blendMode)
end
