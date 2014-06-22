function loadState()
    Log.prefix = "C-"

    createScore()
    createMenu()

    client = Client:new()
    return client
end

function createScore()
    -- test stuff
    score = State:new()
    score.scene.view = View:new()

    local background = score.scene:addEntity(Entity:new("background"))
    background:addComponent(Score:new("score", {{"Caro",5, true},{"Rafael",7, false},{"Paul",7,true},{"Damian",8,true}, {"Blubb",2,true}}, "pirates"))
    score.scene.background = background
end

function createMenu()
    menu = State:new()
    menu.scene.view = View:new()

    local menuEntity = menu.scene:addEntity(Entity:new("menu"))
    menuEntity:addComponent(Menu:new("menu"))
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
