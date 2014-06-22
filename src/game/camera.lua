Camera = class("Camera", Component)

function Camera:initialize(name)
    Component.initialize(self, name)
end

function Camera:onUpdate(dt)
    -- local level = self.entity.scene.entities.level.components.level
    local pos = - self.entity.transform.global.position

    local view = View:new(View.default)
    view.translate = pos
    self.entity.scene.view = view
end
