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
end