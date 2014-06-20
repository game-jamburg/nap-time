
Mouse = {}
Mouse.Position = Vector:new(0, 0)
Mouse.isDown = love.mouse.isDown

Keyboard = {}
Keyboard.isDown = love.keyboard.isDown

Keyboard.Axis = {}
Keyboard.Axis.Left = {"a", "left"}
Keyboard.Axis.Right = {"d", "right"}
Keyboard.Axis.Up = {"w", "up"}
Keyboard.Axis.Down = {"s", "down"}

Keyboard.GetAxes = function(dt)
    function anyKeyDown(keys)
        for _, key in pairs(keys) do
            if Keyboard.isDown(key) then return true end
        end
        return false
    end

    local v = Vector:new(0, 0) 
    if anyKeyDown(Keyboard.Axis.Left)   then v.x = v.x - 1 end
    if anyKeyDown(Keyboard.Axis.Right)  then v.x = v.x + 1 end
    if anyKeyDown(Keyboard.Axis.Up)     then v.y = v.y - 1 end
    if anyKeyDown(Keyboard.Axis.Down)   then v.y = v.y + 1 end

    return v:normalized() * (dt or 1)
end
