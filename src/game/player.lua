Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 300
    Component.initialize(self, name)
end
 
function Player:onFixedUpdate(dt)
    -- Reaktion auf gedrueckte Pfeiltasten
    local movement = Vector:new()
    if love.keyboard.isDown("left") or love.keyboard.isDown("a")  then
        movement.x = -1
    end

    if love.keyboard.isDown("right") or love.keyboard.isDown("d")then
        movement.x = 1
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s")then
        movement.y = 1 
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        movement.y = -1
    end
    
    movement:normalize()
    self.entity.transform.position = self.entity.transform.position + movement *self.speed*dt
    
    if self.target then
        local lookDirection = self.target.position - self.entity.transform.position
        self.entity.transform.rotation = lookDirection:angle()
    end

    self.entity.components.physics:pull()
end