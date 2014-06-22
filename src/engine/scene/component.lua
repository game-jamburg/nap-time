Component = class("Component", PropertyObject)

function Component:initialize(name)
    PropertyObject.initialize(self)
    self.name = name
end

function Component:update(dt)
    PropertyObject.update(self)
    self:onUpdate(dt)
end

function Component:fixedupdate(dt)
    PropertyObject.update(self)
    self:onFixedUpdate(dt)
end

function Component:added(entity)
    self.entity = entity
    self:onAdd(entity)
end

function Component:restore(data)
    for k, v in pairs(data) do
        if not self.properties[k] then 
            Log:error("Invalid property in Component:restore():", k)
            return
        end
        self.properties[k]:set(v) 
    end
end

function Component:serialize(depth, filter)
    return 'define(' .. self.class.name .. ') ' .. serialize(self.name, 0, filter) .. ' ' .. serialize(self.properties, depth, filter)
end

function Component:onAdd(entity) end
function Component:onUpdate(dt)  end
function Component:onFixedUpdate(dt) end
function Component:onEvent(type, data) end

function Component:apply(component)
    for name, property in pairs(component.properties) do
        if self.properties[name] then
            self.properties[name]:set(property:get())
        else
            Log:debug("No such property whatever, fill this out if you need debug.")
        end
    end
    self:onApply(component)
end

function Component:onApply(component) end