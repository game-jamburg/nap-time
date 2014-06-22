Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 600

    self.attacking = false

    Component.initialize(self, name)
end

function Player:onAdd(entity)
    self.lowerAnimation = Animation:new("animation", "ninja-walk-lower")
    self.lowerAnimation.origin = Vector:new(0.6, 0.7)
    self.lowerAnimation.order = 1
    entity.children.lower:addComponent(self.lowerAnimation)

    self.upperAnimation = Animation:new("animation", "ninja-walk-upper")
    self.upperAnimation.origin = Vector:new(0.6, 0.7)
    self.upperAnimation.order = 2
    entity.children.upper:addComponent(self.upperAnimation)

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
    if isClient and not standing then
        client:syncTopLevelEntity(self.entity)
    end
end

function Player:onEvent(type, data)
    if type == "mousereleased" and data.button == "l" and not self.attacking then
        self.attacking = true
        self.upperAnimation.animation = "ninja-slash-upper"
        self.upperAnimation.origin = Vector:new(0.48, 0.74)
        wait(0.033 * 13, function() self:attackEnded() end)
        self:strike()
    end
end

function Player:strike()
    for key, entity in pairs(engine:getCurrentState().scene.entities) do
        if entity:hasComponent(character) and not entity:hasComponent(player) then
            local pos = self.entity.components.transform.position

            local otherpos = entity.components.transform.position - pos
            local otherdeg = math.atan2(otherpos.x, otherpos.y) + math.pi

            local distance = math.sqrt((otherpos.x)^2+(otherpos.y)^2)

            local mousepos = self.entity.scene.view:toLocal(mouse.position) - pos
            local mousedeg = math.atan2(mousepos.x, mousepos.y) + math.pi

            local degdiff = math.abs(mousedeg - otherdeg)
            local actualdiff = math.min(degdiff, (2*math.pi)-degdiff)

            if distance <= 160 and actualdiff <= 1 then
                if distance <= 105 and actualdiff <= 0.65 then
                    -- critical hit
                    entity.components.character:damage(100)
                else
                    entity.components.character:damage(50)
                end
            end
        end
    end
end

function Player:attackEnded()
    self.attacking = false
    self.lowerAnimation.animation = "ninja-walk-lower"
    self.upperAnimation.animation = "ninja-walk-upper"
    self.lowerAnimation.origin = Vector:new(0.6, 0.7)
    self.upperAnimation.origin = Vector:new(0.6, 0.7)
end
