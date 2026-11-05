io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest", "nearest")

local System = require("system.System")

local system

function love.load()
    print("Fantasy Computer 128")
    print("Initialisation de la machine...")

    system = System.new()
    system:boot()
end

function love.update(dt)
    system:update(dt)
end

function love.draw()
    system:draw()
end
