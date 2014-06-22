socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")
anal = require("engine/external/AnAL")
lube = require("engine/external/LUBE")

require "engine"

require "game/player"
require "game/animation"
require "game/camera"
require "game/lamp"
require "game/ui/mouse"
require "game/ui/log"
require "game/level"
require "game/positionbymouse"
require "game/character"
require "game/menubutton"
require "game/network"
require "game/score"
require "game/menu"

engine = Engine:new()

function love.load(args)
    engine.resources:load(Resources.Image, "background", "data/gfx/gruen.jpg")
    engine.resources:load(Resources.Image, "blur", "data/gfx/blur.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Image, "ninja-walk-lower", "data/gfx/anim/ninja/walk-lower.png")
    engine.resources:load(Resources.Image, "ninja-walk-upper", "data/gfx/anim/ninja/walk-upper.png")
    engine.resources:load(Resources.Image, "ninja-slash-upper", "data/gfx/anim/ninja/slash-upper.png")
    engine.resources:load(Resources.Image, "pirate-walk-lower", "data/gfx/anim/pirate/walk-lower.png")
    engine.resources:load(Resources.Image, "pirate-walk-upper", "data/gfx/anim/pirate/walk-upper.png")
    engine.resources:load(Resources.Image, "pirate-slash-upper", "data/gfx/anim/pirate/slash-upper.png")
    engine.resources:load(Resources.Image, "target", "data/gfx/target.png")

    engine.resources:load(Resources.Animation, "ninja-slash-upper", "ninja-slash-upper", 340, 229, 0.033, 13, {origin=Vector:new(0.48, 0.74)})
    engine.resources:load(Resources.Animation, "ninja-walk-lower", "ninja-walk-lower", 104, 128, 0.033, 21, {origin=Vector:new(0.6, 0.7)})
    engine.resources:load(Resources.Animation, "ninja-walk-upper", "ninja-walk-upper", 126, 181, 0.033, 21, {origin=Vector:new(0.6, 0.7)})
    engine.resources:load(Resources.Animation, "pirate-slash-upper", "pirate-slash-upper", 168, 112, 0.02, 27, {origin=Vector:new(0.34, 0.78), scaleFactor=1.25, mode="once"})
    engine.resources:load(Resources.Animation, "pirate-walk-lower", "pirate-walk-lower", 91, 180, 0.033, 22, {origin=Vector:new(0.5, 0.5), start=8, scaleFactor=0.8})
    engine.resources:load(Resources.Animation, "pirate-walk-upper", "pirate-walk-upper", 108, 128, 0.033, 22, {origin=Vector:new(0.34, 0.57), scaleFactor=1.5})

    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    engine.resources:load(Resources.Shader, "lightmap", "data/shader/lightmap.glsl")
    engine.resources:load(Resources.Shader, "stencil", "data/shader/stencil.glsl")

    engine.resources:load(Resources.Font, "bold", "data/fonts/3Dumb.ttf")
    engine.resources:load(Resources.Font, "default", "data/fonts/2Dumb.ttf")
    FontFace.static.Default = engine.resources.font.default

    state = State:new()
    
    isServer = (args[2] == "--server")
    isClient = not isServer

    if isServer then
        require "main-server"
    else
        require "main-client"
    end
    engine:subscribe()

    state = loadState()
    engine:pushState(state)

    initLevel()
end


function initLevel()
    -- create the level
    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("level"))

    -- Ninja
    ninja = state.scene:addEntity(Entity:new("ninja")) 
    ninja.transform.position = Vector:new(1000, 2000)
    ninja:addComponent(Character:new("character", "Ninj'arrr", nil, "ninja"))
    ninja:addComponent(Physics:new("physics", function() return love.physics.newCircleShape(30), 0, 20, 1 end))

    shadow = ninja:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3

    if isServer then
        availablePlayers = {"ninja"}
    end

    -- Test Enemy
    local names = {"John", "Captain Silver", "Barnacle", "William"}
    for i=1,4 do
        local pirateName = "pirate-" .. i
        if isServer then
            table.insert(availablePlayers, pirateName)
        end
        enemy = state.scene:addEntity(Entity:new(pirateName))
        enemy.transform.position = Vector:new(500 + 200 * i, 1900)
        shadow = enemy:addComponent(Sprite:new("shadow", "blur"))
        shadow.color = Color:new(0, 0, 0, 0.5)
        shadow.order = 1
        shadow.scaleFactor = 0.3
        enemy:addComponent(Character:new("character", names[i], nil, "pirate"))
        enemy.children.lower.transform.rotation = math.pi
        enemy.children.upper.transform.rotation = math.pi
        enemy.components.physics:pull()
    end
    
    -- UI TEST 
    if isClient then
        uiRoot = state.scene:addEntity(Entity:new("button"))

        -- Menu button
        testButton = uiRoot:addComponent(MenuButton:new("button"))
        testButton.position = Vector:new(Vector.WindowSize.x - 30, 10)
        testButton.size = Vector:new(20, 20)
        testButton.text = "x"
        testButton.click = function() love.event.quit() end

        -- Chatlog
        chatlog = uiRoot:addComponent(ChatLog:new("chatlog"))
        chatlog:append("You started the client.")
        chatlog:append("Welcome.")
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
