Player = class("Player", Component)

function Player:initialize(name)
    self.speed = 600

    self.attacking = false
    self.move = Vector:new()
    self.turn = 0

    self.prev = {}
    self.prev.position = Vector:new()
    self.prev.rotation = 0

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
    self.entity.components.physics:push()
    self.prev.position = self.entity.transform.global.position



    if isClient then
        if self.entity.name ~= client.playerName then
            Log:error("WTF", self.entity.name, client.playerName)
        end
        local sync = false

        local move = Vector:new()
        local turn = 0
        if                                  love.keyboard.isDown("q") then move.x = -1 end
        if                                  love.keyboard.isDown("e") then move.x =  1 end
        if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then move.y =  1 end
        if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then move.y = -1 end
        if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then turn   = -1 end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then turn   =  1 end
        move:normalize()


        local d = 20
        move = self.move * (1 - dt * d) + move * dt * d
        turn = self.turn * (1 - dt * d) + turn * dt * d
        self.move = move
        self.turn = turn

        move = move:rotated(self.prev.rotation) * dt * self.speed
        turn = turn * dt * 4
        
        local standing = move:len() < 0.05

        if not self:getCharacter().attacking then
            self:getCharacter():setAnimation(standing and "idle" or "walk")
        end

        local rotation = self.prev.rotation + turn
        local position = self.prev.position + move
        self:setTransform(position, rotation, move:angle())

        -- lower body rotates with movement direction
        sync = (not standing) or (self.prev.rotation == nil or turn)

        -- upper body rotates to mouse
        if sync then
            client:syncTopLevelEntity(self.entity)
        end
    end    

    -- update position
    -- self.entity.transform.position = self.entity.transform.position + self.movement * self.speed * dt

    -- tell the physics we changed stuff :)
    if self.entity.components.physics then self.entity.components.physics:pull() end
end

function Player:setTransform(position, rotation, moveRotation)
    self.entity.transform.position = position
    self.entity.children.lower.transform.rotation = moveRotation or rotation
    self.entity.children.upper.transform.rotation = rotation

    self.prev.position = position
    self.prev.rotation = rotation
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
