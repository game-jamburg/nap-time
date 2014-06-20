require("engine/scene/view")

World = class("World", View)

function World:initialize()
    View.initialize(self, View.default)
    self.entities = {}

    love.physics.setMeter(1)
    self.physicsWorld = love.physics.newWorld(0, 40, false)
    self.physicsWorld:setCallbacks(function(a, b, coll) self:beginContact(a, b, coll) end,
                                   function(a, b, coll) self:endContact(a, b, coll) end,
                                   function(a, b, coll) self:preSolve(a, b, coll) end,
                                   function(a, b, coll) self:postSolve(a, b, coll) end)
end

function World:add(entity)
    table.insert(self.entities, entity)
    entity.world = self
    entity:onAdd()
end

function World:clear()
    for k,v in pairs(self.entities) do
        v:kill()
    end
end

function World:remove(entity)
    entity:kill()
end

function World:handleEvent(type, data)
    for k,v in pairs(self.entities) do
        if v:onEvent(type, data) then
            return true
        end
    end
end

function World:removeDead()
    for k,v in pairs(self.entities) do
        if v.dead then
            v:onRemove()
            table.remove(self.entities, k)
            v.world = nil
            if v.physicsObject and v.physicsObject.body then
                v.physicsObject.body:destroy()
            end
        end
    end
end

function World:update(dt)
    self:removeDead()

    for k, v in pairs(self.entities) do
        v:update(dt)
    end

    self.physicsWorld:update(dt)
    table.sort(self.entities, function(a, b) return a.z > b.z end)
end

function World:draw()
    self:push()
    for k, v in pairs(self.entities) do
        v:draw()
    end
    self:pop()
end

function World:findByType(typename, matchChildren)
    l = {}
    for k, v in pairs(self.entities) do
        if (v.__name == typename) or (matchChildren and inherits(v, typename)) then
            table.insert(l, v)
        end
    end
    return l
end

-- callbacks

function World:beginContact(a, b, coll)
    local uA = a:getUserData()
    local uB = b:getUserData()

    if uA and uB then
        if not uA:onCollide(uB, coll) then
            uB:onCollide(uA, coll)
        end
    end
end

function World:endContact(a, b, coll)
end

function World:preSolve(a, b, coll)
end

function World:postSolve(a, b, coll)
end
