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

    -- update position
    self.entity.transform.position = self.entity.transform.position + movement * self.speed * dt

    -- lower body rotates with movement direction
    self.entity.children.lower.transform.rotation = movement:angle()

    -- upper body rotates to target
    if self.target then
        local lookDirection = self.target.position - self.entity.transform.position
        self.entity.children.upper.transform.rotation = lookDirection:angle()
    end

    -- tell the physics we changed stuff :)
    self.entity.components.physics:pull()
end
