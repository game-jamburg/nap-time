
function loadState()
    server = Server:new()
    return server
end

function initLevel()
    -- create the level
    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("ship"))
    
    -- Ninja
    player = state.scene:addEntity(Entity:new("player")) 
    player.transform.position = Vector:new(1000, 2000)
    player:addComponent(Character:new("character", "Ninj'arrr"))
    player:addComponent(Physics:new("physics", function() return love.physics.newCircleShape(30), 0, 20, 1 end))

    -- Test Enemy
    enemy = state.scene:addEntity(Entity:new("enemy"))
    enemy.transform.position = Vector:new(1000, 1800)
    enemy:addComponent(Character:new("character", "Test Pirate"))
    
end

function love.draw()
    love.graphics.print("Server running...", 10, 10)
end