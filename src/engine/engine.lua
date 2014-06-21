Engine = class("Engine")

Time = {}
Time.Delta = 0
Time.Global = 0
Time.Frame = 0

function Engine:initialize()
    math.randomseed(os.time())

    self.states = {}
    self.renderer = Renderer:new()
    self.guirenderer = Renderer:new()
    self.resources = Resources()

    self:updateGlobals(0)

    love.filesystem.setIdentity("pylone-engine")
end

function Engine:pushState(state)
    if #self.states > 0 then self:getCurrentState():leave() end
    table.insert(self.states, state)
    state:enter()
end

function Engine:getCurrentState()
    return self.states[#self.states]
end

function Engine:popState()
    local s = self:getCurrentState()
    s:leave()
    self.states[#self.states] = nil
    if #self.states > 0 then self:getCurrentState():enter() end
    return s
end

function Engine:hasState()
    return #self.states > 0
end


function Engine:updateGlobals(dt)
    -- update window size
    Vector.WindowSize.x = love.graphics.getWidth()
    Vector.WindowSize.y = love.graphics.getHeight()
    
    View.makeDefaultView(Vector.WindowSize, 500)

    -- update mouse position
    Mouse.Position.x = love.mouse.getX()
    Mouse.Position.y = love.mouse.getY()

    -- update time
    Time.Delta = dt
    Time.Global = Time.Global + dt
    Time.Frame = Time.Frame + 1
end

function Engine:update(dt) 
    self:updateGlobals(dt)

    if self:hasState() then
        self:getCurrentState():update(dt)
    else
        love.event.push("quit")
    end
end

function Engine:fixedupdate(dt) 
    self:getCurrentState():fixedupdate(dt)
end

function Engine:draw() 
    local view = self:getCurrentState().scene.view
    view:push()
    self.renderer:render()
    self:getCurrentState().scene.world:debugDraw()
    View:popAll()
    self:renderGUI()
end

function Engine:renderGUI()
    Color.White:set()
    self.guirenderer:render()
end

function Engine:handleEvent(type, data) 
    if self:hasState() then
        self:getCurrentState():handleEvent(type, data)
    end
end

function Engine:subscribe()
    local update = love.update
    love.update = function(dt)
        if update then update(dt) end
        self:update(dt)
    end

    local fixedupdate = love.fixedupdate
    love.fixedupdate = function(dt)
        if fixedupdate then fixedupdate(dt) end
        self:fixedupdate(dt)
    end

    local draw = love.draw
    love.draw = function()
        if draw then draw() end
        self:draw()
    end

    local touchpressed = love.touchpressed
    love.touchpressed = function(id, x, y, p)
        if touchpressed then touchpressed(id, x, y, p) end
        local data = {id=id, x=x*WIDTH, y=y*HEIGHT, p=p}
        self:handleEvent("touchpressed", data)
    end

    local touchmoved = love.touchmoved
    love.touchmoved = function(id, x, y, p)
        if touchmoved then touchmoved(id, x, y, p) end
        local data = {id=id, x=x*WIDTH, y=y*HEIGHT, p=p}
        self:handleEvent("touchmoved", data)
    end

    local touchreleased = love.touchreleased
    love.touchreleased = function(id, x, y, p)
        if touchreleased then touchreleased(id, x, y, p) end
        local data = {id=id, x=x*WIDTH, y=y*HEIGHT, p=p}
        self:handleEvent("touchreleased", data)
    end

    local mousepressed = love.mousepressed
    love.mousepressed = function(x, y, button)
        if mousepressed then mousepressed(x, y, button) end
        self:handleEvent("mousepressed", {x=x, y=y, button=button})
    end

    local mousereleased = love.mousereleased
    love.mousereleased = function(x, y, button)
        if mousereleased then mousereleased(x, y, button) end
        self:handleEvent("mousereleased", {x=x, y=y, button=button})
    end

    local keypressed = love.keypressed
    love.keypressed = function(key)
        if keypressed then keypressed(key) end
        if key == "escape" then
            love.event.quit()
        end
        self:handleEvent("keypressed", {key=key})
    end

    local keyreleased = love.keyreleased
    love.keyreleased = function(key)
        if keyreleased then keyreleased(key) end
        self:handleEvent("keyreleased", {key=key})
    end

    local textinput = love.textinput
    love.textinput = function(t)
        if textinput then textinput(t) end
        self:handleEvent("textinput", {t=t})
    end
end



