Renderer = class("Renderer")

function Renderer:initialize()
    self.renderQueue = {}
end

function Renderer:queue(renderable, order)
    table.insert(self.renderQueue, {order, renderable})
end

function Renderer:render()
    table.sort(self.renderQueue, function(a, b) 
        return a[1] < b[1]
    end)

    for k, v in pairs(self.renderQueue) do
        v[2]:onDraw()
    end

    self.renderQueue = {}
end

