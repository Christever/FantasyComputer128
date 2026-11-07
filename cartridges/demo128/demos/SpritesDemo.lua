local SpritesDemo = {}

local player

function SpritesDemo.createPlayer()
    player = f_sprite(16, 16, -1)

    if not player then
        print("ERREUR : f_sprite ne retourne rien")
        return
    end

    print("Sprite cree : " .. player.width .. "x" .. player.height)

    -- Chapeau
    for x = 5, 12 do
        f_spr_pixel(player, x, 2, 4)
    end

    -- Tete
    for y = 3, 8 do
        for x = 4, 13 do
            f_spr_pixel(player, x, y, 7)
        end
    end

    -- Yeux
    f_spr_pixel(player, 6, 5, 0)
    f_spr_pixel(player, 11, 5, 0)

    -- Corps
    for y = 9, 13 do
        for x = 5, 12 do
            f_spr_pixel(player, x, y, 3)
        end
    end

    -- Jambes
    for x = 5, 7 do
        f_spr_pixel(player, x, 14, 4)
    end

    for x = 10, 12 do
        f_spr_pixel(player, x, 14, 4)
    end
end

function SpritesDemo.draw()
    f_cls(0)

    f_print("SPRITES DEMO", 105, 10, 7)

    if player then
        print("Player :", player)
        print("Largeur :", player and player.width)
        f_spr(player, 152, 80)
        f_spr(player, 152, 80)
    end
end

return SpritesDemo
