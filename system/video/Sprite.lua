local Logger = require("system.Logger")
---@class Sprite
local Sprite = {}


--- Crée un nouveau sprite.
---@param width integer Largeur du sprite en pixels.
---@param height integer Hauteur du sprite en pixels.
---@param colorIndex? integer Couleur initiale (0-255). Par défaut transparent.
---@return Sprite
function Sprite.new(width, height, colorIndex)
    Logger.assert(width > 0, "Largeur invalide")
    Logger.assert(height > 0, "Hauteur invalide")

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

--- Crée un sprite à partir d'une table de pixels.
---@param width integer Largeur du sprite.
---@param height integer Hauteur du sprite.
---@param data integer[] Données des pixels (base 1).
---@return Sprite
function Sprite.fromData(width, height, data)
    Logger.assert(width > 0, "Largeur invalide")
    Logger.assert(height > 0, "Hauteur invalide")
    Logger.assert(#data == width * height, "Nombre de pixels invalide")

    local sprite = Sprite.new(width, height, -1)

    for y = 1, height do
        for x = 1, width do
            local index = (y - 1) * width + x
            sprite:setPixel(x, y, data[index])
        end
    end

    return sprite
end

--- Crée un sprite à partir d'une représentation textuelle.
---@param lines string[] Lignes composant le sprite.
---@return Sprite
function Sprite.fromMap(lines)
    local height = #lines
    local width = #lines[1]

    Logger.assert(width > 0, "Largeur invalide")
    Logger.assert(height > 0, "Hauteur invalide")

    local data = {}

    for y = 1, height do
        Logger.assert(#lines[y] == width, "Largeur des lignes invalide")

        for x = 1, width do
            local char = lines[y]:sub(x, x)
            local color

            if char == "." then
                color = -1
            elseif char >= "0" and char <= "9" then
                color = tonumber(char)
            elseif char >= "A" and char <= "F" then
                color = string.byte(char) - string.byte("A") + 10
            else
                Logger.assert(false, "Caractere invalide dans le sprite")
            end

            table.insert(data, color)
        end
    end

    return Sprite.fromData(width, height, data)
end

--- Modifie la couleur d'un pixel du sprite.
---@param x integer Coordonnée X (base 1).
---@param y integer Coordonnée Y (base 1).
---@param colorIndex integer Index de couleur (0-255) ou -1 pour transparent.
function Sprite:setPixel(x, y, colorIndex)
    Logger.assert(x >= 1 and x <= self.width, "Coordonnée X invalide")
    Logger.assert(y >= 1 and y <= self.height, "Coordonnée Y invalide")
    Logger.assert(colorIndex == -1 or (colorIndex >= 0 and colorIndex <= 255), "Couleur invalide")

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
    Logger.assert(
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

--- Remplit entièrement le sprite avec une couleur.
---@param colorIndex integer Index de couleur (0-255) ou -1 pour transparent.
function Sprite:clear(colorIndex)
    Logger.assert(
        colorIndex == -1 or (colorIndex >= 0 and colorIndex <= 255),
        "Couleur invalide"
    )

    for y = 1, self.height do
        for x = 1, self.width do
            self.pixels[y][x] = colorIndex
        end
    end
end

return Sprite
