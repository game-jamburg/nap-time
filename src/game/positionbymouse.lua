PositionByMouse = class("positionbymouse", Component)

function PositionByMouse:onUpdate(dt)
    local view = self.entity.scene.view
    local pos = view and view:toLocal(Mouse.Position) or Mouse.Position
    if pos ~= self.entity.transform.position then
       self.entity.transform.position = pos
       if isClient then
           client:syncTopLevelEntity(client.scene.entities["player"])
       end
    end
end