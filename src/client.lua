
function loadState()
    engine.resources:load(Resources.Image, "target", "data/target.png")
    engine.resources:load(Resources.Image, "blur", "data/blur.png")
    engine.resources:load(Resources.Image, "ninja-walk-lower", "data/gfx/anim/ninja/walk-lower.png")
    engine.resources:load(Resources.Image, "ninja-walk-upper", "data/gfx/anim/ninja/walk-upper.png")
    engine.resources:load(Resources.Image, "level01", "data/levels/level-01/background.png")
    engine.resources:load(Resources.Text,  "level01", "data/levels/level-01/mesh.lua")

    client = Client:new()
    return client
end

function love.keypressed(key)
    if key == " " then
        state.scene:save("saved-level.lua")
    elseif key == "f5" then
        state:setScene(Scene.load("saved-level.lua"))
    end
end

function love.draw()
    love.graphics.setBackgroundColor(150, 150, 150)
end



function dummy()

    -- Mouse target
    mouseTarget = state.scene:addEntity(Entity:new("mousetarget"))
    mousegui = mouseTarget:addComponent(MouseGUI:new("mousegui", "target"))
    mousegui.scale = Vector:new(0.2,0.2)
    mouseTarget:addComponent(PositionByMouse:new("positionbymouse"))
    player.components.player.target = mouseTarget.transform

    player:addComponent(Player:new("player"))
    player:addComponent(Camera:new("playercam"))

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


    shadow = enemy:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3
    



    -- test menu button
    butten = state.scene:addEntity(Entity:new("butten"))
    buttencomponent = enemy:addComponent(MenuButton:new("button"))
    buttencomponent.click = function() love.event.quit() end


end
