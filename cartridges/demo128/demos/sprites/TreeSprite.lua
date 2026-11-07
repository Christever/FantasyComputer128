local TreeSprite = {}

function TreeSprite.create()
    local sprite = f_sprite(16, 16, -1)

    -- Feuillage
    for y = 2, 9 do
        local startX = 4
        local endX = 11

        if y == 2 then
            startX = 7
            endX = 8
        elseif y == 3 then
            startX = 5
            endX = 10
        elseif y == 8 then
            startX = 2
            endX = 13
        elseif y == 9 then
            startX = 4
            endX = 11
        end

        for x = startX, endX do
            f_spr_pixel(sprite, x, y, 3)
        end
    end

    -- Tronc
    for y = 10, 14 do
        for x = 7, 8 do
            f_spr_pixel(sprite, x, y, 4)
        end
    end

    return sprite
end

return TreeSprite