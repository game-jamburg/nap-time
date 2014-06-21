Animation = class("Animation", Drawable)

function Animation:initialize(name)
    Drawable.initialize(self, name)
end

function Animation:create(image, fw, fh, delay, frames)
    self.animation = newAnimation(image, fw, fh, delay, frames)
end

function Animation:onUpdate(dt)
    Drawable.onUpdate(self, dt)
    self.animation:update(dt)
end

function Animation:onDraw()
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0) - offset
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local height = self.animation.fh
    local width = self.animation.fw
    self.animation:draw(position.x, position.y, rotation, 1, 1, width/2, height/2)
end
