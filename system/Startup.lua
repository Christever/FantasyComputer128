---@class Startup
local Startup = {}
local Config = require("system.Config")

Startup.duration = Config.STARTUP_DURATION
Startup.timer = 0
Startup.finished = false


function Startup.new()
    local self = setmetatable({}, { __index = Startup })

    self.timer = 0
    self.finished = false
    self.animationTimer = 0
    self.screenInitialized = false

    return self
end

function Startup:update(dt)
    if self.finished then
        return
    end

    self.animationTimer = self.animationTimer + dt
    self.timer = self.timer + dt

    if self.timer >= self.duration then
        self.finished = true
    end
end

function Startup:draw(video)
    if not self.screenInitialized then
        video:clear(6)

        video:setColor(3)
        video:drawText(115, 65, "FANTASY 128")

        video:setColor(4)
        video:drawText(75, 95, "FANTASY COMPUTER SYSTEM")

        video:setColor(3)
        video:drawLine(65, 115, 255, 115)

        video:setColor(15)
        video:drawText(90, 135, "8-BIT VIRTUAL CONSOLE")

        self.screenInitialized = true
    end

    -- Titre principal
    video:setColor(3)
    video:drawText(115, 65, "FANTASY 128")

    -- Sous-titre
    video:setColor(4)
    video:drawText(75, 95, "FANTASY COMPUTER SYSTEM")

    -- Ligne décorative
    video:setColor(3)
    video:drawLine(65, 115, 255, 115)

    -- Informations système
    video:setColor(15)
    video:drawText(90, 135, "8-BIT VIRTUAL CONSOLE")

    -- Message de démarrage
    video:setColor(6)
    video:fillRect(112, 160, 96, 16)

    video:setColor(7)
    local dots = math.floor(self.animationTimer * 2) % 4
    local loadingText = "LOADING" .. string.rep(".", dots)
    video:drawText(120, 165, loadingText)
end

return Startup
