function loadState()
    Log.prefix = "C-"

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
