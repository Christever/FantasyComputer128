local Logger = require "system.Logger"

---@class Animation
local Animation = {}

---@param spriteSheet SpriteSheet
---@param frames integer|integer[]
---@param lastFrameOrFps number
---@param fpsOrMode number|"loop"|"once"|nil
---@param mode nil|"loop"|"once"
---@return Animation
function Animation.new(spriteSheet, frames, lastFrameOrFps, fpsOrMode, mode)
    local actualFps
    local actualMode

    if type(frames) == "table" then
        actualFps = lastFrameOrFps
        actualMode = fpsOrMode
    else
        actualFps = fpsOrMode
        actualMode = mode
    end

    actualFps = math.floor(actualFps)
    Logger.assert(actualFps > 0, "La frequence d animation doit etre superieure a zero")

    local self = setmetatable({}, { __index = Animation })

    if type(frames) == "table" then
        self.frames = frames
    else
        self.frames = {}

        for i = frames, lastFrameOrFps do
            table.insert(self.frames, i)
        end
    end

    self.spriteSheet  = spriteSheet
    self.firstFrame   = 1
    self.lastFrame    = #self.frames
    self.fps          = actualFps
    self.mode         = actualMode or "loop"

    self.currentFrame = 1
    self.elapsed      = 0
    self.playing      = true

    return self
end

--- Démarre ou reprend l'animation.
---@return nil
function Animation:play()
    self.playing = true
end

--- Met l'animation en pause.
---@return nil
function Animation:stop()
    self.playing = false
end

--- Réinitialise l'animation à sa première image.
function Animation:reset()
    self.currentFrame = self.firstFrame
    self.elapsed = 0
end

--- Modifie la vitesse de l'animation.
---@param fps number Nouvelle fréquence en images par seconde.
function Animation:setSpeed(fps)
    fps = math.floor(fps)
    Logger.assert(fps > 0, "La frequence d animation doit etre superieure a zero")
    self.fps = fps
end

--- Met à jour l'animation.
---@param dt number Temps écoulé depuis la dernière image.
function Animation:update(dt)
    if not self.playing then
        return
    end

    self.elapsed = self.elapsed + dt

    local frameDuration = 1 / self.fps

    while self.elapsed >= frameDuration do
        self.elapsed = self.elapsed - frameDuration

        self.currentFrame = self.currentFrame + 1

        if self.currentFrame > self.lastFrame then
            if self.mode == "loop" then
                self.currentFrame = self.firstFrame
            elseif self.mode == "once" then
                self.currentFrame = self.lastFrame
                self.elapsed = 0
                self.playing = false
                break
            end
        end
    end
end

--- Récupère le sprite actuellement affiché.
---@return Sprite|nil
--- Récupère le sprite actuellement affiché.
---@return Sprite|nil
function Animation:getSprite()
    local frameIndex = self.frames[self.currentFrame]
    return self.spriteSheet:getSprite(frameIndex)
end

return Animation
