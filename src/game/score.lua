Score = class("Score", Drawable)

function Score:initialize(name, players, team)
    Drawable.initialize(self, name)
    self.team = team
    self.players = players
    self.round = 0
end

function Score:enter()
    self.round = self.round + 1
    for number,player in pairs(self.players) do
        if self.team == "pirate" and player[3] then
            self.players[number][2] = player[2] + 1
        elseif self.team == "ninja" and not player[3] then
            self.players[number][2] = player[2] + 3
        end
    end

    -- player liste sortieren
    table.sort(self.players,function(a,b) return a[2] > b[2] end)    
end


function Score:onDraw()
    engine.resources.font.bold:set(50)

    local winner = (self.team == "pirate") and "Pirates" or "Ninja"
    love.graphics.print("The " .. winner .. " won!", Vector.WindowSize.x/2 -200,30)

    FontFace.Default:set(30)

    for number, player in pairs(self.players) do
        if self.round < 4 then
            love.graphics.setColor(230,230,230)
           
            if player[3] then
                love.graphics.setColor(100,50,50)
            else 
                love.graphics.setColor(255,255,255)
            end
         else 
            local winner = "The winner is " .. self.players[1][1] .. "! Congratulations!"
            local dim = FontFace.Default:getDimensions(30, winner)

            love.graphics.setColor(230,230,230)
            love.graphics.print(winner, Vector.WindowSize.x / 2 - dim.x / 2, 30)
        end

        love.graphics.print(player[1], 50, 90 + number*30)
        love.graphics.print(player[2], 300, 90 + number*30)
    end
end

