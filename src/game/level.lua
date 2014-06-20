Level = class("Level", Component)

function Level:initialize(name)
    Component.initialize(self, name)

    self.sprite = Sprite:new("background", "ship")
    self.sprite.order = -1
end

function Level:onAdd(entity)
    self.entity:addComponent(self.sprite)
end