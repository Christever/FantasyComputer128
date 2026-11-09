local testSprite

function BOOT()
    local pixels = {
        -1, -1, -1,  1,  1, -1, -1, -1,
        -1, -1,  1,  4,  4,  1, -1, -1,
        -1,  1,  4,  4,  4,  4,  1, -1,
         1,  4,  4,  4,  4,  4,  4,  1,
         1,  4,  4,  4,  4,  4,  4,  1,
        -1,  1,  4,  4,  4,  4,  1, -1,
        -1, -1,  1,  4,  4,  1, -1, -1,
        -1, -1, -1,  1,  1, -1, -1, -1
    }

    testSprite = f_sprite_data(8, 8, pixels)
end

function FAN128(dt)
    f_cls(0)
    f_spr(testSprite, 156, 96)
end