socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")

anal = require("engine/external/AnAL")

require "engine"
require "game/player"
require "game/animation"

require "game/level"

engine = Engine:new()

function love.load()
    engine.resources:load(Resources.Image, "ship", "data/gfx/ship.png")

    state = State:new()

    player = state.scene:addEntity(Entity:new("player")) 

    -- Test stuff
    engine.resources:load(Resources.Image, "playerwalk", "data/gfx/anim/player/walk.png")

    playercomponent = player:addComponent(Player:new("player"))
    player:addComponent(SyncTransform:new("SyncTransform"))

    local ani = Animation:new("Animation")
    ani:create(engine.resources.image.playerwalk, 139, 124, 0.033, 30)
    player:addComponent(ani)

    label = player:addChild(Entity:new("label"))
    text = label:addComponent(Text:new("text", "Captain Iglu", nil, 25))
    -- label.transform.global.position = Vector.WindowSize / 2

    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("ship"))
    

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
