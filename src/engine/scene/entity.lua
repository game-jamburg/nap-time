Entity = class("Entity")

function Entity:initialize(name)
    if not name then
        error("Entity needs a name")
    end
    self.name = name
    self.components = {}
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
            Log:error("Invalid type in entity child list: " .. element)
        end
    end

    -- hacky
    self.transform = self.components.transform
end

function Entity:update(dt)
    for i, component in pairs(self.components) do
        component:update(dt)
    end
    for i, child in pairs(self.children) do
        child:update(dt)
    end
end

function Entity:fixedupdate(dt)
    for i, component in pairs(self.components) do
        component:fixedupdate(dt)
    end
    for i, child in pairs(self.children) do
        child:fixedupdate(dt)
    end
end

function Entity:onEvent(type, data) 
    for i, component in pairs(self.components) do
        if component:onEvent(type, data) then return true end
    end
    for i, child in pairs(self.children) do
        if child:onEvent(type, data) then return true end
    end
end

function Entity:addComponent(component)
    if not (component and component:isInstanceOf(Component)) then
        error("Entity:addComponent requires instance of Component")
    end
    self.components[component.name] = component

    -- this is the only hard link
    if component.name == "transform" then
        self.transform = component
    end
    
    component:added(self)
    return component
end

function Entity:removeComponent(componentName)
    self.components[componentName] = nil
end

function Entity:hasComponent(class)
    for key, component in pairs(self.components) do
        if component:isInstanceOf(class) then return true end
    end
    return false
end

function Entity:onAdd(scene)
    self.scene = scene
    for _, child in pairs(self.children) do
        child:onAdd(scene)
    end
end

function Entity:addChild(entity)
    entity.parent = self
    self.children[entity.name] = entity
    if self.scene then
        entity:onAdd(self.scene)
    end
    return entity
end

function Entity:detach()
    if not self.parent then
        print("Warning: detaching Entity without parent")
        return
    end
    self.parent = nil
end

function Entity:serialize(depth)
    local elements = {}
    for i, component in pairs(self.components) do
        table.insert(elements, component)
    end
    for i, child in pairs(self.children) do
        table.insert(elements, child)
    end

    return 'define(Entity) ' .. serialize(self.name, 0, filter) .. ' ' .. serialize(elements, depth, filter)
end

function Entity:apply(entity, insert)
    Log:verbose("Apply entity", self.name)

    for _, child in pairs(entity.children) do
        if self.children[child.name] then
            self.children[child.name]:apply(child, insert)
        elseif insert then
            self:addChild(child)
        end
    end
    
    for _, component in pairs(entity.components) do
        if self.components[component.name] then
            self.components[component.name]:apply(component)
        elseif insert then
            self:addComponent(component)
        end
    end

end
