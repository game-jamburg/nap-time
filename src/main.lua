socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")

anal = require("engine/external/AnAL")

require "engine"

require "game/player"
require "game/animation"
require "game/camera"
require "game/mousegui"
require "game/level"
require "game/positionbymouse"

engine = Engine:new()

function love.load()
    engine.resources:load(Resources.Image, "target", "data/target.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    state = State:new()
    
    mouseTarget = state.scene:addEntity(Entity:new("mousetarget"))
    mousegui = mouseTarget:addComponent(MouseGUI:new("mousegui", "target"))
    mousegui.scale = Vector:new(0.2,0.2)
    mouseTarget:addComponent(PositionByMouse:new("positionbymouse"))

    player = state.scene:addEntity(Entity:new("player")) 

    -- Test stuff
    engine.resources:load(Resources.Image, "ninjawalk", "data/gfx/anim/ninja-walk.png")

    playercomponent = player:addComponent(Player:new("player"))
    player:addComponent(SyncTransform:new("SyncTransform"))
    player:addComponent(Camera:new("playercam"))

    local ani = Animation:new("Animation")
    ani:create(engine.resources.image.ninjawalk, 90, 128, 0.033, 21)
    player:addComponent(ani)

    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("ship"))

    sprite = player:addComponent(Sprite:new("sprite", "target"))
    sprite.scaleFactor = 0.25
    player:addComponent(Physics:new("physics", function()
        return love.physics.newCircleShape(30), 0, 20, 1
    end))

    playercomponent.target = mouseTarget.transform

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

function love.draw()
    love.graphics.setBackgroundColor(100, 100, 100)
end

-- fixed timestep stuff
local fixedTimestep = 0.02
local timeSinceLastFixedUpdate = 0

function fixedupdatecheck(dt)
    timeSinceLastFixedUpdate = timeSinceLastFixedUpdate + dt
    while timeSinceLastFixedUpdate > fixedTimestep do
        timeSinceLastFixedUpdate = timeSinceLastFixedUpdate - fixedTimestep
        love.fixedupdate(fixedTimestep)
    end
end

function love.fixedupdate(dt)
end
-- end of fixed timestep stuff

engine:subscribe()
