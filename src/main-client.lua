function loadState()
    Log.prefix = "C-"

    createScore()
    createMenu()

    engine.renderer.preRender = function(drawable)
        if not (client.playerName and engine:getCurrentState() == state) then return end
        local lamp = drawable.entity.scene.entities[client.playerName].components.lamp
        local isPlayer = drawable.entity.parent and drawable.entity.parent.components.player
        if engine.resources.image.lightmap and not isPlayer and lamp then
            local stencil = engine.resources.shader.stencil
            local view = client.scene.view
            local scale = view:getGlobalScale()
            stencil:send("stencil", engine.resources.image.lightmap)
            stencil:send("size", {Vector.WindowSize.x, Vector.WindowSize.y})
            stencil:send("sampling", lamp.sampling)
            stencil:send("radius", lamp.radius)
            stencil:send("scale", {scale.x, scale.y})
            love.graphics.setShader(stencil)
        else
            love.graphics.setShader()
        end
    end

    client = Client:new()
    return client
end

function createScore()
    -- test stuff
    score = State:new()
    score.scene.view = View:new()

    background = score.scene:addEntity(Entity:new("background"))
    background:addComponent(Score:new("score", {{"Caro",5, true},{"Rafael",7, false},{"Paul",7,true},{"Damian",8,true}, {"Blubb",2,true}}, "pirates"))


end

function createMenu()

    menu = State:new()
    menu.scene.view = View:new()
    test = menu.scene:addEntity(Entity:new("test"))
    test:addComponent(Menu:new("menu"))


    optionButton = test:addComponent(MenuButton:new("option"))
    optionButton.position = Vector:new(300, 80)
    optionButton.size = Vector:new(100, 30)
    optionButton.text = "Options"
    optionButton.click = function() love.event.quit() end


    startButton = test:addComponent(MenuButton:new("start"))
    startButton.position = Vector:new(300, 140)
    startButton.size = Vector:new(100, 30)
    startButton.text = "Start"
    startButton.click = function() love.event.quit() end


    exitButton = test:addComponent(MenuButton:new("exit"))
    exitButton.position = Vector:new(300, 200)
    exitButton.size = Vector:new(100, 30)
    exitButton.text = "Exit"
    exitButton.click = function() love.event.quit() end



end

function love.keypressed(key)
    if key == " " then
        state.scene:save("saved-level.lua")
    elseif key == "f5" then
        state:setScene(Scene.load("saved-level.lua"))
    elseif key == "f1" and engine:getCurrentState() ~= score then
        engine:pushState(score)
    elseif key == "f2" and engine:getCurrentState() ~= menu then
        engine:pushState(menu)
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
end
