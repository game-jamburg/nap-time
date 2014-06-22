function loadState()
    Log.prefix = "C-"

    createMenu()

    client = Client:new()
    return client
end

function createMenu()
    -- test stuff
    menu = State:new()
    menu.scene.view = View:new()

    background = menu.scene:addEntity(Entity:new("background"))
    background:addComponent(Sprite:new("background", engine.resources.image.background))
    background:addComponent(Score:new("score", {{"Caro",5, true},{"Rafael",7, false},{"Paul",7,true},{"Damian",8,true}, {"Blubb",2,true}}, "pirates"))
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
