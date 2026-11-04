io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest", "nearest")

-- Modules System
local Memory     = require("system.memory.Memory")
local CPU        = require("system.cpu.CPU")
local Video      = require("system.video.Video")
local Input      = require("system.input.Input")
local Program    = require("system.Program")
local Palette    = require("system.video.Palette")

-- Tests
local MemoryTest = require("tests.MemoryTest")
local CPUTest    = require("tests.CPUTest")
local VideoTest  = require("tests.VideoTest")
local BasicTest  = require("tests.BasicTest")
local AudioTest  = require("tests.AudioTest")




local memory
local cpu

local video

---@type Input
local input

local program



function love.load()
    print("Fantasy Computer 128")
    print("Initialisation de la machine...")

    Palette.setColor(0, 0, 0, 0)
    Palette.setColor(1, 255, 0, 0)
    Palette.setColor(2, 0, 255, 0)
    Palette.setColor(3, 0, 0, 255)
    Palette.setColor(4, 255, 255, 255)

    memory = Memory.new()
    cpu    = CPU.new(memory)
    video  = Video.new(memory)
    input  = Input.new()

    video:init()
    input:init()
    print("Nombre de manettes :", input:getJoystickCount())
    print("Manette 1 disponible :", input:hasJoystick(1))
    program = Program.new(video)
    program:load("programs/main.lua")
end

function love.update(dt)
    input:update()
    program:update(dt)
    video:updateScreen()

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
