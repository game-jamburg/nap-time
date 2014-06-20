Transform = class("Transform", Component)

function Transform:initialize(name)
    Component.initialize(self, name)

    self.position = Vector:new(0, 0)
    self.rotation = 0
    self.scale = Vector:new(1, 1)
    -- self.global = GlobalTransform:new(self)
    self.velocity = Vector:new(0, 0)
    self.global = {velocity=Vector:new(0, 0)}

    -- create global metatable
    setmetatable(self.global, {
        __index = function(_, key)
            if key == "position" or key == "rotation" or key == "scale" then
                local p = self._parentTransform
                if not p then
                    return self[key]
                elseif key == "position" then
                    return p.global.position + self.position:permul(p.global.scale):rotated(p.global.rotation)
                elseif key == "rotation" then
                    return p.global.rotation + self.rotation
                elseif key == "scale" then
                    return p.global.scale:permul(self.scale)
                end 
            end
        end,
        __newindex = function(_, key, value)
            if key == "position" or key == "rotation" or key == "scale" then
                local p = self._parentTransform
                if not p then
                    self[key] = value
                elseif key == "position" then
                    self.position = value - p.global.position
                elseif key == "rotation" then
                    self.rotation = value - p.global.rotation
                elseif key == "scale" then
                    self.scale = value:perdiv(p.global.scale)
                end 
            end
        end
    })

    self._parentTransform = nil
    self._oldPosition = self.position:clone()
    self._oldGlobalPosition = self.global.position:clone()

    self:addProperty(Property.Vector:new(self, "position"))
    self:addProperty(Property.Number:new(self, "rotation", nil, nil, 2))
    self:addProperty(Property.Vector:new(self, "scale"))
end

function Transform:onUpdate(dt)
    if self.entity and self.entity.parent then
        self._parentTransform = self.entity.parent.components.transform
    else
        self._parentTransform = nil
    end

    if dt > 0 then
        self.velocity = (self.position - self._oldPosition) / dt
        self.global.velocity = (self.global.position - self._oldGlobalPosition) / dt
    end
    self._oldPosition = self.position:clone()
    self._oldGlobalPosition = self.global.position:clone()
end
