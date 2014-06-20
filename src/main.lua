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
    tween.update(dt)

    label.transform.global.rotation = state.scene.time
end

engine:subscribe()