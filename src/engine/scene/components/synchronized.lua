Synchronized = class("Synchronized", Component)

function Synchronized:initialize(name, targetComponents, updateInterval)
    Component.initialize(self, name)
    self.targetComponents = targetComponents
    self.updateInterval = updateInterval or 0.1
    self.dt = 0

    self.socket = socket.udp()
    self.socket:settimeout(0)
    self.socket:setpeername('localhost', 1337)
end

function Synchronized:onUpdate(dt)
    self.dt = self.dt + dt
    if self.dt >= self.updateInterval then
        for componentName, props in pairs(self.targetComponents) do
            local component = self.entity.components[componentName]
            for _, prop in pairs(props) do
                local value = component.properties[prop]
                local time = string.format("%.03f", Time.Global)
                local msg = string.format("%s %s %s %s %s",
                    time, self.entity.name, componentName, prop, serialize(value))
                -- Log:debug("Sync " .. msg)
                self.socket:send(msg)
            end
        end
        self.dt = 0
    end
end


SyncTransform = class("SyncTransform", Synchronized)

function SyncTransform:initialize(name)
    Synchronized.initialize(self, name, {
        transform = {"position", "rotation", "global"}
    })
end
