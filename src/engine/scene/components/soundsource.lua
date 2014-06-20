SoundSource = class("SoundSource", Component)

function SoundSource:initialize(name, sound, loop)
    Component.initialize(self, name)

    self.sound = sound
    self.loop = loop or false
    self.playing = false
    self.pitch = 1
    self.volume = 1
    self.positionMode = "none"

    self:addProperty(Property.String:new(self, "sound"))
    self:addProperty(Property.Boolean:new(self, "loop"))
    self:addProperty(Property.Boolean:new(self, "playing"))
    self:addProperty(Property.Enum:new(self, "positionMode", {{"none", "No positioning"}, {"global", "Global transform"}, {"local", "Local transform"}}))
    self:addProperty(Property.Number:new(self, "pitch", 0.0001, nil, 5))
    self:addProperty(Property.Number:new(self, "volume", 0, 1, 2))

    self._wasPlaying = false
    self._wasSound = sound
    self:_updateSource()
end

function SoundSource:_updateSource()
    local snd = engine.resources.sound[self.sound]
    if snd then
        self._source = love.audio.newSource(snd)
    end
    return snd ~= nil
end

function SoundSource:play(rewind)
    if rewind then self._source:stop() end
    self._source:play()
    self.playing = true
    self._wasPlaying = true
end

function SoundSource:stop()
    self._source:stop()
    self.playing = false
    self._wasPlaying = false
end

function SoundSource:pause()
    self._source:pause()
    self.playing = false
    self._wasPlaying = false
end

function SoundSource:onUpdate(dt)
    if not self._source then
        if not self:_updateSource() then
            return
        end
    end

    if self._wasSound ~= self.sound then
        self:stop()
        self:_updateSource()
        if self.playing then 
            self.playing = false
            self:play() 
        end
    end

    if self.playing ~= self._wasPlaying then
        if self.playing then
            self:play()
        else
            self:stop()
        end
    end

    self._source:setLooping(self.loop)
    self._source:setPitch(self.pitch)
    self._source:setVolume(self.volume)

    if self.positionMode == "none" then
        self._source:setRelative(true)
        self._source:setPosition(0, 0, 0)
        self._source:setVelocity(0, 0, 0)
    else
        self._source:setRelative(false)
        local transform
        if self.positionMode == "local" then
            transform = self.entity.transform
        elseif self.positionMode == "global" then
            transform = self.entity.transform.global
        end
        self._source:setPosition(transform.position.x, transform.position.y, 0)
        self._source:setVelocity(transform.velocity.x, transform.velocity.y, 0)
    end

    self._wasSound = self.sound
    self._wasPlaying = self.playing
end
