
function loadState()
    Log.prefix = "S-"
    server = Server:new()
    return server
end

function serverDraw()
    love.graphics.print("Server running on " .. server.server.port, 10, 10)
    love.graphics.print("Clients: " .. serialize(server.clients), 10, 40)
end