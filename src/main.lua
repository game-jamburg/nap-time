socket = require("socket")
tween = require("engine/external/tween")
class = require("engine/external/middleclass")
anal = require("engine/external/AnAL")
lube = require("engine/external/LUBE")

require "engine"

require "game/player"
require "game/animation"
require "game/camera"
require "game/mousegui"
require "game/level"
require "game/positionbymouse"
require "game/character"
require "game/menubutton"
require "game/network"

engine = Engine:new()

function love.load(args)
    isServer = (args[2] == "--server")

    if isServer then
        require "server"
    else
        require "client"
    end

    state = loadState()
    engine:pushState(state)
end

function love.update(dt)
    fixedupdatecheck(dt)
    tween.update(dt)
end

-- fixed timestep stuff
local fixedTimestep = 0.02
local timeSinceLastFixedUpdate = 0

function fixedupdatecheck(dt)
    timeSinceLastFixedUpdate = timeSinceLastFixedUpdate + dt
    while timeSinceLastFixedUpdate > fixedTimestep do
        timeSinceLastFixedUpdate = timeSinceLastFixedUpdate - fixedTimestep
        love.fixedupdate(fixedTimestep)
    end
end

function love.fixedupdate(dt)
end
-- end of fixed timestep stuff

engine:subscribe()
