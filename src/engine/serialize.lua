function define(Type) 
    if not Type then
        Log:error("Cannot define type " .. tostring(Type) .. ". Class not found.")
        return function(name) return function(data) return nil end end
    end
    if not Type.restore then
        Log:error("Cannot define type " .. tostring(Type) .. ". Define method " .. tostring(Type) .. ":restore(data) first.")
        return function(name) return function(data) return nil end end
    end
    return function(name)
        return function(data)
            local instance = Type:new(name)
            instance:restore(data)
            return instance
        end
    end
end

function isValidSymbol(s)
    return string.match(s, '^[A-Za-z_][A-Za-z0-9_]*$') ~= nil
end

function string.times(input, count)
    local out = ""
    for i=1,count do
        out = out .. input
    end
    return out
end

function serialize(obj, depth)
    depth = depth or 0
    indent = "    "

    local result = ''

    if type(obj) == "number" then
        result = tostring(obj)
    elseif type(obj) == "string" then
        if obj:match("\n") and not obj:match("]]") and not obj:match("]$") then
            result = '[[' .. obj .. ']]'
        else
            result = '"' .. obj:gsub('"', '\\"'):gsub('\n', '\\n') .. '"'
        end
    elseif type(obj) == nil or obj == nil then
        result = 'nil'
    elseif type(obj) == "boolean" then
        result = obj and 'true' or 'false'
    elseif type(obj) == "table" then
        if obj.serialize and type(obj.serialize == "function") then
            result = obj:serialize(depth)
        elseif obj.isInstanceOf and obj:isInstanceOf(class.Object) then
            Log:error("Cannot serialize object of type " .. tostring(obj.class) .. ". Please implement the " .. tostring(obj.class) .. " :serialize() method.")
            return ""
        else
            result = '{\n'
            for k, v in pairs(obj) do
                result = result .. string.times(indent, depth + 1)
                if type(k) == "string" and isValidSymbol(k) then
                    result = result .. k .. ' = ' .. serialize(v, depth + 1) .. ', \n'
                else
                    result = result .. '[ ' .. serialize(k) .. ' ] = ' .. serialize(v, depth + 1) .. ', \n'
                end
            end
            result = result .. string.times(indent, depth) .. '}'
        end
    else
        Log:error("Unable to serialize object", obj)
        return "{}"
    end

    return result
end
