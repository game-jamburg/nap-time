
function loadState()
    Log.prefix = "S-"
    server = Server:new()
    return server
end

function love.draw()
    love.graphics.print("Server running...", 10, 10)
end