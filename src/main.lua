socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")

require "engine"
require "game/player"

require "game/level"

engine = Engine:new()

function love.load()
    engine.resources:load(Resources.Image, "target", "data/target.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    state = State:new()

    player = state.scene:addEntity(Entity:new("player")) 
    playercomponent = player:addComponent(Player:new("player"))
    player:addComponent(SyncTransform:new("SyncTransform"))

    label = player:addChild(Entity:new("label"))
    text = label:addComponent(Text:new("text", "Hello World", nil, 30))
    -- label.transform.global.position = Vector.WindowSize / 2

    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("ship"))
    

    ball = state.scene:addEntity(Entity:new("ball"))
    ball.transform.position = Vector:new(100, 100)
    sprite = ball:addComponent(Sprite:new("sprite", "target"))
    sprite.scaleFactor = 0.25
    ball:addComponent(Physics:new("physics", function()
        return love.physics.newCircleShape(16), 0, 0, 1
    end))

    engine:pushState(state)
end

function love.keypressed(key)
    if key == " " then
        state.scene:save("saved-level.lua")
    elseif key == "f5" then
        state:setScene(Scene.load("saved-level.lua"))
    end
end

function love.update(dt)
    fixedupdatecheck(dt)
    tween.update(dt)
end

-- fixed timestep stuff
local fixedTimestep = 0.02
local timeSinceLastFixedUpdate = 0

function fixedupdatecheck(dt)
    timeSinceLastFixedUpdate = timeSinceLastFixedUpdate + dt
    while timeSinceLastFixedUpdate > fixedTimestep do
        timeSinceLastFixedUpdate = timeSinceLastFixedUpdate - fixedTimestep
        fixedupdate(fixedTimestep)
    end
end

function fixedupdate(dt)
end
-- end of fixed timestep stuff

engine:subscribe()
