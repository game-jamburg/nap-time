DEFAULTS = {}
DEFAULTS.ip = "127.0.0.1"
DEFAULTS.port = 1337

GameState = class("GameState", State)

function GameState:initialize()
    State.initialize(self)
    self.messageQueue = {}
end

function GameState:enqueue(message, target)
    table.insert(self.messageQueue, {message, target})
end

function GameState:sendQueue()
    for _, data in pairs(self.messageQueue) do
        self:send(data[1], data[2])
    end
    self.messageQueue = {}
end

function GameState:send(data, target) 
    Log:error("GameState:send not implemented in " .. self.class)
end

function GameState:splitMessage(msg)
    local type, payload = msg:match("^(%S+) (.+)$")
    if type then
        return type, payload
    else
        return msg:match("^(%S+)$")
    end
end

function GameState:sendUpdateTopLevelEntity(entity, target)
    Log:verbose("Send", "updateTopLevelEntity", entity.name)
    msg = string.format("updateTopLevelEntity %s",
        serialize({entity.name, entity}))
    self:enqueue(msg, target)
end
