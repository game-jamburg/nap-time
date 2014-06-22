Animation = class("Animation", Sprite)

function Animation:initialize(name, animation)
    Sprite.initialize(self, name, image)

    self.animation = animation
    self.speed = 1

    self:addProperty(Property.String:new(self, "animation"))
    self:addProperty(Property.Number:new(self, "speed"))

    self._anim = nil
end

function Animation:onUpdate(dt)
    Drawable.onUpdate(self, dt)

    if self._anim then
        self._anim:update(dt * self.speed)
    end
end

function Animation:onDraw()
    if not self._anim or (self._anim.name ~= self.animation) then
        local args = engine.resources.animation[self.animation]
        local img = engine.resources.image[args.image]
        if not img then return end
        self._anim = newAnimation(img, args.frameWidth, args.frameHeight, args.delay, args.frames)
        if args.mode then self._anim:setMode(args.mode) end
        self._anim.name = self.animation
    end

    local origin   = self.origin:permul(Vector:new(self._anim.fw, self._anim.fh))
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0)
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local scale    = self.entity and self.entity.transform.global.scale or Vector:new(1, 1)
    scale = scale * self.scaleFactor

    Drawable.onDraw(self)

    self.color:set()
    self._anim:draw(position.x, position.y, rotation, scale.x, scale.y, origin.x, origin.y)
end
