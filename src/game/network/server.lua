Server = class("Server", GameState)

function Server:initialize()
    GameState.initialize(self)

    self.clients = {}
end

function Server:send(data, target)
    data = libc:Compress(data)
    self.server:send(data, target)
end

function Server:preUpdate(dt)
    self.server:update(dt)
end

function Server:postUpdate(dt)
    self:sendQueue()
end

function Server:onConnect(id)
    Log:info(string.format("Client connected: %s", id))


    -- report back to the client with ID
    self:sendWelcome(id)
    self:sendSnapshot(id)
end

function Server:onReceive(data, id)
    local type, payload = self:splitMessage(data)
    if payload then
        payload = loadstring("return " .. payload)()
    end
    self:onMessage(id, type, payload, data)
end

function Server:onDisconnect(ip, port)
    Log:info("Client disconnected: " .. ip .. ":" .. port)
end

function Server:onEvent(type, data)
    if type == "enter" then
        Log:info("Starting server on port " .. DEFAULTS.port)
        self.server = lube.udpServer()
        self.server:listen(DEFAULTS.port)
        self.server.callbacks.connect = function(...) self:onConnect(...) end
        self.server.callbacks.recv = function(...) self:onReceive(...) end
        self.server.callbacks.disconnect = function(...) self:onDisconnect(...) end
        self.server.handshake = "Hi!"
        love.draw = serverDraw
    end 
end 

function Server:sendSnapshot(id)
    for _, entity in pairs(self.scene.entities) do
        self:sendUpdateTopLevelEntity(entity, id)
    end
end

function Server:sendWelcome(id)
    local playerName = nil
    if not self.clients[id] then
        if #availablePlayers == 0 then
            self:sendKill(id)
            return
        end
        playerName = availablePlayers[#availablePlayers]
        table.removeValue(availablePlayers, playerName)

        Log:info("Send welcome to new player '" .. playerName .. "'")
        self.clients[id] = playerName
    else
        playerName = self.clients[id]
        Log:debug("Resend welcome to '" .. playerName .. "'")
    end
    local msg = string.format("welcome \"%s\"", playerName)
    self:enqueue(id .. " " .. msg, msg, id)
end

function Server:sendKill(id)
    self:enqueue(id .. "kill", "kill", id)
end

function Server:onMessage(id, type, data, message)
    Log:verbose("Received message " .. type .. " from " .. id)
    if type == "requestSnapshot" then
        self:sendSnapshot(id)
    elseif type == "requestWelcome" then
        self:sendWelcome(id)
    elseif type == "updateComponent" then
        self.scene:updateComponent(data[1], data[2])
    elseif type == "updateTopLevelEntity" then
        entityName = data[1]
        entity = data[2]
        entity.name = entityName
        self.scene:updateEntity(entityName, entity)
        for otherId, _ in pairs(self.clients) do
            if otherId ~= id then
                self:sendUpdateTopLevelEntity(entity, otherId)
            end
        end
    elseif type == "rpc" then
        local entity = self.scene.entities[data.entity]
        local component = entity.components[data.component]
        local func = component[data.func]
        func(component, unpack(data.params))
        
        -- forward to every client
        for clientid, _ in pairs(self.clients) do
            if id ~= clientid then
                self:enqueue(message .. clientid, message, clientid)
            end
        end
    end
end
