
local playerX = 50
local playerY = 90

local boxX = 150
local boxY = 90

local playerSize = 16
local boxSize = 32

function BOOT()
    f_cls(0)
end

function FAN128(dt)

    -- Deplacement du joueur
    if f_btn("LEFT") then
        playerX = playerX - 60 * dt
    end

    if f_btn("RIGHT") then
        playerX = playerX + 60 * dt
    end

    if f_btn("UP") then
        playerY = playerY - 60 * dt
    end

    if f_btn("DOWN") then
        playerY = playerY + 60 * dt
    end

    -- Detection de collision
    local collision = f_overlap(
        playerX, playerY, playerSize, playerSize,
        boxX, boxY, boxSize, boxSize
    )

    -- Affichage
    f_cls(0)

    f_rect_fill(boxX, boxY, boxSize, boxSize, 5)

    local playerColor = collision and 2 or 7
    f_rect_fill(playerX, playerY, playerSize, playerSize, playerColor)
    -- f_circle_fill(playerX, playerY, 10, playerColor)

    if collision then
        f_print("COLLISION !", 120, 20, 2)
    else
        f_print("NO COLLISION", 120, 20, 7)
    end
end
