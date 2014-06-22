socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")

anal = require("engine/external/AnAL")

require "engine"

require "game/player"
require "game/animation"
require "game/camera"
require "game/ui/mouse"
require "game/level"
require "game/positionbymouse"
require "game/character"
require "game/menubutton"
require "game/score"

engine = Engine:new()

function love.load()
    engine.resources:load(Resources.Image, "background", "data/gfx/gruen.jpg")
    engine.resources:load(Resources.Image, "blur", "data/blur.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Image, "ninja-walk-lower", "data/gfx/anim/ninja/walk-lower.png")
    engine.resources:load(Resources.Image, "ninja-walk-upper", "data/gfx/anim/ninja/walk-upper.png")
    engine.resources:load(Resources.Image, "ninja-slash-upper", "data/gfx/anim/ninja/slash-upper.png")
    engine.resources:load(Resources.Image, "pirate-walk-lower", "data/gfx/anim/pirate/walk-lower.png")
    engine.resources:load(Resources.Image, "pirate-walk-upper", "data/gfx/anim/pirate/walk-upper.png")
    engine.resources:load(Resources.Image, "pirate-slash-upper", "data/gfx/anim/pirate/slash-upper.png")
    engine.resources:load(Resources.Image, "target", "data/target.png")
    engine.resources:load(Resources.Animation, "ninja-slash-upper", "ninja-slash-upper", 340, 229, 0.033, 13, {origin=Vector:new(0.48, 0.74)})
    engine.resources:load(Resources.Animation, "ninja-walk-lower", "ninja-walk-lower", 104, 128, 0.033, 21, {origin=Vector:new(0.6, 0.7)})
    engine.resources:load(Resources.Animation, "ninja-walk-upper", "ninja-walk-upper", 126, 181, 0.033, 21, {origin=Vector:new(0.6, 0.7)})

    engine.resources:load(Resources.Animation, "pirate-slash-upper", "pirate-slash-upper", 168, 112, 0.033, 27, {origin=Vector:new(0.48, 0.74)})
    engine.resources:load(Resources.Animation, "pirate-walk-lower", "pirate-walk-lower", 91, 180, 0.033, 22, {origin=Vector:new(0.5, 0.5), start=8})
    engine.resources:load(Resources.Animation, "pirate-walk-upper", "pirate-walk-upper", 108, 128, 0.033, 22, {origin=Vector:new(0.5, 0.5)})
    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    engine.resources:load(Resources.Font, "bold", "data/fonts/3Dumb.ttf")
    engine.resources:load(Resources.Font, "default", "data/fonts/2Dumb.ttf")
    FontFace.static.Default = engine.resources.font.default

    state = State:new()
    menu = State:new()
    menu.scene.view = View:new()
    
    -- Mouse target
    mouseTarget = state.scene:addEntity(Entity:new("mousetarget"))
    mouse_ui = mouseTarget:addComponent(MouseUI:new("mouse_ui", "target"))
    mouse_ui.scale = Vector:new(0.2,0.2)
    mouseTarget:addComponent(PositionByMouse:new("positionbymouse"))

    level = state.scene:addEntity(Entity:new("level"))
    ship = level:addComponent(Level:new("ship"))

    -- Player
    player = state.scene:addEntity(Entity:new("player")) 
    player.transform.position = Vector:new(1000, 2000)

    player:addComponent(Character:new("character", "Ninj'arrr", nil, "ninja"))

    player:addComponent(Player:new("player"))
    player:addComponent(SyncTransform:new("SyncTransform"))
    player.components.player.target = mouseTarget.transform
    player:addComponent(Camera:new("playercam"))

    shadow = player:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3

    -- Test Enemy
    local names = {"John", "Captain Silver", "Barnacle", "William"}
    for i=1,4 do
        enemy = state.scene:addEntity(Entity:new("enemy"))
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
    
    -- test menu button
    butten = state.scene:addEntity(Entity:new("butten"))
    buttencomponent = enemy:addComponent(MenuButton:new("button"))
    buttencomponent.click = function() love.event.quit() end

    background = menu.scene:addEntity(Entity:new("background"))
  
    
    background:addComponent(Sprite:new("background",engine.resources.image["background"]))
    background:addComponent(Score:new("score", {{"Caro",5, true},{"Rafael",7, false},{"Paul",7,true},{"Damian",8,true}, {"Blubb",2,true}}, "pirates"))

    engine:pushState(state)
end

function love.keypressed(key)
    if key == "f1" and engine:getCurrentState() == state then
        engine:pushState(menu)
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
