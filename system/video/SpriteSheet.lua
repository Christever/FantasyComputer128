local Logger = require("system.Logger")
local Sprite = require("system.video.Sprite")
local Palette = require("system.video.Palette")

---@class SpriteSheet
local SpriteSheet = {}

function SpriteSheet.new()
    local self = setmetatable({}, { __index = SpriteSheet })

    self.sprites = {}
    self.columns = 0
    self.rows = 0
    self.spriteWidth = 0
    self.spriteHeight = 0

    return self
end

--- Charge une image PNG.
---@param path string Chemin de l'image.
function SpriteSheet:load(path)
    local imageData, errorMessage = love.image.newImageData(path)

    Logger.assert(imageData ~= nil, "Impossible de charger l'image : " .. tostring(errorMessage))

    self.imageData = imageData
    self.width = imageData:getWidth()
    self.height = imageData:getHeight()
end

--- Découpe l'image en sprites.
---@param spriteWidth number Largeur d'un sprite.
---@param spriteHeight number Hauteur d'un sprite.
function SpriteSheet:split(spriteWidth, spriteHeight)
    Logger.assert(spriteWidth > 0, "Largeur de sprite invalide")
    Logger.assert(spriteHeight > 0, "Hauteur de sprite invalide")

    Logger.assert(
        self.width % spriteWidth == 0,
        "La largeur de l'image doit être divisible par celle du sprite"
    )

    Logger.assert(
        self.height % spriteHeight == 0,
        "La hauteur de l'image doit être divisible par celle du sprite"
    )

    self.spriteWidth = spriteWidth
    self.spriteHeight = spriteHeight

    self.columns = self.width / spriteWidth
    self.rows = self.height / spriteHeight

    self.sprites = {}

    for row = 0, self.rows - 1 do
        for column = 0, self.columns - 1 do
            local sprite = Sprite.new(spriteWidth, spriteHeight)

            for y = 1, spriteHeight do
                for x = 1, spriteWidth do
                    local imageX = column * spriteWidth + x - 1
                    local imageY = row * spriteHeight + y - 1

                    local r, g, b, a = self.imageData:getPixel(imageX, imageY)

                    if a < 0.5 then
                        sprite:setPixel(x, y, -1)
                    else
                        local colorIndex = Palette.findClosestColor(
                            r * 255,
                            g * 255,
                            b * 255
                        )

                        sprite:setPixel(x, y, colorIndex)
                    end
                end
            end

            table.insert(self.sprites, sprite)
        end
    end
end

--- Récupère un sprite par son index.
---@param index integer Index du sprite (à partir de 1).
---@return Sprite|nil
function SpriteSheet:getSprite(index)
    Logger.assert(index >= 1, "Index de sprite invalide")

    return self.sprites[index]
end

return SpriteSheet
