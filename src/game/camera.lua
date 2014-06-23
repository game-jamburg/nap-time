Camera = class("Camera", Component)

function Camera:initialize(name)
    Component.initialize(self, name)
end

function Camera:onUpdate(dt)
    -- local level = self.entity.scene.entities.level.components.level
    local pos = - self.entity.transform.global.position
    local rot = - self.entity.children.lower.transform.global.rotation

    local view = View:new()
    local view2 = View:new(view)
    view2.translate = pos
    view.rotation = rot
    view.translate = Vector:new(Vector.WindowSize.x / 2, Vector.WindowSize.y * 0.7)
    self.entity.scene.view = view2
end
