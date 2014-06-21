DEFAULTS = {}
DEFAULTS.ip = "127.0.0.1"
DEFAULTS.port = 1337

function splitMessage(msg)
    local type, payload = msg:match("^(%S+) (.+)$")
    if type then
        return type, payload
    else
        return msg:match("^(%S+)$")
    end
end

Server = class("Server", State)

function Server:initialize()
    State.initialize(self)

    self.clients = {}
end

function Server:preUpdate(dt)
    self.server:update(dt)
end

function Server:onConnect(id)
    Log:debug(string.format("Client connected: %s", id))

    table.insert(self.clients, id)

    -- report back to the client with ID
    self:sendSnapshot(id)
end

function Server:onReceive(data, id)
    Log:debug("Data received: " .. id .. " > " .. data)
    -- self.server:send("you sent me stuff", id)

    local type, payload = splitMessage(data)
    if payload then
        payload = loadstring("return " .. payload)()
    end
    self:onMessage(id, type, payload)
end

function Server:onDisconnect(ip, port)
    Log:debug("Client disconnected: " .. ip .. ":" .. port)
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
    self.server:send(data, id)
end

function Server:onMessage(id, type, data)
    if type == "requestSnapshot" then
        self:sendSnapshot(id)
    elseif type == "updateComponent" then
        self.scene:updateComponent(data[1], data[2])
    end
    Log:verbose("Recieved " .. type .. " from client " .. id)
end



Client = class("Client", State)

function Client:initialize()
    State.initialize(self)
    self.timeSinceLastSnapshot = 0
    self.msgQueue = {}
end

function Client:onEvent(type, data)
    if type == "enter" then
        Log:info("Connecting...")
        self.client = lube.udpClient()
        self.client.handshake = "Hi!"
        self.client.callbacks.recv = function(...) self:onReceive(...) end
        self.client:connect(DEFAULTS.ip, DEFAULTS.port)
    end
end

function Client:onReceive(data)
    local type, payload = splitMessage(data)
    if payload then
        payload = loadstring("return " .. payload)()
    end
    self:onMessage(type, payload)
end

function Client:preUpdate(dt)
    self.client:update(dt)
    if self.timeSinceLastSnapshot > 1 then
        self:requestSnapshot()
        self.timeSinceLastSnapshot = 0
    else
        self.timeSinceLastSnapshot = self.timeSinceLastSnapshot + dt
    end

    -- Send messages in queue
    for _, msg in pairs(self.msgQueue) do
        self.client:send(msg)
    end
    self.msgQueue = {}
end

function Client:onMessage(type, data)
    -- Log:debug("Client received message of type " .. type)
    if type == "snapshot" then
        Log:debug("Received snapshot")
        self.scene:apply(data)
    end
end

function Client:requestSnapshot()
    self.client:send("requestSnapshot")
end

function Client:syncComponent(component)
    msg = string.format("updateComponent %s",
        serialize({component.entity.name, component}))
    self:enqueue(msg)
end

function Client:enqueue(msg)
    table.insert(self.msgQueue, msg)
end
