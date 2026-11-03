---@class Sprite
---@field width integer
---@field height integer
---@field pixels table
local Sprite = {}


--- Crée un nouveau sprite.
---@param width integer Largeur du sprite en pixels.
---@param height integer Hauteur du sprite en pixels.
---@param colorIndex? integer Couleur initiale (0-255). Par défaut transparent.
---@return Sprite
function Sprite.new(width, height, colorIndex)
    assert(width > 0, "Largeur invalide")
    assert(height > 0, "Hauteur invalide")

    local self            = setmetatable({}, { __index = Sprite })

    self.width            = width
    self.height           = height
    self.pixels           = {}
    self.transparentColor = -1

    local color           = colorIndex or -1

    for y = 1, height do
        self.pixels[y] = {}

        for x = 1, width do
            self.pixels[y][x] = color
        end
    end

    return self
end

--- Modifie la couleur d'un pixel du sprite.
---@param x integer Coordonnée X (base 1).
---@param y integer Coordonnée Y (base 1).
---@param colorIndex integer Index de couleur (0-255) ou -1 pour transparent.
function Sprite:setPixel(x, y, colorIndex)
    assert(x >= 1 and x <= self.width, "Coordonnée X invalide")
    assert(y >= 1 and y <= self.height, "Coordonnée Y invalide")
    assert(colorIndex == -1 or (colorIndex >= 0 and colorIndex <= 255), "Couleur invalide")

    self.pixels[y][x] = colorIndex
end

--- Récupère la couleur d'un pixel du sprite.
---@param x integer Coordonnée X (base 1).
---@param y integer Coordonnée Y (base 1).
---@return integer|nil Index de couleur ou nil si hors limites.
function Sprite:getPixel(x, y)
    if x < 1 or x > self.width or y < 1 or y > self.height then
        return nil
    end

    return self.pixels[y][x]
end

--- Définit la couleur transparente du sprite.
---@param colorIndex integer Index de couleur (0-255) ou -1 pour aucune couleur transparente.
function Sprite:setTransparentColor(colorIndex)
    assert(
        colorIndex == -1 or (colorIndex >= 0 and colorIndex <= 255),
        "Couleur transparente invalide"
    )

    self.transparentColor = colorIndex
end

--- Récupère la couleur transparente du sprite.
---@return integer Index de couleur transparente.
function Sprite:getTransparentColor()
    return self.transparentColor
end

return Sprite
