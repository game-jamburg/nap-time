class = require("utils/class") -- middleclass
require("utils/vector")
require("utils/helper")
require("utils/resources")


-- love hooks

function love.init()
end

function love.update(dt)
end

function love.draw()
    love.graphics.print("Hello World", 10, 10)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end