Lamp = class("Lamp", Component)

function Lamp:initialize(name)
    Component.initialize(self, name)

    self.radius = 512
    self.sampling = 4

    self.shadowMapData = love.image.newImageData(512, 1)
    self.shadowMap = nil
    self.stencil = love.graphics.newCanvas(self.radius * 2, self.radius * 2)
end

function Lamp:onAdd(entity)
    -- self.sprite = entity:addComponent(Sprite:new(self.name .. "_sprite", nil))
    -- self.sprite.order = 100
    -- self.sprite.scaleFactor = 1
end

function Lamp:onUpdate(dt)
    -- recompile the raycast texture
    local width = self.shadowMapData:getWidth()
    local world = self.entity.scene.world.physicsWorld
    local pos = self.entity.transform.global.position

    for i = 0, width  - 1 do
        local alpha = i * math.pi * 2 / width
        local length = self.radius * self.sampling
        local dx, dy = pos.x + math.cos(alpha) * length, pos.y - math.sin(alpha) * length

        local results = {}
        world:rayCast(pos.x, pos.y, dx, dy, function(fixture, x, y, xn, yn, fraction)
            local physicsComponent = fixture:getUserData()
            if physicsComponent then
                local entity = physicsComponent.entity

                -- ignore characters
                if entity.components.character then return 1 end
            end

            local d = math.sqrt((pos.x - x) * (pos.x - x) + (pos.y - y) * (pos.y - y))
            table.insert(results, d)
            return 1
        end)

        local smallest = self.radius * self.sampling
        for k, v in pairs(results) do
            if smallest > v then smallest = v end
        end
        local d = smallest * 1000 / self.sampling

        local r = d % 256
        local g = ((d - r) / 256) % 256
        local b = (d - g * 256) / 256 / 256

        self.shadowMapData:setPixel(i, 0, r, g, b, 255)
    end
    self.shadowMap = love.graphics.newImage(self.shadowMapData)
    -- self.shadowMap:setFilter("nearest", "nearest")
    -- self.sprite.image = self.shadowMap

    -- render stencil
    local shader = engine.resources.shader.lightmap
    shader:send("radius", self.radius)
    -- shader:send("sampling", self.sampling)
    shader:send("shadowmap", self.shadowMap)

    love.graphics.setCanvas(self.stencil)
    love.graphics.setShader(shader)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, self.radius * 2, self.radius * 2)
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- self.sprite.image = love.graphics.newImage(self.stencil:getImageData())
    -- -- self.sprite.image:setFilter("nearest", "nearest")
    -- self.sprite.scaleFactor = self.sampling
end
