Character = class("Character", Component)

function Character:initialize(name, title, health)
    Component.initialize(self, name)
    self.title = title
    self.health = health or 100
end

function Character:onAdd(entity)
    if not entity.children.upper then
        self.upper = entity:addChild(Entity:new("upper"))
    end
    if not entity.children.lower then
        self.lower = entity:addChild(Entity:new("lower"))
    end

    local label = entity:addChild(Entity:new("label"))
    label.transform.position.y = -50
    local text = label:addComponent(Text:new("title", self.title))
    text.size = 20
    text.order = 20
end
