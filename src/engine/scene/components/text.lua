Text = class("Text", Drawable)

function Text:initialize(name, text, font, size, color, align)
    Drawable.initialize(self, name)
    self.text   = text or ""
    self.font   = font or FontFace.Default
    self.size   = size or nil
    self.color  = color or Color.White
    self.verticalAlign = "center"
    self.horizontalAlign = "center"

    self:addProperty(Property.String:new(self, "text"))
    self:addProperty(Property.Integer:new(self, "size"))
    self:addProperty(Property.Color:new(self, "color"))
    self:addProperty(Property.Enum:new(self, "verticalAlign", ALIGNS_VERTICAL))
    self:addProperty(Property.Enum:new(self, "horizontalAlign", ALIGNS_HORIZONTAL))
    -- self:addProperty(Property.Font:new(self, "font"))
end

function Text:onDraw()
    -- fetch transform
    local position = self.entity and self.entity.transform.global.position or Vector:new(0, 0) - offset
    local rotation = self.entity and self.entity.transform.global.rotation or 0
    local scale    = Vector:new(1, 1) -- self.entity and self.entity.transform.global.scale or Vector:new(1, 1)

    -- fetch alignment from string
    local aligns = {left=0, center=0.5, right=1, top=0, bottom=1}
    local alignFactor = Vector:new(aligns[self.horizontalAlign] or 0, aligns[self.verticalAlign] or 0)

    -- calculate alignment offset
    local dimensions = self.font:getDimensions(self.size, self.text)
    local offset = dimensions:permul(alignFactor)

    -- apply alignment offset to position
    position = position - offset:rotated(rotation)

    -- draw
    Drawable.onDraw(self)
    self.color:set()
    self.font:set(self.size)
    love.graphics.print(self.text, position.x, position.y, rotation)
end