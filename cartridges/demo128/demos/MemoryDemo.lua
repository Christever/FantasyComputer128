
local MemoryDemo = {}

local cursorX = 0
local cursorY = 0

local ADDRESS = 0x4000

local COLUMNS = 16
local ROWS = 8

local CELL_SIZE = 12
local CELL_GAP = 2

local START_X = 54
local START_Y = 55

-- Couleur des cases selon la valeur
local function getColor(value)
    return value % 16
end

-- Affichage de la grille mémoire
local function drawMemory()

    for y = 0, ROWS - 1 do
        for x = 0, COLUMNS - 1 do

            local index = y * COLUMNS + x
            local address = ADDRESS + index

            local value = f_peek(address)
            local color = getColor(value)

            local px = START_X + x * (CELL_SIZE + CELL_GAP)
            local py = START_Y + y * (CELL_SIZE + CELL_GAP)

            f_rect_fill(px, py, CELL_SIZE, CELL_SIZE, color)
        end
    end

    -- Curseur de selection
    local cursorPX = START_X + cursorX * (CELL_SIZE + CELL_GAP)
    local cursorPY = START_Y + cursorY * (CELL_SIZE + CELL_GAP)

    f_rect(
        cursorPX - 2,
        cursorPY - 2,
        CELL_SIZE + 4,
        CELL_SIZE + 4,
        7
    )
end

-- Affichage principal
function MemoryDemo.draw()

    -- Titre
    f_print("MEMORY MONITOR", 105, 12, 7)
    f_line(10, 28, 310, 28, 7)

    f_print("RAM", 10, 40, 5)

    -- Grille mémoire
    drawMemory()

    -- Informations de la case selectionnee
    local index = cursorY * COLUMNS + cursorX
    local address = ADDRESS + index
    local value = f_peek(address)

    -- Separation du panneau
    f_line(10, 160, 310, 160, 7)

    -- Valeurs
    f_print(string.format("ADDR %04X", address), 10, 168, 7)
    f_print(string.format("HEX %02X", value), 10, 181, 7)
    f_print(string.format("DEC %d", value), 85, 181, 7)

    -- Visualisation binaire
    f_print("BINARY", 175, 168, 5)

    for i = 7, 0, -1 do

        local bit = math.floor(value / (2 ^ i)) % 2
        local bitX = 175 + (7 - i) * 16

        local color = bit == 1 and 5 or 0

        f_rect_fill(bitX, 175, 11, 11, color)
        f_print(tostring(bit), bitX + 2, 190, 7)
    end
end

-- Gestion des commandes
function MemoryDemo.update()

    -- Deplacement du curseur
    if f_btnp("LEFT") then
        cursorX = math.max(0, cursorX - 1)
    end

    if f_btnp("RIGHT") then
        cursorX = math.min(COLUMNS - 1, cursorX + 1)
    end

    if f_btnp("UP") then
        cursorY = math.max(0, cursorY - 1)
    end

    if f_btnp("DOWN") then
        cursorY = math.min(ROWS - 1, cursorY + 1)
    end

    -- Modification de la valeur
    local index = cursorY * COLUMNS + cursorX
    local address = ADDRESS + index
    local value = f_peek(address)

    if f_btnp("A") then
        value = (value + 1) % 256
        f_poke(address, value)
    end

    if f_btnp("SELECT") then
        value = (value - 1) % 256
        f_poke(address, value)
    end
end

return MemoryDemo
