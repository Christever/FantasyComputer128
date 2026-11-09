
local ChestAnim = {}

function ChestAnim.create()

    local sprites = {}

    -- Image 1 : coffre ferme
    local closed = f_sprite(16, 16, -1)

    -- Base
    for y = 8, 14 do
        for x = 3, 14 do
            f_spr_pixel(closed, x, y, 4)
        end
    end

    -- Couvercle
    for y = 4, 7 do
        for x = 3, 14 do
            f_spr_pixel(closed, x, y, 6)
        end
    end

    -- Bordure
    for x = 3, 14 do
        f_spr_pixel(closed, x, 7, 4)
    end

    -- Serrure
    f_spr_pixel(closed, 9, 9, 7)
    f_spr_pixel(closed, 9, 10, 7)

    table.insert(sprites, closed)

    -- Image 2 : coffre en ouverture
    local opening = f_sprite(16, 16, -1)

    for y = 9, 14 do
        for x = 3, 14 do
            f_spr_pixel(opening, x, y, 4)
        end
    end

    for y = 3, 6 do
        for x = 4, 13 do
            f_spr_pixel(opening, x, y, 6)
        end
    end

    for x = 5, 12 do
        f_spr_pixel(opening, x, 7, 4)
    end

    f_spr_pixel(opening, 8, 10, 7)
    f_spr_pixel(opening, 9, 10, 7)

    table.insert(sprites, opening)

    -- Image 3 : coffre ouvert
    local opened = f_sprite(16, 16, -1)

    for y = 9, 14 do
        for x = 3, 14 do
            f_spr_pixel(opened, x, y, 4)
        end
    end

    for x = 4, 13 do
        f_spr_pixel(opened, x, 5, 6)
        f_spr_pixel(opened, x, 6, 6)
    end

    f_spr_pixel(opened, 6, 7, 7)
    f_spr_pixel(opened, 8, 7, 7)
    f_spr_pixel(opened, 10, 7, 7)

    table.insert(sprites, opened)

    return sprites
end

return ChestAnim
