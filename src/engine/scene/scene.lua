Scene = class("Scene")
function Scene:initialize()
    self.entities = {}
    self.state = nil
    self.name = "unnamed_scene"
    self.view = View.default
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
    if entity.scene then
        entity.scene:removeEntity(entity)
    end

    table.insert(self.entities, entity)
    entity:onAdd(self)
    return entity
end

function Scene:update(dt)
    self.time = self.time + dt
    for k, v in pairs(self.entities) do
        v:update(dt)
    end
end

function Scene:fixedupdate(dt)
    for k, v in pairs(self.entities) do
        v:fixedupdate(dt)
    end
end

function Scene:renderGUI()
    for k, v in pairs(self.entities) do
        v:renderGUI()
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


function Scene:getRootEntities()
    local root = {}
    for k, v in pairs(self.entities) do
        if not v.parent then
            table.insert(root, v)
        end    
    end
    return root
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
