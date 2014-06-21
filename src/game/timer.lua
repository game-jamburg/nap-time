Timer = class("Timer", Component)

function Timer:initialize(name, delay, action, actionArgs)
    Component.initialize(self, name)
    self.timePassed = 0
    self.delay = delay
    self.action = action
    self.actionArgs = actionArgs or {}
end

function Timer:onUpdate(dt)
    self.timePassed = self.timePassed + dt
    if (self.timePassed > self.delay) then
        self.action(unpack(self.actionArgs))
        self.entity.components[self.name] = nil
    end
end
