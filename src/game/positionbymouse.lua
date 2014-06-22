PositionByMouse = class("PositionByMouse", Component)

function PositionByMouse:onUpdate(dt)
    local view = self.entity.scene.view
    local pos = view and view:toLocal(Mouse.Position) or Mouse.Position
    if pos ~= self.entity.transform.position then
       self.entity.transform.position = pos
    end
end