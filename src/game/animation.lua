Animation = class("Animation", Component)

function Animation:initialize(name)
    Component.initialize(self, name)
    self.order = 1
    self:addProperty(Property.Integer:new(self, "order"))
end

function Animation:create(image, fw, fh, delay, frames)
    self.animation = newAnimation(image, fw, fh, delay, frames)
end

function Animation:onUpdate(dt)
    engine.renderer:queue(self, self.order)
    self.animation:update(dt)
end

function Animation:onDraw()
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0) - offset
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local height = self.animation.fh
    local width = self.animation.fw
    self.animation:draw(position.x+width/2,position.y+height,rotation)
end
