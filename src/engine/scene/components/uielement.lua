UiElement = class("UiElement", Drawable)

function UiElement:initialize(name, renderer)
    Drawable.initialize(self, name, renderer or engine.ui)
end
