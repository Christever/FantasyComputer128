---@class Graphics
local Graphics = {}

function Graphics.init(video)
    Graphics.video = video
end

--- Efface l'écran.
---@param color? integer
function Graphics.cls(color)
    -- print("CLS APPELE", color)

    Graphics.video:clear(color or 0)

    -- print("PIXEL VRAM :", Graphics.video.memory:read(0x8000))
end

--- Dessine un pixel.
---@param x number
---@param y number
---@param color? integer
function Graphics.pix(x, y, color)
    print("PIX APPELE", x, y, color)
    Graphics.video:setPixel(x, y, color)
end

--- Affiche du texte.
---@param text string
---@param x? number
---@param y? number
---@param color? integer
function Graphics.print(text, x, y, color)
    x = x or 0
    y = y or 0

    print("GRAPHICS.PRINT APPELE")
    print("Video :", Graphics.video)
    print("Texte :", text, "X :", x, "Y :", y)

    Graphics.video:drawText(x, y, text, color)
end

--- Trace une ligne.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param color? integer
function Graphics.line(x1, y1, x2, y2, color)
    if color then
        Graphics.video:setColor(color)
    end

    Graphics.video:drawLine(x1, y1, x2, y2)
end

return Graphics
