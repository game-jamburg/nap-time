Camera = class("Camera", Component)

function Camera:initialize(name)
    Component.initialize(self, name)
end

function Camera:onUpdate(dt)
    local view = View:new(View.default)
    view.translate = - self.entity.transform.global.position
    self.entity.scene.view = view
end
