Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 600

    self.attacking = false
    self.movement = Vector:new()
    self.previousAngle = nil
    self.lastMouse = Vector:new()

    Component.initialize(self, name)
end

function Player:onAdd(entity)
    if not self.entity.components.camera then
        self.entity:addComponent(Camera:new("camera"))
        self.entity:addComponent(Lamp:new("lamp"))
    end
end

function Player:getCharacter()
    return self.entity.components.character
end
 
function Player:onFixedUpdate(dt)
    if isClient then
        if self.entity.name ~= client.playerName then
            Log:error("WTF", self.entity.name, client.playerName)
        end
        local sync = false

        local input = Vector:new()
        if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then input.x = -1 end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then input.x =  1 end
        if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then input.y =  1 end
        if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then input.y = -1 end
        input:normalize()

        local ms = 20
        self.movement = self.movement * (1 - dt * ms) + input * dt * ms
        
        local standing = self.movement:len() < 0.05
        if standing then
            self.movement = Vector:new()
        end

        if not self:getCharacter().attacking then
            self:getCharacter():setAnimation(standing and "idle" or "walk")
        end

        -- lower body rotates with movement direction
        if not standing then
            self.entity.children.lower.transform.rotation = self.movement:angle()
            sync = true
        end

        -- upper body rotates to mouse
        local view = self.entity.scene.view
        local mouse = view and view:toLocal(Mouse.Position) or Mouse.Position
        local lookDirection = mouse - self.entity.transform.position
        local angle = lookDirection:angle()
        if self.previousAngle == nil or angle ~= self.previousAngle then
            self.entity.children.upper.transform.rotation = angle
            sync = true
        end
        self.previousAngle = angle
        if sync then
            client:syncTopLevelEntity(self.entity)
        end
    end    

    -- update position
    self.entity.transform.position = self.entity.transform.position + self.movement * self.speed * dt

    -- tell the physics we changed stuff :)
    if self.entity.components.physics then self.entity.components.physics:pull() end
end

function Player:onEvent(type, data)
    if type == "mousereleased" and data.button == "l" and not self.attacking and not self:getCharacter().dead then
        self:getCharacter():sendRpc("strike")
        self:getCharacter():strike()
    elseif type == "keypressed" then
        if data.key == " " then
            self:getCharacter().type = (self:getCharacter().type == "ninja") and "pirate" or "ninja"
        end
    end
end
