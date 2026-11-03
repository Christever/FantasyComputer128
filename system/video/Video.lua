local Palette       = require("system.video.Palette")
local Memory        = require("system.memory.Memory")

---@class Video
---@field memory Memory
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
