World = class("World")

function World:initialize()
    love.physics.setMeter(64)
    self.physicsWorld = love.physics.newWorld(0, 64*9.81, false)
    self.physicsWorld:setCallbacks(function(a, b, coll) self:beginContact(a, b, coll) end,
                                   function(a, b, coll) self:endContact(a, b, coll) end,
                                   function(a, b, coll) self:preSolve(a, b, coll) end,
                                   function(a, b, coll) self:postSolve(a, b, coll) end)
end

function World:update(dt)
    self.physicsWorld:update(dt)
end

function World:beginContact(a, b, coll)
    local uA = a:getUserData()
    local uB = b:getUserData()

    if uA and uB then
        if not uA:onCollide(uB, coll) then
            uB:onCollide(uA, coll)
        end
    end
end

function World:endContact(a, b, coll)
end

function World:preSolve(a, b, coll)
end

function World:postSolve(a, b, coll)
end


function World:debugDraw()
    local bodies = self.physicsWorld:getBodyList()
    for b=#bodies,1,-1 do
        local body = bodies[b]
        local bx,by = body:getPosition()
        local bodyAngle = body:getAngle()
        love.graphics.push()
        love.graphics.translate(bx,by)
        love.graphics.rotate(bodyAngle)

    local fixtures = body:getFixtureList()
    for i=1,#fixtures do
        local fixture = fixtures[i]
        local shape = fixture:getShape()
        local shapeType = shape:getType()
        local isSensor = fixture:isSensor()
        local isSleeping = not body:isAwake()

        if isSensor then
            love.graphics.setColor(255,255,0,96)
        elseif isSleeping then
            love.graphics.setColor(255,0,0,255)
        else
            love.graphics.setColor(0, 255,0,255)
        end

        love.graphics.setLineWidth(1)
        if (shapeType == "circle") then
            local x,y = fixture:getMassData() --0.9.0 missing circleshape:getPoint()
            --local x,y = shape:getPoint() --0.9.1
            local radius = shape:getRadius()
            love.graphics.circle("line",x,y,radius)
        elseif (shapeType == "polygon") then
            local points = {shape:getPoints()}
            love.graphics.polygon("fill",points)
            love.graphics.setColor(0,0,0,255)
            love.graphics.polygon("line",points)
        elseif (shapeType == "edge") then
            love.graphics.setColor(0,0,0,255)
            love.graphics.line(shape:getPoints())
            elseif (shapeType == "chain") then
                love.graphics.setColor(0,0,0,255)
                love.graphics.line(shape:getPoints())
            end
        end
        love.graphics.pop()
    end

    local joints = self.physicsWorld:getJointList()
    for index,joint in pairs(joints) do
        love.graphics.setColor(0,255,0,255)
        local x1,y1,x2,y2 = joint:getAnchors()
        if (x1 and x2) then
            love.graphics.setLineWidth(3)
            love.graphics.line(x1,y1,x2,y2)
        else
            love.graphics.setPointSize(3)
            if (x1) then
                love.graphics.point(x1,y1)
            end
            if (x2) then
                love.graphics.point(x2,y2)
            end
        end
    end

    local contacts = self.physicsWorld:getContactList()
    for i=1,#contacts do
        love.graphics.setColor(255,0,0,255)
        love.graphics.setPointSize(3)
        local x1,y1,x2,y2 = contacts[i]:getPositions()
        if (x1) then
            love.graphics.point(x1,y1)
        end
        if (x2) then
            love.graphics.point(x2,y2)
        end
    end
end
