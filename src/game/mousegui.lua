MouseGUI = class("MouseGUI", GUIDrawable)

function MouseGUI:initialize(name, image)
    GUIDrawable.initialize(self, name)
    
    self.image = image or nil
    self.origin = origin or Vector(0.5, 0.5)
    self.rotation = 0
    self.scale = Vector:new(1,1)
    self.position = Vector:new(0,0)
end

function MouseGUI:onUpdate(dt)
    GUIDrawable.onUpdate(self, dt)
    self.position = Mouse.Position
end

function MouseGUI:onDraw()
    local img = engine.resources.image[self.image]
    if not img then return end
    
    local origin = self.origin:permul(Vector:new(img:getDimensions()))
    
    GUIDrawable.onDraw(self)
    
    love.graphics.draw(img, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y, origin.x, origin.y)
end