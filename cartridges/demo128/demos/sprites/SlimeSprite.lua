local SlimeSprite = {}

function SlimeSprite.create()
    local sprite = f_sprite(16, 16, -1)

    -- Corps
    for y = 5, 11 do
        local startX = 3
        local endX = 12

        if y == 5 then
            startX = 6
            endX = 9
        elseif y == 6 then
            startX = 4
            endX = 11
        end

        for x = startX, endX do
            f_spr_pixel(sprite, x, y, 3)
        end
    end

    -- Base
    for x = 2, 13 do
        f_spr_pixel(sprite, x, 12, 3)
    end

    -- Yeux
    f_spr_pixel(sprite, 6, 8, 7)
    f_spr_pixel(sprite, 10, 8, 7)

    -- Pupilles
    f_spr_pixel(sprite, 6, 9, 0)
    f_spr_pixel(sprite, 10, 9, 0)

    return sprite
end

return SlimeSprite