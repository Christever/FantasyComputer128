local Palette       = require("system.video.Palette")
local Memory        = require("system.memory.Memory")
local Font          = require("system.video.Font")
local Sprite        = require("system.video.Sprite")
local Logger        = require("system.Logger")

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
    local self         = setmetatable({}, { __index = Video })

    self.memory        = memory
    self.canvas        = nil
    self.imageData     = nil
    self.image         = nil
    self.previousVRAM  = {}
    self.screenChanged = false
    self.currentColor  = Video.DEFAULT_COLOR

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

    -- Forcer l'affichage initial de toute la VRAM
    for address = 0, Video.PIXEL_COUNT - 1 do
        self.memory.dirtyVRAM[address] = true
    end

    print("========== VIDEO ==========")
    print("Résolution :", Video.WIDTH, "x", Video.HEIGHT)
    print("Pixels :", Video.PIXEL_COUNT)
    print("VRAM :", self.memory.VRAM_SIZE / 1024, "Ko")
end

--- Réinitialise l'état interne du système vidéo.
function Video:reset()
    self.currentColor = Video.DEFAULT_COLOR
end

--- Conversion de la VRAM en pixels
--- Conversion de la VRAM en pixels
function Video:updateScreen()
    local dirtyVRAM = self.memory.dirtyVRAM

    self.screenChanged = false

    for pixelIndex in pairs(dirtyVRAM) do
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

        self.screenChanged = true

        dirtyVRAM[pixelIndex] = nil
    end

    if self.screenChanged then
        self.image:replacePixels(self.imageData)
    end
end

--- Définit la couleur graphique courante
---@param colorIndex integer numéro de la couleur
function Video:setColor(colorIndex)
    if colorIndex < 0 or colorIndex > 255 then
        return
    end

    self.currentColor = colorIndex
end

---Retourne la couleur courante
---@return integer
function Video:getColor()
    return self.currentColor
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

    for address = 0, Video.PIXEL_COUNT - 1 do
        self.memory:writeVRAM(address, colorIndex)
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

    local startX = math.max(0, math.floor(x))
    local startY = math.max(0, math.floor(y))

    local endX = math.min(Video.WIDTH - 1, math.floor(x + width - 1))
    local endY = math.min(Video.HEIGHT - 1, math.floor(y + height - 1))

    if startX > endX or startY > endY then
        return
    end

    for py = startY, endY do
        local address = py * Video.WIDTH + startX

        for px = startX, endX do
            self.memory:writeVRAM(address, colorIndex)
            address = address + 1
        end
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

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM
    local width = Video.WIDTH
    local height = Video.HEIGHT

    local function pixel(px, py)
        if px < 0 or px >= width or py < 0 or py >= height then
            return
        end

        local address = py * width + px
        local index = address + 1

        if vram[index] ~= colorIndex then
            vram[index] = colorIndex
            dirtyVRAM[address] = true
        end
    end

    while x >= y do
        pixel(cx + x, cy + y)
        pixel(cx + y, cy + x)
        pixel(cx - y, cy + x)
        pixel(cx - x, cy + y)

        pixel(cx - x, cy - y)
        pixel(cx - y, cy - x)
        pixel(cx + y, cy - x)
        pixel(cx + x, cy - y)

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

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM
    local width = Video.WIDTH
    local height = Video.HEIGHT

    for y = -radius, radius do
        local py = cy + y

        if py >= 0 and py < height then
            local x = math.floor(math.sqrt(radius * radius - y * y))

            local startX = math.max(0, cx - x)
            local endX = math.min(width - 1, cx + x)

            local address = py * width + startX

            for px = startX, endX do
                local index = address + 1

                if vram[index] ~= colorIndex then
                    vram[index] = colorIndex
                    dirtyVRAM[address] = true
                end

                address = address + 1
            end
        end
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

    if radiusX < 0 or radiusY < 0 then
        return
    end

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM

    local width = Video.WIDTH
    local height = Video.HEIGHT

    local function pixel(px, py)
        if px < 0 or px >= width or py < 0 or py >= height then
            return
        end

        local address = py * width + px
        local index = address + 1

        if vram[index] ~= colorIndex then
            vram[index] = colorIndex
            dirtyVRAM[address] = true
        end
    end

    local x = 0
    local y = radiusY

    local rx2 = radiusX * radiusX
    local ry2 = radiusY * radiusY

    local dx = 0
    local dy = 2 * rx2 * y

    local p1 = ry2 - (rx2 * radiusY) + (0.25 * rx2)

    while dx < dy do
        pixel(cx + x, cy + y)
        pixel(cx - x, cy + y)
        pixel(cx + x, cy - y)
        pixel(cx - x, cy - y)

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
        pixel(cx + x, cy + y)
        pixel(cx - x, cy + y)
        pixel(cx + x, cy - y)
        pixel(cx - x, cy - y)

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

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM

    local width = Video.WIDTH
    local height = Video.HEIGHT

    local rx2 = radiusX * radiusX
    local ry2 = radiusY * radiusY

    local startY = math.max(-radiusY, -cy)
    local endY = math.min(radiusY, height - 1 - cy)

    for y = startY, endY do
        local ratio = 1 - (y * y) / ry2
        local x = math.floor(radiusX * math.sqrt(ratio))

        local startX = math.max(0, cx - x)
        local endX = math.min(width - 1, cx + x)

        local address = (cy + y) * width + startX

        for px = startX, endX do
            local index = address + 1

            if vram[index] ~= colorIndex then
                vram[index] = colorIndex
                dirtyVRAM[address] = true
            end

            address = address + 1
        end
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

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM
    local width = Video.WIDTH
    local height = Video.HEIGHT

    local function pixel(x, y)
        if x < 0 or x >= width or y < 0 or y >= height then
            return
        end

        local address = y * width + x
        local index = address + 1

        if vram[index] ~= colorIndex then
            vram[index] = colorIndex
            dirtyVRAM[address] = true
        end
    end

    local function line(x1, y1, x2, y2)
        local dx = math.abs(x2 - x1)
        local dy = math.abs(y2 - y1)

        local sx = x1 < x2 and 1 or -1
        local sy = y1 < y2 and 1 or -1

        local err = dx - dy

        while true do
            pixel(x1, y1)

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

    line(x1, y1, x2, y2)
    line(x2, y2, x3, y3)
    line(x3, y3, x1, y1)
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

    local minY = math.max(0, math.min(y1, y2, y3))
    local maxY = math.min(Video.HEIGHT - 1, math.max(y1, y2, y3))

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM
    local width = Video.WIDTH

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
        local left = math.huge
        local right = -math.huge

        local x = scanlineIntersection(y, x1, y1, x2, y2)
        if x then
            left = math.min(left, x)
            right = math.max(right, x)
        end

        x = scanlineIntersection(y, x2, y2, x3, y3)
        if x then
            left = math.min(left, x)
            right = math.max(right, x)
        end

        x = scanlineIntersection(y, x3, y3, x1, y1)
        if x then
            left = math.min(left, x)
            right = math.max(right, x)
        end

        if left ~= math.huge then
            local startX = math.max(0, math.floor(left))
            local endX = math.min(width - 1, math.ceil(right))

            local address = y * width + startX

            for px = startX, endX do
                local index = address + 1

                if vram[index] ~= colorIndex then
                    vram[index] = colorIndex
                    dirtyVRAM[address] = true
                end

                address = address + 1
            end
        end
    end
end

--- Dessine le contour d'un polygone.
---@param points table Liste de sommets { x = number, y = number }.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function Video:drawPolygon(points, colorIndex)
    colorIndex = colorIndex or self.currentColor

    Logger.assert(#points >= 3, "Un polygone doit avoir au moins 3 sommets")

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM
    local width = Video.WIDTH
    local height = Video.HEIGHT

    local function pixel(x, y)
        if x < 0 or x >= width or y < 0 or y >= height then
            return
        end

        local address = y * width + x
        local index = address + 1

        if vram[index] ~= colorIndex then
            vram[index] = colorIndex
            dirtyVRAM[address] = true
        end
    end

    local function line(x1, y1, x2, y2)
        local dx = math.abs(x2 - x1)
        local dy = math.abs(y2 - y1)

        local sx = x1 < x2 and 1 or -1
        local sy = y1 < y2 and 1 or -1

        local err = dx - dy

        while true do
            pixel(x1, y1)

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

    for i = 1, #points do
        local current = points[i]
        local nextPoint = points[(i % #points) + 1]

        line(
            math.floor(current.x),
            math.floor(current.y),
            math.floor(nextPoint.x),
            math.floor(nextPoint.y)
        )
    end
end

--- Dessine un polygone plein (convexe ou concave).
---@param points table Liste de sommets { x = number, y = number }.
---@param colorIndex? integer Index de couleur (0-255). Utilise la couleur actuelle si absent.
function Video:fillPolygon(points, colorIndex)
    colorIndex = colorIndex or self.currentColor

    Logger.assert(#points >= 3, "Un polygone doit avoir au moins 3 sommets")

    local minY = math.huge
    local maxY = -math.huge

    for i = 1, #points do
        local y = math.floor(points[i].y)
        minY = math.min(minY, y)
        maxY = math.max(maxY, y)
    end

    minY = math.max(0, minY)
    maxY = math.min(Video.HEIGHT - 1, maxY)

    local memory = self.memory
    local vram = memory.vram
    local dirtyVRAM = memory.dirtyVRAM
    local width = Video.WIDTH

    local intersections = {}

    for y = minY, maxY do
        local count = 0

        for i = 1, #points do
            local current = points[i]
            local nextPoint = points[(i % #points) + 1]

            local x1 = current.x
            local y1 = current.y
            local x2 = nextPoint.x
            local y2 = nextPoint.y

            if (y1 <= y and y < y2) or (y2 <= y and y < y1) then
                local x = x1 + (y - y1) * (x2 - x1) / (y2 - y1)

                count = count + 1
                intersections[count] = x
            end
        end

        -- Trie les intersections par ordre croissant
        for i = 2, count do
            local value = intersections[i]
            local j = i - 1

            while j >= 1 and intersections[j] > value do
                intersections[j + 1] = intersections[j]
                j = j - 1
            end

            intersections[j + 1] = value
        end

        -- Remplit chaque zone comprise entre deux intersections
        for i = 1, count - 1, 2 do
            local startX = math.max(0, math.ceil(intersections[i]))
            local endX = math.min(width - 1, math.floor(intersections[i + 1]))

            local address = y * width + startX

            for x = startX, endX do
                local index = address + 1

                if vram[index] ~= colorIndex then
                    vram[index] = colorIndex
                    dirtyVRAM[address] = true
                end

                address = address + 1
            end
        end
    end

    self:drawPolygon(points, colorIndex)
end

--- Affiche un sprite à l'écran avec possibilité de retournement.
---@param sprite Sprite Sprite à afficher.
---@param x integer Position horizontale (base 1).
---@param y integer Position verticale (base 1).
---@param flipX? boolean Retournement horizontal.
---@param flipY? boolean Retournement vertical.
function Video:drawSprite(sprite, x, y, flipX, flipY)
    function Video:drawSprite(sprite, x, y, flipX, flipY)
        flipX = flipX or false
        flipY = flipY or false

        -- Limites visibles du sprite
        local startX = math.max(1, 1 - x)
        local startY = math.max(1, 1 - y)

        local endX = math.min(sprite.width, Video.WIDTH - x)
        local endY = math.min(sprite.height, Video.HEIGHT - y)

        if startX > endX or startY > endY then
            return
        end

        local pixels = sprite.pixels
        local transparentColor = sprite.transparentColor

        for sy = startY, endY do
            local sourceY = flipY and (sprite.height - sy + 1) or sy
            local row = pixels[sourceY]

            for sx = startX, endX do
                local sourceX = flipX and (sprite.width - sx + 1) or sx

                local colorIndex = row[sourceX]

                if colorIndex ~= transparentColor then
                    self:setPixel(
                        x + sx - 1,
                        y + sy - 1,
                        colorIndex
                    )
                end
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
