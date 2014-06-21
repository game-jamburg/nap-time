require("engine/util/vector")

View = class("View")
function View:initialize(parent, translate, scale, rotation)
    self.parent     = parent    or nil
    self.translate  = translate or Vector:new(0, 0)
    self.scale      = scale     or Vector:new(1, 1)
    self.rotation   = rotation  or 0
    self.isPushed   = false
end

View.static.currentView = nil
View.static.default = View:new()

function View.static.makeDefaultView(windowSize, size)
    View.default.translate = windowSize * 0.5 
    View.default.scale = Vector:new(1/windowSize.y, 1/windowSize.y) * size
end

function View.static.popUntil(view)
    local current = View.currentView
    while current and current ~= view do
        current = current:pop()
        print("Popped until...")
    end
    return current == view
end

function View.static.popAll()
    local current = View.currentView
    while current do
        current = current:pop()
    end
end

-- after push(), the stack has changed to this view, and applied the parent views
-- correctly
function View:push()
    if View.currentView == self then return end

    View.popUntil(self.parent)
    if self.parent and not self.parent.isPushed then
        self.parent:push()
    end

    love.graphics.push()
    View.currentView = self
    self.isPushed = true

    love.graphics.translate(self.translate.x, self.translate.y)
    love.graphics.scale(self.scale.x, self.scale.y)
    love.graphics.rotate(self.rotation)
end

-- returns the new active view (the parent)
function View:pop()
    if View.currentView ~= self then
        print("Error: View.pop() can only be called on current view. Best not call it yourself.")
    elseif not self.isPushed then
        print("Error: View.pop() can only be called on pushed view. Best not call it yourself.")
    else
        love.graphics.pop()
        View.currentView = self.parent
        self.isPushed = false
        return self.parent
    end
end

function View:toLocal(p)
    if self.parent then p = self.parent:toLocal(p) end
    p = ((p - self.translate) / self.scale):rotated(-self.rotation)
    return p
end

function View:toGlobal(p)
    p = p:rotated(self.rotation) * self.scale + self.translate
    if self.parent then p = self.parent:toGlobal(p) end
    return p
end

function View:getGlobalScale()
    if self.parent then 
        return self.scale:permul(self.parent:getGlobalScale())
    else
        return self.scale
    end
end
