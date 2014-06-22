Animation = class("Animation", Sprite)

function Animation:initialize(name, animation, speed, mode)
    Sprite.initialize(self, name, image)
    self:set(animation, speed, mode)

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

function Animation:set(animation, speed, mode)
    self.animation = animation
    self.speed = speed or 1
    self.mode = mode or "loop"
end

function Animation:onDraw()
    if not self.anim or (self.anim.name ~= self.animation) then
        local data = engine.resources.animation[self.animation]
        if not data then return end -- not found
        local args = data.args
        local img = engine.resources.image[data.image]
        self.anim = newAnimation(img, data.frameWidth, data.frameHeight, data.delay, data.frames)
        self.anim.name = self.animation

        if args.mode then 
            self.anim:setMode(args.mode) 
        end

        if args.origin then 
            self.origin = args.origin
        end

        if args.start then 
            self.anim:seek(args.start)
        end

        self.scaleFactor = args.scaleFactor or 1
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
