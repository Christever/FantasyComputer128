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

---@type Input
local input

function love.load()
    print("Fantasy Computer 128")
    print("Initialisation de la machine...")

    memory = Memory.new()
    cpu    = CPU.new(memory)
    video  = Video.new(memory)
    input  = Input.new()

    video:init()
    input:init()


    -- CPUTest.run(cpu)
    -- MemoryTest.run(memory, Memory)
    VideoTest.run(video)

    input:setKey("LEFT", "q")
end

function love.update(dt)
    video:updateScreen()

    if input:wasKeyPressed("LEFT") then
        print("LEFT vient d'être pressée")
    end

    if input:wasKeyReleased("LEFT") then
        print("LEFT vient d'être relâchée")
    end

    input:update()
end

function love.draw()
    video:draw()
end

function love.keypressed(key)

end

function love.keyreleased(key)
    -- Input.keyreleased(key)
end

function love.mousepressed(x, y, btn)

end
