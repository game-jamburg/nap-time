State = class("State")
function State:initialize()
    self.passEventsDown = false
    self.time = 0
    self.current = false
    self.scene = Scene:new()
end

-- callbacks
function State:preUpdate(dt) end
function State:postUpdate(dt) end
function State:onEvent(type, data) end

function State:setScene(scene) 
    if self.scene then
        self.scene:leave()
    end
    self.scene = scene
    self.scene.state = self
    if self.scene then
        self.scene:enter()
    end
end

function State:update(dt)
    self.time = self.time + dt
    self:preUpdate(dt)
    self.scene:update(dt)
    self:postUpdate(dt)
end

function State:fixedupdate(dt)
    self.scene:fixedupdate(dt)
end

function State:handleEvent(type, data)
    if self:onEvent(type, data) then return true end
    if self.scene:handleEvent(type, data) then return true end
    return not self.passEventsDown
end

function State:enter()
    self.current = true
    self.time = 0
    if self.scene then
        self.scene:enter()
    end
    self:handleEvent("enter")
end

function State:leave()
    self.current = false
    if self.scene then
        self.scene:leave()
    end
    self:handleEvent("leave")
end
