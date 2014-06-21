DEFAULTS = {}
DEFAULTS.ip = "127.0.0.1"
DEFAULTS.port = 1337

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
    self.server:send("welcome " .. id, id)
end

function Server:onReceive(data, id)
    Log:debug("Data received: " .. id .. " > " .. data)
    self.server:send("you sent me stuff", id)
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


Client = class("Client", State)

function Client:initialize()
    State.initialize(self)
end

function Client:onEvent(type, data)
    if type == "enter" then
        Log:info("Connecting...")
        self.client = lube.udpClient()
        self.client.handshake = "Hi!"
        self.client.callbacks.recv = function(...) self:onReceive(...) end
        self.client:connect(DEFAULTS.ip, DEFAULTS.port)
        self.client:send("hello server")
    end
end

function Client:onReceive(data)
    Log:info("Client received stuff")
end

function Client:preUpdate(dt)
    self.client:update(dt)
end
