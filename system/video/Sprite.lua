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

    local self = setmetatable({}, { __index = Sprite })

    self.width = width
    self.height = height
    self.pixels = {}

    local color = colorIndex or -1

    for y = 1, height do
        self.pixels[y] = {}

        for x = 1, width do
            self.pixels[y][x] = color
        end
    end

    return self
end

return Sprite
