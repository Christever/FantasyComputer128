
local SlimeAnim = {}

function SlimeAnim.create()

    local sprites = {}

    -- Pose 1 : slime normal
    local normal = f_sprite(16, 16, -1)

    for y = 5, 12 do
        for x = 3, 14 do
            f_spr_pixel(normal, x, y, 3)
        end
    end

    for x = 5, 12 do
        f_spr_pixel(normal, x, 4, 3)
    end

    f_spr_pixel(normal, 6, 8, 0)
    f_spr_pixel(normal, 11, 8, 0)

    table.insert(sprites, normal)

    -- Pose 2 : slime aplati
    local flat = f_sprite(16, 16, -1)

    for y = 9, 13 do
        for x = 2, 15 do
            f_spr_pixel(flat, x, y, 3)
        end
    end

    f_spr_pixel(flat, 6, 11, 0)
    f_spr_pixel(flat, 11, 11, 0)

    table.insert(sprites, flat)

    -- Pose 3 : slime etire
    local tall = f_sprite(16, 16, -1)

    for y = 3, 13 do
        for x = 5, 12 do
            f_spr_pixel(tall, x, y, 3)
        end
    end

    for x = 7, 10 do
        f_spr_pixel(tall, x, 2, 3)
    end

    f_spr_pixel(tall, 7, 7, 0)
    f_spr_pixel(tall, 10, 7, 0)

    table.insert(sprites, tall)

    return sprites
end

return SlimeAnim
