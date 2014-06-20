Entity = class("Entity")

function Entity:initialize(name)
    if not name then
        error("Entity needs a name")
    end
    self.name = name
    self.components = {}
    self.typedComponents = {}
    self.parent = nil
    self.children = {}

    self.transform = self:addComponent(Transform:new("transform"))
end

function Entity:restore(data)
    for _, element in pairs(data) do
        if element:isInstanceOf(Entity) then
            self:addChild(element)
        elseif element:isInstanceOf(Component) then
            self:addComponent(element)
        else
            Log:error("Invalid element type in Entity data:", element)
        end
    end
    self.transform = self.components.transform
end

function Entity:update(dt)
    for i, component in pairs(self.components) do
        component:update(dt)
    end
end

function Entity:fixedupdate(dt)
    for i, component in pairs(self.components) do
        component:fixedupdate(dt)
    end
end

function Entity:onEvent(type, data) 
    for i, component in pairs(self.components) do
        if component:onEvent(type, data) then return true end
    end
end

function Entity:addComponent(component)
    if not (component and component:isInstanceOf(Component)) then
        error("Entity:addComponent requires instance of Component")
    end
    self.components[component.name] = component
    
    if not self.typedComponents[component.class]then
        self.typedComponents[component.class] = {}
    end
    table.insert(self.typedComponents[component.class], component)
    
    component:added(self)
    return component
end

function Entity:onAdd(state)
    self.state = state
    for _, child in pairs(self.children) do
        state:addEntity(child)
    end
end

function Entity:addChild(entity)
    if self.state then
        self.state:addEntity(entity)
    end
    entity.parent = self
    table.insert(self.children, entity)
end

function Entity:detach()
    if not self.parent then
        print("Warning: detaching Entity without parent")
        return
    end
    self.parent = nil
end

function Entity:serialize(depth)
    return 'define(Entity) ' .. serialize(self.name) .. ' ' .. serialize(self.components, depth)
end
