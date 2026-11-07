local PlayerSprite = {}

function PlayerSprite.create()
    local sprite = f_sprite(16, 16, -1)

    -- Chapeau
    for x = 5, 12 do
        f_spr_pixel(sprite, x, 2, 4)
    end

    -- Tete
    for y = 3, 8 do
        for x = 4, 13 do
            f_spr_pixel(sprite, x, y, 7)
        end
    end

    -- Yeux
    f_spr_pixel(sprite, 6, 5, 0)
    f_spr_pixel(sprite, 11, 5, 0)

    -- Corps
    for y = 9, 13 do
        for x = 5, 12 do
            f_spr_pixel(sprite, x, y, 3)
        end
    end

    -- Jambes
    for x = 5, 7 do
        f_spr_pixel(sprite, x, 14, 4)
    end

    for x = 10, 12 do
        f_spr_pixel(sprite, x, 14, 4)
    end

    return sprite
end

return PlayerSprite