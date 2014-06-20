PropertyObject = class("PropertyObject")

function PropertyObject:initialize()
    self.properties = {}
end

function PropertyObject:update()
    for k, v in pairs(self.properties) do
        v:update()
    end
end

function PropertyObject:addProperty(property)
    self.properties[property.name] = property
end

function PropertyObject:restore() end

Property = class("Property")
function Property:initialize(obj, name)
    self.obj = obj
    self.name = name

    self.source = nil
end

function Property:set(value, suffix)
    recursive_set(self.obj, self.name .. (suffix or ""), value)
end

function Property:get(suffix)
    return recursive_get(self.obj, self.name .. (suffix or ""))
end

function Property:update()
    if self.source then
        self:set(self.source:get())
    end
end

function Property:serialize(depth)
    return serialize(self:get(), depth)
end

function define_property(name, settings, defaults, parent, parentArguments)
    parent = parent or Property
    local prop = class(name, parent)
    prop.initialize = function(self, obj, name_, ...)
        local args = {...}
        local parentArguments = parentArguments or args
        parent.initialize(self, obj, name_, unpack(parentArguments))
        for k, setting in pairs(settings or {}) do
            self[setting] = args[k] or defaults[k]
        end
    end
    return prop
end

Property.static.Number = define_property("Number", {"min", "max", "digits"}, {nil, nil, 0})
Property.static.Integer = define_property("Integer", {"min", "max"}, {nil, nil}, Property.static.Number, {nil, nil, 0})
Property.static.Boolean = define_property("Boolean")
Property.static.String = define_property("String", {"default"}, {""})
Property.static.Vector = define_property("Vector")
Property.static.Color = define_property("Color")
Property.static.Vector = define_property("Vector")
Property.static.Font = define_property("Font")
Property.static.Array = define_property("Array", {"childProperty", "minCount", "minCount"}, {Property.String:new(nil, nil), 1, nil})
Property.static.Range = define_property("Range", {"childProperty"}, {Property.Number:new(nil, nil, 0, 1, 2)})
Property.static.Enum = define_property("Enum", {"options"}, {{}})

function enum(values)
    local result = {}
    for k, v in pairs(values) do
        result[v] = v
    end
    return result
end