local Graphics  = require("api.Graphics")
local MemoryAPI = require("api.Memory")
local Logger    = require("system.Logger")
---@class Program
local Program   = {}
Program.__index = Program

function Program.new(video)
    local self  = setmetatable({}, Program)

    self.boot   = nil
    self.fan128 = nil
    self.loaded = false

    Graphics.init(video)

    return self
end

function Program:load(path)
    local chunk, errorMessage = love.filesystem.load(path)

    if not chunk then
        print("Erreur de chargement :", errorMessage)
        return false
    end

    local environment = {
        cls           = Graphics.cls,
        palette       = Graphics.palette,
        color         = Graphics.color,
        pixel         = Graphics.pixel,
        print         = Graphics.print,
        line          = Graphics.line,
        rect_fill     = Graphics.rect_fill,
        rect          = Graphics.rect,
        circle        = Graphics.circle,
        circle_fill   = Graphics.circle_fill,
        ellipse       = Graphics.ellipse,
        ellipse_fill  = Graphics.ellipse_fill,
        triangle      = Graphics.triangle,
        triangle_fill = Graphics.triangle_fill,
        polygone      = Graphics.polygone,
        polygone_fill = Graphics.polygone_fill,

        -- Accès mémoire
        peek          = MemoryAPI.peek,
        poke          = MemoryAPI.poke,

    }

    setmetatable(environment, {
        __index = _G
    })

    setfenv(chunk, environment)

    local success, result = pcall(chunk)

    if not success then
        print("Erreur d'execution :", result)
        return false
    end
    -- Initialisation de la cartouche
    if environment.BOOT then
        local bootSuccess, bootError = pcall(environment.BOOT)

        if not bootSuccess then
            print("CARTRIDGE BOOT ERROR :", bootError)
            Logger.error("CARTRIDGE BOOT ERROR : " .. tostring(bootError))
            self.fan128 = nil
            self.loaded = false
            self.errorMessage = bootError
            return false
        end
    end

    self.fan128 = environment.FAN128
    self.loaded = true

    return true
end

function Program:update(dt)
    if self.loaded and self.fan128 then
        local success, errorMessage = pcall(self.fan128)

        if not success then
            self.errorMessage = errorMessage
            self.fan128 = nil
            self.loaded = false

            print("CARTRIDGE RUNTIME ERROR :", errorMessage)
            Logger.error("CARTRIDGE RUNTIME ERROR : " .. tostring(errorMessage))
        end
    end
end

--- Arrête le programme en cours.
function Program:stop()
    self.fan128 = nil
    self.loaded = false
end

return Program
