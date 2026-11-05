io.stdout:setvbuf("no")

love.graphics.setDefaultFilter("nearest", "nearest")

-- Modules système
local Config    = require("system.Config")
local Memory    = require("system.memory.Memory")
local CPU       = require("system.cpu.CPU")
local Video     = require("system.video.Video")
local Input     = require("system.input.Input")
local Program   = require("system.Program")
local Startup   = require("system.Startup")
local Cartridge = require("system.Cartridge")
local Palette   = require("system.video.Palette")


-- Instances
local memory
local cpu
local video
local input
local program
local startup
local cartridge


-- Initialisation
function love.load()
    print("Fantasy Computer 128")
    print("Initialisation de la machine...")

    -- Matériel
    memory = Memory.new()
    cpu = CPU.new(memory)
    video = Video.new(memory)
    input = Input.new()
    input.onKeyPressed = function(key)
    if key == "f5" and not Config.DEVELOPER_MODE then
        if startup and startup.finished then
            local success = cartridge:reload()

            if success then
                print("Cartouche rechargée !")
            else
                print("Erreur lors du rechargement de la cartouche.")
            end
        end
    end
end

    video:init()
    input:init()

    -- Système de programmes
    program = Program.new(video)
    cartridge = Cartridge.new(program)

    -- Mode de fonctionnement
    if Config.DEVELOPER_MODE then
        -- Chargement direct du programme de développement
        program:load(Config.PROGRAM_PATH)
    else
        -- Démarrage normal de la console
        startup = Startup.new()
        startup:draw(video)
    end
end

-- Mise à jour
function love.update(dt)
    input:update()

    if Config.DEVELOPER_MODE then
        -- Mode développeur
        program:update(dt)
    else
        -- Mode console
        if not startup.finished then
            startup:update(dt)
            startup:draw(video)

            -- Chargement de la cartouche à la fin du démarrage
            if startup.finished then
                cartridge:load(Config.CARTRIDGE_PATH)
            end
        else
            -- Exécution de la cartouche
            program:update(dt)
        end
    end

    video:updateScreen()
end

-- Affichage
function love.draw()
    video:draw()
end

