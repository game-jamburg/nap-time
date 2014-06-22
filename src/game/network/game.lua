DEFAULTS = {}
DEFAULTS.ip = "127.0.0.1"
DEFAULTS.port = 1337

GameState = class("GameState", State)

function GameState:initialize()
    State.initialize(self)
    self.messageQueue = {}
end

function GameState:enqueue(key, message, target)
    self.messageQueue[key] = {message, target}
end

function GameState:sendQueue()
    local i = 0
    for _, data in pairs(self.messageQueue) do
        self:send(data[1], data[2])
        i = i + 1
    end
    self.messageQueue = {}
    if i ~= 0 then
        Log:verbose("Send queue with " .. i .. " messages")
    end
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

    function filter(obj)
        if type(obj) == "table" and obj.isInstanceOf then
            return not(obj:isInstanceOf(Animation) or obj:isInstanceOf(Player)
                       or obj:isInstanceOf(Camera) or obj:isInstanceOf(Lamp)
                       or obj:isInstanceOf(Text))
        else
            return true
        end
    end

    msg = string.format("updateTopLevelEntity %s",
        serialize({entity.name, entity}, 0, filter))
    local queue_tag = "updateTopLevelEntity " .. entity.name
    if target then queue_tag = target .. queue_tag end
    self:enqueue(queue_tag, msg, target)
end
