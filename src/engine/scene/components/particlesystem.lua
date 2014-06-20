ParticleSystem = class("ParticleSystem", Drawable)

function ParticleSystem:initialize(name, image, order)
    Drawable.initialize(self, name)

    self.image = image or nil
    self.order = order or 0
    self.blendMode = "additive"

    self.bufferSize         = 1000
    self.colors             = {Color:new(1, 0.5, 0.1), Color:new(1, 0.5, 0.1, 0)}
    self.emissionRate       = 100
    self.linearAcceleration = Vector:new(0, 0)
    self.offset             = Vector:new(0.5, 0.5)
    self.particleLifetime   = {min=1, max=1}
    self.emitterLifetime    = -1
    self.areaSpread         = Vector:new(0, 0)
    self.areaSpreadDistribution = "normal"
    self.insertMode         = "top"
    self.radialAcceleration = {min=0, max=0}
    self.tangentialAcceleration = {min=0, max=0}
    self.sizeVariation      = 0
    self.sizes              = {1}
    self.speed              = {min=0, max=100}
    self.spin               = {min=0, max=0}
    self.spinVariation      = 0
    self.spread             = math.pi * 2

    self:addProperty(Property.String:new(self, "image"))
    self:addProperty(Property.Integer:new(self, "bufferSize"))
    -- self:addProperty(Property.Array:new(self, "colors", Property.Color:new(nil, nil))
    self:addProperty(Property.Number:new(self, "emissionRate"))
    self:addProperty(Property.Vector:new(self, "linearAcceleration"))
    self:addProperty(Property.Vector:new(self, "offset"))
    self:addProperty(Property.Range:new(self, "particleLifetime", Property.Number:new(nil, nil, -1, nil, 1)))
    self:addProperty(Property.Number:new(self, "emitterLifetime", -1, nil, 1))
    self:addProperty(Property.Vector:new(self, "areaSpread"))
    self:addProperty(Property.Enum:new(self, "areaSpreadDistribution", {{"normal", "Normal"}, {"uniform", "Uniform (Gaussian)"}, {"none", "None"}}))
    self:addProperty(Property.Enum:new(self, "insertMode", {{"top", "Top"}, {"bottom", "Bottom"}, {"random", "Random"}}))
    self:addProperty(Property.Range:new(self, "radialAcceleration", Property.Number:new(nil, nil, nil, nil, 1)))
    self:addProperty(Property.Range:new(self, "tangentialAcceleration", Property.Number:new(nil, nil, nil, nil, 1)))
    self:addProperty(Property.Number:new(self, "sizeVariation", 0, 1, 2))
    -- self:addProperty(Property.Array:new(self, "sizes", Property.Number:new(0, nil, 2))
    self:addProperty(Property.Range:new(self, "speed", Property.Number:new(nil, nil, nil, nil, 1)))
    self:addProperty(Property.Range:new(self, "spin", Property.Number:new(nil, nil, nil, nil, 1)))
    self:addProperty(Property.Number:new(self, "spinVariation", 0, 1, 2))
    self:addProperty(Property.Number:new(self, "spread", 0, 2*math.pi, 2))

    if self.image then 
        self:_createParticleSystem()
    end
end

function ParticleSystem:_createParticleSystem()
    local img = engine.resources.image[self.image]
    if img then
        self.particles = love.graphics.newParticleSystem(img, self.bufferSize)
    end
    return img ~= nil
end

function ParticleSystem:onUpdate(dt)
    if not self.particles then
        if not self:_createParticleSystem() then
            return
        end
    end

    local image = engine.resources.image[self.image] 

    -- push draw call
    Drawable.onUpdate(self, dt)

    -- update particle system
    if self.particles:getBufferSize() ~= self.bufferSize and (self.bufferSize >= 1) then
        self.particles:setBufferSize(self.bufferSize)
    end

    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0)
    self.particles:setPosition(position.x, position.y)

    local rotation = self.entity and self.entity.transform.global.rotation or 0
    self.particles:setDirection(rotation)

    self.particles:setEmissionRate(self.emissionRate)
    self.particles:setSizes(unpack(self.sizes))
    self.particles:setSpeed(self.speed.min, self.speed.max)
    self.particles:setLinearAcceleration(self.linearAcceleration.x, self.linearAcceleration.y)
    self.particles:setOffset(self.offset.x * image:getWidth(), self.offset.y * image:getHeight())
    self.particles:setParticleLifetime(self.particleLifetime.min, self.particleLifetime.max)
    self.particles:setImage(image)
    self.particles:setEmitterLifetime(self.emitterLifetime)
    self.particles:setAreaSpread(self.areaSpreadDistribution, self.areaSpread.x, self.areaSpread.y)
    self.particles:setInsertMode(self.insertMode)
    self.particles:setRadialAcceleration(self.radialAcceleration.min, self.radialAcceleration.max)
    self.particles:setSizeVariation(self.sizeVariation)
    self.particles:setSpin(self.spin.min, self.spin.max)
    self.particles:setSpinVariation(self.spinVariation)
    self.particles:setSpread(self.spread)
    self.particles:setTangentialAcceleration(self.tangentialAcceleration.min, self.tangentialAcceleration.max)

    -- colors
    local c = {}
    for k, v in pairs(self.colors) do
        local r, g, b, a = v:unpack(255)
        table.insert(c, r)
        table.insert(c, g)
        table.insert(c, b)
        table.insert(c, a)
    end
    self.particles:setColors(unpack(c))

    self.particles:update(dt)
end

function ParticleSystem:onDraw()
    Drawable.onDraw(self)
    love.graphics.draw(self.particles, 0, 0)
end

function ParticleSystem:restore(data)
    Drawable.restore(self, data)
    self:spawnParticles()
end

function ParticleSystem:spawnParticles()
    if self.particles then
        local duration = self.particleLifetime.max
        local dt = 0.01
        for t=0,duration,dt do
            self.particles:update(dt)
        end
    end
end