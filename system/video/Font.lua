---@class Font
local Font = {}

Font.WIDTH = 5
Font.HEIGHT = 7
Font.CHAR_WIDTH = 8
Font.CHAR_HEIGHT = 8

-- Police bitmap
-- 1 = pixel allumé
-- 0 = pixel éteint
Font.GLYPHS = {

    [" "] = {
        "00000",
        "00000",
        "00000",
        "00000",
        "00000",
        "00000",
        "00000"
    },

    ["A"] = {
        "01110",
        "10001",
        "10001",
        "11111",
        "10001",
        "10001",
        "10001"
    },

    ["B"] = {
        "11110",
        "10001",
        "10001",
        "11110",
        "10001",
        "10001",
        "11110"
    }
}

--- Retourne le bitmap d'un caractère
---@param character string caractère à rechercher
---@return table
function Font.getGlyph(character)
    character = string.upper(character)

    return Font.GLYPHS[character] or Font.GLYPHS[" "]
end

return Font
