Level = class("Level", Component)

function Level:initialize(name)
    Component.initialize(self, name)

    self.sprite = Sprite:new("background", "level01")
    self.sprite.order = -1

    local mesh = engine.resources.text.level01
    self.paths = loadstring("return " .. mesh, "level01.mesh")()
end

function Level:onAdd(entity)
    self.entity:addComponent(self.sprite)

    -- create physics body
    self.body = love.physics.newBody(self.entity.scene.world.physicsWorld, 0, 0, "static")
    for _, path in pairs(self.paths) do
        for i=1,#path-1 do
            local p1 = path[i]
            local p2 = path[i+1]
            local shape = love.physics.newEdgeShape(p1[1], p1[2], p2[1], p2[2])
            local fixture = love.physics.newFixture(self.body, shape, 1)
        end
    end
end