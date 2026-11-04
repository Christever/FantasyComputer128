io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest", "nearest")

-- Modules System
local Memory     = require("system.memory.Memory")
local CPU        = require("system.cpu.CPU")
local Video      = require("system.video.Video")
local Input      = require("system.input.Input")

-- Tests
local MemoryTest = require("system.memory.MemoryTest")
local CPUTest    = require("system.cpu.CPUTest")
local VideoTest  = require("system.video.VideoTest")




local memory
local cpu
---@type Video
local video

function love.load()
    print("Fantasy Computer 128")
    print("Initialisation de la machine...")

    memory = Memory.new()
    cpu    = CPU.new(memory)
    video  = Video.new(memory)

    video:init()


    -- CPUTest.run(cpu)
    -- MemoryTest.run(memory, Memory)
    VideoTest.run(video)
end

function love.update(dt)
    video:updateScreen()
    if Input.isKeyDown("right") then
        print("Droite maintenue")
    end
end

function love.draw()
    video:draw()
end

function love.keypressed(key, isrepeat)

end

function love.mousepressed(x, y, btn)

end
