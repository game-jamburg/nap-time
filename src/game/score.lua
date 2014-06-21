Score = class("Score", Drawable)

function Score:initialize(name, players,team)
    Drawable.initialize(self, name)
    self.team = team
    self.players = players
    self.round = 3

    -- self:addProperty(Property.Vector:new(self, "size"))
    -- self:addProperty(Property.Color:new(self, "color"))
end

function Score:onDraw()
    -- player liste sortieren

    table.sort(self.players,function(a,b) return a[2] > b[2] end)    


    for number,player in pairs(self.players) do
        if self.round < 4 then
            love.graphics.setColor(0,0,0)
            FontFace.Default:set(50)
            love.graphics.print("The " .. self.team .. " won!", Vector.WindowSize.x/2 -200,30)
           
            if player[3] then
                love.graphics.setColor(100,50,50)
            else 
                love.graphics.setColor(0,0,0)
            end
         else 
            local winner = "The winner is " .. self.players[1][1] .. ". Congratulations!"
            local dim = FontFace.Default:getDimensions(30, winner)

            FontFace.Default:set(30)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(winner, Vector.WindowSize.x / 2 - dim.x / 2, 30)
        end
        FontFace.Default:set(30)
        love.graphics.print(player[1], 50, 70 + number*30)
        love.graphics.print(player[2], 300, 70 + number*30)

    end
    -- love.graphics.print(self.players[1][1], 50, 70)
    -- love.graphics.print(self.players[2], 50, 100)
    -- love.graphics.print(self.players[3], 50, 130)
    -- love.graphics.print(self.players[4], 50, 160)
    -- love.graphics.print(self.players[5], 50, 190)

end
