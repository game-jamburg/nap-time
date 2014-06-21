Physics = class("Physics", Component)

function Physics:initialize(name, createShape)
    Component.initialize(self, name)
    self.createShape = createShape or function()
        return love.physics.newCircleShape(10), 0, 0, 1
    end
end

function Physics:pull()
    local pos = self.entity.transform.global.position
    self.body:setPosition(pos.x, pos.y)
    self.body:setAngle(self.entity.transform.global.rotation)
end

function Physics:onAdd(entity)
    local shape, dx, dy, density = self.createShape()

    local pos = self.entity.transform.global.position
    dx = (dx or 0) + pos.x
    dy = (dy or 0) + pos.y
    density = density or 1

    self.body = love.physics.newBody(self.entity.scene.world.physicsWorld, dx, dy, "dynamic")
    self.shape = shape
    self.fixture = love.physics.newFixture(self.body, self.shape, density)
end

function Physics:onUpdate(dt)
    self.entity.transform.position = Vector:new(self.body:getX(), self.body:getY())
    self.entity.transform.rotation = self.body:getAngle()
end