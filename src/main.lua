socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")
anal = require("engine/external/AnAL")
lube = require("engine/external/LUBE")

require "engine"

require "game/player"
require "game/animation"
require "game/camera"
require "game/mousegui"
require "game/level"
require "game/positionbymouse"
require "game/character"
require "game/menubutton"
require "game/network"
require "game/score"

engine = Engine:new()

function love.load(args)
    engine.resources:load(Resources.Image, "background", "data/gfx/gruen.jpg")
    engine.resources:load(Resources.Image, "blur", "data/blur.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Image, "ninja-walk-lower", "data/gfx/anim/ninja/walk-lower.png")
    engine.resources:load(Resources.Image, "ninja-walk-upper", "data/gfx/anim/ninja/walk-upper.png")
    engine.resources:load(Resources.Image, "ninja-slash-upper", "data/gfx/anim/ninja/slash-upper.png")
    engine.resources:load(Resources.Image, "target", "data/target.png")
    engine.resources:load(Resources.Animation, "ninja-slash-upper", "ninja-slash-upper", 340, 229, 0.033, 13)
    engine.resources:load(Resources.Animation, "ninja-walk-lower", "ninja-walk-lower", 104, 128, 0.033, 21)
    engine.resources:load(Resources.Animation, "ninja-walk-upper", "ninja-walk-upper", 126, 181, 0.033, 21)
    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    state = State:new()
    menu = State:new()
    menu.scene.view = View:new()
    
    isServer = (args[2] == "--server")
    isClient = not isServer

    if isServer then
        require "server"
    else
        require "client"
    end
    engine:subscribe()

    state = loadState()
    engine:pushState(state)

    initLevel()
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
    player:addComponent(Player:new("player"))
    player:addComponent(Camera:new("playercam"))


    -- Test Enemy
    enemy = state.scene:addEntity(Entity:new("enemy"))
    enemy.transform.position = Vector:new(1000, 1800)
    enemy:addComponent(Character:new("character", "Test Pirate"))

    -- Mouse target
    mouseTarget = state.scene:addEntity(Entity:new("mousetarget"))
    mousegui = mouseTarget:addComponent(MouseGUI:new("mousegui", "target"))
    mousegui.scale = Vector:new(0.2,0.2)
    mouseTarget:addComponent(PositionByMouse:new("positionbymouse"))
    if isClient then
        player.components.player.target = mouseTarget.transform
    end

    shadow = player:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3

    local lowerWalk = Animation:new("animation", "ninja-walk-lower", 104, 128, 0.033, 21)
    lowerWalk.origin = Vector:new(0.6, 0.7)
    lowerWalk.order = 1
    player.children.lower:addComponent(lowerWalk)

    local upperWalk = Animation:new("animation", "ninja-walk-upper", 126, 181, 0.033, 21)
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
    

    background = menu.scene:addEntity(Entity:new("background"))
  
    
    background:addComponent(Sprite:new("background",engine.resources.image["background"]))
    background:addComponent(Score:new("score", {{"Caro",5, true},{"Rafael",7, false},{"Paul",7,true},{"Damian",8,true}, {"Blubb",2,true}}, "pirates"))
end


function love.keypressed(key)
    if key == " " then
        state.scene:save("saved-level.lua")
    elseif key == "f5" then
        state:setScene(Scene.load("saved-level.lua"))
    elseif key == "f1" and engine:getCurrentState() == state then
        engine:pushState(menu)
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
        love.fixedupdate(fixedTimestep)
    end
end

function love.fixedupdate(dt)
end
-- end of fixed timestep stuff
