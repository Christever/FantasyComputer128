local Sprite      = require("system.video.Sprite")
local Palette     = require("system.video.Palette")
local SpriteSheet = require("system.video.SpriteSheet")
local Animation   = require("system.video.Animation")
local Logger      = require("system.Logger")

---@class Graphics
local Graphics    = {}


---@param video Video
---@param animationManager AnimationManager
function Graphics.init(video, animationManager)
    Graphics.video = video
    Graphics.animationManager = animationManager
end

----------------------  SPRITES --------------------------------

--- Crée un nouveau sprite.
---@param width number Largeur du sprite.
---@param height number Hauteur du sprite.
---@param colorIndex number|nil Couleur initiale.
---@return Sprite
function Graphics.sprite(width, height, colorIndex)
    return Sprite.new(width, height, colorIndex)
end

-- Modifie un pixel du sprite.
-- function Graphics.spr_pixel(sprite, x, y, color)
--     sprite:setPixel(x, y, color)
-- end
function Graphics.spr_pixel(sprite, x, y, color)
    if not sprite then
        return
    end

    sprite:setPixel(x, y, color)
end

-- Définit la couleur transparente du sprite.
function Graphics.spr_transparent(sprite, color)
    sprite:setTransparentColor(color)
end

--- Affiche un sprite à l'écran.
---@param sprite Sprite|SpriteSheet Sprite ou feuille de sprites.
---@param x number Position horizontale.
---@param y number Position verticale.
---@param flipX boolean|nil Retourne horizontalement.
---@param flipY boolean|nil Retourne verticalement.
---@param index integer|nil Index du sprite dans la spritesheet.
function Graphics.spr(sprite, x, y, flipX, flipY, index)
    local selectedSprite

    x = math.floor(x)
    y = math.floor(y)

    if index ~= nil then
        ---@cast sprite SpriteSheet
        selectedSprite = sprite:getSprite(index)
    elseif sprite and sprite.getSprite then
        ---@cast sprite Animation
        selectedSprite = sprite:getSprite()
    else
        ---@cast sprite Sprite
        selectedSprite = sprite
    end

    if not selectedSprite then
        return
    end

    Graphics.video:drawSprite(selectedSprite, x, y, flipX, flipY)
end

--- Charge et découpe une feuille de sprites.
---@param path string Chemin de l'image.
---@param spriteWidth number Largeur d'un sprite.
---@param spriteHeight number Hauteur d'un sprite.
---@return SpriteSheet
function Graphics.spritesheet(path, spriteWidth, spriteHeight)
    local sheet = SpriteSheet.new()

    sheet:load(path)
    sheet:split(spriteWidth, spriteHeight)

    return sheet
end

--- Récupère un sprite depuis une spritesheet.
---@param sheet SpriteSheet
---@param index integer
---@return Sprite|nil
function Graphics.get_sprite(sheet, index)
    return sheet:getSprite(index)
end

--------------------- ANIMATION ---------------------------

--- Crée une animation à partir d'une spritesheet.
---@param spriteSheet SpriteSheet
---@param frames integer|integer[]
---@param lastFrameOrFps number
---@param fpsOrMode number|"loop"|"once"|nil
---@param mode nil|"loop"|"once"
---@return Animation
function Graphics.animation(spriteSheet, frames, lastFrameOrFps, fpsOrMode, mode)
    local anim = Animation.new(
        spriteSheet,
        frames,
        lastFrameOrFps,
        fpsOrMode,
        mode
    )

    Graphics.animationManager:add(anim)

    return anim
end

--- Met une animation en pause.
---@param anim Animation
function Graphics.stop_anim(anim)
    anim:stop()
end

--- Réinitialise une animation.
---@param anim Animation
function Graphics.reset_anim(anim)
    anim:reset()
end

---Modifie la vitesse d'une animation
---@param anim Animation
---@param fps integer
function Graphics.set_anim_speed(anim, fps)
    anim:setSpeed(fps)
end

--- Démarre ou reprend une animation.
---@param anim Animation
function Graphics.play_anim(anim)
    anim:play()
end

---------------------  DIVERS ------------------------------

function Graphics.palette(index, r, g, b)
    Palette.setColor(index, r, g, b)
end

function Graphics.cls(color)
    Graphics.video:clear(color or 0)
end

function Graphics.color(color)
    color = color or 0
    Graphics.video:setColor(color)
end

--- Retourne la largeur de l'écran.
---@return integer
function Graphics.screen_width()
    return Graphics.video.WIDTH
end

--- Retourne la hauteur de l'écran.
---@return integer
function Graphics.screen_height()
    return Graphics.video.HEIGHT
end

-----------------------  FORMES BASIQUES  ----------------------

function Graphics.pixel(x, y, color)
    local currentColor = Graphics.video:getColor()
    x = math.floor(x)
    y = math.floor(y)
    color = color or currentColor
    Graphics.video:setPixel(x, y, color)
    -- Graphics.video:setColor(currentColor)
end

function Graphics.print(text, x, y, color)
    x = math.floor(x) or 0
    y = math.floor(y) or 0

    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawText(x, y, text, color)
end

function Graphics.line(x1, y1, x2, y2, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    x1 = math.floor(x1)
    y1 = math.floor(y1)
    x2 = math.floor(x2)
    y2 = math.floor(y2)
    Graphics.video:drawLine(x1, y1, x2, y2, color)
end

function Graphics.rect(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    x = math.floor(x)
    y = math.floor(y)
    color = color or currentColor
    Graphics.video:drawRect(x, y, width, height, color)
end

function Graphics.rect_fill(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    x = math.floor(x)
    y = math.floor(y)
    Graphics.video:fillRect(x, y, width, height, color)
end

function Graphics.circle(cx, cy, radius, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    cx = math.floor(cx)
    cy = math.floor(cy)
    radius = math.floor(radius)
    Graphics.video:drawCircle(cx, cy, radius, color)
end

function Graphics.circle_fill(cx, cy, radius, color)
    local currentColor = Graphics.video:getColor()
    color              = color or currentColor
    cx                 = math.floor(cx)
    cy                 = math.floor(cy)
    radius             = math.floor(radius)
    Graphics.video:fillCircle(cx, cy, radius, color)
end

function Graphics.ellipse(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color              = color or currentColor
    x                  = math.floor(x)
    y                  = math.floor(y)
    width              = math.floor(width)
    height             = math.floor(height)
    Graphics.video:drawEllipse(x, y, width, height)
end

function Graphics.ellipse_fill(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color              = color or currentColor
    x                  = math.floor(x)
    y                  = math.floor(y)
    width              = math.floor(width)
    height             = math.floor(height)
    Graphics.video:fillEllipse(x, y, width, height)
end

function Graphics.triangle(x1, y1, x2, y2, x3, y3, color)
    local currentColor = Graphics.video:getColor()
    color              = color or currentColor
    x1                 = math.floor(x1)
    y1                 = math.floor(y1)
    x2                 = math.floor(x2)
    y2                 = math.floor(y2)
    x3                 = math.floor(x3)
    y3                 = math.floor(y3)
    Graphics.video:drawTriangle(x1, y1, x2, y2, x3, y3, color)
end

function Graphics.triangle_fill(x1, y1, x2, y2, x3, y3, color)
    local currentColor = Graphics.video:getColor()
    color              = color or currentColor
    x1                 = math.floor(x1)
    y1                 = math.floor(y1)
    x2                 = math.floor(x2)
    y2                 = math.floor(y2)
    x3                 = math.floor(x3)
    y3                 = math.floor(y3)
    Graphics.video:fillTriangle(x1, y1, x2, y2, x3, y3, color)
end

function Graphics.polygone(points, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawPolygon(points, color)
end

function Graphics.polygone_fill(points, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:fillPolygon(points, color)
end

return Graphics
