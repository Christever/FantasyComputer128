---@class Palette
local Palette = {}

-- Nombre de couleurs disponibles
Palette.COLOR_COUNT = 256

-- Palette RGB
Palette.colors = {}

-- Initialisation de la palette
function Palette.init()
    for i = 0, 255 do
        Palette.colors[i] = {
            r = 0,
            g = 0,
            b = 0
        }
    end
end

-- Définition d'une couleur
---@param index integer
---@param r number
---@param g number
---@param b number
function Palette.setColor(index, r, g, b)
    assert(index >= 0 and index < 256, "Index couleur invalide")

    Palette.colors[index] = {
        r = r,
        g = g,
        b = b
    }
end

-- Récupération d'une couleur
---@param index integer
---@return table
function Palette.getColor(index)
    assert(index >= 0 and index < 256, "Index couleur invalide")

    return Palette.colors[index]
end

-- Initialisation automatique
Palette.init()

return Palette
