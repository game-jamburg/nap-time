tween = require("engine/external/tween")
class = require("engine/external/middleclass")

require "engine"
require "game/player"

engine = Engine:new()

function love.load()
    state = State:new()

    player = state.scene:addEntity(Entity:new("player")) 
    playercomponent = player:addComponent(Player:new("player"))


    label = player:addChild(Entity:new("label"))
    text = label:addComponent(Text:new("text", "Hello World", nil, 30))
    -- label.transform.global.position = Vector.WindowSize / 2

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