Animation = class("Animation", Sprite)

function Animation:initialize(name, image, frameWidth, frameHeight, delay, frames, mode)
    Sprite.initialize(self, name, image)
    self.animation = nil
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.delay = delay
    self.frames = frames

    self.speed = 1
    self:addProperty(Property.Number:new(self, "speed"))

    local img = engine.resources.image[self.image]
    self.animation = newAnimation(img, self.frameWidth, self.frameHeight, self.delay, self.frames)

    if mode then
        self.animation:setMode(mode)
    end
end

function Animation:onUpdate(dt)
    Drawable.onUpdate(self, dt)
    self.animation:update(dt * self.speed)
end

function Animation:onDraw()
    local img = engine.resources.image[self.image]
    if not img then return end

    local origin   = self.origin:permul(Vector:new(self.frameWidth, self.frameHeight))
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0)
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local scale    = self.entity and self.entity.transform.global.scale or Vector:new(1, 1)
    scale = scale * self.scaleFactor

    Drawable.onDraw(self)

    self.color:set()
    self.animation:draw(position.x, position.y, rotation, scale.x, scale.y, origin.x, origin.y)
end
