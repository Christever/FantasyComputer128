local Memory    = require("system.memory.Memory")
local CPU       = require("system.cpu.CPU")
local Video     = require("system.video.Video")
local Input     = require("system.input.Input")
local Audio     = require("system.audio.Audio")
local Program   = require("system.Program")
local Startup   = require("system.Startup")
local Cartridge = require("system.Cartridge")
local Config    = require("system.Config")
local Logger    = require("system.Logger")
local MemoryAPI = require("api.Memory")

---@class System
---@field memory Memory
---@field cpu CPU
---@field video Video
---@field input Input
---@field program Program
---@field startup Startup|nil
---@field audio Audio
---@field cartridge Cartridge
local System    = {}
System.__index  = System

-------------------------- LOCALES -----------------------------------

--- Découpe un texte en lignes de longueur maximale.
---@param text string
---@param maxLength integer
---@return table
local function wrapText(text, maxLength)
    local lines = {}

    while #text > maxLength do
        local splitAt = maxLength

        local space = text:sub(1, maxLength):match(".*()%s")

        if space then
            splitAt = space
        end

        table.insert(lines, text:sub(1, splitAt - 1))
        text = text:sub(splitAt + 1)
    end

    table.insert(lines, text)

    return lines
end

----------------------------------------------------------------------

---@return System
function System.new()
    local self     = setmetatable({}, System)

    self.memory    = nil
    self.cpu       = nil
    self.video     = nil
    self.input     = nil
    self.program   = nil
    self.startup   = nil
    self.cartridge = nil
    self.audio     = nil

    return self
end

--- Initialise le matériel et les composants de la console.
function System:init()
    self.memory = Memory.new()
    MemoryAPI.init(self.memory)

    self.cpu            = CPU.new(self.memory)
    self.video          = Video.new(self.memory)
    self.input          = Input.new()
    self.audio          = Audio.new()
    self.cartridgeError = nil

    self.video:init()
    self.input:init()

    self.program            = Program.new(self.video)
    self.cartridge          = Cartridge.new(self.program)

    -- Gestion des raccourcis système
    self.input.onKeyPressed = function(key)
        -- F5 : redémarrage à chaud
        if key == "f5" then
            self:reset("warm")

            -- F9 : redémarrage à froid
        elseif key == "f9" then
            self:reset("cold")

            -- Échap : quitter la console
        elseif key == "escape" then
            love.event.quit()
        end
    end
end

--- Démarre la console.
---@param mode "cold"|"warm"
function System:start(mode)
    self.startup = nil

    -- Mode développeur : lancement direct du programme
    if Config.DEVELOPER_MODE then
        self.program:load(Config.PROGRAM_PATH)
        return
    end

    -- Démarrage à froid : afficher le Startup
    if mode == "cold" then
        self.startup = Startup.new()
        return
    end

    -- Démarrage à chaud : charger directement la cartouche
    if mode == "warm" then
        self.cartridge:load(Config.CARTRIDGE_PATH)
    end
end

--- Redémarre la console.
---@param mode "cold"|"warm"
function System:reset(mode)
    Logger.info("FANTASY COMPUTER 128")
    Logger.info("SYSTEM RESET")

    if mode == "warm" then
        Logger.info("BOOT MODE : WARM")
        Logger.info("RAM : PRESERVED")
    else
        Logger.info("BOOT MODE : COLD")
        Logger.info("RAM : CLEARED")
    end

    -- Arrêter le programme actuel
    self.cartridge:unload()

    -- Réinitialiser le matériel
    self.cpu:reset()
    self.video:reset()
    self.input:reset()
    self.audio:reset()

    -- Réinitialisation mémoire
    if mode == "cold" then
        self.memory:clear()
    else
        self.memory:reset()
    end

    -- Redémarrer la console
    self:start(mode)
end

function System:boot()
    Logger.init()
    Logger.info("FANTASY COMPUTER 128")
    Logger.info("SYSTEM BOOT")
    Logger.info("BOOT MODE : COLD")
    Logger.info("INITIALIZING HARDWARE...")

    self:init()
    self:start("cold")
end

--- Met à jour la console.
---@param dt number Temps écoulé depuis la dernière frame.
function System:update(dt)
    self.input:update()
    self.audio:update(dt)

    if self.startup and not self.startup.finished then
        self.startup:update(dt)
        self.startup:draw(self.video)

        if self.startup.finished then
            local success = self.cartridge:load(Config.CARTRIDGE_PATH)

            if not success then
                self.cartridgeError = self.program.errorMessage
            end
        end
    else
        self.program:update(dt)

        if not self.program.loaded and self.program.errorMessage then
            self.cartridgeError = self.program.errorMessage
        end
    end

    self.video:updateScreen()
end

--- Dessine l'image de la console.
function System:draw()
    if self.cartridgeError then
        self.video:clear(0)
        self.video:drawText(80, 60, "FANTASY COMPUTER 128", 1)
        self.video:drawText(100, 90, "CARTRIDGE ERROR", 2)
        self.video:drawText(95, 110, "CARTRIDGE FAILED", 1)
        local errorLines = wrapText(tostring(self.cartridgeError), 30)

        for i, line in ipairs(errorLines) do
            self.video:drawText(40, 135 + (i - 1) * 12, line, 12)
        end

        self.video:drawRect(30, 45, 260, 150, 2)
    end

    self.video:draw()
end

return System
