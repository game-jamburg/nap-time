ChatLog = class("ChatLog", UiElement)

function ChatLog:initialize(name)
    UiElement.initialize(self, name)
    
    self.position = Vector:new(10, 100)
    self.size = Vector:new(300, 160)
    
    self.font = FontFace.Default
    self.fontsize = 14

    self.lines = {}
end

function ChatLog:append(line)
    table.insert(self.lines, line)
end

function ChatLog:onUpdate(dt)
    UiElement.onUpdate(self, dt)
    self.position.x = 10
    self.position.y = Vector.WindowSize.y - 40 - self.size.y
end

function ChatLog:onDraw()
    local p = self.position
    local s = self.size

    Color:new(0, 0, 0, 0.2):set()
    -- love.graphics.rectangle("fill", p.x, p.y, s.x, s.y)

    self.font:set(self.fontsize)

    for i=0,10 do
        local line = self.lines[#self.lines-i]
        if not line then break end
        local x, y = p.x + 5, p.y + s.y - (i + 1) * 20

        love.graphics.printBorder(line, Color:new(0,0,0,0.5), Color.White, x, y)
        -- Color:new(0,0,0,0.5):set()
        -- love.graphics.print(line, x+1, y)
        -- love.graphics.print(line, x-1, y)
        -- love.graphics.print(line, x, y+1)
        -- love.graphics.print(line, x, y-1)
        -- Color.White:set()
        -- love.graphics.print(line, x, y)
    end
end