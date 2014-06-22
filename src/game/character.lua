Character = class("Character", Component)

function Character:initialize(name, title, health, type)
    Component.initialize(self, name)
    self.title = title
    self.health = health or 100
    self.type = type or "ninja"
    self.dead = false
    self.attacking = false
end

function Character:onAdd(entity)
    if not entity.children.upper then
        self.upper = entity:addChild(Entity:new("upper"))

        local upperAnimation = Animation:new("animation", "none")
        upperAnimation.origin = Vector:new(0.6, 0.7)
        upperAnimation.order = 2
        entity.children.upper:addComponent(upperAnimation)
    end

    if not entity.children.lower then
        self.lower = entity:addChild(Entity:new("lower"))

        local lowerAnimation = Animation:new("animation", "none")
        lowerAnimation.origin = Vector:new(0.6, 0.7)
        lowerAnimation.order = 1
        entity.children.lower:addComponent(lowerAnimation)
    end

    local shadow = ninja:addComponent(Sprite:new("shadow", "blur"))
    shadow.color = Color:new(0, 0, 0, 0.5)
    shadow.order = 1
    shadow.scaleFactor = 0.3

    if not entity.components.physics then
        self.entity:addComponent(Physics:new("physics", function() return love.physics.newCircleShape(50), 0, 0, 1 end))
    end

    local label = entity:addChild(Entity:new("label"))
    label.transform.position.y = -50
    local text = label:addComponent(Text:new("title", self.title))
    text.size = 20
    text.order = 20

    self:setAnimation("idle")
end

function Character:damage(amount)
    self.health = self.health - amount
    Log:info(self.name .. " took " .. amount .. " damage")
    if self.health <= 0 and not self.dead then
        self.dead = true
        self.entity.children.upper.components.animation = nil
        self.entity.children.lower.components.animation = nil
        self.entity.children.label.components.text = nil
        self.entity.components.shadow = nil
        self.entity.components.physics = nil

        -- Check if all characters are dead
        local piratesDead = true
        for key, entity in pairs(state.scene.entities) do
            if entity:hasComponent(Character) then
                local char = entity.components.character
                if char.type == "ninja" and char.dead then
                    engine:pushState(score)
                elseif char.type == "pirate" and not char.dead then
                    piratesDead = false
                end
            end
        end
        if piratesDead then
            engine:pushState(score)
        end


        Log:info("Character died.")
    end
end

function Character:setAnimation(animation, special)
    local lower = self.entity.children.lower.components.animation
    local upper = self.entity.children.upper.components.animation

    if not (lower and upper) then return end

    if animation == "walk" then
        local backwards = special
        lower:set(self.type .. "-walk-lower", backwards and 0.6 or 1)
        upper:set(self.type .. "-walk-upper", backwards and 0.6 or 1)
    elseif animation == "idle" then
        lower:set(self.type .. "-walk-lower", 0)
        upper:set(self.type .. "-walk-upper", 0)
    elseif animation == "slash" then
        upper:set(self.type .. "-slash-upper", 1, "once")
    end
end

function Character:strike()
    self.attacking = true
    self:setAnimation("slash")
    wait(0.033 * 13, function() self:attackEnded() end)

    for key, entity in pairs(self.entity.scene.entities) do
        if entity:hasComponent(Character) and not entity:hasComponent(Player) then
            local pos = self.entity.components.transform.position

            local otherpos = entity.components.transform.position - pos
            local otherdeg = math.atan2(otherpos.x, otherpos.y) + math.pi

            local distance = math.sqrt((otherpos.x)^2+(otherpos.y)^2)

            local mousepos = self.entity.scene.view:toLocal(Mouse.Position) - pos
            local mousedeg = math.atan2(mousepos.x, mousepos.y) + math.pi

            local degdiff = math.abs(mousedeg - otherdeg)
            local actualdiff = math.min(degdiff, (2*math.pi)-degdiff)

            if distance <= 160 and actualdiff <= 1 then
                if distance <= 105 and actualdiff <= 0.65 then
                    -- critical hit
                    entity.components.character:damage(100)
                else
                    entity.components.character:damage(50)
                end
            end
        end
    end
end

function Character:attackEnded()
    self.attacking = false
    self:setAnimation("idle")
end
