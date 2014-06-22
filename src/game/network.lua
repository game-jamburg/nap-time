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
    Log:info(string.format("Client connected: %s", id))

    table.insert(self.clients, id)

    -- report back to the client with ID
    self:sendSnapshot(id)
end

function Server:onReceive(data, id)
    Log:verbose("Message received from " .. id)

    local type, payload = splitMessage(data)
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
    self.server:send(data, id)
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



Client = class("Client", State)

function Client:initialize()
    State.initialize(self)
    self.timeSinceLastSnapshot = 0
    self.msgQueue = {}
end

function Client:onEvent(type, data)
    if type == "enter" then
        Log:info("Connecting to server " .. DEFAULTS.ip .. ":" .. DEFAULTS.port)
        self.client = lube.udpClient()
        self.client.handshake = "Hi!"
        self.client.callbacks.recv = function(...) self:onReceive(...) end
        local ok, msg = self.client:connect(DEFAULTS.ip, DEFAULTS.port, false)
        if not ok then
            Log:error(string.format("Error connecting to %s:%s:",
                DEFAULTS.ip, DEFAULTS.port), msg)
        end
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
    Log:verbose("Client received message of type " .. type)
    if type == "snapshot" then
        self.scene:apply(data)

        -- now, make sure we own our player
        local ninja = self.scene.entities.ninja
        if not ninja.components.player then
            player = ninja:addComponent(Player:new("player"))

            -- also, add the mouse target stuff
            target = self.scene:addEntity(Entity:new("target"))

            sprite = target:addComponent(Sprite:new("mouseui", "target"))
            sprite.scaleFactor = 0.2
            sprite.renderer = engine.ui

            target:addComponent(PositionByMouse:new("positionbymouse", "target"))

            player.target = target.transform
        end
    end
end

function Client:requestSnapshot()
    self.client:send("requestSnapshot")
end

function Client:syncComponent(component)
    Log:verbose("Send", "syncComponent", component.entity.name, component.name)
    msg = string.format("updateComponent %s",
        serialize({component.entity.name, component}))
    self:enqueue(msg)
end

function Client:syncTopLevelEntity(entity)
    Log:verbose("Send", "syncTopLevelEntity", entity.name)
    msg = string.format("updateTopLevelEntity %s",
        serialize({entity.name, entity}))
    self:enqueue(msg)
end

function Client:enqueue(msg)
    table.insert(self.msgQueue, msg)
end
