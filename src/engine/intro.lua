Intro = class("Intro", State)

function Intro:initialize()
    State.initialize(self)

    self.logo = Entity:new("logo")
    self:addEntity(self.logo)
    local sprite = self.logo:addComponent(Sprite:new("sprite", "pylone-logo.png"))
    sprite.color = Color.White:clone()
    sprite.color.a = 0
end

function Intro:postUpdate(dt)
    self.logo.transform.position = Vector.WindowSize / 2
end

function Intro:onEnter()
    self.logo.components.sprite.color.a = 0
    tween(0.5, self.logo.components.sprite.color, {a=1}, "inOutQuad", function()
        wait(1, function() 
            tween(0.5, self.logo.components.sprite.color, {a=0}, "inOutQuad", function()
                if self.current then 
                    engine:popState()
                end
            end)
        end)
    end)
end

function Intro:onEvent(type, data)
    if type == "mousepressed" or (type == "keypressed" and data.key == " ") then
        engine:popState()
    end
end
