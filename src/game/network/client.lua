Client = class("Client", GameState)

function Client:initialize()
    GameState.initialize(self)
    self.timeSinceLastSnapshot = 0
    --self.sendInterval = 0
    --self.timeSinceLastSend = 0
end

function Client:send(data)
    self.client:send(data)
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
    local type, payload = self:splitMessage(data)
    if payload then
        payload = loadstring("return " .. payload)()
    end
    self:onMessage(type, payload)
end

function Client:preUpdate(dt)
    self.client:update(dt)
    if self.timeSinceLastSnapshot > 2 then
        self:requestSnapshot()
        self.timeSinceLastSnapshot = 0
    else
        self.timeSinceLastSnapshot = self.timeSinceLastSnapshot + dt
    end
end

function Client:postUpdate(dt)
    --self.timeSinceLastSend = self.timeSinceLastSend + dt
    --if self.timeSinceLastSend > self.sendInterval then
        self:sendQueue()
    --    self.timeSinceLastSend = 0
    --end
end

function Client:onMessage(type, data)
    Log:verbose("Client received message of type " .. type)
    if type == "updateTopLevelEntity" then
        if not self.playerName then
            Log:warning("Received update before welcome")
            self:requestWelcome()
        end

        self.scene:updateEntity(data[1], data[2], true)

        -- now, make sure we own our player
        if data[1] == self.playerName then
            self.playerEntity = self.scene.entities[self.playerName]
            if not self.playerEntity.components.player then
                Log:debug("Add player component to " .. self.playerName)
                player = self.playerEntity:addComponent(Player:new("player"))

                -- also, add the mouse target stuff
                target = self.scene:addEntity(Entity:new("target"))

                sprite = target:addComponent(Sprite:new("mouseui", "target"))
                sprite.scaleFactor = 0.2
                sprite.renderer = engine.ui

                target:addComponent(PositionByMouse:new("positionbymouse", "target"))

                player.target = target.transform
            end
        end
    elseif type == "rpc" then
        -- remote procedure call
        local entity = self.scene.entities[data.entity]
        local component = entity.components[data.component]
        local func = component[data.func]
        func(component, unpack(data.params))
    elseif type == "welcome" then
        if not self.playerName then
            Log:info("You are now '" .. data .. "'")
            self.playerName = data
        elseif self.playerName ~= data then
            Log:error("Recieved additional welcome", data)
        end
    elseif type == "kill" then
        love.event.push("quit")
    end

end

function Client:requestSnapshot()
    self:enqueue("requestSnapshot", "requestSnapshot")
end

function Client:requestWelcome()
    self:enqueue("requestWelcome", "requestWelcome")
end

function Client:syncComponent(component)
    Log:verbose("Send", "syncComponent", component.entity.name, component.name)
    msg = string.format("updateComponent %s",
        serialize({component.entity.name, component}))
    self:enqueue("syncComponent " .. component.entity.name " " .. component.name, msg)
end

function Client:syncTopLevelEntity(entity)
    self:sendUpdateTopLevelEntity(entity)
end
