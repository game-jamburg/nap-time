Menu = class("Menu", Drawable)

function Menu:initialize(name)
    Drawable.initialize(self, name)
    
    
end

function Menu:onDraw()

    playerwantstoexit = false
    love.graphics.setColor(0,0,0)
    engine.resources.font.bold:set(30) 
    love.graphics.print("Main Menu", 300, 10)
    
   
    -- if playerwantstoexit and self.keypressed
end

function Menu:onExit()
    playerwantstoexit = true
end    
-- love.graphics.print("Do you really want to exit?", 300, 320)