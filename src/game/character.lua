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

        self.upperAnimation = Animation:new("animation", "none")
        self.upperAnimation.origin = Vector:new(0.6, 0.7)
        self.upperAnimation.order = 2
        entity.children.upper:addComponent(self.upperAnimation)
    end

    if not entity.children.lower then
        self.lower = entity:addChild(Entity:new("lower"))

        self.lowerAnimation = Animation:new("animation", "none")
        self.lowerAnimation.origin = Vector:new(0.6, 0.7)
        self.lowerAnimation.order = 1
        entity.children.lower:addComponent(self.lowerAnimation)
    end

    if not entity.components.physics then
        self.entity:addComponent(Physics:new("physics", function() return love.physics.newCircleShape(30), 0, 0, 1 end))
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
    if animation == "walk" then
        local backwards = special
        self.lowerAnimation:set(self.type .. "-walk-lower", backwards and 0.6 or 1)
        self.upperAnimation:set(self.type .. "-walk-upper", backwards and 0.6 or 1)
    elseif animation == "idle" then
        self.lowerAnimation:set(self.type .. "-walk-lower", 0)
        self.upperAnimation:set(self.type .. "-walk-upper", 0)
    elseif animation == "slash" then
        self.upperAnimation:set(self.type .. "-slash-upper", 1, "once")
    end
end