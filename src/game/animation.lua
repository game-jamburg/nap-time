Animation = class("Animation", Sprite)

function Animation:initialize(name, animation)
    Sprite.initialize(self, name, image)
    self.animation = animation
    self.mode = mode or "loop"
    self.speed = 1

    self:addProperty(Property.String:new(self, "animation"))
    self:addProperty(Property.Number:new(self, "speed"))
    self:addProperty(Property.String:new(self, "mode"))

    self.anim = nil
end

function Animation:onUpdate(dt)
    Drawable.onUpdate(self, dt)

    if self.anim then
        self.anim:update(dt * self.speed)
    end
end

function Animation:onDraw()
    if not self.anim or (self.anim.name ~= self.animation) then
        local args = engine.resources.animation[self.animation]
        local img = engine.resources.image[args.image]
        self.anim = newAnimation(img, args.frameWidth, args.frameHeight, args.delay, args.frames)
        if args.mode then self.anim:setMode(args.mode) end
        self.anim.name = self.animation
    end

    local origin   = self.origin:permul(Vector:new(self.anim.fw, self.anim.fh))
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0)
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local scale    = self.entity and self.entity.transform.global.scale or Vector:new(1, 1)
    scale = scale * self.scaleFactor

    Drawable.onDraw(self)

    self.color:set()
    self.anim:draw(position.x, position.y, rotation, scale.x, scale.y, origin.x, origin.y)
end
