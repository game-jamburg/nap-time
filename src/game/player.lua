Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 600
    Component.initialize(self, name)

    self.upperSlash = Animation:new("animation", "ninja-slash-upper", 340, 229, 0.033, 13, "once")
    self.upperSlash.origin = Vector:new(0.48, 0.84)
    self.upperSlash.order = 2
end

function Player:onAdd(entity)
    self.lowerWalk = Animation:new("animation", "ninja-walk-lower", 104, 128, 0.033, 21)
    self.lowerWalk.origin = Vector:new(0.6, 0.7)
    self.lowerWalk.order = 1
    entity.children.lower:addComponent(self.lowerWalk)

    self.upperWalk = Animation:new("animation", "ninja-walk-upper", 126, 181, 0.033, 21)
    self.upperWalk.origin = Vector:new(0.6, 0.7)
    self.upperWalk.order = 2
    entity.children.upper:addComponent(self.upperWalk)

    self.movement = Vector:new()
end
 
function Player:onFixedUpdate(dt)
    local input = Vector:new()
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then input.x = -1 end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then input.x =  1 end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then input.y =  1 end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then input.y = -1 end
    input:normalize()

    local ms = 20
    self.movement = self.movement * (1 - dt * ms) + input * dt * ms
    
    local standing = self.movement:len() < 0.1

    if standing then
        self.entity.children.lower.components.animation.speed = 0
        if self.entity.children.upper.components.animation == self.upperWalk then
            self.entity.children.upper.components.animation.speed = 0.6
        end
    else 
        self.entity.children.lower.components.animation.speed = 1
        self.entity.children.upper.components.animation.speed = 1
    end

    -- update position
    self.entity.transform.position = self.entity.transform.position + self.movement * self.speed * dt

    -- lower body rotates with movement direction
    if not standing then
        self.entity.children.lower.transform.rotation = self.movement:angle()
    end

    -- upper body rotates to target
    if self.target then
        local lookDirection = self.target.position - self.entity.transform.position
        self.entity.children.upper.transform.rotation = lookDirection:angle()
    end

    -- tell the physics we changed stuff :)
    self.entity.components.physics:pull()
end

function Player:onEvent(type, data)
  if type == "mousereleased" and data.button == "l" then
    self.entity.children.upper:addComponent(self.upperSlash)
    self.entity:addComponent(Timer:new("slashEndedTimer", 0.033 * 13, self.slashEnded, {self}))
  end
end

function Player:slashEnded()
    self.upperSlash.animation:reset()
    self.entity.children.upper:addComponent(self.upperWalk)
end
