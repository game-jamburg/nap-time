GUIDrawable = class("GUIDrawable", Component)

function GUIDrawable:initialize(name)
    Component.initialize(self, name)
    self.blendMode = "alpha"
    self.order = 0
    self:addProperty(Property.Enum:new(self, "blendMode", BLEND_MODES))
    self:addProperty(Property.Integer:new(self, "order"))
end

function GUIDrawable:onUpdate(dt)
    engine.guirenderer:queue(self, self.order)
end

function GUIDrawable:onDraw()
    love.graphics.setBlendMode(self.blendMode)
end