Physics = class("Physics", Component)

function Physics:initialize(name, createShape)
    Component.initialize(self, name)
    self.createShape = createShape or function()
        return love.physics.newCircleShape(10), 0, 0, 1
    end
end

function Physics:onAdd(entity)
    local shape, dx, dy, density = self.createShape()
    dx = dx or 0
    dy = dy or 0
    density = density or 1

    self.body = love.physics.newBody(self.entity.scene.world.physicsWorld, dx, dy, "dynamic")
    self.shape = shape
    self.fixture = love.physics.newFixture(self.body, self.shape, density)

    -- self.

    local pos = entity.transform.global.position
    self.body:setPosition(pos.x, pos.y)
end

function Physics:onUpdate(dt)
    self.entity.transform.position = Vector:new(self.body:getX(), self.body:getY())
    self.entity.transform.rotation = self.body:getAngle()
end