local Palette       = require("system.video.Palette")
local Memory        = require("system.memory.Memory")
local Font          = require("system.video.Font")
local Sprite        = require("system.video.Sprite")

---@class Video
local Video         = {}

-- Résolution de l'écran
Video.WIDTH         = 320
Video.HEIGHT        = 200

-- Nombre de pixels
Video.PIXEL_COUNT   = Video.WIDTH * Video.HEIGHT

Video.DEFAULT_COLOR = 1

--- Crée une nouvelle instance du CPU
---@param memory Memory
---@return Video
function Video.new(memory)
    local self        = setmetatable({}, { __index = Video })

    self.memory       = memory
    self.canvas       = nil
    self.imageData    = nil
    self.image        = nil
    self.currentColor = Video.DEFAULT_COLOR

    return self
end

---
---@return nil
function Video:init()
    self.imageData = love.image.newImageData(
        Video.WIDTH,
        Video.HEIGHT
    )

    self.canvas = love.graphics.newCanvas(
        Video.WIDTH,
        Video.HEIGHT
    )

    self.image = love.graphics.newImage(self.imageData)

    print("========== VIDEO ==========")
    print("Résolution :", Video.WIDTH, "x", Video.HEIGHT)
    print("Pixels :", Video.PIXEL_COUNT)
    print("VRAM :", self.memory.VRAM_SIZE / 1024, "Ko")
end

--- Conversion de la VRAM en pixels
function Video:updateScreen()
    for pixelIndex = 0, Video.PIXEL_COUNT - 1 do
        local colorIndex = self.memory:readVRAM(pixelIndex)

        local color = Palette.getColor(colorIndex)

        local x = pixelIndex % Video.WIDTH
        local y = math.floor(pixelIndex / Video.WIDTH)

        self.imageData:setPixel(
            x,
            y,
            color.r / 255,
            color.g / 255,
            color.b / 255,
            1
        )
    end

    self.image:replacePixels(self.imageData)
end

--- Définit la couleur graphique courante
---@param colorIndex integer numéro de la couleur
function Video:setColor(colorIndex)
    if colorIndex < 0 or colorIndex > 255 then
        return
    end

    self.currentColor = colorIndex
end

---comment
---@param x integer
---@param y integer
---@param colorIndex? integer @[0..255]
function Video:setPixel(x, y, colorIndex)
    colorIndex = colorIndex or self.currentColor
    -- Vérification des coordonnées
    if x < 0 or x >= Video.WIDTH then return end
    if y < 0 or y >= Video.HEIGHT then return end

    -- Vérification de la couleur
    if colorIndex < 0 or colorIndex > 255 then return end

    -- Calcul de l'adresse VRAM
    local address = y * Video.WIDTH + x

    -- Écriture du pixel
    self.memory:writeVRAM(address, colorIndex)
end

--- Retourne la couleur d'un pixel
---@param x integer coordonnée X
---@param y integer coordonnée Y
---@return integer|nil index de couleur ou nil si hors écran
function Video:getPoint(x, y)
    if x < 0 or x >= Video.WIDTH then return nil end
    if y < 0 or y >= Video.HEIGHT then return nil end

    local address = y * Video.WIDTH + x

    return self.memory:readVRAM(address)
end

--- Affiche un caractère à l'écran
---@param x integer position X
---@param y integer position Y
---@param character string caractère à afficher
---@param colorIndex integer? couleur facultative
function Video:drawChar(x, y, character, colorIndex)
    colorIndex = colorIndex or self.currentColor

    local glyph = Font.getGlyph(character)

    for row = 1, Font.HEIGHT do
        for col = 1, Font.WIDTH do
            if glyph[row]:sub(col, col) == "1" then
                self:setPixel(
                    x + col - 1,
                    y + row - 1,
                    colorIndex
                )
            end
        end
    end
end

--- Affiche une chaîne de caractères
---@param x integer position X
---@param y integer position Y
---@param text string texte à afficher
---@param colorIndex integer? couleur facultative
function Video:drawText(x, y, text, colorIndex)
    colorIndex = colorIndex or self.currentColor

    local startX = x
    local cursorX = x
    local cursorY = y

    for i = 1, #text do
        local character = text:sub(i, i)

        if character == "\n" then
            cursorX = startX
            cursorY = cursorY + Font.CHAR_HEIGHT
        else
            self:drawChar(cursorX, cursorY, character, colorIndex)
            cursorX = cursorX + Font.CHAR_WIDTH
        end
    end
end

--- Dessine un pixel avec la couleur courante
---@param x integer coordonnée X
---@param y integer coordonnée Y
function Video:plot(x, y)
    self:setPixel(x, y)
end

---Efface l'écran avec la couleur d'index colorIndex (0 par défaut)
---@param colorIndex integer?   numéro de la couleur
function Video:clear(colorIndex)
    colorIndex = colorIndex or 0
    for y = 0, Video.HEIGHT - 1 do
        for x = 0, Video.WIDTH - 1 do
            self:setPixel(x, y, colorIndex)
        end
    end
end

--- Dessine une ligne entre deux points
---@param x1 integer coordonnée X du premier point
---@param y1 integer coordonnée Y du premier point
---@param x2 integer coordonnée X du second point
---@param y2 integer coordonnée Y du second point
---@param colorIndex? integer numéro de la couleur
function Video:drawLine(x1, y1, x2, y2, colorIndex)
    colorIndex = colorIndex or self.currentColor
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)

    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1

    local err = dx - dy

    while true do
        self:setPixel(x1, y1, colorIndex)

        if x1 == x2 and y1 == y2 then
            break
        end

        local e2 = 2 * err

        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end

        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

--- Dessine le contour d'un rectangle
---@param x integer coordonnée X
---@param y integer coordonnée Y
---@param width integer largeur
---@param height integer hauteur
---@param colorIndex? integer numéro de la couleur
function Video:drawRect(x, y, width, height, colorIndex)
    colorIndex = colorIndex or self.currentColor
    self:drawLine(x, y, x + width - 1, y, colorIndex)
    self:drawLine(x, y, x, y + height - 1, colorIndex)
    self:drawLine(x + width - 1, y, x + width - 1, y + height - 1, colorIndex)
    self:drawLine(x, y + height - 1, x + width - 1, y + height - 1, colorIndex)
end

--- Dessine un rectangle plein
---@param x integer coordonnée X
---@param y integer coordonnée Y
---@param width integer largeur
---@param height integer hauteur
---@param colorIndex integer? numéro de la couleur
function Video:fillRect(x, y, width, height, colorIndex)
    colorIndex = colorIndex or self.currentColor
    for py = y, y + height - 1 do
        self:drawLine(x, py, x + width - 1, py, colorIndex)
    end
end

--- Dessine le contour d'un cercle
---@param cx integer centre X
---@param cy integer centre Y
---@param radius integer rayon
---@param colorIndex? integer numéro de la couleur
function Video:drawCircle(cx, cy, radius, colorIndex)
    colorIndex = colorIndex or self.currentColor
    if radius < 0 then return end

    local x = radius
    local y = 0
    local err = 1 - radius

    while x >= y do
        self:setPixel(cx + x, cy + y, colorIndex)
        self:setPixel(cx + y, cy + x, colorIndex)
        self:setPixel(cx - y, cy + x, colorIndex)
        self:setPixel(cx - x, cy + y, colorIndex)

        self:setPixel(cx - x, cy - y, colorIndex)
        self:setPixel(cx - y, cy - x, colorIndex)
        self:setPixel(cx + y, cy - x, colorIndex)
        self:setPixel(cx + x, cy - y, colorIndex)

        y = y + 1

        if err < 0 then
            err = err + 2 * y + 1
        else
            x = x - 1
            err = err + 2 * (y - x) + 1
        end
    end
end

--- Dessine un cercle plein
---@param cx integer centre X
---@param cy integer centre Y
---@param radius integer rayon
---@param colorIndex? integer numéro de la couleur
function Video:fillCircle(cx, cy, radius, colorIndex)
    colorIndex = colorIndex or self.currentColor
    if radius < 0 then return end

    for y = -radius, radius do
        local x = math.floor(math.sqrt(radius * radius - y * y))

        self:drawLine(
            cx - x,
            cy + y,
            cx + x,
            cy + y,
            colorIndex
        )
    end
end

---Dessine une ellipse pleine
---@param cx integer centre X
---@param cy integer centre Y
---@param radiusX integer rayon X
---@param radiusY integer rayon Y
---@param colorIndex? integer numéro de la couleur
function Video:drawEllipse(cx, cy, radiusX, radiusY, colorIndex)
    colorIndex = colorIndex or self.currentColor

    local x = 0
    local y = radiusY

    local rx2 = radiusX * radiusX
    local ry2 = radiusY * radiusY

    local dx = 0
    local dy = 2 * rx2 * y

    local p1 = ry2 - (rx2 * radiusY) + (0.25 * rx2)

    while dx < dy do
        self:setPixel(cx + x, cy + y, colorIndex)
        self:setPixel(cx - x, cy + y, colorIndex)
        self:setPixel(cx + x, cy - y, colorIndex)
        self:setPixel(cx - x, cy - y, colorIndex)

        if p1 < 0 then
            x = x + 1
            dx = dx + (2 * ry2)
            p1 = p1 + dx + ry2
        else
            x = x + 1
            y = y - 1

            dx = dx + (2 * ry2)
            dy = dy - (2 * rx2)

            p1 = p1 + dx - dy + ry2
        end
    end

    local p2 = ry2 * ((x + 0.5) * (x + 0.5))
        + rx2 * ((y - 1) * (y - 1))
        - rx2 * ry2

    while y >= 0 do
        self:setPixel(cx + x, cy + y, colorIndex)
        self:setPixel(cx - x, cy + y, colorIndex)
        self:setPixel(cx + x, cy - y, colorIndex)
        self:setPixel(cx - x, cy - y, colorIndex)

        if p2 > 0 then
            y = y - 1
            dy = dy - (2 * rx2)
            p2 = p2 + rx2 - dy
        else
            y = y - 1
            x = x + 1

            dx = dx + (2 * ry2)
            dy = dy - (2 * rx2)

            p2 = p2 + dx - dy + rx2
        end
    end
end

---Dessine une ellipse vide
---@param cx integer centre X
---@param cy integer centre Y
---@param radiusX integer rayon X
---@param radiusY integer rayon Y
---@param colorIndex? integer numéro de la couleur
function Video:fillEllipse(cx, cy, radiusX, radiusY, colorIndex)
    colorIndex = colorIndex or self.currentColor

    if radiusX <= 0 or radiusY <= 0 then
        return
    end

    for y = -radiusY, radiusY do
        local ratio = 1 - (y * y) / (radiusY * radiusY)
        local x = math.floor(radiusX * math.sqrt(ratio))

        self:drawLine(
            cx - x,
            cy + y,
            cx + x,
            cy + y,
            colorIndex
        )
    end
end

--- Dessine le contour d'un triangle.
---@param x1 number Coordonnée X du premier sommet.
---@param y1 number Coordonnée Y du premier sommet.
---@param x2 number Coordonnée X du deuxième sommet.
---@param y2 number Coordonnée Y du deuxième sommet.
---@param x3 number Coordonnée X du troisième sommet.
---@param y3 number Coordonnée Y du troisième sommet.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function Video:drawTriangle(x1, y1, x2, y2, x3, y3, colorIndex)
    colorIndex = colorIndex or self.currentColor

    self:drawLine(x1, y1, x2, y2, colorIndex)
    self:drawLine(x2, y2, x3, y3, colorIndex)
    self:drawLine(x3, y3, x1, y1, colorIndex)
end

--- Dessine un triangle plein.
---@param x1 number Coordonnée X du premier sommet.
---@param y1 number Coordonnée Y du premier sommet.
---@param x2 number Coordonnée X du deuxième sommet.
---@param y2 number Coordonnée Y du deuxième sommet.
---@param x3 number Coordonnée X du troisième sommet.
---@param y3 number Coordonnée Y du troisième sommet.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function Video:fillTriangle(x1, y1, x2, y2, x3, y3, colorIndex)
    colorIndex = colorIndex or self.currentColor

    local minY = math.min(y1, y2, y3)
    local maxY = math.max(y1, y2, y3)

    local function scanlineIntersection(y, xa, ya, xb, yb)
        if ya == yb then
            return nil
        end

        if y < math.min(ya, yb) or y > math.max(ya, yb) then
            return nil
        end

        return xa + (y - ya) * (xb - xa) / (yb - ya)
    end

    for y = minY, maxY do
        local intersections = {}

        local x = scanlineIntersection(y, x1, y1, x2, y2)
        if x then
            table.insert(intersections, x)
        end

        x = scanlineIntersection(y, x2, y2, x3, y3)
        if x then
            table.insert(intersections, x)
        end

        x = scanlineIntersection(y, x3, y3, x1, y1)
        if x then
            table.insert(intersections, x)
        end

        if #intersections >= 2 then
            table.sort(intersections)

            self:drawLine(
                math.floor(intersections[1]),
                y,
                math.ceil(intersections[#intersections]),
                y,
                colorIndex
            )
        end
    end
end

--- Dessine le contour d'un polygone.
---@param points table Liste de sommets { x = number, y = number }.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function Video:drawPolygon(points, colorIndex)
    colorIndex = colorIndex or self.currentColor

    assert(#points >= 3, "Un polygone doit avoir au moins 3 sommets")

    for i = 1, #points do
        local current = points[i]
        local nextPoint = points[(i % #points) + 1]

        self:drawLine(
            current.x,
            current.y,
            nextPoint.x,
            nextPoint.y,
            colorIndex
        )
    end
end

--- Dessine un polygone plein (convexe ou concave).
---@param points table Liste de sommets { x = number, y = number }.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function Video:fillPolygon(points, colorIndex)
    colorIndex = colorIndex or self.currentColor

    assert(#points >= 3, "Un polygone doit avoir au moins 3 sommets")

    local minY = points[1].y
    local maxY = points[1].y

    for i = 2, #points do
        minY = math.min(minY, points[i].y)
        maxY = math.max(maxY, points[i].y)
    end

    for y = minY, maxY do
        local intersections = {}

        for i = 1, #points do
            local current = points[i]
            local nextPoint = points[(i % #points) + 1]

            local y1 = current.y
            local y2 = nextPoint.y

            -- Ignore les côtés horizontaux et évite
            -- de compter deux fois les sommets.
            if (y1 <= y and y < y2) or (y2 <= y and y < y1) then
                local x = current.x
                    + (y - y1) * (nextPoint.x - current.x) / (y2 - y1)

                table.insert(intersections, x)
            end
        end

        table.sort(intersections)

        -- Remplit les zones comprises entre les intersections.
        for i = 1, #intersections - 1, 2 do
            self:drawLine(
                math.ceil(intersections[i]),
                y,
                math.floor(intersections[i + 1]),
                y,
                colorIndex
            )
        end
    end

    -- Redessine le contour pour obtenir des bords nets.
    self:drawPolygon(points, colorIndex)
end

--- Affiche un sprite à l'écran avec possibilité de retournement.
---@param sprite Sprite Sprite à afficher.
---@param x integer Position horizontale (base 1).
---@param y integer Position verticale (base 1).
---@param flipX? boolean Retournement horizontal.
---@param flipY? boolean Retournement vertical.
function Video:drawSprite(sprite, x, y, flipX, flipY)
    flipX = flipX or false
    flipY = flipY or false

    for sy = 1, sprite.height do
        for sx = 1, sprite.width do
            local sourceX = flipX and (sprite.width - sx + 1) or sx
            local sourceY = flipY and (sprite.height - sy + 1) or sy

            local colorIndex = sprite:getPixel(sourceX, sourceY)

            if colorIndex ~= sprite:getTransparentColor() then
                self:setPixel(
                    x + sx - 1,
                    y + sy - 1,
                    colorIndex
                )
            end
        end
    end
end

--- Affiche l'image vidéo sans déformation
function Video:draw()
    if not self.image then return end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local scale = math.min(
        screenWidth / Video.WIDTH,
        screenHeight / Video.HEIGHT
    )

    local offsetX = (screenWidth - Video.WIDTH * scale) / 2
    local offsetY = (screenHeight - Video.HEIGHT * scale) / 2

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.image,
        offsetX,
        offsetY,
        0,
        scale,
        scale
    )
end

return Video
