local Logger = require("system.Logger")
---@class Palette
local Palette = {}

-- Nombre de couleurs disponibles
Palette.COLOR_COUNT = 256

-- Palette RGB
Palette.colors = {}
Palette.DEFAULT_COLORS = {
    { 0,   0,   0 },   -- 0 : Noir
    { 255, 255, 255 }, -- 1 : Blanc
    { 136, 0,   0 },   -- 2 : Rouge foncé
    { 170, 255, 238 }, -- 3 : Cyan clair
    { 204, 68,  204 }, -- 4 : Magenta
    { 0,   204, 85 },  -- 5 : Vert
    { 0,   0,   170 }, -- 6 : Bleu
    { 238, 238, 119 }, -- 7 : Jaune
    { 221, 136, 85 },  -- 8 : Orange
    { 102, 68,  0 },   -- 9 : Marron
    { 255, 119, 119 }, -- 10 : Rose
    { 51,  51,  51 },  -- 11 : Gris foncé
    { 119, 119, 119 }, -- 12 : Gris
    { 170, 255, 102 }, -- 13 : Vert clair
    { 0,   136, 255 }, -- 14 : Bleu clair
    { 187, 187, 187 }, -- 15 : Gris clair
}

Palette.EXTENDED_COLORS = {
    -- Nous ajouterons ici les 240 couleurs supplémentaires.
}

-- Initialisation de la palette
function Palette.init()
    -- Initialisation des 256 couleurs en noir
    for i = 0, Palette.COLOR_COUNT - 1 do
        Palette.colors[i] = {
            r = 0,
            g = 0,
            b = 0
        }
    end

    -- Chargement des 16 couleurs par défaut
    for i, color in ipairs(Palette.DEFAULT_COLORS) do
        Palette.setColor(
            i - 1,
            color[1],
            color[2],
            color[3]
        )
    end
end

-- Définition d'une couleur
---@param index integer
---@param r number
---@param g number
---@param b number
function Palette.setColor(index, r, g, b)
    Logger.assert(index >= 0 and index < 256, "Index couleur invalide")

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
    Logger.assert(index >= 0 and index < 256, "Index couleur invalide")

    return Palette.colors[index]
end

--- Recherche la couleur la plus proche dans la palette.
---@param r number
---@param g number
---@param b number
---@return integer
function Palette.findClosestColor(r, g, b)
    local bestIndex = 0
    local bestDistance = math.huge

    for index, color in pairs(Palette.colors) do
        local dr = r - color.r
        local dg = g - color.g
        local db = b - color.b

        local distance = dr * dr + dg * dg + db * db

        if distance < bestDistance then
            bestDistance = distance
            bestIndex = index
        end
    end

    return bestIndex
end

-- Initialisation automatique
Palette.init()

return Palette
