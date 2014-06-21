Character = class("Character", Component)

--[[
    
    * Entity
      > character: Character
      > shadow: Sprite
      * lower: LowerBody
        > animation: Animation
      * upper: UpperBody
        > animation: Animation

]]

function Character:initialize(name, title, health)
    Component.initialize(self, name)
    self.title = title
    self.health = health or 100
end

function Character:onAdd(entity)
    self.upper = entity:addChild(Entity:new("upper"))
    self.lower = entity:addChild(Entity:new("lower"))

    local label = entity:addChild(Entity:new("label"))
    label.transform.position.y = -50
    local text = label:addComponent(Text:new("title", self.title))
    text.size = 20
    text.order = 20
end