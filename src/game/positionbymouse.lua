PositionByMouse = class("positionbymouse", Component)

function PositionByMouse:onUpdate(dt)
    local view = self.entity.scene.view
    local pos = view and view:toLocal(Mouse.Position) or Mouse.Position
    self.entity.transform.position = pos
end