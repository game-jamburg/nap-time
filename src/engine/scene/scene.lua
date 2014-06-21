Scene = class("Scene")
function Scene:initialize()
    self.entities = {}
    self.state = nil
    self.name = "unnamed_scene"
    self.view = View.default
    self.world = World:new()
end

function Scene:restore(data)
    for _, element in pairs(data) do
        if element:isInstanceOf(Entity) then
            self:addEntity(element)
        else
            Error:log("Invalid element restored into Scene:", element)
        end
    end
end

function Scene:addEntity(entity)
    if not (entity and entity:isInstanceOf(Entity)) then
        error("Scene:addEntity requires instance of Entity")
    end

    if entity.scene == self then return end

    self.entities[entity.name] = entity
    entity.scene = self
    entity:onAdd(self)
    return entity
end

function Scene:update(dt)
    self.time = self.time + dt
    self.world:update(dt) -- physics
    for k, v in pairs(self.entities) do
        v:update(dt)
    end
end

function Scene:fixedupdate(dt)
    for k, v in pairs(self.entities) do
        v:fixedupdate(dt)
    end
end

function Scene:handleEvent(type, data)
    for k, v in pairs(self.entities) do
        if v:onEvent(type, data) then return true end
    end
    return false
end

function Scene:enter()
    self.current = true
    self.time = 0
end

function Scene:leave()
    self.current = false
end

function Scene:serialize(depth)
    return 'define(Scene) ' .. serialize(self.name) .. ' ' .. serialize(self.entities, depth)
end

function Scene.static.load(filename)
    return love.filesystem.load(filename)()
end

function Scene:save(filename)
    local content = 'return ' .. serialize(self)
    local data = love.filesystem.newFileData(content, filename)
    local success, err = love.filesystem.write(filename, data)
    if success then
        Log:debug("Saved scene " .. self.name .. " to [" .. filename .. "].")
    else
        Log:error("Could not save scene " .. self.name .. " to [" .. filename .. "]: " .. err)
    end
end

function Scene:apply(scene)
    for _, entity in pairs(scene.entities) do
        if self.entities[entity.name] then
            self.entities[entity.name]:apply(entity)
        else
            self:addEntity(entity)
        end
    end
end

function Scene:updateComponent(entityName, component)
    local entity = self.entities[entityName]
    if entity then
        entity.components[component.name] = component
    else
        Log:error("Scene:updateComponent", "Component does not exist",
                  entityName, component)
    end
end
