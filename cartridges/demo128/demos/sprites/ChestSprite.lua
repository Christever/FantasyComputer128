local ChestSprite = {}

function ChestSprite.create()
    local sprite = f_sprite(16, 16, -1)

    -- Corps du coffre
    for y = 5, 13 do
        for x = 2, 13 do
            f_spr_pixel(sprite, x, y, 4)
        end
    end

    -- Couvercle
    for y = 3, 5 do
        for x = 2, 13 do
            f_spr_pixel(sprite, x, y, 6)
        end
    end

    -- Bordure
    for y = 5, 13 do
        f_spr_pixel(sprite, 2, y, 6)
        f_spr_pixel(sprite, 13, y, 6)
    end

    -- Fermeture
    f_spr_pixel(sprite, 7, 7, 7)
    f_spr_pixel(sprite, 8, 7, 7)
    f_spr_pixel(sprite, 7, 8, 7)
    f_spr_pixel(sprite, 8, 8, 7)

    return sprite
end

return ChestSprite