Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 300
    Component.initialize(self, name)
end

function Player:onAdd(entity)
    self.entity.transform.position = Vector:new(0,0)
end


function Player:onFixedUpdate(dt)
    -- Reaktion auf gedrueckte Pfeiltasten
    local movement = Vector:new()
    if love.keyboard.isDown("left") then
        movement.x = -1
    end

    if love.keyboard.isDown("right") then
        movement.x = 1
    end

    if love.keyboard.isDown("down") then
        movement.y = 1 
    end

    if love.keyboard.isDown("up") then
        movement.y = -1
    end

    movement:normalize()
    self.entity.transform.position = self.entity.transform.position + movement *self.speed*dt

end