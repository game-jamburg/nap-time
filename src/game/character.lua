Character = class("Character", Component)

function Character:initialize(name, title, health, type)
    Component.initialize(self, name)
    self.title = title
    self.health = health or 100
    self.type = type or "ninja"
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
    print(self.name .. " took " .. amount .. " damage")
    if self.health <= 0 then
        print(self.name .. " died")
    end
end

function Character:setAnimation(animation, special)
    local lower = self.entity.children.lower.components.animation
    local upper = self.entity.children.upper.components.animation

    if not lower or not upper then
        return
    end

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
