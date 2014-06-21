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
end
 
function Player:onFixedUpdate(dt)
    local movement = Vector:new()
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then movement.x = -1 end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then movement.x =  1 end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then movement.y =  1 end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then movement.y = -1 end
    movement:normalize()
    
    if movement.x == 0 and movement.y == 0 then    
        self.entity.children.lower.components.animation.speed = 0
        if self.entity.children.upper.components.animation == self.upperWalk then
            self.entity.children.upper.components.animation.speed = 0.6
        end
    else 
        self.entity.children.lower.components.animation.speed = 1
        self.entity.children.upper.components.animation.speed = 1
    end

    -- update position
    self.entity.transform.position = self.entity.transform.position + movement * self.speed * dt

    -- lower body rotates with movement direction
    if movement.x ~= 0 or movement.y ~= 0 then
        self.entity.children.lower.transform.rotation = movement:angle()
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
  if type == "mousereleased" and data.button == "l" and self.entity.components.slashEndedTimer == nil then
    self.entity.children.upper:addComponent(self.upperSlash)
    self.entity:addComponent(Timer:new("slashEndedTimer", 0.033 * 13, self.slashEnded, {self}))

    local characters = {}
    for key, entity in pairs(engine:getCurrentState().scene.entities) do
        if entity:hasComponent(Character) and not entity:hasComponent(Player) then
            local pos = self.entity.components.transform.position

            local otherPos = entity.components.transform.position - pos
            local otherDeg = math.atan2(otherPos.x, otherPos.y) + math.pi

            local distance = math.sqrt((otherPos.x)^2+(otherPos.y)^2)

            local mousePos = self.entity.scene.view:toLocal(Mouse.Position) - pos
            local mouseDeg = math.atan2(mousePos.x, mousePos.y) + math.pi

            local degDiff = math.abs(mouseDeg - otherDeg)
            local actualDiff = math.min(degDiff, (2*math.pi)-degDiff)

            if distance <= 160 and actualDiff <= 1 then
                if distance <= 105 and actualDiff <= 0.65 then
                    -- CRITICAL HIT
                    entity.components.character:damage(100)
                else
                    entity.components.character:damage(50)
                end
            end
        end
    end
  end
end

function Player:slashEnded()
    self.upperSlash.animation:reset()
    self.entity.children.upper:addComponent(self.upperWalk)
end
