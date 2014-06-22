MouseUI = class("MouseUI", UiElement)

function MouseUI:initialize(name, image)
    UiElement.initialize(self, name)
    
    self.image = image or nil
    self.origin = origin or Vector(0.5, 0.5)
    self.rotation = 0
    self.scale = Vector:new(1,1)
    self.position = Vector:new(0,0)
end

function MouseUI:onUpdate(dt)
    UiElement.onUpdate(self, dt)
    self.position = Mouse.Position
end

function MouseUI:onDraw()
    local img = engine.resources.image[self.image]
    if not img then return end
    
    local origin = self.origin:permul(Vector:new(img:getDimensions()))
    
    UiElement.onDraw(self)
    
    love.graphics.draw(img, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y, origin.x, origin.y)
end