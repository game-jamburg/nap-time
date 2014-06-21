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

function Component:renderGUI()
    self:onRenderGUI()
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

function Component:serialize(depth)
    return 'define(' .. self.class.name .. ') ' .. serialize(self.name) .. ' ' .. serialize(self.properties, depth)
end

function Component:onAdd(entity) end
function Component:onUpdate(dt)  end
function Component:onFixedUpdate(dt) end
function Component:onRenderGUI() end
function Component:onEvent(type, data) end
