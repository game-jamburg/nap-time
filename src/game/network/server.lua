Server = class("Server", GameState)

function Server:initialize()
    GameState.initialize(self)

    self.clients = {}
end

function Server:send(data, target)
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

    table.insert(self.clients, id)

    -- report back to the client with ID
    self:sendSnapshot(id)
end

function Server:onReceive(data, id)
    Log:verbose("Message received from " .. id)

    local type, payload = self:splitMessage(data)
    if payload then
        payload = loadstring("return " .. payload)()
    end
    self:onMessage(id, type, payload)
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
    end 
end 

function Server:sendSnapshot(id)
    local data = "snapshot " .. serialize(self.scene)
    self:enqueue(data, id)
end

function Server:onMessage(id, type, data)
    if type == "requestSnapshot" then
        self:sendSnapshot(id)
    elseif type == "updateComponent" then
        self.scene:updateComponent(data[1], data[2])
    elseif type == "updateTopLevelEntity" then
        self.scene:updateEntity(data[1], data[2])
    end
    Log:debug("Recieved", type, "from", id)
end
