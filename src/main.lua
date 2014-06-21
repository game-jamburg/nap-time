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
require "game/character"

engine = Engine:new()

function love.load()
    engine.resources:load(Resources.Image, "target", "data/target.png")
    engine.resources:load(Resources.Image, "blur", "data/blur.png")
    engine.resources:load(Resources.Image, "ninja-walk-lower", "data/gfx/anim/ninja/walk-lower.png")
    engine.resources:load(Resources.Image, "ninja-walk-upper", "data/gfx/anim/ninja/walk-upper.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    state = State:new()
    
    -- Mouse target
    mouseTarget = state.scene:addEntity(Entity:new("mousetarget"))
    mousegui = mouseTarget:addComponent(MouseGUI:new("mousegui", "target"))
    mousegui.scale = Vector:new(0.2,0.2)
    mouseTarget:addComponent(PositionByMouse:new("positionbymouse"))

    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("ship"))

    -- Player
    player = state.scene:addEntity(Entity:new("player")) 
    player.transform.position = Vector:new(1000, 2000)

    player:addComponent(Character:new("character", "Ninj'arrr"))

    player:addComponent(Player:new("player"))
    player:addComponent(SyncTransform:new("SyncTransform"))
    player.components.player.target = mouseTarget.transform
    player:addComponent(Camera:new("playercam"))
    player:addComponent(Physics:new("physics", function() return love.physics.newCircleShape(30), 0, 20, 1 end))

    shadow = player:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3

    local lowerWalk = Animation:new("Animation", "ninja-walk-lower", 104, 128, 0.033, 21)
    lowerWalk.origin = Vector:new(0.6, 0.7)
    lowerWalk.order = 1
    player.children.lower:addComponent(lowerWalk)

    local upperWalk = Animation:new("Animation", "ninja-walk-upper", 126, 181, 0.033, 21)
    upperWalk.origin = Vector:new(0.6, 0.7)
    upperWalk.order = 2
    player.children.upper:addComponent(upperWalk)

    -- Test Enemy
    enemy = state.scene:addEntity(Entity:new("enemy"))
    enemy.transform.position = Vector:new(1000, 1800)
    shadow = enemy:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3
    enemy:addComponent(Character:new("character", "Test Pirate"))


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
    love.graphics.setBackgroundColor(150, 150, 150)
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
