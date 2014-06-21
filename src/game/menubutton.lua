MenuButton = class("MenuButton", GUIDrawable)

function MenuButton:initialize(name)
    GUIDrawable.initialize(self, name)
    
    self.position = Vector:new(0,0)
    self.size = Vector:new(200,30)
    
    self.text = "BUTTON"
    self.hover = false
    self.click = nil
    self.wasDown = false

    self.font = FontFace.Default
    self.fontsize = 32
end

function MenuButton:onUpdate(dt)
    GUIDrawable.onUpdate(self, dt)
    
    self.hover = false
    if Mouse.Position.x >= self.position.x and Mouse.Position.x <= self.position.x + self.size.x then
        if Mouse.Position.y >= self.position.y and Mouse.Position.y <= self.position.y + self.size.y then
            self.hover = true
        end
    end
    
    if self.hover and love.mouse.isDown("l") and not self.wasDown and self.click then
        self:click()
    end
    
    self.wasDown = love.mouse.isDown("l")
end

function MenuButton:onDraw()
    self.font:set(self.fontsize)
    
    love.graphics.print(self.text, self.position.x, self.position.y, 0)
end