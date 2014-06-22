
function loadState()
    Log.prefix = "S-"
    server = Server:new()
    return server
end

function serverDraw()
    love.graphics.print("Server running on " .. server.server.port, 10, 10)
    local info = ""
    for id, entityName in pairs(server.clients) do
        local entity = server.scene.entities[entityName]
        local pos = entity.transform.position
        local rot = entity.children.upper.transform.rotation
        info = info .. string.format("%s (%s): pos = %s; r = %s\n",
            entityName, id, serialize(pos), serialize(rot))
    end
    love.graphics.print(info, 10, 40)
end


function love.keypressed(key)
    if key == "k" then
        for id, _ in pairs(server.clients) do
            server:sendKill(id)
        end
    end
end