MenuButton = class("MenuButton", UiElement)

function MenuButton:initialize(name)
    UiElement.initialize(self, name)
    
    self.position = Vector:new(0,0)
    self.size = Vector:new(200,30)
    
    self.text = "Click me"
    self.hover = false
    self.click = nil

    self.font = FontFace.Default
    self.fontsize = 20
end

function MenuButton:onUpdate(dt)
    UiElement.onUpdate(self, dt)
    
    self.hover = false
    if Mouse.Position.x >= self.position.x and Mouse.Position.x <= self.position.x + self.size.x then
        if Mouse.Position.y >= self.position.y and Mouse.Position.y <= self.position.y + self.size.y then
            self.hover = true
        end
    end
    
    if self.hover and love.mouse.isDown("l") and not wasDown then
        self:click()
    end
    
    wasDown = love.mouse.isDown("l")
end

function MenuButton:onDraw()
    local p = self.position
    local s = self.size
    local c = p + s / 2

    if self.hover then
        Color.White:set()
    else
        Color:new(0.9, 0.9, 0.9):set()
    end

    love.graphics.rectangle("fill", p.x, p.y, s.x, s.y)

    local d = self.font:getDimensions(self.fontsize, self.text)

    Color.Black:set()
    self.font:set(self.fontsize)
    love.graphics.print(self.text, c.x - d.x / 2, c.y - d.y / 2)
end