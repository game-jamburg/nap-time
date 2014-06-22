Renderer = class("Renderer")

function Renderer:initialize()
    self.renderQueue = {}
    self.preRender = nil
end

function Renderer:queue(renderable, order)
    table.insert(self.renderQueue, {order, renderable})
end

function Renderer:render()
    table.sort(self.renderQueue, function(a, b) 
        return a[1] < b[1]
    end)

    for k, v in pairs(self.renderQueue) do
        if self.preRender then
            self.preRender(v[2])
        end
        v[2]:onDraw()
    end

    self.renderQueue = {}
end

