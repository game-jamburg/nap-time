Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 600
    Component.initialize(self, name)
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
        self.entity.children.upper.components.animation.speed = 0.6
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
